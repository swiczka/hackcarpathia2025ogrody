
import 'package:flutter/material.dart';

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
    );
  }
}

class VegetableDetailPage extends StatelessWidget {
  const VegetableDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String name = "Tomato";
    const String imageUrl = "https://via.placeholder.com/400x200";
    const String description =
        "Tomatoes are the fruit of the plant Solanum lycopersicum, commonly known as a tomato plant. "
        "They are widely grown and have become a staple food in many cuisines around the world. "
        "They are rich in lycopene, which has been linked to many health benefits, including reduced "
        "risk of heart disease and cancer. They are also a great source of vitamin C, potassium, folate, and vitamin K.";
    const String growingSeason = "Summer";
    const List<String> careInstructions = [
      "Plant in well-draining soil",
      "Water deeply but infrequently",
      "Provide support for tall varieties",
      "Pinch off suckers for indeterminate varieties",
      "Fertilize every 4-6 weeks during growing season",
      "Harvest when fruits are firm and fully colored"
    ];
    const int wateringFrequencyDays = 2;
    const String sunlightNeeds = "Full sun (6-8 hours daily)";
    const int daysToMaturity = 70;
    const String soilType = "Well-draining, slightly acidic soil (pH 6.0-6.8)";
    const List<String> commonPests = ["Aphids", "Tomato Hornworms", "Whiteflies", "Spider Mites"];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vegetable Detail'),
        elevation: 0,
      ),
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

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and season
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        name,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Chip(
                        label: const Text(growingSeason),
                        backgroundColor: Colors.green[100],
                        labelStyle: const TextStyle(color: Colors.green),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    description,
                    style: TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Growing Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const InfoRow(
                            icon: Icons.water_drop,
                            iconColor: Colors.blue,
                            title: 'Watering',
                            value: 'Every $wateringFrequencyDays days',
                          ),

                          const Divider(height: 24),

                          const InfoRow(
                            icon: Icons.wb_sunny,
                            iconColor: Colors.orange,
                            title: 'Sunlight',
                            value: sunlightNeeds,
                          ),

                          const Divider(height: 24),

                          InfoRow(
                            icon: Icons.calendar_today,
                            iconColor: Colors.purple,
                            title: 'Days to Maturity',
                            value: '$daysToMaturity days',
                          ),

                          const Divider(height: 24),

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

                  const Text(
                    'Care Instructions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

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

                  const Text(
                    'Common Pests',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

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
                        icon: Icons.add_task,
                        label: 'Add to My Garden',
                        color: Colors.green,
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Added to Garden')),
                          );
                        },
                      ),
                      ActionButton(
                        icon: Icons.calendar_month,
                        label: 'Set Reminders',
                        color: Colors.blue,
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Reminder feature coming soon')),
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