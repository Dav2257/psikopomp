import 'package:flutter/material.dart';
import '../models/pet_state.dart';

class ShopScreen extends StatelessWidget {
  final PetState petState;

  const ShopScreen({super.key, required this.petState});

  static void show(BuildContext context, PetState petState) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ShopScreen(petState: petState),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0D1E),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: const Border(
          top: BorderSide(color: Color(0xFF534AB7), width: 0.6),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF534AB7).withValues(alpha: 0.2),
            blurRadius: 30,
            spreadRadius: -5,
          ),
        ],
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
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
            child: Row(
              children: [
                const Text('⚰️', style: TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'TOKO ARWAH',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFAFA9EC),
                        letterSpacing: 2,
                      ),
                    ),
                    const Text(
                      'Makanan dari dimensi lain',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF7F77DD),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                ListenableBuilder(
                  listenable: petState,
                  builder: (_, _) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF9F27).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: const Color(0xFFEF9F27).withValues(alpha: 0.4),
                        width: 0.6,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Text('✨', style: TextStyle(fontSize: 14)),
                        const SizedBox(width: 5),
                        Text(
                          '${petState.coins}',
                          style: const TextStyle(
                            color: Color(0xFFEF9F27),
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Divider(
            color: const Color(0xFF534AB7).withValues(alpha: 0.15),
            height: 20,
            indent: 16,
            endIndent: 16,
          ),

          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
              itemCount: kShopItems.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = kShopItems[index];
                return _ShopItemCard(
                  item: item,
                  petState: petState,
                  onBuy: () => _handleBuy(context, item),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _handleBuy(BuildContext context, ShopItem item) {
    final message = petState.buyAndUse(item);
    final isError = message.contains('tidak cukup') || message.contains('kenyang');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? const Color(0xFF4A1020).withValues(alpha: 0.95)
            : const Color(0xFF0F2820).withValues(alpha: 0.95),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _ShopItemCard extends StatefulWidget {
  final ShopItem item;
  final PetState petState;
  final VoidCallback onBuy;

  const _ShopItemCard({
    required this.item,
    required this.petState,
    required this.onBuy,
  });

  @override
  State<_ShopItemCard> createState() => _ShopItemCardState();
}

class _ShopItemCardState extends State<_ShopItemCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 140),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.petState,
      builder: (_, _) {
        final canAfford = widget.petState.coins >= widget.item.price;

        return GestureDetector(
          onTapDown: canAfford ? (_) => _ctrl.forward() : null,
          onTapUp: canAfford
              ? (_) {
                  _ctrl.reverse();
                  widget.onBuy();
                }
              : null,
          onTapCancel: () => _ctrl.reverse(),
          child: AnimatedBuilder(
            animation: _ctrl,
            builder: (_, _) => Transform.scale(
              scale: _scale.value,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: canAfford
                      ? const Color(0xFF1A1630)
                      : const Color(0xFF0F0D1A),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: canAfford
                        ? const Color(0xFF534AB7).withValues(alpha: 0.3)
                        : const Color(0xFF534AB7).withValues(alpha: 0.08),
                    width: 0.8,
                  ),
                  boxShadow: canAfford
                      ? [
                          BoxShadow(
                            color: const Color(0xFF534AB7).withValues(alpha: 0.06),
                            blurRadius: 12,
                          ),
                        ]
                      : null,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      // Item icon
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFF26215C).withValues(alpha: canAfford ? 0.7 : 0.3),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(0xFF534AB7).withValues(alpha: 0.2),
                            width: 0.5,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          widget.item.emoji,
                          style: TextStyle(
                            fontSize: 28,
                            color: Colors.white.withValues(alpha: canAfford ? 1.0 : 0.35),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.item.name,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: canAfford
                                    ? const Color(0xFFCBCAE8)
                                    : const Color(0xFF534AB7),
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.item.description,
                              style: TextStyle(
                                fontSize: 11,
                                color: const Color(0xFF7F77DD).withValues(alpha: 0.6),
                              ),
                            ),
                            const SizedBox(height: 7),
                            Row(
                              children: [
                                _Pill(
                                  text: '+${widget.item.hungerRestore.toInt()} energi',
                                  color: const Color(0xFF1D9E75),
                                ),
                                const SizedBox(width: 6),
                                _Pill(
                                  text: '+${widget.item.xpReward} XP',
                                  color: const Color(0xFF534AB7),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 10),

                      // Price & buy
                      Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('✨', style: TextStyle(fontSize: 13)),
                              const SizedBox(width: 3),
                              Text(
                                '${widget.item.price}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: canAfford
                                      ? const Color(0xFFEF9F27)
                                      : const Color(0xFF534AB7),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 7),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 7),
                            decoration: BoxDecoration(
                              gradient: canAfford
                                  ? const LinearGradient(
                                      colors: [Color(0xFF3D3580), Color(0xFF534AB7)],
                                    )
                                  : null,
                              color: canAfford
                                  ? null
                                  : const Color(0xFF26215C).withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: canAfford
                                  ? [
                                      BoxShadow(
                                        color: const Color(0xFF534AB7).withValues(alpha: 0.3),
                                        blurRadius: 8,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Text(
                              canAfford ? 'Beli' : 'Kurang',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: canAfford
                                    ? Colors.white
                                    : const Color(0xFF534AB7),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final Color color;
  const _Pill({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 0.5),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 9,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}