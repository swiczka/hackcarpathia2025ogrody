import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import '../models/plant.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String plantId = "2"; //CHANGE THIS ID FOR DIFFERENT JSON

    return MaterialApp(
      title: 'Vegetable Detail',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PlantDetailLoader(plantId: plantId),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PlantDetailLoader extends StatefulWidget {
  final String plantId;

  const PlantDetailLoader({
    Key? key,
    required this.plantId,
  }) : super(key: key);

  @override
  State<PlantDetailLoader> createState() => _PlantDetailLoaderState();
}

class _PlantDetailLoaderState extends State<PlantDetailLoader> {
  Plant? plant;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadPlantData();
  }

  Future<void> _loadPlantData() async {
    try {
      final String jsonData = await rootBundle.loadString('assets/data.json');

      final List<dynamic> jsonList = json.decode(jsonData);

      final plantData = jsonList.firstWhere(
            (item) => item['id'] == widget.plantId,
        orElse: () => null,
      );

      if (plantData == null) {
        setState(() {
          error = 'Plant with ID ${widget.plantId} not found';
          isLoading = false;
        });
        return;
      }

      setState(() {
        plant = Plant.fromJson(plantData);
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
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
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
                  onPressed: _loadPlantData,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return VegetableDetailPage(plant: plant!);
  }
}

class VegetableDetailPage extends StatelessWidget {
  final Plant plant;

  const VegetableDetailPage({
    Key? key,
    required this.plant,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('MMMM d, yyyy').format(plant.plantingDate);

    return Scaffold(
      appBar: AppBar(
        title: Text(plant.name),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit feature coming soon')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Delete feature coming soon')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero image
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(plant.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              plant.name,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'ID: ${plant.id}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Chip(
                        label: Text(plant.growingSeason),
                        backgroundColor: Colors.green[100],
                        labelStyle: const TextStyle(color: Colors.green),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Planted: $formattedDate',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Reminders:',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: [
                              ReminderChip(
                                label: 'Watering',
                                isActive: plant.reminderWatering,
                                icon: Icons.water_drop,
                              ),
                              ReminderChip(
                                label: 'Care',
                                isActive: plant.reminderCare,
                                icon: Icons.yard,
                              ),
                              ReminderChip(
                                label: 'Fertilizing',
                                isActive: plant.reminderFertilizing,
                                icon: Icons.eco,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  const SectionHeader(title: 'Description'),
                  const SizedBox(height: 8),
                  Text(
                    plant.description,
                    style: const TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 24),

                  const SectionHeader(title: 'Notes'),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            plant.notes.isNotEmpty ? plant.notes : 'No notes added yet.',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              icon: const Icon(Icons.edit_note),
                              label: const Text('Edit Notes'),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Edit Notes feature coming soon')),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  const SectionHeader(title: 'Growing Information'),
                  const SizedBox(height: 16),

                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          InfoRow(
                            icon: Icons.water_drop,
                            iconColor: Colors.blue,
                            title: 'Watering',
                            value: 'Every ${plant.wateringFrequencyDays} days',
                          ),

                          const Divider(height: 24),

                          InfoRow(
                            icon: Icons.wb_sunny,
                            iconColor: Colors.orange,
                            title: 'Sunlight',
                            value: plant.sunlightNeeds,
                          ),

                          const Divider(height: 24),

                          InfoRow(
                            icon: Icons.calendar_today,
                            iconColor: Colors.purple,
                            title: 'Days to Maturity',
                            value: '${plant.daysToMaturity} days',
                          ),

                          const Divider(height: 24),

                          InfoRow(
                            icon: Icons.landscape,
                            iconColor: Colors.brown,
                            title: 'Soil',
                            value: plant.soilType,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Card(
                    elevation: 2,
                    color: Colors.green[50],
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.event_available,
                            color: Colors.green[700],
                            size: 36,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Estimated Harvest',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[700],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat('MMMM d, yyyy').format(
                                      plant.plantingDate.add(Duration(days: plant.daysToMaturity))
                                  ),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.green[900],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  const SectionHeader(title: 'Care Instructions'),
                  const SizedBox(height: 16),

                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: plant.careInstructions.map((instruction) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.check_circle, color: Colors.green, size: 20),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    instruction,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  const SectionHeader(title: 'Common Pests & Diseases'),
                  const SizedBox(height: 16),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: plant.commonPests.map((pest) {
                      return Chip(
                        avatar: const Icon(Icons.bug_report, size: 16, color: Colors.red),
                        label: Text(pest),
                        backgroundColor: Colors.red[50],
                        labelStyle: TextStyle(color: Colors.red[800]),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 32),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ActionButton(
                        icon: Icons.water_drop,
                        label: 'Log Watering',
                        color: Colors.blue,
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Watering logged')),
                          );
                        },
                      ),
                      ActionButton(
                        icon: Icons.photo_camera,
                        label: 'Add Photo',
                        color: Colors.green,
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Photo feature coming soon')),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ActionButton(
                        icon: Icons.calendar_month,
                        label: 'Set Reminders',
                        color: Colors.purple,
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Reminder feature coming soon')),
                          );
                        },
                      ),
                      ActionButton(
                        icon: Icons.eco,
                        label: 'Log Fertilizing',
                        color: Colors.amber[800]!,
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Fertilizing logged')),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;

  const InfoRow({
    Key? key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 24),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const ActionButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}

class ReminderChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final IconData icon;

  const ReminderChip({
    Key? key,
    required this.label,
    required this.isActive,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(
        icon,
        size: 16,
        color: isActive ? Colors.white : Colors.grey,
      ),
      label: Text(label),
      backgroundColor: isActive ? Colors.blue : Colors.grey[200],
      labelStyle: TextStyle(
        color: isActive ? Colors.white : Colors.grey[600],
      ),
    );
  }
}