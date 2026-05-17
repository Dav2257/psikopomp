import 'package:flutter/material.dart';
import '../models/pet_state.dart';
 
class HungerBar extends StatelessWidget {
  final PetState petState;
 
  const HungerBar({super.key, required this.petState});
 
  @override
  Widget build(BuildContext context) {
    // SizedBox dengan lebar tetap lebih aman daripada IntrinsicWidth
    // karena Flutter langsung tahu berapa lebar yang dialokasikan
    return Center(
      child: SizedBox(
        width: 220, // lebar tetap, compact
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1630),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF534AB7).withValues(alpha: 0.3),
              width: 0.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---- LABEL ATAS ----
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text('🍖', style: TextStyle(fontSize: 13)),
                      const SizedBox(width: 6),
                      const Text(
                        'Lapar',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFAFA9EC),
                        ),
                      ),
                    ],
                  ),
                  // Status teks
                  Text(
                    petState.hungerLabel,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: petState.hungerColor,
                    ),
                  ),
                ],
              ),
 
              const SizedBox(height: 8),
 
              // ---- PROGRESS BAR ----
              // Pakai Stack dengan lebar tetap — tidak butuh LayoutBuilder
              // karena SizedBox parent sudah kasih constraint yang jelas
              Stack(
                children: [
                  // Background
                  Container(
                    height: 8,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  // Foreground — FractionallySizedBox aman di sini
                  // karena parent Stack sudah punya lebar dari SizedBox(220)
                  FractionallySizedBox(
                    widthFactor: (petState.hunger / 100).clamp(0.0, 1.0),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOut,
                      height: 8,
                      decoration: BoxDecoration(
                        color: petState.hungerColor,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: petState.hunger < 30
                            ? [
                                BoxShadow(
                                  color: petState.hungerColor.withValues(alpha: 0.5),
                                  blurRadius: 6,
                                )
                              ]
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
 
              const SizedBox(height: 5),
 
              // Angka persen di kanan
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '${petState.hunger.toInt()}%',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: petState.hungerColor.withValues(alpha: 0.8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}