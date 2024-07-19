import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_gem/providers/chat_provider.dart';
import 'package:smart_gem/screens/chat_history.dart';
import 'package:smart_gem/screens/chat_screen.dart';
import 'package:smart_gem/screens/user_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> _screens = [
    const ChatHistoryScreen(),
    const ChatScreen(),
    const UserProfileScreen()
  ];

  final PageController _pageController = PageController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(builder: (context, chatProvider, child) {
      return Scaffold(
        body: PageView(
          controller: chatProvider.pageController,
          children: _screens,
          onPageChanged: (index) {
            setState(() {
             chatProvider.setCurrentIndex(index: index);
            });
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              chatProvider.setCurrentIndex(index: index);
              chatProvider.pageController.jumpToPage(index);
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      );
    });
  }
}
