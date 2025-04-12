// Model rośliny
class Plant {
  final String id;
  final String name;
  final String imageUrl;
  final String description;
  final String growingSeason;
  final List<String> careInstructions;
  final int wateringFrequencyDays;
  final String sunlightNeeds;
  final int daysToMaturity;
  final String soilType;
  final List<String> commonPests;
  final DateTime plantingDate;
  final bool reminderWatering;
  final bool reminderCare;
  final bool reminderFertilizing;
  final String notes;

  Plant({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.growingSeason,
    required this.careInstructions,
    required this.wateringFrequencyDays,
    required this.sunlightNeeds,
    required this.daysToMaturity,
    required this.soilType,
    required this.commonPests,
    required this.plantingDate,
    this.reminderWatering = false,
    this.reminderCare = false,
    this.reminderFertilizing = false,
    this.notes = '',
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      description: json['description'],
      growingSeason: json['growingSeason'],
      careInstructions: List<String>.from(json['careInstructions']),
      wateringFrequencyDays: json['wateringFrequencyDays'],
      sunlightNeeds: json['sunlightNeeds'],
      daysToMaturity: json['daysToMaturity'],
      soilType: json['soilType'],
      commonPests: List<String>.from(json['commonPests']),
      plantingDate: json['plantingDate'] != null
          ? DateTime.parse(json['plantingDate'])
          : DateTime.now(),
      reminderWatering: json['reminderWatering'] ?? false,
      reminderCare: json['reminderCare'] ?? false,
      reminderFertilizing: json['reminderFertilizing'] ?? false,
      notes: json['notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'description': description,
      'growingSeason': growingSeason,
      'careInstructions': careInstructions,
      'wateringFrequencyDays': wateringFrequencyDays,
      'sunlightNeeds': sunlightNeeds,
      'daysToMaturity': daysToMaturity,
      'soilType': soilType,
      'commonPests': commonPests,
      'plantingDate': plantingDate.toIso8601String(),
      'reminderWatering': reminderWatering,
      'reminderCare': reminderCare,
      'reminderFertilizing': reminderFertilizing,
      'notes': notes,
    };
  }
}