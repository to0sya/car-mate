import 'package:car_mate/car_screen.dart';
import 'package:car_mate/dashboard_screen.dart';
import 'package:car_mate/expenses_screen.dart';
import 'package:flutter/material.dart';
import 'custom_input.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'map_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreen createState() {
    return _HomeScreen();
  }
}

class _HomeScreen extends State<HomeScreen> {
  int _selectedIndex = 1;

  static final List<Widget> _widgetOptions = <Widget>[
    const CarScreen(),
    const ExpensesScreen(),
    MapScreen(),
    DashboardScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/logo.svg',
                height: 40,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 16.0),
              const Text(
                'CarMate',
                style: TextStyle(
                  fontFamily: 'Audi',
                  fontSize: 24,
                  fontWeight: FontWeight.w200,
                ),
              ),
            ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/car.svg',
              height: 40,
              width: 40,
            ),
            label: 'Car',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/tag.svg',
              height: 40,
              width: 40,
            ),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/geofence.svg',
              height: 40,
              width: 40,
            ),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/dashboard.svg',
              height: 40,
              width: 40,
            ),
            label: 'Dashboard',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        showUnselectedLabels: true,
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Audi',
          fontWeight: FontWeight.w400,
        ),
        selectedLabelStyle: const TextStyle(
            fontFamily: 'Audi',
            fontWeight: FontWeight.w400,
        ),
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
      ),
    );
  }
}