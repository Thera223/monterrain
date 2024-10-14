import 'package:flutter/material.dart';

class CustomBottomNavBarp extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTabTapped;

  CustomBottomNavBarp({required this.currentIndex, required this.onTabTapped});

  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBarp> {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      onTap: widget.onTabTapped,
      selectedItemColor: Colors.purple,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: widget.currentIndex == 0
                  ? Colors.purple.withOpacity(0.2)
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            padding: EdgeInsets.all(8),
            child: Icon(
              Icons.home,
              color: widget.currentIndex == 0 ? Colors.purple : Colors.grey,
              size: screenWidth * 0.07,
            ),
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: widget.currentIndex == 1
                  ? Colors.purple.withOpacity(0.2)
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            padding: EdgeInsets.all(8),
            child: Icon(
              Icons.assignment,
              color: widget.currentIndex == 1
                  ? const Color.fromARGB(255, 156, 39, 176)
                  : Colors.grey,
              size: screenWidth * 0.07,
            ),
          ),
          label: 'Demande',
        ),

        BottomNavigationBarItem(
          icon: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: widget.currentIndex == 2
                  ? Colors.purple.withOpacity(0.2)
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            padding: EdgeInsets.all(8),
            child: Icon(
              Icons.person,
              color: widget.currentIndex == 2 ? Colors.purple : Colors.grey,
              size: screenWidth * 0.07,
            ),
          ),
          label: 'Profil',
        ),
      ],
    );
  }
}
