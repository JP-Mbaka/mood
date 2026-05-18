import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/mood_entry.dart';

class MoodProvider extends ChangeNotifier {
  static const _storageKey = 'mood_entries';

  List<MoodEntry> _entries = [];
  bool _isLoading = true;

  List<MoodEntry> get entries => _entries;
  bool get isLoading => _isLoading;

  // Last 7 entries, newest first for timeline display
  List<MoodEntry> get recentEntries {
    final sorted = List<MoodEntry>.from(_entries)
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return sorted.take(7).toList();
  }

  MoodProvider() {
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_storageKey) ?? [];
    _entries = raw.map((s) => MoodEntry.fromJson(s)).toList();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveEntries() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _storageKey,
      _entries.map((e) => e.toJson()).toList(),
    );
  }

  Future<void> addEntry(MoodType mood) async {
    final entry = MoodEntry(mood: mood, timestamp: DateTime.now());
    _entries.add(entry);
    await _saveEntries();
    notifyListeners();
  }

  Future<void> clearAll() async {
    _entries.clear();
    await _saveEntries();
    notifyListeners();
  }
}
