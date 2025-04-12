import 'package:flutter/material.dart';
import 'package:hackcarpathia2025ogrody/pages/addplant.dart';
import 'package:hackcarpathia2025ogrody/pages/scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[300],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: const MyHomePage(title: 'Strona główna'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _selectedPage = 'Strona główna';

  void _onSelectPage(String page) {
    setState(() {
      _selectedPage = page;
    });
    Navigator.pop(context);

    if (page == 'Strona Główna') {
      setState(() {
        _selectedPage = 'Strona główna';
      });
    } else if (page == 'Rośliny') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddPlant()),
      );
    } else if(page == 'Skaner'){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Scanner()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Strona Główna'),
              onTap: () => _onSelectPage('Strona Główna'),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Rośliny'),
              onTap: () => _onSelectPage('Rośliny'),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Skaner'),
              onTap: () => _onSelectPage('Skaner'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Exit'),
              onTap: () => _onSelectPage('Exit'),
            ),
          ],
        ),
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const SizedBox(height: 16),

              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                height: 120,
                width: double.infinity,
                child: Center(
                  child: Text(
                    'RURA 1',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
