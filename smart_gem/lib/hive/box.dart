import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_gem/constant.dart';
import 'package:smart_gem/hive/chat_history.dart';
import 'package:smart_gem/hive/setting.dart';
import 'package:smart_gem/hive/user_model.dart';

class Boxes{
 
  static Box<ChatHistory> getChatHistory() =>
      Hive.box<ChatHistory>(Constants.chatHistory);

  static Box<UserModel> getUserModel()=>
      Hive.box<UserModel>(Constants.userModel);

  static Box<Settings> getSettings()=>
     Hive.box<Settings>(Constants.settings);
  
}
