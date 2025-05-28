import 'package:flutter/material.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:skyways/screens/chat_bot/chatbot.dart';
import 'package:skyways/screens/home_pages/drawer.dart';
import 'package:skyways/screens/home_pages/help_line_widget.dart';
import 'package:skyways/screens/home_pages/manage_bookngs_widget.dart';
import 'package:skyways/screens/home_pages/search_widget.dart';
import 'package:skyways/utils/utils.dart';

class HomePage extends StatefulWidget {
  final bool isStateBooking;
  HomePage({super.key, required this.isStateBooking});


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;
  late final NotchBottomBarController _controller;

  @override
  void initState() {
    super.initState();
    _controller = NotchBottomBarController(index: widget.isStateBooking ? 1 : 0);
    _pageController = PageController(
      initialPage: widget.isStateBooking ? 1 : 0,
    );
  }

  final List<Widget> _pages = [
    SearchWidget(),
    ManageBookingsWidget(),
    HelpLineWidget(),
    ChatbotPage(),
  ];
    @override
 
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      drawer: CustomUserDrawer(),

      appBar: AppBar(
        foregroundColor: themecolor,
        title: Text(
          _controller.index == 3 ? "Gemini Chatbot" : _controller.index == 1 ? "Manage Bookings": "Sky Ways",
          style: TextStyle(color: themecolor),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),

      body: PageView(
        controller: _pageController,
        children: _pages,
        physics: const NeverScrollableScrollPhysics(),
      ),

      bottomNavigationBar: AnimatedNotchBottomBar(
        notchBottomBarController: _controller,
        color: themecolor,
        showLabel: true,
        notchColor: themecolor,
        removeMargins: true,
        durationInMilliSeconds: 0,
        bottomBarWidth: MediaQuery.of(context).size.width,
        kIconSize: 25,
        kBottomRadius: 0,
        itemLabelStyle: const TextStyle(color: Colors.white, fontSize: 12),
        bottomBarItems: [
          BottomBarItem(
            inActiveItem: Icon(Icons.home_outlined, color: Colors.white),
            activeItem: Icon(Icons.home, color: Colors.white),
            itemLabel: "Home",
          ),
          BottomBarItem(
            inActiveItem: Image.asset(
              "lib/assets/bus_ticket.png",
              color: Colors.white,
              width: 24,
            ),
            activeItem: Image.asset(
              "lib/assets/bus_ticket.png",
              color: Colors.white,
              width: 24,
            ),
           
            itemLabel: "Bookings",
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.headset_mic_outlined, color: Colors.white),
            activeItem: Icon(Icons.headset_mic, color: Colors.white),
            itemLabel: "Helpline",
          ),
          BottomBarItem(
 inActiveItem: Image.asset(
              "lib/assets/gemini.png",
              width: 24,
            ),
            activeItem: Image.asset(
              "lib/assets/gemini.png",
              width: 24,
            ),
            itemLabel: "AI Chatbot",
          ),
        ],
        onTap: (index) {
          setState(() {
            _controller.index = index;
          });
          _pageController.jumpToPage(index);
        },
      ),
    );
  }
}
