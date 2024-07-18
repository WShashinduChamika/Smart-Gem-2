import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_gem/providers/chat_provider.dart';
import 'package:smart_gem/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ChatProvider.initHive();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ChatProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        //brightness: Brightness.dark,
      ),
      home: const HomeScreen(),
    );
  }
}
