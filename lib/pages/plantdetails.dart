import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// This is a standalone detail page for a vegetable
// with hard-coded data for demonstration purposes

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vegetable Detail',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const VegetableDetailPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class VegetableDetailPage extends StatelessWidget {
  const VegetableDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Hard-coded vegetable data based on the provided JSON structure
    const String id = "tom-01";
    const String name = "Tomato - Roma";
    const String imageUrl = "https://images.unsplash.com/photo-1607305387299-a3d9611cd469?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D";
    const String description =
        "Roma tomatoes are egg- or pear-shaped and used for tomato paste, tomato sauce, and canning. "
        "They have fewer seeds and a dense, meaty flesh that makes them ideal for processing. "
        "They are determinate tomatoes, which means they grow to a certain height, then flower and set all their fruit within a short period. "
        "They are excellent for container gardening and urban spaces due to their compact growth habit.";
    const String growingSeason = "Summer";
    const List<String> careInstructions = [
      "Plant in well-draining soil after last frost",
      "Space plants 24-36 inches apart",
      "Water deeply 1-2 times per week depending on weather",
      "Provide support with stakes or cages",
      "Prune suckers for better air circulation",
      "Apply balanced fertilizer every 2-3 weeks",
      "Monitor for signs of blight or pest damage"
    ];
    const int wateringFrequencyDays = 3;
    const String sunlightNeeds = "Full sun (6-8 hours daily)";
    const int daysToMaturity = 75;
    const String soilType = "Well-draining, slightly acidic soil (pH 6.0-6.8)";
    const List<String> commonPests = ["Early Blight", "Late Blight", "Aphids", "Tomato Hornworms", "Fusarium Wilt"];
    final DateTime plantingDate = DateTime(2025, 3, 15); // March 15, 2025
    const bool reminderWatering = true;
    const bool reminderCare = true;
    const bool reminderFertilizing = false;
    const String notes = "These Roma tomatoes were started from seeds purchased from Baker Creek Heirloom Seeds. "
        "They've been growing well despite a cooler than normal spring. I've had good success with this variety "
        "in previous years, especially for making tomato sauce. For next season, consider planting 2 weeks earlier "
        "and using black plastic mulch to warm soil more quickly.";

    // Format the planting date
    final formattedDate = DateFormat('MMMM d, yyyy').format(plantingDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vegetable Detail'),
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
      // Using SingleChildScrollView to make entire content scrollable
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero image
            Container(
              width: double.infinity,
              height: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Content padding
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and season
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              name,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'ID: $id',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Chip(
                        label: const Text(growingSeason),
                        backgroundColor: Colors.green[100],
                        labelStyle: const TextStyle(color: Colors.green),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Planting date and reminders
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
                                isActive: reminderWatering,
                                icon: Icons.water_drop,
                              ),
                              ReminderChip(
                                label: 'Care',
                                isActive: reminderCare,
                                icon: Icons.yard,
                              ),
                              ReminderChip(
                                label: 'Fertilizing',
                                isActive: reminderFertilizing,
                                icon: Icons.eco,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Description
                  const SectionHeader(title: 'Description'),
                  const SizedBox(height: 8),
                  const Text(
                    description,
                    style: TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 24),

                  // Notes
                  const SectionHeader(title: 'Notes'),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            notes,
                            style: TextStyle(fontSize: 16),
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

                  // Growing information
                  const SectionHeader(title: 'Growing Information'),
                  const SizedBox(height: 16),

                  // Growing info card
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Watering needs
                          const InfoRow(
                            icon: Icons.water_drop,
                            iconColor: Colors.blue,
                            title: 'Watering',
                            value: 'Every $wateringFrequencyDays days',
                          ),

                          const Divider(height: 24),

                          // Sunlight needs
                          const InfoRow(
                            icon: Icons.wb_sunny,
                            iconColor: Colors.orange,
                            title: 'Sunlight',
                            value: sunlightNeeds,
                          ),

                          const Divider(height: 24),

                          // Days to maturity
                          InfoRow(
                            icon: Icons.calendar_today,
                            iconColor: Colors.purple,
                            title: 'Days to Maturity',
                            value: '$daysToMaturity days',
                          ),

                          const Divider(height: 24),

                          // Soil type
                          const InfoRow(
                            icon: Icons.landscape,
                            iconColor: Colors.brown,
                            title: 'Soil',
                            value: soilType,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Harvest date estimate
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
                                      plantingDate.add(Duration(days: daysToMaturity))
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

                  // Care instructions
                  const SectionHeader(title: 'Care Instructions'),
                  const SizedBox(height: 16),

                  // List of care instructions
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: careInstructions.map((instruction) {
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

                  // Common pests
                  const SectionHeader(title: 'Common Pests & Diseases'),
                  const SizedBox(height: 16),

                  // Pest chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: commonPests.map((pest) {
                      return Chip(
                        avatar: const Icon(Icons.bug_report, size: 16, color: Colors.red),
                        label: Text(pest),
                        backgroundColor: Colors.red[50],
                        labelStyle: TextStyle(color: Colors.red[800]),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 32),

                  // Actions
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

// Helper widget for section headers
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

// Helper widget for information rows
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

// Action button widget
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

// Reminder chip widget
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