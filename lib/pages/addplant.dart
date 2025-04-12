import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddPlantForm extends StatefulWidget {
  const AddPlantForm({Key? key}) : super(key: key);

  @override
  _AddPlantFormState createState() => _AddPlantFormState();
}

class _AddPlantFormState extends State<AddPlantForm> {
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
        title: const Text('Dodaj Roślinkę'),
      ),
      body: const Center(
        child: Text(
          'Strona dodawania rośliny',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}