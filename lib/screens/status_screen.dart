import 'package:flutter/material.dart';
import '../models/pet_state.dart';

class StatusScreen extends StatelessWidget {
  final PetState petState;

  const StatusScreen({super.key, required this.petState});

  static void show(BuildContext context, PetState petState) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatusScreen(petState: petState),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF0F0D1E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(
          top: BorderSide(color: Color(0xFF7F77DD), width: 0.5),
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
              color: const Color(0xFF7F77DD).withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
            child: Row(
              children: [
                const Text('⚡', style: TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                const Text(
                  'Status & Efek',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF7F77DD),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),

          Flexible(
            child: ListenableBuilder(
              listenable: petState,
              builder: (_, _) => SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: Column(
                  children: [
                    // Stat Cards
                    _buildStatGrid(context),

                    const SizedBox(height: 16),

                    // Status Effects
                    _buildStatusSection(context),

                    const SizedBox(height: 16),

                    // Apply effects
                    _buildEffectButtons(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      childAspectRatio: 1.1,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: [
        _StatCard(
          label: 'Level',
          value: '${petState.level}',
          icon: '⚔️',
          color: const Color(0xFF534AB7),
          subtitle: petState.levelTitle,
        ),
        _StatCard(
          label: 'Jiwa Dicabut',
          value: '${petState.soulsCollected}',
          icon: '💀',
          color: const Color(0xFF7F77DD),
        ),
        _StatCard(
          label: 'Total Makan',
          value: '${petState.totalFed}',
          icon: '🍖',
          color: const Color(0xFF1D9E75),
        ),
        _StatCard(
          label: 'Kuis Benar',
          value: '${petState.quizCorrect}',
          icon: '📜',
          color: const Color(0xFFEF9F27),
        ),
        _StatCard(
          label: 'Koin',
          value: '${petState.coins}',
          icon: '✨',
          color: const Color(0xFFEF9F27),
        ),
        _StatCard(
          label: 'Alam Baka',
          value: petState.realmName,
          icon: '🌑',
          color: const Color(0xFF9B59B6),
          isText: true,
        ),
      ],
    );
  }

  Widget _buildStatusSection(BuildContext context) {
    final current = petState.statusEffect;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1630),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF534AB7).withValues(alpha: 0.2),
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Status Aktif',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF7F77DD),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _statusColor(current).withValues(alpha: 0.15),
                  border: Border.all(
                    color: _statusColor(current).withValues(alpha: 0.4),
                    width: 0.8,
                  ),
                ),
                child: Text(
                  _statusIcon(current),
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _statusName(current),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _statusColor(current),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _statusDesc(current),
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF7F77DD),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEffectButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text(
            'Gunakan Efek (Biaya Koin)',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF7F77DD),
              letterSpacing: 0.5,
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _EffectButton(
                label: 'Berkah',
                icon: '✨',
                cost: 30,
                color: const Color(0xFFFFD700),
                onTap: () {
                  if (petState.coins >= 30) {
                    petState.addCoins(-30);
                    petState.applyStatusEffect('blessed', const Duration(minutes: 5));
                    Navigator.pop(context);
                    _showSnack(context, '✨ Status Berkah aktif selama 5 menit!', const Color(0xFFFFD700));
                  } else {
                    _showSnack(context, 'Koin tidak cukup! Butuh 30 koin.', const Color(0xFFE05C5C));
                  }
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _EffectButton(
                label: 'Kutukan',
                icon: '☠️',
                cost: 0,
                color: const Color(0xFF6A0DAD),
                isFree: true,
                onTap: () {
                  petState.applyStatusEffect('cursed', const Duration(minutes: 3));
                  Navigator.pop(context);
                  _showSnack(context, '☠️ Dikutuk selama 3 menit... awas!', const Color(0xFF6A0DAD));
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _EffectButton(
                label: 'Ethereal',
                icon: '👻',
                cost: 50,
                color: const Color(0xFF5DCAA5),
                onTap: () {
                  if (petState.coins >= 50) {
                    petState.addCoins(-50);
                    petState.applyStatusEffect('ethereal', const Duration(minutes: 10));
                    Navigator.pop(context);
                    _showSnack(context, '👻 Mode Ethereal aktif selama 10 menit!', const Color(0xFF5DCAA5));
                  } else {
                    _showSnack(context, 'Koin tidak cukup! Butuh 50 koin.', const Color(0xFFE05C5C));
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showSnack(BuildContext context, String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: color.withValues(alpha: 0.9),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
    ));
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'blessed': return const Color(0xFFFFD700);
      case 'cursed': return const Color(0xFF6A0DAD);
      case 'ethereal': return const Color(0xFF5DCAA5);
      default: return const Color(0xFF534AB7);
    }
  }

  String _statusIcon(String status) {
    switch (status) {
      case 'blessed': return '✨';
      case 'cursed': return '☠️';
      case 'ethereal': return '👻';
      default: return '😶';
    }
  }

  String _statusName(String status) {
    switch (status) {
      case 'blessed': return 'Berkah';
      case 'cursed': return 'Terkutuk';
      case 'ethereal': return 'Ethereal';
      default: return 'Normal';
    }
  }

  String _statusDesc(String status) {
    switch (status) {
      case 'blessed': return 'Lapar berkurang 50% lebih lambat';
      case 'cursed': return 'Lapar berkurang 50% lebih cepat!';
      case 'ethereal': return 'Tak bisa mati kelaparan sementara';
      default: return 'Tidak ada efek aktif';
    }
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String icon;
  final Color color;
  final String? subtitle;
  final bool isText;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
    this.isText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1630),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 0.7,
        ),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 4),
          Text(
            isText ? value : value,
            style: TextStyle(
              fontSize: isText ? 11 : 16,
              fontWeight: FontWeight.w700,
              color: color,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              color: color.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class _EffectButton extends StatelessWidget {
  final String label;
  final String icon;
  final int cost;
  final Color color;
  final bool isFree;
  final VoidCallback onTap;

  const _EffectButton({
    required this.label,
    required this.icon,
    required this.cost,
    required this.color,
    required this.onTap,
    this.isFree = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: color.withValues(alpha: 0.35),
            width: 0.8,
          ),
        ),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              isFree ? 'GRATIS' : '✨ $cost',
              style: TextStyle(
                fontSize: 9,
                color: isFree
                    ? const Color(0xFF1D9E75)
                    : const Color(0xFFEF9F27),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
