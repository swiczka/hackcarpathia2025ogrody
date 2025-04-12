import 'package:flutter/material.dart';
import 'package:hackcarpathia2025ogrody/pages/addplant.dart';

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
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Exit'),
              onTap: () => _onSelectPage('Exit'),
            ),
          ],
        ),
      ),

        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              width: double.infinity,
              height: 900,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Roślinki tu bd',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('eskere'),
                ],
              ),
            ),
          ),
        ),
    );
  }
}
