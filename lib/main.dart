import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'widgets/psikopomp_character.dart';
import 'widgets/hunger_bar.dart';
import 'widgets/soul_particles.dart';
import 'models/pet_state.dart';
import 'screens/shop_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/missions_screen.dart';
import 'screens/achievements_screen.dart';
import 'screens/status_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('[Firebase] Init failed: $e');
  }
  runApp(const PsikopompApp());
}

class PsikopompApp extends StatelessWidget {
  const PsikopompApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Psikopomp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        fontFamily: 'sans-serif',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF534AB7),
          brightness: Brightness.dark,
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  final PetState _petState = PetState();

  Timer? _hungerTimer;
  Timer? _soulTimer;

  String? _message;
  bool _showDialog = false;
  String _dialogText = '';

  late AnimationController _messageController;
  late Animation<double> _messageAnim;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  final _rand = Random();

  static const List<String> _grimDialogs = [
    'Jiwa-jiwa memanggil...',
    'Kau tahu waktu semua orang, bukan?',
    'Aku mencium aroma kematian di sini.',
    'Istirahat? Aku tidak mengenal kata itu.',
    'Nyawa hanyalah pinjaman.',
    'Setiap langkahmu meninggalkan jejak gelap.',
    'Alam baka menunggumu.',
    'Apakah kau takut padaku?',
    'Berikan jiwa, aku akan baik-baik saja.',
    'Sabit ini haus...',
  ];

  @override
  void initState() {
    super.initState();

    _messageController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _messageAnim = CurvedAnimation(
      parent: _messageController,
      curve: Curves.elasticOut,
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _startHungerTimer();
    _startSoulTimer();
  }

  void _startHungerTimer() {
    _hungerTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      _petState.decayHunger(2.0);
      if (_petState.hunger < 20 && _petState.hunger > 18) {
        _showMessage('Psikopomp sangat lapar! ☠️');
      }
      if (_petState.hunger < 5) {
        _showMessage('⚠️ Bahaya! Psikopomp sekarat!');
      }
    });
  }

  void _startSoulTimer() {
    // Collect a soul every 30 seconds randomly
    _soulTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      final souls = _rand.nextInt(3) + 1;
      _petState.collectSouls(souls);
      if (_rand.nextDouble() < 0.3) {
        _showMessage('💀 +$souls jiwa berhasil dicabut!');
      }
    });
  }

  void _showMessage(String msg) {
    setState(() => _message = msg);
    _messageController.forward(from: 0);
    Future.delayed(const Duration(milliseconds: 2800), () {
      if (mounted) {
        _messageController.reverse();
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) setState(() => _message = null);
        });
      }
    });
  }

  void _onCharacterTap() {
    final dialog = _grimDialogs[_rand.nextInt(_grimDialogs.length)];
    setState(() {
      _showDialog = true;
      _dialogText = dialog;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showDialog = false);
    });
  }

  @override
  void dispose() {
    _hungerTimer?.cancel();
    _soulTimer?.cancel();
    _petState.dispose();
    _messageController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0B1A),
      body: ListenableBuilder(
        listenable: _petState,
        builder: (context, _) {
          return Stack(
            children: [
              // ─── Dynamic Background Realm ──────────────────────────────────
              Positioned.fill(
                child: RealmBackground(
                  realmName: _petState.realmName,
                  mood: _petState.mood,
                ),
              ),

              // ─── Soul Particles ────────────────────────────────────────────
              Positioned.fill(
                child: SoulParticleOverlay(mood: _petState.mood),
              ),

              // ─── Main Content ──────────────────────────────────────────────
              SafeArea(
                child: Column(
                  children: [
                    // Top bar
                    _buildTopBar(),

                    // Level + realm info
                    _buildRealmInfo(),

                    // Character area
                    Expanded(child: _buildCharacterArea()),

                    // Status bar
                    _buildStatusBadge(),

                    const SizedBox(height: 12),

                    // Hunger + XP bars
                    HungerBar(petState: _petState),

                    const SizedBox(height: 16),

                    // Action buttons
                    _buildActionButtons(),

                    const SizedBox(height: 12),

                    // Bottom nav buttons (missions, achievements, status)
                    _buildBottomNav(),

                    const SizedBox(height: 16),
                  ],
                ),
              ),

              // ─── Message Toast ──────────────────────────────────────────────
              if (_message != null)
                Positioned(
                  top: 80,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ScaleTransition(
                      scale: _messageAnim,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1630).withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: const Color(0xFF534AB7).withValues(alpha: 0.5),
                            width: 0.8,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF534AB7).withValues(alpha: 0.2),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                        child: Text(
                          _message!,
                          style: const TextStyle(
                            color: Color(0xFFAFA9EC),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),

              // ─── Character Dialog Bubble ────────────────────────────────────
              if (_showDialog)
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.22,
                  left: 24,
                  right: 24,
                  child: AnimatedOpacity(
                    opacity: _showDialog ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1630),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                          bottomLeft: Radius.circular(4),
                        ),
                        border: Border.all(
                          color: const Color(0xFF534AB7).withValues(alpha: 0.4),
                          width: 0.8,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF534AB7).withValues(alpha: 0.15),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                      child: Text(
                        '"$_dialogText"',
                        style: const TextStyle(
                          color: Color(0xFFCBCAE8),
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: [
          // Title
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'PSIKOPOMP',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF7F77DD),
                  letterSpacing: 3,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                _petState.levelTitle,
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF534AB7),
                  letterSpacing: 1,
                ),
              ),
            ],
          ),

          const Spacer(),

          // Souls counter
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF7F77DD).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF7F77DD).withValues(alpha: 0.25),
                width: 0.6,
              ),
            ),
            child: Row(
              children: [
                const Text('💀', style: TextStyle(fontSize: 12)),
                const SizedBox(width: 4),
                Text(
                  '${_petState.soulsCollected}',
                  style: const TextStyle(
                    color: Color(0xFF7F77DD),
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          // Coin display
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFEF9F27).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFEF9F27).withValues(alpha: 0.3),
                width: 0.6,
              ),
            ),
            child: Row(
              children: [
                const Text('✨', style: TextStyle(fontSize: 13)),
                const SizedBox(width: 5),
                Text(
                  '${_petState.coins}',
                  style: const TextStyle(
                    color: Color(0xFFEF9F27),
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRealmInfo() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFF0F0D1E).withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFF534AB7).withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                const Text('🌑', style: TextStyle(fontSize: 11)),
                const SizedBox(width: 5),
                Text(
                  _petState.realmName,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF7F77DD),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Mission progress pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFF0F0D1E).withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFF534AB7).withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                const Text('📜', style: TextStyle(fontSize: 11)),
                const SizedBox(width: 5),
                Text(
                  '${_petState.completedMissionsCount}/${_petState.dailyMissions.length} Misi',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF7F77DD),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFF0F0D1E).withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFF534AB7).withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                const Text('⚔️', style: TextStyle(fontSize: 11)),
                const SizedBox(width: 5),
                Text(
                  'LVL ${_petState.level}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF7F77DD),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterArea() {
    return Stack(
      alignment: Alignment.center,
      children: [
        PsikopompCharacter(
          mood: _petState.mood,
          size: 190,
          onTap: _onCharacterTap,
        ),
        // Tap hint
        Positioned(
          bottom: 0,
          child: AnimatedBuilder(
            animation: _pulseController,
            builder: (_, _) => Opacity(
              opacity: _pulseAnim.value - 0.5,
              child: const Text(
                '◉ ketuk untuk bicara',
                style: TextStyle(
                  fontSize: 10,
                  color: Color(0xFF534AB7),
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge() {
    final status = _petState.statusEffect;
    if (status == 'none') return const SizedBox.shrink();

    final statusColors = {
      'blessed': const Color(0xFFFFD700),
      'cursed': const Color(0xFF6A0DAD),
      'ethereal': const Color(0xFF5DCAA5),
    };
    final statusIcons = {
      'blessed': '✨',
      'cursed': '☠️',
      'ethereal': '👻',
    };
    final statusNames = {
      'blessed': 'Berkah',
      'cursed': 'Terkutuk',
      'ethereal': 'Ethereal',
    };

    final color = statusColors[status] ?? const Color(0xFF534AB7);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(statusIcons[status] ?? '⚡', style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          Text(
            'Status: ${statusNames[status]}',
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _ActionButton(
              label: 'KUIS',
              icon: '📜',
              gradient: const LinearGradient(
                colors: [Color(0xFF1A3A2A), Color(0xFF1D9E75)],
              ),
              glowColor: const Color(0xFF1D9E75),
              onTap: () => QuizScreen.show(context, _petState),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _ActionButton(
              label: 'TOKO',
              icon: '⚰️',
              gradient: const LinearGradient(
                colors: [Color(0xFF3D3580), Color(0xFF534AB7)],
              ),
              glowColor: const Color(0xFF534AB7),
              onTap: () => ShopScreen.show(context, _petState),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _NavButton(
              label: 'Misi',
              icon: '📜',
              badge: _petState.completedMissionsCount > 0
                  ? '${_petState.completedMissionsCount}'
                  : null,
              onTap: () => MissionsScreen.show(context, _petState),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _NavButton(
              label: 'Pencapaian',
              icon: '🏆',
              badge: _petState.unlockedAchievementsCount > 0
                  ? '${_petState.unlockedAchievementsCount}'
                  : null,
              onTap: () => AchievementsScreen.show(context, _petState),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _NavButton(
              label: 'Status',
              icon: '⚡',
              onTap: () => StatusScreen.show(context, _petState),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Reusable Widgets ──────────────────────────────────────────────────────────
class _ActionButton extends StatefulWidget {
  final String label;
  final String icon;
  final Gradient gradient;
  final Color glowColor;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.gradient,
    required this.glowColor,
    required this.onTap,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.93).animate(
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
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, _) => Transform.scale(
          scale: _scale.value,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              gradient: widget.gradient,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: widget.glowColor.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.icon, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Text(
                  widget.label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final String label;
  final String icon;
  final String? badge;
  final VoidCallback onTap;

  const _NavButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1630).withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFF534AB7).withValues(alpha: 0.2),
                width: 0.6,
              ),
            ),
            child: Column(
              children: [
                Text(icon, style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF7F77DD),
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
          if (badge != null)
            Positioned(
              top: 4,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF9F27),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badge!,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}