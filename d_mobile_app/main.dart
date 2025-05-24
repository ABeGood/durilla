import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Wrap(
                    spacing: 0,
                    children: const [
                      _ColorLetter('D', Color(0xFFFF9AD6)), // розовый
                      _ColorLetter('U', Color(0xFF3A85FF)), // синий
                      _ColorLetter('R', Color(0xFF34C759)), // зелёный
                      _ColorLetter('I', Color(0xFFFFCC00)), // жёлтый
                      _ColorLetter('L', Color(0xFFFF9AD6)), // розовый
                      _ColorLetter('L', Color(0xFF5FDFFF)), // голубой
                      _ColorLetter('A', Color(0xFFBF3EFF)), // фиолетовый
                    ],
                  ),
                  const SizedBox(height: 64),
                  SizedBox(
                    width: size.width * 0.8,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Навигация к игре
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
                          fontFamily:
                              'Comic Sans', // можно заменить на кастомный
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
        fontFamily: 'Arial Rounded MT Bold', // заменяем при необходимости
      ),
    );
  }
}
