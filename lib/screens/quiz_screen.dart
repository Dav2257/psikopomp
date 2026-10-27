import 'dart:math';
import 'package:flutter/material.dart';
import '../models/pet_state.dart';

class QuizScreen extends StatefulWidget {
  final PetState petState;

  const QuizScreen({super.key, required this.petState});

  static void show(BuildContext context, PetState petState) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, _, _) => QuizScreen(petState: petState),
        transitionsBuilder: (_, anim, _, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
          child: child,
        ),
      ),
    );
  }

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _Question {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String category;

  const _Question({
    required this.question,
    required this.options,
    required this.correctIndex,
    this.category = 'Umum',
  });
}

const List<_Question> _questionBank = [
  // Hewan Peliharaan
  _Question(
    question: 'Berapa rata-rata usia kucing peliharaan?',
    options: ['3–5 tahun', '10–15 tahun', '20–25 tahun', '5–8 tahun'],
    correctIndex: 1,
    category: '🐱 Kucing',
  ),
  _Question(
    question: 'Apa makanan utama ikan mas?',
    options: ['Daging segar', 'Pelet ikan & alga', 'Buah-buahan', 'Serangga hidup'],
    correctIndex: 1,
    category: '🐟 Ikan',
  ),
  _Question(
    question: 'Hewan peliharaan mana yang bisa hidup lebih dari 100 tahun?',
    options: ['Anjing', 'Kucing', 'Kura-kura', 'Hamster'],
    correctIndex: 2,
    category: '🐢 Reptil',
  ),
  _Question(
    question: 'Apa tanda kucing sedang merasa nyaman dan senang?',
    options: ['Mengeluarkan cakar', 'Mendengkur (purring)', 'Menggigit terus', 'Telinga ke belakang'],
    correctIndex: 1,
    category: '🐱 Kucing',
  ),
  _Question(
    question: 'Hamster adalah hewan yang aktif di waktu?',
    options: ['Pagi hari', 'Siang hari', 'Malam hari', 'Sore hari'],
    correctIndex: 2,
    category: '🐹 Hamster',
  ),
  _Question(
    question: 'Vitamin apa yang paling dibutuhkan reptil dari sinar matahari?',
    options: ['Vitamin A', 'Vitamin C', 'Vitamin D3', 'Vitamin B12'],
    correctIndex: 2,
    category: '🦎 Reptil',
  ),
  _Question(
    question: 'Berapa kali sehari anjing dewasa idealnya diberi makan?',
    options: ['1 kali', '2 kali', '5 kali', 'Terus-menerus'],
    correctIndex: 1,
    category: '🐶 Anjing',
  ),
  _Question(
    question: 'Apa fungsi kumis (misai) pada kucing?',
    options: ['Hiasan saja', 'Mendeteksi jarak & ruang', 'Menarik perhatian betina', 'Membantu mencium bau'],
    correctIndex: 1,
    category: '🐱 Kucing',
  ),
  _Question(
    question: 'Kelinci sebaiknya tidak diberi makan apa?',
    options: ['Wortel', 'Kangkung', 'Cokelat', 'Rumput kering'],
    correctIndex: 2,
    category: '🐰 Kelinci',
  ),
  _Question(
    question: 'Berapa lama masa kehamilan anjing rata-rata?',
    options: ['30 hari', '45 hari', '63 hari', '90 hari'],
    correctIndex: 2,
    category: '🐶 Anjing',
  ),
  _Question(
    question: 'Hewan apa yang dikenal memiliki ingatan sangat panjang?',
    options: ['Kucing', 'Anjing', 'Ikan mas', 'Gajah'],
    correctIndex: 3,
    category: '🐘 Satwa Liar',
  ),
  _Question(
    question: 'Apa yang dimaksud dengan "sterilisasi" pada hewan peliharaan?',
    options: ['Memandikan hewan', 'Operasi agar tidak bisa berkembang biak', 'Memberi vaksin', 'Memotong kuku'],
    correctIndex: 1,
    category: '🏥 Veteriner',
  ),
  _Question(
    question: 'Berapa jumlah gigi susu pada anak anjing?',
    options: ['20 gigi', '28 gigi', '32 gigi', '42 gigi'],
    correctIndex: 1,
    category: '🐶 Anjing',
  ),
  _Question(
    question: 'Makanan apa yang BERBAHAYA untuk anjing?',
    options: ['Nasi putih', 'Daging ayam rebus', 'Bawang merah/putih', 'Wortel'],
    correctIndex: 2,
    category: '🐶 Anjing',
  ),
  _Question(
    question: 'Burung beo terkenal karena kemampuan apa?',
    options: ['Terbang sangat cepat', 'Meniru suara manusia', 'Berenang di air', 'Melihat dalam gelap'],
    correctIndex: 1,
    category: '🦜 Burung',
  ),
  _Question(
    question: 'Berapa lama ikan mas bisa hidup jika dirawat dengan baik?',
    options: ['1–2 tahun', '3–5 tahun', '10–15 tahun', '25–30 tahun'],
    correctIndex: 2,
    category: '🐟 Ikan',
  ),
  _Question(
    question: 'Kucing domestik termasuk dalam keluarga hewan apa?',
    options: ['Canidae (anjing-anjingan)', 'Felidae (kucing-kucingan)', 'Rodentia (pengerat)', 'Mustelidae'],
    correctIndex: 1,
    category: '🐱 Kucing',
  ),
  _Question(
    question: 'Apa yang harus selalu tersedia untuk hewan peliharaan setiap hari?',
    options: ['Mainan baru', 'Air bersih segar', 'Camilan', 'Tempat tidur baru'],
    correctIndex: 1,
    category: '🏥 Veteriner',
  ),
  _Question(
    question: 'Seberapa sering kucing dewasa sehat idealnya dibawa ke dokter hewan?',
    options: ['Setiap minggu', 'Setiap bulan', 'Setahun sekali', 'Hanya kalau sakit'],
    correctIndex: 2,
    category: '🏥 Veteriner',
  ),
  // Mitologi / Psikopomp
  _Question(
    question: 'Dalam mitologi Yunani, siapakah Psikopomp terkenal yang memandu jiwa ke alam baka?',
    options: ['Zeus', 'Hermes', 'Poseidon', 'Apollo'],
    correctIndex: 1,
    category: '⚰️ Mitologi',
  ),
  _Question(
    question: 'Dalam mitologi Mesir Kuno, siapa yang menimbang jiwa orang yang telah meninggal?',
    options: ['Ra', 'Osiris', 'Anubis', 'Horus'],
    correctIndex: 2,
    category: '⚰️ Mitologi',
  ),
  _Question(
    question: 'Sungai apa dalam mitologi Yunani yang memisahkan dunia orang hidup dan mati?',
    options: ['Sungai Nil', 'Sungai Styx', 'Sungai Lethe', 'Sungai Eridanus'],
    correctIndex: 1,
    category: '⚰️ Mitologi',
  ),
  _Question(
    question: 'Dalam budaya Jepang, hewan apa yang dikaitkan dengan jiwa orang yang telah meninggal?',
    options: ['Serigala', 'Rubah (Kitsune)', 'Kucing (Nekomata)', 'Gagak'],
    correctIndex: 2,
    category: '⚰️ Mitologi',
  ),
];

List<_Question> _pickRandom(int n) {
  final list = List<_Question>.from(_questionBank);
  list.shuffle(Random());
  return list.take(n).toList();
}

class _QuizScreenState extends State<QuizScreen> with SingleTickerProviderStateMixin {
  late List<_Question> _questions;
  int _currentIndex = 0;
  int _coinsEarned = 0;
  int _correctCount = 0;
  int? _selectedAnswer;
  bool _answered = false;
  bool _finished = false;
  int _streak = 0;
  int _maxStreak = 0;

  late AnimationController _feedbackController;

  static const int _rewardPerCorrect = 8;
  static const int _streakBonus = 3;

  @override
  void initState() {
    super.initState();
    _questions = _pickRandom(10);

    _feedbackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _answer(int index) {
    if (_answered) return;
    final isCorrect = index == _questions[_currentIndex].correctIndex;

    setState(() {
      _selectedAnswer = index;
      _answered = true;
      if (isCorrect) {
        _streak++;
        _maxStreak = _streak > _maxStreak ? _streak : _maxStreak;
        final bonus = _streak >= 3 ? _streakBonus : 0;
        _coinsEarned += _rewardPerCorrect + bonus;
        _correctCount++;
        _feedbackController.forward(from: 0);
      } else {
        _streak = 0;
      }
    });

    Future.delayed(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      if (_currentIndex < _questions.length - 1) {
        setState(() {
          _currentIndex++;
          _selectedAnswer = null;
          _answered = false;
        });
      } else {
        widget.petState.addCoins(_coinsEarned);
        widget.petState.addQuizCorrect(_correctCount);
        widget.petState.addXpPublic(_correctCount * 10);
        setState(() => _finished = true);
      }
    });
  }

  void _restart() {
    setState(() {
      _questions = _pickRandom(10);
      _currentIndex = 0;
      _coinsEarned = 0;
      _correctCount = 0;
      _selectedAnswer = null;
      _answered = false;
      _finished = false;
      _streak = 0;
      _maxStreak = 0;
    });
  }

  Color _optionColor(int i) {
    if (!_answered) return const Color(0xFF1A1630);
    if (i == _questions[_currentIndex].correctIndex) return const Color(0xFF0A2215);
    if (i == _selectedAnswer) return const Color(0xFF2A0A10);
    return const Color(0xFF1A1630);
  }

  Color _optionBorder(int i) {
    if (!_answered) return const Color(0xFF534AB7).withValues(alpha: 0.25);
    if (i == _questions[_currentIndex].correctIndex) return const Color(0xFF1D9E75);
    if (i == _selectedAnswer) return const Color(0xFFE05C5C);
    return const Color(0xFF534AB7).withValues(alpha: 0.12);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0B1A),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.0, -0.5),
                radius: 0.8,
                colors: [Color(0x20534AB7), Colors.transparent],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // AppBar
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Color(0xFFAFA9EC)),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Text(
                          'UJIAN JIWA',
                          style: TextStyle(
                            color: Color(0xFF7F77DD),
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 3,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      // Streak + Coins
                      Row(
                        children: [
                          if (_streak >= 2)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE05C5C).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: const Color(0xFFE05C5C).withValues(alpha: 0.4),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Text('🔥', style: TextStyle(fontSize: 12)),
                                  const SizedBox(width: 3),
                                  Text(
                                    '$_streak',
                                    style: const TextStyle(
                                      color: Color(0xFFE05C5C),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEF9F27).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color(0xFFEF9F27).withValues(alpha: 0.35),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.bolt, color: Color(0xFFEF9F27), size: 14),
                                const SizedBox(width: 3),
                                Text(
                                  '$_coinsEarned',
                                  style: const TextStyle(
                                    color: Color(0xFFEF9F27),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    transitionBuilder: (child, anim) => FadeTransition(
                      opacity: anim,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.05, 0),
                          end: Offset.zero,
                        ).animate(anim),
                        child: child,
                      ),
                    ),
                    child: _finished ? _buildResult() : _buildQuiz(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuiz() {
    final q = _questions[_currentIndex];
    return SafeArea(
      key: ValueKey(_currentIndex),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF534AB7).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${_currentIndex + 1} / ${_questions.length}',
                    style: const TextStyle(fontSize: 11, color: Color(0xFF7F77DD)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (_currentIndex + 1) / _questions.length,
                      backgroundColor: Colors.white.withValues(alpha: 0.06),
                      valueColor: const AlwaysStoppedAnimation(Color(0xFF534AB7)),
                      minHeight: 4,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1D9E75).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    q.category,
                    style: const TextStyle(fontSize: 10, color: Color(0xFF1D9E75)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Question box
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1630),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF534AB7).withValues(alpha: 0.2),
                  width: 0.8,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '💀 Pertanyaan',
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF7F77DD),
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    q.question,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFEEEAFF),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF9F27).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.bolt, color: Color(0xFFEF9F27), size: 11),
                            SizedBox(width: 3),
                            Text(
                              '+8 koin • +10 XP',
                              style: TextStyle(fontSize: 10, color: Color(0xFFEF9F27)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (_streak >= 2)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE05C5C).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            children: [
                              Text('🔥', style: TextStyle(fontSize: 10)),
                              SizedBox(width: 3),
                              Text(
                                '+3 bonus streak',
                                style: TextStyle(fontSize: 10, color: Color(0xFFE05C5C)),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Options
            Expanded(
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: q.options.length,
                itemBuilder: (_, i) {
                  return GestureDetector(
                    onTap: () => _answer(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: _optionColor(i),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: _optionBorder(i), width: 0.8),
                        boxShadow: _answered && i == _questions[_currentIndex].correctIndex
                            ? [BoxShadow(color: const Color(0xFF1D9E75).withValues(alpha: 0.2), blurRadius: 12)]
                            : null,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFF26215C).withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              String.fromCharCode(65 + i),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFAFA9EC),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              q.options[i],
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFFCBCAE8),
                              ),
                            ),
                          ),
                          if (_answered && i == q.correctIndex)
                            const Icon(Icons.check_circle, color: Color(0xFF1D9E75), size: 20),
                          if (_answered && i == _selectedAnswer && i != q.correctIndex)
                            const Icon(Icons.cancel, color: Color(0xFFE05C5C), size: 20),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResult() {
    final String msg;
    final String icon;
    if (_correctCount == _questions.length) {
      msg = 'Sempurna! Jiwa-jiwa menunduk padamu!';
      icon = '💀';
    } else if (_correctCount >= 8) {
      msg = 'Luar biasa! Psikopomp bangga!';
      icon = '⚔️';
    } else if (_correctCount >= 6) {
      msg = 'Bagus! Teruslah belajar, wahai pemandu jiwa.';
      icon = '🌙';
    } else if (_correctCount >= 4) {
      msg = 'Lumayan. Jiwa-jiwa masih ragu padamu.';
      icon = '👻';
    } else {
      msg = 'Psikopomp sangat kecewa. Coba lagi!';
      icon = '☠️';
    }

    return SafeArea(
      key: const ValueKey('result'),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(icon, style: const TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            const Text(
              'UJIAN SELESAI',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFFAFA9EC),
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              msg,
              style: const TextStyle(fontSize: 14, color: Color(0xFF7F77DD)),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 28),

            // Stats row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ResultBox(label: 'Benar', value: '$_correctCount', color: const Color(0xFF1D9E75)),
                const SizedBox(width: 10),
                _ResultBox(label: 'Salah', value: '${_questions.length - _correctCount}', color: const Color(0xFFE05C5C)),
                const SizedBox(width: 10),
                _ResultBox(label: 'Koin', value: '+$_coinsEarned', color: const Color(0xFFEF9F27)),
                const SizedBox(width: 10),
                _ResultBox(label: 'XP', value: '+${_correctCount * 10}', color: const Color(0xFF534AB7)),
              ],
            ),

            if (_maxStreak >= 3) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE05C5C).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFE05C5C).withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🔥', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 8),
                    Text(
                      'Streak terbaik: $_maxStreak! (+${_maxStreak * _streakBonus} koin bonus)',
                      style: const TextStyle(fontSize: 12, color: Color(0xFFE05C5C)),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 28),

            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _restart,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1630),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF534AB7).withValues(alpha: 0.4),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.refresh, color: Color(0xFFAFA9EC), size: 16),
                          SizedBox(width: 6),
                          Text('Main Lagi', style: TextStyle(color: Color(0xFFAFA9EC), fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
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
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.home, color: Colors.white, size: 16),
                          SizedBox(width: 6),
                          Text('Kembali', style: TextStyle(color: Colors.white, fontSize: 14)),
                        ],
                      ),
                    ),
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

class _ResultBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _ResultBox({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 0.7),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: color),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: color.withValues(alpha: 0.7)),
          ),
        ],
      ),
    );
  }
}