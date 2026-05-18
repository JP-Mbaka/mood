import 'package:flutter/material.dart';
import 'package:mood/models/mood_entry.dart';
import 'package:mood/screens/widgets/mood_selector.dart';
import 'package:mood/screens/widgets/timeline_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  MoodType? _selectedMood;
  bool _logged = false;

  late AnimationController _logButtonController;
  late Animation<double> _logButtonScale;

  @override
  void initState() {
    super.initState(); // ← MOVE THIS TO THE TOP

    _logButtonController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _logButtonScale = Tween(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _logButtonController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _logButtonController.dispose();
    super.dispose();
  }

  Future<void> _logMood() async {
    if (_selectedMood == null) return;

    await _logButtonController.forward();
    await _logButtonController.reverse();

    setState(() {
      _logged = true;
      _selectedMood = null;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _logged = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF4ECDC4),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'MOOD TRACKER',
                            style: TextStyle(
                              color: Color(0xFF4ECDC4),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 3,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'How are you\nfeeling today?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: _logged
                        ? Row(
                            key: const ValueKey('confirmed'),
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF4ECDC4,
                                  ).withOpacity(0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Color(0xFF4ECDC4),
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Mood logged! Keep it up.',
                                style: TextStyle(
                                  color: Color(0xFF4ECDC4),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                        : const Text(
                            'Select your mood below and tap "Log Mood" to record it.',
                            key: ValueKey('prompt'),
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 15,
                              height: 1.5,
                            ),
                          ),
                  ),
                  const SizedBox(height: 32),

                  // ─── Mood Selectors ───
                  if (!_logged)
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: MoodType.values.map((mood) {
                        return MoodSelector(
                          mood: mood,
                          isSelected: _selectedMood == mood,
                          onTap: () => setState(() => _selectedMood = mood),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 32),
                  // ─── Log Button ───
                  if (!_logged)
                    AnimatedBuilder(
                      animation: _logButtonScale,
                      builder: (context, child) => Transform.scale(
                        scale: _logButtonScale.value,
                        child: GestureDetector(
                          onTap: _selectedMood != null ? _logMood : null,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            height: 56,
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            decoration: BoxDecoration(
                              gradient: _selectedMood != null
                                  ? const LinearGradient(
                                      colors: [
                                        Color(0xFF6C63FF),
                                        Color(0xFF4ECDC4),
                                      ],
                                    )
                                  : null,
                              color: _selectedMood != null
                                  ? null
                                  : Colors.white10,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: _selectedMood != null
                                  ? [
                                      BoxShadow(
                                        color: const Color(
                                          0xFF6C63FF,
                                        ).withOpacity(0.4),
                                        blurRadius: 20,
                                        offset: const Offset(0, 6),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.add_circle_outline_rounded,
                                  color: _selectedMood != null
                                      ? Colors.white
                                      : Colors.white24,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  _selectedMood != null
                                      ? 'Log Mood'
                                      : 'Select a mood first',
                                  style: TextStyle(
                                    color: _selectedMood != null
                                        ? Colors.white
                                        : Colors.white24,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 56),

                  // ─── Timeline ───
                  if (1 + 1 == 2) ...[
                    Row(
                      children: [
                        const Text(
                          'Recent Moods',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Last 2',
                            style: const TextStyle(
                              color: Colors.white38,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          child: const Text(
                            'Clear',
                            style: TextStyle(
                              color: Colors.white24,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 2,
                        itemBuilder: (context, index) => TimelineCard(
                          entry: MoodEntry(
                            mood: MoodType.happy,
                            timestamp: DateTime.now(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
