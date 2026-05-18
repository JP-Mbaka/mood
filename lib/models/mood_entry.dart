import 'dart:convert';
import 'package:flutter/material.dart';

enum MoodType { ecstatic, happy, neutral, sad, awful }

class MoodEntry {
  final MoodType mood;
  final DateTime timestamp;
  final String id;

  MoodEntry({
    required this.mood,
    required this.timestamp,
    String? id,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  // Mood display label
  String get label {
    switch (mood) {
      case MoodType.ecstatic:
        return 'Ecstatic';
      case MoodType.happy:
        return 'Happy';
      case MoodType.neutral:
        return 'Neutral';
      case MoodType.sad:
        return 'Sad';
      case MoodType.awful:
        return 'Awful';
    }
  }

  // Mood accent color
  Color get color {
    switch (mood) {
      case MoodType.ecstatic:
        return const Color(0xFFFFD700);
      case MoodType.happy:
        return const Color(0xFF4ECDC4);
      case MoodType.neutral:
        return const Color(0xFF95A5A6);
      case MoodType.sad:
        return const Color(0xFF6C63FF);
      case MoodType.awful:
        return const Color(0xFFE74C3C);
    }
  }

  // Serialize to JSON string for shared_preferences
  String toJson() {
    return jsonEncode({
      'mood': mood.index,
      'timestamp': timestamp.toIso8601String(),
      'id': id,
    });
  }

  factory MoodEntry.fromJson(String jsonStr) {
    final map = jsonDecode(jsonStr);
    return MoodEntry(
      mood: MoodType.values[map['mood'] as int],
      timestamp: DateTime.parse(map['timestamp'] as String),
      id: map['id'] as String,
    );
  }
}
