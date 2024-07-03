import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:smart_gem/constant.dart';
import 'package:smart_gem/hive/chat_history.dart';
import 'package:smart_gem/hive/setting.dart';
import 'package:smart_gem/hive/user_model.dart';
import 'package:smart_gem/models/model.dart';

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
