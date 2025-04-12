import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hackcarpathia2025ogrody/models/userplantsstorage.dart';
import 'dart:convert';
import 'package:hackcarpathia2025ogrody/pages/addplant.dart';
import 'package:hackcarpathia2025ogrody/pages/calendar.dart';
import 'package:hackcarpathia2025ogrody/pages/scanner.dart';
import 'package:hackcarpathia2025ogrody/pages/plantdetails.dart';
import 'package:hackcarpathia2025ogrody/pages/allplants.dart';
import 'package:hackcarpathia2025ogrody/models/plant.dart';

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
      home: const MyHomePage(title: '🥕 Ogródek'),
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
  int _selectedIndex = 2;

  final List<Widget> _pages = [
    const Scanner(),
    const PlantsPage(),
    const HomePage(),
    CalendarPage(),
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
        title: Text(
          widget.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 32,
          ),
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.camera),
              label: 'Skanuj!',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_tree),
              label: 'Rośliny',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Strona Główna',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: 'Kalendarz',
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Plant> plants = [];
  List<Plant> userPlants = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadPlants();
  }

  Future<void> _loadPlants() async {
    try {
      final String jsonData = await rootBundle.loadString('assets/data.json');

      final List<dynamic> jsonList = json.decode(jsonData);

      final loadedPlants = jsonList.map((item) => Plant.fromJson(item)).toList();

      final List<Plant> loadedUserPlants = await UserPlantsStorage.loadUserPlants();
      setState(() {
        plants = loadedPlants;
        userPlants = loadedUserPlants;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Error loading plant data: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 60, color: Colors.red),
              const SizedBox(height: 16),
              Text(error!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadPlants,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: double.infinity,

      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.3),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
               child: Column(
                 children: [
                   Row(
                     children: [
                      Icon(Icons.sunny, size: 30, color: Colors.yellow[900]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "14°C",
                              style: const TextStyle(fontSize: 16, color: Colors.black87),
                            ),
                            Text(
                              "Przewidywane opady",
                              style: const TextStyle(fontSize: 16, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    ],
                                 ),
                   Padding(
                     padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                     child: Row(
                       children: [

                         Icon(Icons.circle, size: 30, color: Colors.white60),
                         const SizedBox(width: 8),
                         Expanded(
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Text(
                                 "",
                                 style: const TextStyle(fontSize: 16, color: Colors.black87),
                               ),
                               Text(
                                 "Pełnia księżyca",
                                 style: const TextStyle(fontSize: 16, color: Colors.black54),
                               ),
                             ],
                           ),
                         ),
                       ],
                     ),
                   ),
                 ],
               ),
            ),
            const Text(
              'Mój ogród',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.0,
                ),
                itemCount: userPlants.length,
                itemBuilder: (context, index) {
                  return PlantCard(plant: userPlants[index]);
                },
              ),
            ),
            const SizedBox(height: 16),
            // Add new plant button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AddPlant()),
                  );

                  final updatedPlants = await UserPlantsStorage.loadUserPlants();

                  setState(() {
                    userPlants = updatedPlants;
                  });
                },
                icon: const Icon(Icons.add),
                label: const Text('Dodaj nową roślinę'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlantCard extends StatelessWidget {
  final Plant plant;

  const PlantCard({
    super.key,
    required this.plant,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlantDetailPage(plantId: plant.id),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 2),
              blurRadius: 4,
            ),
          ],
          image: DecorationImage(
            image: NetworkImage(plant.imageUrl),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3),
              BlendMode.darken,
            ),
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Text(
                  plant.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlantsPage extends StatefulWidget {
  const PlantsPage({super.key});

  @override
  State<PlantsPage> createState() => _PlantsPageState();
}

class _PlantsPageState extends State<PlantsPage> {
  List<Plant> plants = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadPlants();
  }

  Future<void> _loadPlants() async {
    try {
      final String jsonData = await rootBundle.loadString('assets/data.json');

      final List<dynamic> jsonList = json.decode(jsonData);

      final loadedPlants = jsonList.map((item) => Plant.fromJson(item)).toList();

      setState(() {
        plants = loadedPlants;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Error loading plant data: $e';
        isLoading = false;
      });
    }
  }

  IconData getPlantIcon(String plantName) {
    final name = plantName.toLowerCase();
    if (name.contains('marchew')) {
      return Icons.spa;
    } else if (name.contains('ogórek')) {
      return Icons.eco;
    } else if (name.contains('bazylia')) {
      return Icons.grass;
    } else if (name.contains('rzodkiewka')) {
      return Icons.fiber_manual_record;
    } else if (name.contains('cebula')) {
      return Icons.bubble_chart;
    } else {
      return Icons.local_florist;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 60, color: Colors.red),
              const SizedBox(height: 16),
              Text(error!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadPlants,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Katalog roślin',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Wybierz roślinę, aby dowiedzieć się więcej',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: plants.length,
                itemBuilder: (context, index) {
                  final plant = plants[index];
                  return PlantListItem(
                    plant: plant,
                    icon: getPlantIcon(plant.name),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlantListItem extends StatelessWidget {
  final Plant plant;
  final IconData icon;

  const PlantListItem({
    super.key,
    required this.plant,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlantDetailPage(plantId: plant.id),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(
                  icon,
                  color: Colors.green,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plant.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Season: ${plant.growingSeason}',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              // Arrow icon
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}