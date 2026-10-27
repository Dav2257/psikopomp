import 'package:flutter/material.dart';
import '../models/pet_state.dart';

class MissionsScreen extends StatelessWidget {
  final PetState petState;

  const MissionsScreen({super.key, required this.petState});

  static void show(BuildContext context, PetState petState) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MissionsScreen(petState: petState),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.82,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF0F0D1E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(
          top: BorderSide(color: Color(0xFF534AB7), width: 0.5),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF534AB7).withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            child: Row(
              children: [
                const Text('📜', style: TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Misi Harian',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFAFA9EC),
                        letterSpacing: 0.5,
                      ),
                    ),
                    ListenableBuilder(
                      listenable: petState,
                      builder: (_, _) => Text(
                        '${petState.completedMissionsCount}/${petState.dailyMissions.length} selesai',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF7F77DD),
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF9F27).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFEF9F27).withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Text('🔄', style: TextStyle(fontSize: 13)),
                      SizedBox(width: 4),
                      Text(
                        'Reset Besok',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFFEF9F27),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Divider(
            color: const Color(0xFF534AB7).withValues(alpha: 0.15),
            height: 20,
          ),

          Flexible(
            child: ListenableBuilder(
              listenable: petState,
              builder: (_, _) => ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                itemCount: petState.dailyMissions.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (_, i) => _MissionCard(
                  mission: petState.dailyMissions[i],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MissionCard extends StatelessWidget {
  final DailyMission mission;
  const _MissionCard({required this.mission});

  @override
  Widget build(BuildContext context) {
    final isDone = mission.completed;
    final borderColor = isDone
        ? const Color(0xFF1D9E75).withValues(alpha: 0.5)
        : const Color(0xFF534AB7).withValues(alpha: 0.25);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: isDone
            ? const Color(0xFF0F3020).withValues(alpha: 0.6)
            : const Color(0xFF1A1630),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 0.8),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(mission.icon, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mission.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDone
                            ? const Color(0xFF1D9E75)
                            : const Color(0xFFAFA9EC),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      mission.description,
                      style: TextStyle(
                        fontSize: 11,
                        color: const Color(0xFF7F77DD).withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              if (isDone)
                const Icon(Icons.check_circle, color: Color(0xFF1D9E75), size: 22)
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Text(
                          '✨ ${mission.rewardCoins}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFFEF9F27),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '+${mission.rewardXp} XP',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF7F77DD),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ),

          const SizedBox(height: 10),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: mission.progress,
              minHeight: 6,
              backgroundColor: Colors.white.withValues(alpha: 0.05),
              valueColor: AlwaysStoppedAnimation<Color>(
                isDone ? const Color(0xFF1D9E75) : const Color(0xFF534AB7),
              ),
            ),
          ),

          const SizedBox(height: 5),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${mission.currentCount} / ${mission.targetCount}',
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF7F77DD),
                ),
              ),
              if (isDone)
                const Text(
                  '✅ Misi Selesai!',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF1D9E75),
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
