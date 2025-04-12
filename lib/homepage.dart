import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 1;

  void _navigateBottomBar(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    ,

  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.fastfood, color: Colors.white), 
            SizedBox(width: 8),
            Text(
              'Mniam Match',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: <Widget> [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white,),
            onPressed: (){},
          )
        ],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _navigateBottomBar,
            unselectedItemColor: Colors.grey,
            items:[
              BottomNavigationBarItem(icon: Icon(Icons.smartphone), label: 'Mode'),
              BottomNavigationBarItem(icon: Icon(Icons.favorite_outline), label: 'Match!'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),

            ]),
      ),
    );
  }
}