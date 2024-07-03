import 'package:hive_flutter/hive_flutter.dart';

part 'setting.g.dart';

@HiveType(typeId: 2)
class Settings extends HiveObject{

  @HiveField(0)
  final bool isDarktheme;
  
  @HiveField(1)
  final bool shouldSpeak;

  Settings({
    required this.isDarktheme,
    required this.shouldSpeak
  });

}