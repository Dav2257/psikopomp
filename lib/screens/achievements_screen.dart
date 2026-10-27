import 'package:flutter/material.dart';
import '../models/pet_state.dart';

class AchievementsScreen extends StatelessWidget {
  final PetState petState;

  const AchievementsScreen({super.key, required this.petState});

  static void show(BuildContext context, PetState petState) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AchievementsScreen(petState: petState),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF0F0D1E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(
          top: BorderSide(color: Color(0xFFEF9F27), width: 0.5),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFEF9F27).withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            child: Row(
              children: [
                const Text('🏆', style: TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pencapaian',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFEF9F27),
                        letterSpacing: 0.5,
                      ),
                    ),
                    ListenableBuilder(
                      listenable: petState,
                      builder: (_, _) => Text(
                        '${petState.unlockedAchievementsCount}/${petState.achievements.length} terbuka',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF7F77DD),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Divider(
            color: const Color(0xFFEF9F27).withValues(alpha: 0.15),
            height: 20,
          ),

          Flexible(
            child: ListenableBuilder(
              listenable: petState,
              builder: (_, _) => GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: petState.achievements.length,
                itemBuilder: (_, i) => _AchievementCard(
                  achievement: petState.achievements[i],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final Achievement achievement;
  const _AchievementCard({required this.achievement});

  @override
  Widget build(BuildContext context) {
    final unlocked = achievement.unlocked;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      decoration: BoxDecoration(
        color: unlocked
            ? const Color(0xFF1A1420)
            : const Color(0xFF0F0D1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: unlocked
              ? const Color(0xFFEF9F27).withValues(alpha: 0.5)
              : const Color(0xFF534AB7).withValues(alpha: 0.15),
          width: 0.8,
        ),
        boxShadow: unlocked
            ? [
                BoxShadow(
                  color: const Color(0xFFEF9F27).withValues(alpha: 0.1),
                  blurRadius: 12,
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              unlocked ? achievement.icon : '🔒',
              style: TextStyle(
                fontSize: 26,
                color: unlocked ? null : Colors.white.withValues(alpha: 0.2),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              achievement.name,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: unlocked
                    ? const Color(0xFFEF9F27)
                    : const Color(0xFF534AB7).withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 3),
            Text(
              achievement.description,
              style: TextStyle(
                fontSize: 9,
                color: unlocked
                    ? const Color(0xFF7F77DD).withValues(alpha: 0.8)
                    : const Color(0xFF534AB7).withValues(alpha: 0.3),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
