import 'package:flutter/material.dart';
 
class ShopItem {
  final String id;
  final String name;
  final String emoji;
  final String description;
  final int price;        
  final double hungerRestore;
 
  const ShopItem({
    required this.id,
    required this.name,
    required this.emoji,
    required this.description,
    required this.price,
    required this.hungerRestore,
  });
}
 
const List<ShopItem> kShopItems = [
  ShopItem(
    id: 'soul_candy',
    name: 'Soul Candy',
    emoji: '🍬',
    description: 'Permen dari jiwa yang manis',
    price: 5,
    hungerRestore: 20,
  ),
  ShopItem(
    id: 'ghost_bread',
    name: 'Ghost Bread',
    emoji: '🍞',
    description: 'Roti panggang dari alam baka',
    price: 10,
    hungerRestore: 35,
  ),
  ShopItem(
    id: 'spirit_soup',
    name: 'Spirit Soup',
    emoji: '🍲',
    description: 'Sup hangat penuh energi jiwa',
    price: 18,
    hungerRestore: 55,
  ),
  ShopItem(
    id: 'phantom_feast',
    name: 'Phantom Feast',
    emoji: '🍱',
    description: 'Pesta makan malam dari dimensi lain',
    price: 30,
    hungerRestore: 80,
  ),
  ShopItem(
    id: 'void_cake',
    name: 'Void Cake',
    emoji: '🎂',
    description: 'Kue dari kekosongan abadi',
    price: 50,
    hungerRestore: 100,
  ),
];
 
class PetState extends ChangeNotifier {
  double _hunger = 75.0;  
  int _coins = 40;        
 
  double get hunger => _hunger;
  int get coins => _coins;
 
  String get hungerLabel {
    if (_hunger >= 80) return 'Kenyang';
    if (_hunger >= 60) return 'Baik';
    if (_hunger >= 40) return 'Agak Lapar';
    if (_hunger >= 20) return 'Lapar';
    return 'Sangat Lapar!';
  }
 
  Color get hungerColor {
    if (_hunger >= 60) return const Color(0xFF1D9E75);  
    if (_hunger >= 30) return const Color(0xFFEF9F27);  
    return const Color(0xFFE05C5C);                     
  }
 
  String get mood {
    if (_hunger < 15) return 'hungry';
    if (_hunger < 35) return 'sad';
    if (_hunger >= 70) return 'happy';
    return 'neutral';
  }
 
  void decayHunger(double amount) {
    _hunger = (_hunger - amount).clamp(0.0, 100.0);
    notifyListeners(); 
  }
 
  String buyAndUse(ShopItem item) {
    if (_coins < item.price) {
      return 'Koin tidak cukup! 😢';
    }
 
    if (_hunger >= 95) {
      return 'Psikopomp sudah kenyang!';
    }
 
    _coins -= item.price;
    _hunger = (_hunger + item.hungerRestore).clamp(0.0, 100.0);
    notifyListeners();
 
    return '${item.name} dimakan! +${item.hungerRestore.toInt()} hunger 🍽️';
  }
 
  void addCoins(int amount) {
    _coins += amount;
    notifyListeners();
  }
}