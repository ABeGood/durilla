import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _englishLetters = List.generate(
    26,
    (i) => String.fromCharCode(65 + i),
  );
  List<String> _currentLetters = [
    'D',
    'U',
    'R',
    'I',
    'L',
    'L',
    'A',
    ' ',
    'P',
    'U',
    'P',
    'K',
    'I',
    'N',
  ];

  final List<Color> _availableColors = [
    Color(0xFFFF9AD6),
    Color(0xFF3A85FF),
    Color(0xFF34C759),
    Color(0xFFFFCC00),
    Color(0xFF5FDFFF),
    Color(0xFFBF3EFF),
    Color(0xFFFF6B6B),
    Color(0xFF4ECDC4),
    Color(0xFFFFE66D),
    Color(0xFF95E1D3),
  ];

  List<Color> _currentColors = [];

  final Random _random = Random();
  bool _isEditing = false;
  late TextEditingController _textController;
  late FocusNode _focusNode;

  Set<int> _slotPositions = {};
  Set<int> _runningSlots = {};
  Map<int, Timer> _timers = {};

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: _currentLetters.join(''));
    _focusNode = FocusNode();
    _currentColors = List.generate(
      _currentLetters.length,
      (index) => _availableColors[_random.nextInt(_availableColors.length)],
    );
  }

  @override
  void dispose() {
    for (var timer in _timers.values) {
      timer.cancel();
    }
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
      _textController.text = _currentLetters.join('');
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  void _finishEditing() {
    setState(() {
      _isEditing = false;
      String newText = _textController.text.toUpperCase();

      if (newText.isNotEmpty) {
        _currentLetters = newText.split('');
        _currentColors = List.generate(
          _currentLetters.length,
          (index) => _availableColors[_random.nextInt(_availableColors.length)],
        );
        _textController.text = _currentLetters.join('');
      }
    });
  }

  void _changeFirstLettersInWords() {
    String fullText = _currentLetters.join('');
    List<String> words = fullText.split(' ');
    List<int> positions = [];

    int currentIndex = 0;
    for (var word in words) {
      if (word.isNotEmpty) {
        positions.add(currentIndex);
      }
      currentIndex += word.length + 1;
    }

    setState(() {
      _slotPositions = positions.toSet();
      _runningSlots = {..._slotPositions};
    });

    for (int pos in _slotPositions) {
      int count = 0;
      const maxCount = 15;
      const duration = Duration(milliseconds: 20);

      _timers[pos]?.cancel();
      _timers[pos] = Timer.periodic(duration, (timer) {
        setState(() {
          _currentLetters[pos] =
              _englishLetters[_random.nextInt(_englishLetters.length)];
          _currentColors[pos] =
              _availableColors[_random.nextInt(_availableColors.length)];
          _textController.text = _currentLetters.join('');
        });

        count++;
        if (count >= maxCount) {
          timer.cancel();
          Future.delayed(const Duration(milliseconds: 60), () {
            setState(() {
              _currentLetters[pos] =
                  _englishLetters[_random.nextInt(_englishLetters.length)];
              _currentColors[pos] =
                  _availableColors[_random.nextInt(_availableColors.length)];
              _textController.text = _currentLetters.join('');
              _runningSlots.remove(pos);
            });
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Меню
            Positioned(
              top: 16,
              left: 16,
              child: GestureDetector(
                onTap: () => debugPrint('Меню нажато'),
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

            // Центр
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child:
                    _isEditing
                        ? Container(
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: TextField(
                            controller: _textController,
                            focusNode: _focusNode,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              fontFamily: 'Arial Rounded MT Bold',
                            ),
                            onSubmitted: (_) => _finishEditing(),
                            onTapOutside: (_) => _finishEditing(),
                            textCapitalization: TextCapitalization.characters,
                            maxLength: 30,
                          ),
                        )
                        : GestureDetector(
                          onTap: _startEditing,
                          child: FittedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(_currentLetters.length, (
                                index,
                              ) {
                                final isAnimating = _runningSlots.contains(
                                  index,
                                );
                                final isSlot = _slotPositions.contains(index);

                                if (!isSlot || isAnimating) {
                                  // во время анимации — просто текст без эффекта
                                  return Text(
                                    _currentLetters[index],
                                    style: TextStyle(
                                      fontSize: 56,
                                      fontWeight: FontWeight.w900,
                                      color: _currentColors[index],
                                      fontFamily: 'Arial Rounded MT Bold',
                                    ),
                                  );
                                } else {
                                  // после анимации — с fade эффектом
                                  return AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    transitionBuilder:
                                        (child, animation) => FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        ),
                                    child: Text(
                                      _currentLetters[index],
                                      key: ValueKey(
                                        _currentLetters[index] +
                                            index.toString(),
                                      ),
                                      style: TextStyle(
                                        fontSize: 56,
                                        fontWeight: FontWeight.w900,
                                        color: _currentColors[index],
                                        fontFamily: 'Arial Rounded MT Bold',
                                      ),
                                    ),
                                  );
                                }
                              }),
                            ),
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),

      // Кнопка
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 60,
            top: 16,
          ),
          child: SizedBox(
            height: 76,
            child: ElevatedButton(
              onPressed: () {
                debugPrint('Start Game нажато');
                if (_isEditing) {
                  _finishEditing();
                } else {
                  _changeFirstLettersInWords();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 222, 196, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Text(
                _isEditing ? 'Done' : 'Generate',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Comic Sans',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
