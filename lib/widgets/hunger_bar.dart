import 'package:flutter/material.dart';
import '../models/pet_state.dart';
 
class HungerBar extends StatelessWidget {
  final PetState petState;
 
  const HungerBar({super.key, required this.petState});
 
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1630),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF534AB7).withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Icon lapar
              const Text('🍖', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              const Text(
                'Kelaparan',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFFAFA9EC),
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: Text(
                  petState.hungerLabel,
                  key: ValueKey(petState.hungerLabel),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: petState.hungerColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
           ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: [
                Container(
                  height: 12,
                  color: Colors.white.withValues(alpha: 0.06),
                ),
                 AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOut,
                  height: 12,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeOut,
                        width: constraints.maxWidth * (petState.hunger / 100),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              petState.hungerColor.withValues(alpha: 0.7),
                              petState.hungerColor,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                             boxShadow: petState.hunger < 30
                              ? [
                                  BoxShadow(
                                    color: petState.hungerColor.withValues(alpha: 0.5),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  )
                                ]
                              : null,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
 
          const SizedBox(height: 6),
            Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${petState.hunger.toInt()}%',
              style: TextStyle(
                fontSize: 10,
                color: petState.hungerColor.withValues(alpha: 0.8),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}