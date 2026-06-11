import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'widgets/psikopomp_character.dart';
import 'dart:async';
import 'models/pet_state.dart';
import 'screens/shop_screen.dart';
import 'screens/quiz_screen.dart';
import 'widgets/hunger_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Firebase belum dikonfigurasi — app tetap jalan tanpa persistensi
    // ignore: avoid_print
    print('[Firebase] Init failed (belum dikonfigurasi?): $e');
  }
  runApp(const PsikopompApp());
}

class PsikopompApp extends StatelessWidget {
    const PsikopompApp({super.key});

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title : 'Psikopomp',
            debugShowCheckedModeBanner : false,
            theme : ThemeData(
                brightness : Brightness.dark,
                useMaterial3 : true,
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
 
class _MainScreenState extends State<MainScreen> {
  final PetState _petState = PetState();
 
  Timer? _hungerTimer;
 
  String? _message;
 
  @override
  void initState() {
    super.initState();
    _startHungerTimer();
  }
 
  void _startHungerTimer() {
    _hungerTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      _petState.decayHunger(2.0);
 
      if (_petState.hunger < 20 && _petState.hunger > 18) {
        _showMessage('Psikopomp sangat lapar! 🍖');
      }
    });
  }
 
  void _showMessage(String msg) {
    setState(() => _message = msg);
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) setState(() => _message = null);
    });
  }
 
  @override
  void dispose() {
    _hungerTimer?.cancel();
    _petState.dispose(); // dispose ChangeNotifier
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0B1A),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.0, 0.3),
                radius: 0.75,
                colors: [
                  Color(0x35534AB7),
                  Color(0x001a1630),
                ],
              ),
            ),
          ),
 
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Psikopomp',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF534AB7),
                          letterSpacing: 2,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      ListenableBuilder(
                        listenable: _petState,
                        builder: (_, __) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF9F27).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFFEF9F27).withValues(alpha: 0.35),
                              width: 0.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('✨', style: TextStyle(fontSize: 14)),
                              const SizedBox(width: 5),
                              Text(
                                '${_petState.coins}',
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
 
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Karakter — mood berubah otomatis sesuai hunger
                      ListenableBuilder(
                        listenable: _petState,
                        builder: (_, __) => PsikopompCharacter(
                          mood: _petState.mood,
                          size: 200,
                        ),
                      ),
 
                      if (_message != null)
                        Positioned(
                          top: 20,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF26215C),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFF534AB7),
                                width: 0.5,
                              ),
                            ),
                            child: Text(
                              _message!,
                              style: const TextStyle(
                                color: Color(0xFFAFA9EC),
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
 
                ListenableBuilder(
                  listenable: _petState,
                  builder: (_, __) => HungerBar(petState: _petState),
                ),
 
                const SizedBox(height: 20),
 
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      // Tombol Kuis
                      Expanded(
                        child: GestureDetector(
                          onTap: () => QuizScreen.show(context, _petState),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF1A3A2A), Color(0xFF1D9E75)],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF1D9E75).withValues(alpha: 0.35),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('🎯', style: TextStyle(fontSize: 18)),
                                SizedBox(width: 8),
                                Text(
                                  'Kuis',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Tombol Toko
                      Expanded(
                        child: GestureDetector(
                          onTap: () => ShopScreen.show(context, _petState),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF3D3580), Color(0xFF534AB7)],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF534AB7).withValues(alpha: 0.35),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('🏪', style: TextStyle(fontSize: 18)),
                                SizedBox(width: 8),
                                Text(
                                  'Toko',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}