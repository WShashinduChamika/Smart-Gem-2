import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:smart_gem/api/api_services.dart';
import 'package:smart_gem/constant.dart';
import 'package:smart_gem/hive/chat_history.dart';
import 'package:smart_gem/hive/setting.dart';
import 'package:smart_gem/hive/user_model.dart';
import 'package:smart_gem/models/model.dart';
import 'package:uuid/uuid.dart';

class ChatProvider extends ChangeNotifier {
  //list of messages
  List<Message> _inChatMessages = [];

  //page controller
  final PageController pageController = PageController();

  //list of images
  List<XFile> _imageFilesList = [];

  //index of the current screen
  int _currentIndex = 0;

  //current chat ID
  String _currentChatID = '';

  //initalize generative model
  GenerativeModel? _generativeModel;

  //initialize text model
  GenerativeModel? _textModel;

  //intialized vision model
  GenerativeModel? _visionModel;

  //current mode
  String _currentMode = 'gemini-pro';

  //loading status
  bool _isLoading = false;

  //getters
  List<Message> get inChatMessages => _inChatMessages;

  List<XFile> get imageFilesList => _imageFilesList;

  int get currentIndex => _currentIndex;

  String get currentChatID => _currentChatID;

  GenerativeModel? get generativeModel => _generativeModel;

  GenerativeModel? get textModel => _textModel;

  GenerativeModel? get visionModel => _visionModel;

  String get currentMode => _currentMode;

  bool get isLoading => _isLoading;

  //setters

  //set inChatMessages
  Future<void> setInChatMessages({required String chatID}) async {
    final messageFromDB = await loadMessageFromDB(chatId: chatID);

    for (var message in messageFromDB) {
      if (_inChatMessages.contains(message)) {
        log('message already exists in the list');
        continue;
      }
      _inChatMessages.add(message);
    }
    notifyListeners();
  }

  Future<List<Message>> loadMessageFromDB({required String chatId}) async {
    await Hive.openBox('${Constants.chatMessagesBox}$chatId');

    final messageBox = Hive.box('${Constants.chatMessagesBox}$chatId');

    final newData = messageBox.keys
        .map((e) {
          final message = messageBox.get(e);
          if (message != null) {
            final messageData =
                Message.fromMap(Map<String, dynamic>.from(message));
            return messageData;
          } else {
            // Handle the case when message is null, e.g., by returning a default Message or by skipping
            // Here, we skip the null messages
            return null;
          }
        })
        .where((message) => message != null)
        .cast<Message>()
        .toList();

    notifyListeners();
    return newData;
  }

  //set file list
  void setImageFilesList({required List<XFile> filesList}) {
    _imageFilesList = filesList;
    notifyListeners();
  }

  //set the current model
  String setCurrentModel({required String newModel}) {
    _currentMode = newModel;
    notifyListeners();
    return newModel;
  }

  //function to set the model based on bool - isTextOnly
  Future<void> setModel({required bool isTextOnly}) async {
    if (isTextOnly) {
      _generativeModel = _textModel ??
          GenerativeModel(
            model: setCurrentModel(newModel: "gemini-pro"),
            apiKey: APIServices.apiKey,
          );
    } else {
      _generativeModel = _visionModel ??
          GenerativeModel(
              model: setCurrentModel(newModel: "gemini-pro-vision"),
              apiKey: APIServices.apiKey);
    }
    notifyListeners();
  }

  //set current page index
  void setCurrentIndex({required int index}) {
    _currentIndex = index;
    notifyListeners();
  }

  //set current chat ID
  void setCurrentChatID({required String id}) {
    _currentChatID = id;
    notifyListeners();
  }

  //set loading
  void setIsLoading({required bool value}) {
    _isLoading = value;
    notifyListeners();
  }

  //send message to gemini and get the streamed response
  Future<void> sendMessage(
      {required String message, required bool isTextOnly}) async {
    //set the model
    await setModel(isTextOnly: isTextOnly);

    //set loading to true
    setIsLoading(value: true);

    //get the chatID
    String chatID = getChatID();

    //list of history messages
    List<Content> historyMessages = [];

    //get the chat history
    historyMessages = await getChatHistory(chatID: chatID);

    //get the imageUrls
    List<String> imageUrls = getImageUrls(isTextOnly: isTextOnly);

    //user message
    final userMessage = Message(
      messageID: "",
      message: StringBuffer(message),
      role: Role.user,
      chatID: chatID,
      imageUrls: imageUrls,
      timeSent: DateTime.now(),
    );

    //add the user message to the list
    _inChatMessages.add(userMessage);

    //notify listeners
    notifyListeners();

    if (currentChatID.isNotEmpty) {
      setCurrentChatID(id: chatID);
    }

    //send the message to the generative model and wait for the response
    await sendMessageAndAwaitResponse(
      chatID: chatID,
      message: message,
      isTextOnly: isTextOnly,
      historyMessages: historyMessages,
      userMessage: userMessage,
    );
  }

  //send message to gemini and get the streamed response
  Future<void> sendMessageAndAwaitResponse({
    required String chatID,
    required String message,
    required bool isTextOnly,
    required List<Content> historyMessages,
    required Message userMessage,
  }) async {
    //start chat session - only send history is its text only
    final chatSession = _generativeModel!.startChat(
      history: historyMessages.isEmpty || isTextOnly ? null : historyMessages,
    );

    //get the content
    final content = await getContent(
      message: message,
      isTextOnly: isTextOnly,
    );

    //assistant message
    final assistantMessage = userMessage.copyWith(
      messageID: '',
      role: Role.assistant,
      message: StringBuffer(''),
      timeSent: DateTime.now(),
    );

    //add the assistant message to the list
    _inChatMessages.add(assistantMessage);
    notifyListeners();
 
    //wait for stream response
    chatSession.sendMessageStream(content).asyncMap((event) {
      return event;
    }).listen((event) {
      _inChatMessages
          .firstWhere((element) => element.messageID == assistantMessage.messageID && element.role == Role.assistant)
          .message
          .write(event.text);
      notifyListeners();
    }, onDone: () {
      //save the message to the database
      
      //set isLoading false
      setIsLoading(value: false);
    }).onError((error, stackTrace) {
      //set isLoading false
      setIsLoading(value: false);
    });
  }

  Future<Content> getContent(
      {required String message, required bool isTextOnly}) async {
    if (isTextOnly) {
      //generate text from text only content
      return Content.text(message);
    } else {
      //generate image form text and image input
      final imageFeature = _imageFilesList
          .map((imageFile) => imageFile.readAsBytes())
          .toList(growable: false);
      final imageBytes = await Future.wait(imageFeature!);
      final prompt = TextPart(message);
      final imagePart = imageBytes
          .map((bytes) => DataPart('image/jpg', Uint8List.fromList(bytes)))
          .toList();
      return Content.model([prompt, ...imagePart]);
    }
  }

  //get the images urls
  List<String> getImageUrls({required bool isTextOnly}) {
    List<String> imageUrls = [];
    if (!isTextOnly && imageFilesList != null) {
      for (var image in imageFilesList) {
        imageUrls.add(image.path);
      }
    }
    return imageUrls;
  }

  Future<List<Content>> getChatHistory({required String chatID}) async {
    List<Content> history = [];
    if (currentChatID.isNotEmpty) {
      await setInChatMessages(chatID: chatID);
    }
    for (var message in inChatMessages) {
      if (message.role == Role.user) {
        history.add(Content.text(message.message.toString()));
      } else {
        history.add(Content.model([TextPart(message.message.toString())]));
      }
    }
    return history;
  }

  String getChatID() {
    if (currentChatID.isEmpty) {
      return const Uuid().v4();
    } else {
      return currentChatID;
    }
  }

  static initHive() async {
    // init hivebox
    final dir = await path.getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    await Hive.initFlutter(Constants.geminiDB);

    //register adapters

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ChatHistoryAdapter());

      //open the chat history box
      await Hive.openBox<ChatHistory>(Constants.chatHistory);
    }

    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter((UserModelAdapter()));

      //open the chat history box
      await Hive.openBox<UserModel>(Constants.userModel);
    }

    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(SettingsAdapter());

      //open the chat history box
      await Hive.openBox<Settings>(Constants.settings);
    }
  }
}
