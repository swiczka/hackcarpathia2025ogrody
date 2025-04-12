import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddPlant extends StatefulWidget {
  const AddPlant({Key? key}) : super(key: key);

  @override
  _AddPlantFormState createState() => _AddPlantFormState();
}

class _AddPlantFormState extends State<AddPlant> {
  final _formKey = GlobalKey<FormState>();

  // Zmienne formularza
  String? _selectedPlant;
  DateTime _plantingDate = DateTime.now();
  bool _reminderWatering = false;
  bool _reminderCare = false;
  bool _reminderFertilizing = false;
  String _notes = '';

  // Lista przykładowych roślin do wyboru
  final List<String> _plantTypes = [
    'Pomidor',
    'Ogórek',
    'Marchew',
    'Truskawka',
    'Papryka',
    'Sałata',
    'Rzodkiewka',
    'Cebula',
    'Pietruszka',
    'Bazylia',
    'Mięta',
    'Róża',
    'Tulipan',
    'Lawenda',
  ];

  // Metoda wyświetlająca wybór daty
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

  @override
  Widget build(BuildContext context) {
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
                  value: _selectedPlant,
                  items: _plantTypes.map((String plant) {
                    return DropdownMenuItem<String>(
                      value: plant,
                      child: Text(plant),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPlant = newValue;
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Tutaj dodać kod zapisujący dane
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
}