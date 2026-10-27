import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

// ─── Shop Items ────────────────────────────────────────────────────────────────
class ShopItem {
  final String id;
  final String name;
  final String emoji;
  final String description;
  final int price;
  final double hungerRestore;
  final int xpReward;

  const ShopItem({
    required this.id,
    required this.name,
    required this.emoji,
    required this.description,
    required this.price,
    required this.hungerRestore,
    this.xpReward = 5,
  });
}

const List<ShopItem> kShopItems = [
  ShopItem(
    id: 'soul_candy',
    name: 'Jiwa Permen',
    emoji: '🍬',
    description: 'Permen manis dari jiwa yang tersisa',
    price: 5,
    hungerRestore: 20,
    xpReward: 5,
  ),
  ShopItem(
    id: 'ghost_bread',
    name: 'Roti Arwah',
    emoji: '🍞',
    description: 'Dipanggang di api neraka paling kecil',
    price: 10,
    hungerRestore: 35,
    xpReward: 10,
  ),
  ShopItem(
    id: 'spirit_soup',
    name: 'Sup Jiwa',
    emoji: '🍲',
    description: 'Dimasak dari jiwa-jiwa yang tersesat',
    price: 18,
    hungerRestore: 55,
    xpReward: 18,
  ),
  ShopItem(
    id: 'phantom_feast',
    name: 'Perjamuan Hantu',
    emoji: '🍱',
    description: 'Makan malam mewah dari dimensi kelam',
    price: 30,
    hungerRestore: 80,
    xpReward: 30,
  ),
  ShopItem(
    id: 'void_cake',
    name: 'Kue Keabadian',
    emoji: '🎂',
    description: 'Dibuat dari kekosongan abadi semesta',
    price: 50,
    hungerRestore: 100,
    xpReward: 50,
  ),
  ShopItem(
    id: 'death_elixir',
    name: 'Eliksir Kematian',
    emoji: '☠️',
    description: 'Ramuan mistis dari tulang belulang kuno',
    price: 75,
    hungerRestore: 60,
    xpReward: 80,
  ),
  ShopItem(
    id: 'styx_water',
    name: 'Air Sungai Styx',
    emoji: '🌊',
    description: 'Langsung dari sungai antara dua dunia',
    price: 100,
    hungerRestore: 100,
    xpReward: 120,
  ),
];

// ─── Achievement ──────────────────────────────────────────────────────────────
class Achievement {
  final String id;
  final String name;
  final String description;
  final String icon;
  bool unlocked;
  DateTime? unlockedAt;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    this.unlocked = false,
    this.unlockedAt,
  });
}

// ─── Daily Mission ────────────────────────────────────────────────────────────
class DailyMission {
  final String id;
  final String title;
  final String description;
  final String icon;
  final int rewardCoins;
  final int rewardXp;
  final int targetCount;
  int currentCount;
  bool completed;

  DailyMission({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.rewardCoins,
    required this.rewardXp,
    required this.targetCount,
    this.currentCount = 0,
    this.completed = false,
  });

  double get progress => (currentCount / targetCount).clamp(0.0, 1.0);
}

// ─── Pet State ────────────────────────────────────────────────────────────────
class PetState extends ChangeNotifier {
  double _hunger = 75.0;
  int _coins = 40;
  int _xp = 0;
  int _level = 1;
  int _soulsCollected = 0;
  int _totalFed = 0;
  int _quizCorrect = 0;
  String _statusEffect = 'none'; // none, blessed, cursed, ethereal
  DateTime _statusExpiry = DateTime.now();

  bool _isLoading = true;

  // Daily missions
  late List<DailyMission> _dailyMissions;
  DateTime _missionsDate = DateTime.now();

  // Achievements
  late List<Achievement> _achievements;

  // Getters
  double get hunger => _hunger;
  int get coins => _coins;
  int get xp => _xp;
  int get level => _level;
  int get soulsCollected => _soulsCollected;
  int get totalFed => _totalFed;
  int get quizCorrect => _quizCorrect;
  bool get isLoading => _isLoading;
  List<DailyMission> get dailyMissions => _dailyMissions;
  List<Achievement> get achievements => _achievements;

  String get statusEffect {
    if (_statusExpiry.isBefore(DateTime.now())) return 'none';
    return _statusEffect;
  }

  int get xpToNextLevel => _level * 100;
  double get xpProgress => (_xp % xpToNextLevel) / xpToNextLevel;
  int get currentLevelXp => _xp % xpToNextLevel;

  PetState() {
    _initMissions();
    _initAchievements();
    _loadFromFirestore();
  }

  void _initMissions() {
    _dailyMissions = [
      DailyMission(
        id: 'feed_3',
        title: 'Beri Makan 3 Kali',
        description: 'Beri Psikopomp makanan sebanyak 3 kali',
        icon: '🍖',
        rewardCoins: 20,
        rewardXp: 30,
        targetCount: 3,
      ),
      DailyMission(
        id: 'quiz_5',
        title: 'Jawab 5 Kuis Benar',
        description: 'Jawab pertanyaan kuis dengan benar 5 kali',
        icon: '📜',
        rewardCoins: 25,
        rewardXp: 40,
        targetCount: 5,
      ),
      DailyMission(
        id: 'collect_souls',
        title: 'Kumpulkan 10 Jiwa',
        description: 'Cabut nyawa 10 jiwa hari ini',
        icon: '💀',
        rewardCoins: 30,
        rewardXp: 50,
        targetCount: 10,
      ),
    ];
  }

  void _initAchievements() {
    _achievements = [
      Achievement(
        id: 'first_meal',
        name: 'Santapan Pertama',
        description: 'Beri makan Psikopomp untuk pertama kali',
        icon: '🍖',
      ),
      Achievement(
        id: 'level_5',
        name: 'Penjaga Alam Baka',
        description: 'Capai level 5',
        icon: '⚰️',
      ),
      Achievement(
        id: 'level_10',
        name: 'Sang Pencabut Nyawa',
        description: 'Capai level 10',
        icon: '💀',
      ),
      Achievement(
        id: 'quiz_master',
        name: 'Guru Pengetahuan',
        description: 'Jawab 50 soal kuis dengan benar',
        icon: '📜',
      ),
      Achievement(
        id: 'soul_collector',
        name: 'Pengumpul Jiwa',
        description: 'Kumpulkan 100 jiwa',
        icon: '👻',
      ),
      Achievement(
        id: 'rich_reaper',
        name: 'Pencabut Kaya',
        description: 'Miliki 500 koin sekaligus',
        icon: '💰',
      ),
      Achievement(
        id: 'survivor',
        name: 'Tetap Hidup',
        description: 'Jaga Psikopomp dari kelaparan selama 7 hari',
        icon: '🌙',
      ),
      Achievement(
        id: 'blessed',
        name: 'Berkah Ilahi',
        description: 'Aktifkan status Blessed untuk pertama kali',
        icon: '✨',
      ),
    ];
  }

  Future<void> _loadFromFirestore() async {
    final data = await FirestoreService.loadPetState();
    if (data != null) {
      _hunger = (data['hunger'] as num?)?.toDouble() ?? 75.0;
      _coins = (data['coins'] as num?)?.toInt() ?? 40;
      _xp = (data['xp'] as num?)?.toInt() ?? 0;
      _level = (data['level'] as num?)?.toInt() ?? 1;
      _soulsCollected = (data['soulsCollected'] as num?)?.toInt() ?? 0;
      _totalFed = (data['totalFed'] as num?)?.toInt() ?? 0;
      _quizCorrect = (data['quizCorrect'] as num?)?.toInt() ?? 0;
    }
    _isLoading = false;
    notifyListeners();
  }

  void _saveToFirestore() {
    FirestoreService.savePetState(
      hunger: _hunger,
      coins: _coins,
      xp: _xp,
      level: _level,
      soulsCollected: _soulsCollected,
      totalFed: _totalFed,
      quizCorrect: _quizCorrect,
    );
  }

  // ── Labels & Colors ──────────────────────────────────────────────────────────
  String get hungerLabel {
    if (_hunger >= 80) return 'Kenyang';
    if (_hunger >= 60) return 'Baik';
    if (_hunger >= 40) return 'Agak Lapar';
    if (_hunger >= 20) return 'Lapar';
    return 'Sekarat!';
  }

  Color get hungerColor {
    if (_hunger >= 60) return const Color(0xFF1D9E75);
    if (_hunger >= 30) return const Color(0xFFEF9F27);
    return const Color(0xFFE05C5C);
  }

  String get mood {
    if (statusEffect == 'blessed') return 'blessed';
    if (statusEffect == 'cursed') return 'cursed';
    if (_hunger < 15) return 'hungry';
    if (_hunger < 35) return 'sad';
    if (_hunger >= 70) return 'happy';
    return 'neutral';
  }

  String get levelTitle {
    if (_level >= 20) return 'Penguasa Kematian';
    if (_level >= 15) return 'Raja Alam Baka';
    if (_level >= 10) return 'Sang Pencabut Nyawa';
    if (_level >= 7) return 'Penjaga Jiwa';
    if (_level >= 5) return 'Pemandu Arwah';
    if (_level >= 3) return 'Penjaga Batas';
    return 'Psikopomp Muda';
  }

  String get realmName {
    if (_hunger >= 70) return 'Elysium';
    if (_hunger >= 40) return 'Limbo';
    if (_hunger >= 20) return 'Purgatorio';
    return 'Tartarus';
  }

  // ── Actions ──────────────────────────────────────────────────────────────────
  void decayHunger(double amount) {
    double decay = amount;
    if (statusEffect == 'blessed') decay *= 0.5;
    if (statusEffect == 'cursed') decay *= 1.5;

    _hunger = (_hunger - decay).clamp(0.0, 100.0);

    // Auto collect soul when patrolling
    _soulsCollected++;
    _updateMission('collect_souls', 1);

    notifyListeners();
    _saveToFirestore();
  }

  String buyAndUse(ShopItem item) {
    if (_coins < item.price) return 'Koin tidak cukup! ☠️';
    if (_hunger >= 95) return 'Psikopomp sudah kenyang!';

    _coins -= item.price;
    _hunger = (_hunger + item.hungerRestore).clamp(0.0, 100.0);
    _totalFed++;
    _addXp(item.xpReward);

    _updateMission('feed_3', 1);
    _checkAchievement('first_meal');
    notifyListeners();
    _saveToFirestore();
    return '${item.name} dimakan! +${item.hungerRestore.toInt()} lapar 🍽️';
  }

  void addCoins(int amount) {
    _coins += amount;
    _checkAchievement('rich_reaper');
    notifyListeners();
    _saveToFirestore();
  }

  void addQuizCorrect(int count) {
    _quizCorrect += count;
    _updateMission('quiz_5', count);
    if (_quizCorrect >= 50) _checkAchievement('quiz_master');
    notifyListeners();
    _saveToFirestore();
  }

  void _addXp(int amount) {
    _xp += amount;
    final newLevel = (_xp / 100).floor() + 1;
    if (newLevel > _level) {
      _level = newLevel;
      _checkLevelAchievements();
    }
    notifyListeners();
  }

  void addXpPublic(int amount) {
    _addXp(amount);
    _saveToFirestore();
  }

  void _checkLevelAchievements() {
    if (_level >= 5) _checkAchievement('level_5');
    if (_level >= 10) _checkAchievement('level_10');
  }

  void collectSouls(int count) {
    _soulsCollected += count;
    if (_soulsCollected >= 100) _checkAchievement('soul_collector');
    notifyListeners();
    _saveToFirestore();
  }

  void applyStatusEffect(String effect, Duration duration) {
    _statusEffect = effect;
    _statusExpiry = DateTime.now().add(duration);
    if (effect == 'blessed') _checkAchievement('blessed');
    notifyListeners();
  }

  void _updateMission(String id, int increment) {
    // Reset missions if it's a new day
    final now = DateTime.now();
    if (now.day != _missionsDate.day) {
      _initMissions();
      _missionsDate = now;
    }

    final mission = _dailyMissions.firstWhere(
      (m) => m.id == id,
      orElse: () => DailyMission(
        id: '',
        title: '',
        description: '',
        icon: '',
        rewardCoins: 0,
        rewardXp: 0,
        targetCount: 1,
      ),
    );

    if (mission.id.isEmpty || mission.completed) return;

    mission.currentCount = (mission.currentCount + increment).clamp(0, mission.targetCount);
    if (mission.currentCount >= mission.targetCount && !mission.completed) {
      mission.completed = true;
      _coins += mission.rewardCoins;
      _addXp(mission.rewardXp);
    }
    notifyListeners();
  }

  void claimMission(String id) {
    final mission = _dailyMissions.firstWhere((m) => m.id == id, orElse: () => DailyMission(
      id: '',
      title: '',
      description: '',
      icon: '',
      rewardCoins: 0,
      rewardXp: 0,
      targetCount: 1,
    ));
    if (mission.id.isEmpty) return;
    mission.completed = true;
    notifyListeners();
  }

  void _checkAchievement(String id) {
    final ach = _achievements.firstWhere(
      (a) => a.id == id,
      orElse: () => Achievement(id: '', name: '', description: '', icon: ''),
    );
    if (ach.id.isEmpty || ach.unlocked) return;
    ach.unlocked = true;
    ach.unlockedAt = DateTime.now();
    notifyListeners();
  }

  int get unlockedAchievementsCount => _achievements.where((a) => a.unlocked).length;
  int get completedMissionsCount => _dailyMissions.where((m) => m.completed).length;
}
