import 'dart:math';
import 'package:flutter/material.dart';
import '../models/pet_state.dart';
 
class _Question {
  final String question;
  final List<String> options;
  final int correctIndex;
 
  const _Question({
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}
 
const List<_Question> _questionBank = [
  _Question(
    question: 'Berapa rata-rata usia kucing peliharaan?',
    options: ['3–5 tahun', '10–15 tahun', '20–25 tahun', '5–8 tahun'],
    correctIndex: 1,
  ),
  _Question(
    question: 'Apa makanan utama ikan mas?',
    options: ['Daging segar', 'Pelet ikan & alga', 'Buah-buahan', 'Serangga hidup'],
    correctIndex: 1,
  ),
  _Question(
    question: 'Hewan peliharaan mana yang bisa hidup lebih dari 100 tahun?',
    options: ['Anjing', 'Kucing', 'Kura-kura', 'Hamster'],
    correctIndex: 2,
  ),
  _Question(
    question: 'Apa tanda kucing sedang merasa nyaman dan senang?',
    options: ['Mengeluarkan cakar', 'Mendengkur (purring)', 'Menggigit terus', 'Telinga ke belakang'],
    correctIndex: 1,
  ),
  _Question(
    question: 'Hamster adalah hewan yang aktif di waktu?',
    options: ['Pagi hari', 'Siang hari', 'Malam hari', 'Sore hari'],
    correctIndex: 2,
  ),
  _Question(
    question: 'Vitamin apa yang paling dibutuhkan reptil dari sinar matahari?',
    options: ['Vitamin A', 'Vitamin C', 'Vitamin D3', 'Vitamin B12'],
    correctIndex: 2,
  ),
  _Question(
    question: 'Berapa kali sehari anjing dewasa idealnya diberi makan?',
    options: ['1 kali', '2 kali', '5 kali', 'Terus-menerus'],
    correctIndex: 1,
  ),
  _Question(
    question: 'Apa fungsi kumis (misai) pada kucing?',
    options: ['Hiasan saja', 'Mendeteksi jarak & ruang', 'Menarik perhatian betina', 'Membantu mencium bau'],
    correctIndex: 1,
  ),
  _Question(
    question: 'Kelinci sebaiknya tidak diberi makan apa?',
    options: ['Wortel', 'Kangkung', 'Cokelat', 'Rumput kering'],
    correctIndex: 2,
  ),
  _Question(
    question: 'Berapa lama masa kehamilan anjing rata-rata?',
    options: ['30 hari', '45 hari', '63 hari', '90 hari'],
    correctIndex: 2,
  ),
  _Question(
    question: 'Hewan apa yang dikenal memiliki ingatan sangat panjang?',
    options: ['Kucing', 'Anjing', 'Ikan mas', 'Gajah'],
    correctIndex: 3,
  ),
  _Question(
    question: 'Apa yang dimaksud dengan "sterilisasi" pada hewan peliharaan?',
    options: ['Memandikan hewan', 'Operasi agar tidak bisa berkembang biak', 'Memberi vaksin', 'Memotong kuku'],
    correctIndex: 1,
  ),
  _Question(
    question: 'Berapa jumlah gigi susu pada anak anjing?',
    options: ['20 gigi', '28 gigi', '32 gigi', '42 gigi'],
    correctIndex: 1,
  ),
  _Question(
    question: 'Makanan apa yang BERBAHAYA untuk anjing?',
    options: ['Nasi putih', 'Daging ayam rebus', 'Bawang merah/putih', 'Wortel'],
    correctIndex: 2,
  ),
  _Question(
    question: 'Burung beo terkenal karena kemampuan apa?',
    options: ['Terbang sangat cepat', 'Meniru suara manusia', 'Berenang di air', 'Melihat dalam gelap'],
    correctIndex: 1,
  ),
  _Question(
    question: 'Apa nama kandang kecil tempat tinggal hamster?',
    options: ['Aquarium', 'Terrarium', 'Kandang kawat / cage', 'Vivarium'],
    correctIndex: 2,
  ),
  _Question(
    question: 'Berapa lama ikan mas bisa hidup jika dirawat dengan baik?',
    options: ['1–2 tahun', '3–5 tahun', '10–15 tahun', '25–30 tahun'],
    correctIndex: 2,
  ),
  _Question(
    question: 'Kucing domestik termasuk dalam keluarga hewan apa?',
    options: ['Canidae (anjing-anjingan)', 'Felidae (kucing-kucingan)', 'Rodentia (pengerat)', 'Mustelidae'],
    correctIndex: 1,
  ),
  _Question(
    question: 'Apa yang harus selalu tersedia untuk hewan peliharaan setiap hari?',
    options: ['Mainan baru', 'Air bersih segar', 'Camilan', 'Tempat tidur baru'],
    correctIndex: 1,
  ),
  _Question(
    question: 'Seberapa sering kucing dewasa sehat idealnya dibawa ke dokter hewan?',
    options: ['Setiap minggu', 'Setiap bulan', 'Setahun sekali', 'Hanya kalau sakit'],
    correctIndex: 2,
  ),
];
 
List<_Question> _pickRandom(int n) {
  final list = List<_Question>.from(_questionBank);
  list.shuffle(Random()); 
  return list.take(n).toList(); 
}
 
class QuizScreen extends StatefulWidget {
  final PetState petState;
 
  const QuizScreen({super.key, required this.petState});
 
  static void show(BuildContext context, PetState petState) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => QuizScreen(petState: petState),
        transitionsBuilder: (_, anim, __, child) => SlideTransition(
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
 
class _QuizScreenState extends State<QuizScreen> {
  // Ambil 8 soal acak saat pertama kali dibuat
  late List<_Question> _questions = _pickRandom(8);
 
  int _currentIndex = 0;
  int _coinsEarned = 0;
  int _correctCount = 0;
  int? _selectedAnswer;
  bool _answered = false;
  bool _finished = false;
 
  static const int _rewardPerCorrect = 8;
 
  void _answer(int index) {
    if (_answered) return;
    final isCorrect = index == _questions[_currentIndex].correctIndex;
    setState(() {
      _selectedAnswer = index;
      _answered = true;
      if (isCorrect) {
        _coinsEarned += _rewardPerCorrect;
        _correctCount++;
      }
    });
 
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      if (_currentIndex < _questions.length - 1) {
        setState(() {
          _currentIndex++;
          _selectedAnswer = null;
          _answered = false;
        });
      } else {
        widget.petState.addCoins(_coinsEarned);
        setState(() => _finished = true);
      }
    });
  }
 
  void _restart() {
    setState(() {
      _questions = _pickRandom(8); 
      _currentIndex = 0;
      _coinsEarned = 0;
      _correctCount = 0;
      _selectedAnswer = null;
      _answered = false;
      _finished = false;
    });
  }
 
  Color _optionColor(int i) {
    if (!_answered) return const Color(0xFF1A1630);
    if (i == _questions[_currentIndex].correctIndex) return const Color(0xFF0F3020);
    if (i == _selectedAnswer) return const Color(0xFF3A1020);
    return const Color(0xFF1A1630);
  }
 
  Color _optionBorder(int i) {
    if (!_answered) return const Color(0xFF534AB7).withValues(alpha: 0.3);
    if (i == _questions[_currentIndex].correctIndex) return const Color(0xFF1D9E75);
    if (i == _selectedAnswer) return const Color(0xFFE05C5C);
    return const Color(0xFF534AB7).withValues(alpha: 0.15);
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0B1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFFAFA9EC)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Kuis Peliharaan',
          style: TextStyle(
            color: Color(0xFFAFA9EC),
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: 1,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                const Icon(Icons.star, color: Color(0xFFEF9F27), size: 16),
                const SizedBox(width: 4),
                Text(
                  '$_coinsEarned',
                  style: const TextStyle(
                    color: Color(0xFFEF9F27),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _finished ? _buildResult() : _buildQuiz(),
      ),
    );
  }
 
  Widget _buildQuiz() {
    final q = _questions[_currentIndex];
    return SafeArea(
      key: ValueKey(_currentIndex),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Soal ${_currentIndex + 1} / ${_questions.length}',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF7F77DD)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (_currentIndex + 1) / _questions.length,
                      backgroundColor: Colors.white12,
                      valueColor:
                          const AlwaysStoppedAnimation(Color(0xFF534AB7)),
                      minHeight: 5,
                    ),
                  ),
                ),
              ],
            ),
 
            const SizedBox(height: 32),
 
            Text(
              q.question,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFFAFA9EC),
                height: 1.5,
              ),
            ),
 
            const SizedBox(height: 10),
 
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFEF9F27).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFEF9F27).withValues(alpha: 0.3),
                  width: 0.5,
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, color: Color(0xFFEF9F27), size: 12),
                  SizedBox(width: 4),
                  Text(
                    '+8 koin kalau benar',
                    style:
                        TextStyle(fontSize: 11, color: Color(0xFFEF9F27)),
                  ),
                ],
              ),
            ),
 
            const SizedBox(height: 28),
 
            ...List.generate(q.options.length, (i) {
              return GestureDetector(
                onTap: () => _answer(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: _optionColor(i),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _optionBorder(i), width: 0.5),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 26,
                        height: 26,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFF26215C).withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          String.fromCharCode(65 + i),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
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
                            color: Color(0xFFAFA9EC),
                          ),
                        ),
                      ),
                      if (_answered && i == q.correctIndex)
                        const Icon(Icons.check_circle,
                            color: Color(0xFF1D9E75), size: 18),
                      if (_answered &&
                          i == _selectedAnswer &&
                          i != q.correctIndex)
                        const Icon(Icons.cancel,
                            color: Color(0xFFE05C5C), size: 18),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
 
  Widget _buildResult() {
    final String msg;
    if (_correctCount == _questions.length) msg = 'Sempurna! Kamu ahli peliharaan!';
    else if (_correctCount >= 6) msg = 'Bagus banget! Hampir sempurna.';
    else if (_correctCount >= 4) msg = 'Lumayan, terus belajar!';
    else msg = 'Coba lagi ya, Psikopomp butuh koin! 🪙';
 
    return SafeArea(
      key: const ValueKey('result'),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star, color: Color(0xFFEF9F27), size: 64),
            const SizedBox(height: 20),
            const Text(
              'Kuis Selesai!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Color(0xFFAFA9EC),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              msg,
              style: const TextStyle(fontSize: 14, color: Color(0xFF7F77DD)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
 
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _StatBox(label: 'Benar', value: '$_correctCount', color: const Color(0xFF1D9E75)),
                const SizedBox(width: 12),
                _StatBox(label: 'Salah', value: '${_questions.length - _correctCount}', color: const Color(0xFFE05C5C)),
                const SizedBox(width: 12),
                _StatBox(label: 'Koin', value: '+$_coinsEarned', color: const Color(0xFFEF9F27)),
              ],
            ),
 
            const SizedBox(height: 16),
 
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF1D9E75).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: const Color(0xFF1D9E75).withValues(alpha: 0.3),
                    width: 0.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle_outline,
                      color: Color(0xFF1D9E75), size: 16),
                  const SizedBox(width: 8),
                  Text(
                    '$_coinsEarned koin sudah masuk ke Psikopomp!',
                    style: const TextStyle(
                        fontSize: 13, color: Color(0xFF1D9E75)),
                  ),
                ],
              ),
            ),
 
            const SizedBox(height: 28),
 
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _restart, // soal diacak ulang
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF534AB7).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: const Color(0xFF534AB7).withValues(alpha: 0.4),
                            width: 0.5),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Main Lagi',
                        style: TextStyle(
                            color: Color(0xFFAFA9EC), fontSize: 14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF534AB7),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Kembali',
                        style: TextStyle(color: Colors.white, fontSize: 14),
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
 
class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
 
  const _StatBox({
    required this.label,
    required this.value,
    required this.color,
  });
 
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 0.5),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: color),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
                fontSize: 11, color: color.withValues(alpha: 0.7)),
          ),
        ],
      ),
    );
  }
}
 