import 'package:flutter/material.dart';
import '../models/pet_state.dart';

class HungerBar extends StatelessWidget {
  final PetState petState;

  const HungerBar({super.key, required this.petState});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF0F0D1E).withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: petState.hungerColor.withValues(alpha: 0.25),
            width: 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: petState.hungerColor.withValues(alpha: 0.08),
              blurRadius: 16,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                // Icon + Label
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: petState.hungerColor.withValues(alpha: 0.12),
                  ),
                  child: const Center(
                    child: Text('🍖', style: TextStyle(fontSize: 14)),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Energi Jiwa',
                  style: TextStyle(
                    fontSize: 12,
                    color: const Color(0xFFAFA9EC).withValues(alpha: 0.7),
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: petState.hungerColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: petState.hungerColor.withValues(alpha: 0.3),
                      width: 0.5,
                    ),
                  ),
                  child: Text(
                    petState.hungerLabel,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: petState.hungerColor,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${petState.hunger.toInt()}%',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: petState.hungerColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                children: [
                  // Background track
                  Container(
                    height: 10,
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                  // Filled part
                  AnimatedFractionallySizedBox(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOut,
                    widthFactor: (petState.hunger / 100).clamp(0.0, 1.0),
                    child: Container(
                      height: 10,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            petState.hungerColor.withValues(alpha: 0.7),
                            petState.hungerColor,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: petState.hunger < 30
                            ? [
                                BoxShadow(
                                  color: petState.hungerColor.withValues(alpha: 0.6),
                                  blurRadius: 8,
                                ),
                              ]
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // XP Bar
            Row(
              children: [
                Text(
                  'LVL ${petState.level}',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF7F77DD),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Stack(
                      children: [
                        Container(height: 5, color: Colors.white.withValues(alpha: 0.05)),
                        AnimatedFractionallySizedBox(
                          duration: const Duration(milliseconds: 600),
                          widthFactor: petState.xpProgress,
                          child: Container(
                            height: 5,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF534AB7), Color(0xFF7F77DD)],
                              ),
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF534AB7).withValues(alpha: 0.5),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${petState.currentLevelXp}/${petState.xpToNextLevel} XP',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF7F77DD),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}