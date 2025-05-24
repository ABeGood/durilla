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

  // Text editing variables
  bool _isEditing = false;
  late TextEditingController _textController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: _currentLetters.join(''));
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

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

      // Update text controller
      _textController.text = _currentLetters.join('');
    });
  }

  // Function to generate random letters and shuffle colors
  // Function to randomly change the first letters of each word
  void _changeFirstLetters() {
    setState(() {
      // Join current letters into a string
      String currentText = _currentLetters.join('');

      // Split into words (by spaces)
      List<String> words = currentText.split(' ');

      // Change first letter of each word
      List<String> newWords =
          words.map((word) {
            if (word.isNotEmpty) {
              // Generate random first letter
              String newFirstLetter =
                  _englishLetters[_random.nextInt(_englishLetters.length)];
              // Keep the rest of the word the same
              String restOfWord = word.length > 1 ? word.substring(1) : '';
              return newFirstLetter + restOfWord;
            }
            return word; // Return empty word as is
          }).toList();

      // Join words back together
      String newText = newWords.join(' ');

      // Convert back to letters list
      _currentLetters = newText.split('');

      // Update text controller
      _textController.text = newText;
    });
  }

  // Function to start editing
  void _startEditing() {
    setState(() {
      _isEditing = true;
      _textController.text = _currentLetters.join('');
    });
    // Focus the text field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  // Function to finish editing
  void _finishEditing() {
    setState(() {
      _isEditing = false;
      String newText = _textController.text.toUpperCase();

      if (newText.isNotEmpty) {
        // Convert text to letters list
        _currentLetters = newText.split('');

        // Generate new colors for the new length
        _currentColors = List.generate(
          _currentLetters.length,
          (index) => _availableColors[_random.nextInt(_availableColors.length)],
        );

        // Update text controller
        _textController.text = _currentLetters.join('');
      }
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
                  // Text display/editing area
                  _isEditing
                      ?
                      // Editing mode - show TextField
                      Container(
                        constraints: BoxConstraints(maxWidth: 400),
                        child: TextField(
                          controller: _textController,
                          focusNode: _focusNode,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 56,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            fontFamily: 'Arial Rounded MT Bold',
                          ),
                          onSubmitted: (value) => _finishEditing(),
                          onTapOutside: (event) => _finishEditing(),
                          textCapitalization: TextCapitalization.characters,
                          maxLength: 20, // Reasonable limit
                        ),
                      )
                      :
                      // Display mode - show colored letters
                      GestureDetector(
                        onTap: _startEditing,
                        child: FittedBox(
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
                          if (_isEditing) {
                            _finishEditing();
                          } else {
                            _changeFirstLetters();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF34C759),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: Text(
                          _isEditing ? 'Done' : 'Start Game',
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
