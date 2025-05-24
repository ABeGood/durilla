import 'package:flutter/material.dart';
import './word_gen_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Current letters to display (initially DURILLA)
  List<String> _currentLetters = ['D', 'U', 'R', 'I', 'L', 'L', 'A'];

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

        // Update text controller
        _textController.text = _currentLetters.join('');
      }
    });
  }

  // Function to finish editing
  void _buttonPressedStart() {
    setState(() {
      _isEditing = false;

      // Update text controller
      _currentLetters = changeFirstLetters(_currentLetters);
      _textController.text = _currentLetters.join('');
      _currentColors = generateRandomColors(_currentColors);
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
                            _buttonPressedStart();
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
