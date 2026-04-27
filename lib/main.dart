import 'package:flutter/material.dart';
import 'widgets/psikopomp_character.dart';

void main() {
    runApp(const PsikopompApp());
}

class PsikopompApp extends StatelessWidget {
    const PsikopompApp({super.key});

    @override
    Widget build(BuildContext) {
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

class MainScreen extends StatelessWidget {
    const MainScreen ({super.key});

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: const Color(0xFF0D0B1A),

            body: Stack(
                children: [
                    Container(
                        decoration: const BoxDecoration(
                            gradient:RadialGradient(
                                center: Alignment(0.0, 0,5),
                                radius: 0.8,
                                colors: [
                                    Color(0x40534AB7),
                                    Color(0x001a1630),
                                ]
                            )
                        )
                    )
                    Center(
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                                const PsikopompCharacter(
                                    mood: 'Bahagia',
                                    size: 220,
                                ),
                                const SizedBox(height: 24),

                                const Text(
                                    'Pemandu Jiwa yang Tersesat',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Color(0x887F77DD),
                                        letterSpacing: 1.5,
                                    ),

                                ),
                            ],
                        ),
                    ),
                ],
            ),
        );
    }
    List<Widget> _buildStars() {
        const stars = [
            [0.1, 0.1, 2.0, 0.4],
            [0.25, 0.05, 1.5, 0.3],
            [0.7, 0.08, 2.5, 0.5],
            [0.85, 0.15, 1.5, 0.35],
            [0.05, 0.3, 2.0, 0.25],
            [0.9, 0.35, 2.0, 0.4],
            [0.15, 0.75, 1.5, 0.3],
            [0.8, 0.7, 2.5, 0.45],
            [0.45, 0.07, 1.5, 0.3],
            [0.6, 0.88, 2.0, 0.35],
            [0.3, 0.9, 1.5, 0.25],
        ];
        return stars.map((s){
        return Positioned(
            left: null,
            top: null,
            child: Align(
                alignment: FractionalOffset(s[0], s[1]),
                child: Container(
                    width: s[2],
                    height: s[2],
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.white.withOpacity(s[3]),
                    ),
                ),
            ),
        );
    }).toList();
    }
}