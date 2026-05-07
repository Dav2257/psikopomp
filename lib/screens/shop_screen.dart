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
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF120F24),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(color: Color(0xFF534AB7), width: 0.5),
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
              color: const Color(0xFF534AB7).withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
 
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            child: Row(
              children: [
                const Text(
                  '🏪',
                  style: TextStyle(fontSize: 22),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Toko Jiwa',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFAFA9EC),
                    letterSpacing: 1,
                  ),
                ),
                const Spacer(),
                ListenableBuilder(
                  listenable: petState,
                  builder: (_, __) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF9F27).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFEF9F27).withValues(alpha: 0.4),
                        width: 0.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('✨', style: TextStyle(fontSize: 14)),
                        const SizedBox(width: 4),
                        Text(
                          '${petState.coins}',
                          style: const TextStyle(
                            color: Color(0xFFEF9F27),
                            fontWeight: FontWeight.w700,
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
 
          const SizedBox(height: 8),
 
          Divider(
            color: const Color(0xFF534AB7).withValues(alpha: 0.2),
            height: 1,
          ),
 
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              itemCount: kShopItems.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
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
 
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: message.contains('tidak cukup') || message.contains('kenyang')
            ? const Color(0xFF4A2020) 
            : const Color(0xFF1A3020), 
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
 
class _ShopItemCard extends StatelessWidget {
  final ShopItem item;
  final PetState petState;
  final VoidCallback onBuy;
 
  const _ShopItemCard({
    required this.item,
    required this.petState,
    required this.onBuy,
  });
 
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: petState,
      builder: (_, __) {
        final canAfford = petState.coins >= item.price;
 
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: canAfford
                ? const Color(0xFF1A1630)
                : const Color(0xFF0F0D1A), 
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: canAfford
                  ? const Color(0xFF534AB7).withValues(alpha: 0.3)
                  : const Color(0xFF534AB7).withValues(alpha: 0.1),
              width: 0.5,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              onTap: canAfford ? onBuy : null,
              borderRadius: BorderRadius.circular(14),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFF26215C).withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        item.emoji,
                        style: TextStyle(
                          fontSize: 26,
                          color: Colors.white.withValues(alpha: canAfford ? 1.0 : 0.4),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
 
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: canAfford
                                  ? const Color(0xFFAFA9EC)
                                  : const Color(0xFF534AB7),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.description,
                            style: TextStyle(
                              fontSize: 11,
                              color: const Color(0xFF7F77DD).withValues(alpha: 0.7),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1D9E75).withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: const Color(0xFF1D9E75).withValues(alpha: 0.3),
                                    width: 0.5,
                                  ),
                                ),
                                child: Text(
                                  '+${item.hungerRestore.toInt()} hunger',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFF1D9E75),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
 
                    const SizedBox(width: 10),
 
                    Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('✨', style: TextStyle(fontSize: 12)),
                            const SizedBox(width: 3),
                            Text(
                              '${item.price}',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: canAfford
                                    ? const Color(0xFFEF9F27)
                                    : const Color(0xFF534AB7),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        // Tombol beli
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: canAfford
                                ? const Color(0xFF534AB7).withValues(alpha: 0.8)
                                : const Color(0xFF26215C).withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            canAfford ? 'Beli' : 'Kurang',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: canAfford
                                  ? Colors.white
                                  : const Color(0xFF534AB7),
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
        );
      },
    );
  }
}