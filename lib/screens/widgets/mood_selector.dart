import 'package:flutter/material.dart';
import 'package:mood/models/mood_entry.dart';
import 'package:mood/painters/mood_face_painter.dart';

class MoodSelector extends StatefulWidget {
  final MoodType mood;
  final bool isSelected;
  final VoidCallback onTap;

  const MoodSelector({
    super.key,
    required this.mood,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<MoodSelector> createState() => _MoodSelectorState();
}

class _MoodSelectorState extends State<MoodSelector>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _hoverAnim;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _hoverAnim = Tween(begin: 1.0, end: 1.1)
        .animate(CurvedAnimation(parent: _hoverController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = MoodEntry(mood: widget.mood, timestamp: DateTime.now()).color;
    final label = MoodEntry(mood: widget.mood, timestamp: DateTime.now()).label;

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _hoverController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _hoverController.reverse();
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _hoverAnim,
          builder: (context, _) => Transform.scale(
            scale: widget.isSelected ? 1.12 : _hoverAnim.value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 90,
              height: 110,
              decoration: BoxDecoration(
                color: widget.isSelected
                    ? color.withOpacity(0.18)
                    : Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: widget.isSelected ? color : color.withOpacity(0.25),
                  width: widget.isSelected ? 2 : 1,
                ),
                boxShadow: widget.isSelected
                    ? [
                        BoxShadow(
                          color: color.withOpacity(0.4),
                          blurRadius: 20,
                          spreadRadius: 2,
                        )
                      ]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CustomPaint(
                      painter: MoodFacePainter(mood: widget.mood, color: color),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    style: TextStyle(
                      color: widget.isSelected ? color : color.withOpacity(0.7),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
