import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:hackcarpathia2025ogrody/models/userplantsstorage.dart';
import 'package:intl/intl.dart';

import '../models/plant.dart';



class PlantService {
  // Załaduj dane roślin z pliku JSON
  static Future<List<Plant>> loadPlants() async {
    final String jsonString = await rootBundle.loadString('assets/data.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    return jsonData.map((plantJson) => Plant.fromJson(plantJson)).toList();
  }
}

class AddPlant extends StatefulWidget {
  const AddPlant({Key? key}) : super(key: key);

  @override
  _AddPlantState createState() => _AddPlantState();
}

class _AddPlantState extends State<AddPlant> {
  final _formKey = GlobalKey<FormState>();

  // Zmienne formularza
  String? _selectedPlantId;
  DateTime _plantingDate = DateTime.now();
  bool _reminderWatering = false;
  bool _reminderCare = false;
  bool _reminderFertilizing = false;
  String _notes = '';

  // Lista roślin z JSON
  List<Plant> _plants = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPlantsData();
  }

  Future<void> _loadPlantsData() async {
    try {
      final plants = await PlantService.loadPlants();
      setState(() {
        _plants = plants;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Błąd ładowania danych: $e')),
      );
    }
  }

  // Metoda wyboru daty
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _plantingDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _plantingDate) {
      setState(() {
        _plantingDate = picked;
      });
    }
  }

  // Metoda do znajdowania szczegółów wybranej rośliny
  Plant? _getSelectedPlantDetails() {
    if (_selectedPlantId == null) return null;
    try {
      return _plants.firstWhere((plant) => plant.id == _selectedPlantId);
    } catch (e) {
      return null;
    }
  }

  // Metoda do wypełniania formularza danymi wybranej rośliny
  void _populateFormWithPlantData(Plant plant) {
    setState(() {
      _reminderWatering = plant.reminderWatering;
      _reminderCare = plant.reminderCare;
      _reminderFertilizing = plant.reminderFertilizing;
      _notes = plant.notes;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Jeśli dane są ładowane, pokaż wskaźnik ładowania
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Dodaj nową roślinę'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Szczegóły wybranej rośliny
    Plant? selectedPlant = _getSelectedPlantDetails();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dodaj nową roślinę'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Wybór gatunku rośliny
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Wybierz gatunek rośliny',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedPlantId,
                  items: _plants.map((Plant plant) {
                    return DropdownMenuItem<String>(
                      value: plant.id,
                      child: Text(plant.name),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPlantId = newValue;

                      // Jeśli wybrano roślinę, pobierz jej szczegóły
                      if (newValue != null) {
                        Plant plant = _plants.firstWhere((p) => p.id == newValue);
                        _populateFormWithPlantData(plant);
                      }
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Proszę wybrać gatunek rośliny';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Informacje o wybranej roślinie
                if (selectedPlant != null) ...[
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Zdjęcie rośliny
                        if (selectedPlant.imageUrl.isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              selectedPlant.imageUrl,
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),

                        const SizedBox(height: 8),

                        // Opis rośliny
                        Text(
                          selectedPlant.description,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),

                        const SizedBox(height: 8),

                        // Podstawowe informacje
                        _buildInfoRow('Sezon wzrostu:', selectedPlant.growingSeason),
                        _buildInfoRow('Podlewanie co:', '${selectedPlant.wateringFrequencyDays} dni'),
                        _buildInfoRow('Potrzeby słoneczne:', selectedPlant.sunlightNeeds),
                        _buildInfoRow('Dni do dojrzałości:', '${selectedPlant.daysToMaturity}'),
                        _buildInfoRow('Typ gleby:', selectedPlant.soilType),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                ],

                // Wybór daty posadzenia
                InkWell(
                  onTap: () => _selectDate(context),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Data posadzenia',
                      border: OutlineInputBorder(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(DateFormat('dd.MM.yyyy').format(_plantingDate)),
                        const Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Sekcja przypomnień
                const Text(
                  'Przypomnienia:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),

                CheckboxListTile(
                  title: const Text('Przypominaj o podlewaniu'),
                  value: _reminderWatering,
                  onChanged: (bool? value) {
                    setState(() {
                      _reminderWatering = value ?? false;
                    });
                  },
                ),

                CheckboxListTile(
                  title: const Text('Przypominaj o pielęgnacji'),
                  value: _reminderCare,
                  onChanged: (bool? value) {
                    setState(() {
                      _reminderCare = value ?? false;
                    });
                  },
                ),

                CheckboxListTile(
                  title: const Text('Przypominaj o nawożeniu'),
                  value: _reminderFertilizing,
                  onChanged: (bool? value) {
                    setState(() {
                      _reminderFertilizing = value ?? false;
                    });
                  },
                ),

                const SizedBox(height: 16),

                // Pole na notatki
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Notatki',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  initialValue: _notes,
                  maxLines: 5,
                  onChanged: (value) {
                    _notes = value;
                  },
                ),

                const SizedBox(height: 24),

                // Przycisk zapisywania
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          Plant newPlant = Plant(
                            id: selectedPlant?.id ?? "",
                            name: selectedPlant?.name ?? "",
                            imageUrl: selectedPlant?.imageUrl ?? "",
                            description: selectedPlant?.description ?? "",
                            growingSeason: selectedPlant?.growingSeason ?? "",
                            careInstructions: selectedPlant?.careInstructions ?? [],
                            wateringFrequencyDays: selectedPlant?.wateringFrequencyDays ?? 0,
                            sunlightNeeds: selectedPlant?.sunlightNeeds ?? "",
                            daysToMaturity: selectedPlant?.daysToMaturity ?? 0,
                            soilType: selectedPlant?.soilType ?? "",
                            commonPests: selectedPlant?.commonPests ?? [],
                            plantingDate: _plantingDate ?? DateTime.now(),
                            reminderWatering: _reminderWatering ?? true,
                            reminderCare: _reminderCare ?? true,
                            reminderFertilizing: _reminderFertilizing ?? true,
                            notes: _notes ?? "",
                          );
                          UserPlantsStorage.addPlant(newPlant);

                        } catch(error){
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Błąd dodawania!')),
                          );
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Roślina została dodana')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text('Zapisz roślinę'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper do wyświetlania informacji o roślinie
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}