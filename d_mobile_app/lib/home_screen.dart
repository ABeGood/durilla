import 'package:flutter/material.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // List of all English capital letters
  final List<String> _englishLetters = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z',
  ];

  // Current letters to display (initially DURILLA)
  List<String> _currentLetters = ['D', 'U', 'R', 'I', 'L', 'L', 'A'];

  // Available colors for letters
  final List<Color> _availableColors = [
    Color(0xFFFF9AD6), // Pink
    Color(0xFF3A85FF), // Blue
    Color(0xFF34C759), // Green
    Color(0xFFFFCC00), // Yellow
    Color(0xFF5FDFFF), // Light Blue
    Color(0xFFBF3EFF), // Purple
    Color(0xFFFF6B6B), // Red
    Color(0xFF4ECDC4), // Teal
    Color(0xFFFFE66D), // Light Yellow
    Color(0xFF95E1D3), // Mint Green
  ];

  // Current colors for each letter position
  List<Color> _currentColors = [
    Color(0xFFFF9AD6), // D - Pink
    Color(0xFF3A85FF), // U - Blue
    Color(0xFF34C759), // R - Green
    Color(0xFFFFCC00), // I - Yellow
    Color(0xFFFF9AD6), // L - Pink
    Color(0xFF5FDFFF), // L - Light Blue
    Color(0xFFBF3EFF), // A - Purple
  ];

  final Random _random = Random();

  // Function to generate random letters and shuffle colors
  void _generateRandomLetters() {
    setState(() {
      // Generate random letters
      _currentLetters = List.generate(
        7, // Keep the same number of letters as DURILLA
        (index) => _englishLetters[_random.nextInt(_englishLetters.length)],
      );

      // Shuffle colors randomly
      _currentColors = List.generate(
        7,
        (index) => _availableColors[_random.nextInt(_availableColors.length)],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 16,
              left: 16,
              child: GestureDetector(
                onTap: () {
                  // TODO: реализовать меню
                  debugPrint('Меню нажато');
                },
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.menu, color: Colors.black),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _currentLetters.length,
                        (index) => _ColorLetter(
                          _currentLetters[index],
                          _currentColors[index],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 64),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          debugPrint('Start Game нажато');
                          _generateRandomLetters();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF34C759),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: const Text(
                          'Start Game',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Comic Sans',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorLetter extends StatelessWidget {
  final String char;
  final Color color;

  const _ColorLetter(this.char, this.color);

  @override
  Widget build(BuildContext context) {
    return Text(
      char,
      style: TextStyle(
        fontSize: 56,
        fontWeight: FontWeight.w900,
        color: color,
        fontFamily: 'Arial Rounded MT Bold',
      ),
    );
  }
}
