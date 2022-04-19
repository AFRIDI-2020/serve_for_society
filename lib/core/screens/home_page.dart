import 'package:flutter/material.dart';
import 'package:volunteer_project/core/components/custom_text.dart';
import 'package:volunteer_project/core/components/drawer.dart';
import 'bottom_nav_bar_screens/event/create_event_nav_scr.dart';
import 'bottom_nav_bar_screens/chat/chat_nav_scr.dart';
import 'package:volunteer_project/core/screens/bottom_nav_bar_screens/home_nav_scr.dart';
import 'package:volunteer_project/utils/theme.dart';

class HomePage extends StatefulWidget {
  int pageIndex;
  HomePage({Key? key, required this.pageIndex}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final _pageController = PageController();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  final navPages = [HomeNavScr(), ChatNavScr(), CreateEventNavScr()];

  @override
  void initState() {
    setState(() {
      _selectedIndex = widget.pageIndex;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: screenBgColor,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: darkGreen,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              if (_scaffoldKey.currentState!.isDrawerOpen) {
                _scaffoldKey.currentState!.openEndDrawer();
              } else {
                _scaffoldKey.currentState!.openDrawer();
              }
            },
            icon: const Icon(Icons.menu)),
        title: customText(
            _selectedIndex == 0? 'Home': _selectedIndex == 1? 'Chat' : 'Create Event', Colors.white, FontSize.largeFont, FontWeight.w500),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        ],
      ),
      drawer: customDrawer(context),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: darkGreen,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          _pageController.animateToPage(_selectedIndex,
              duration: const Duration(milliseconds: 100),
              curve: Curves.linear);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'Create Event'),
        ],
      ),
      body: PageView(
        controller: _pageController,
        children: navPages,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
