import 'package:flutter/material.dart';
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
    const ChatScreen(),
    const ChatHistoryScreen(),
    const UserProfileScreen()
  ];
  
  final PageController _pageController = PageController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
          controller: _pageController,
          children: _screens,
          onPageChanged: (index) {
            setState(() {
              currentIndex = index;
            });
          }),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        elevation: 0,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: (index){
           setState(() {
             currentIndex = index;
           });
           _pageController.jumpToPage(index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "Chat History",
          ),
           BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: "Chat",
          ),
           BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
