import 'dart:io';
import 'dart:convert';
import 'package:hackcarpathia2025ogrody/models/plant.dart';
import 'package:path_provider/path_provider.dart';

class UserPlantsStorage {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/user_plants.json');
  }

  static Future<File> saveUserPlants(List<Plant> plants) async {
    final file = await _localFile;
    final plantsJson = plants.map((plant) => plant.toJson()).toList();
    return file.writeAsString(jsonEncode(plantsJson));
  }

  static Future<List<Plant>> loadUserPlants() async {
    try {
      final file = await _localFile;

      if (!await file.exists()) {
        await file.writeAsString('[]');
        return [];
      }

      final contents = await file.readAsString();
      final List<dynamic> jsonData = jsonDecode(contents);
      return jsonData.map<Plant>((json) => Plant.fromJson(json)).toList();
    } catch (e) {
      print('Błąd odczytu pliku: $e');
      return [];
    }
  }

  static Future<void> addPlant(Plant plant) async {
    List<Plant> plants = await loadUserPlants();
    plants.add(plant);
    await saveUserPlants(plants);
  }
}