import 'package:flutter/material.dart';
import './word_gen_utils.dart';

import 'package:flutter/services.dart';
import 'dart:io';
import 'package:widgets_to_image/widgets_to_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

// Custom widget for share options
class _ShareOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ShareOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Color(0xFF34C759),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white),
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[400])),
      onTap: onTap,
    );
  }
}

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

  // Modern screenshot controller using widgets_to_image
  final WidgetsToImageController _screenshotController =
      WidgetsToImageController();

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

        // Generate new colors for the new text length
        _currentColors = generateRandomColors(_currentLetters);

        // Update text controller
        _textController.text = _currentLetters.join('');
      }
    });
  }

  // Function to handle Start Game button press
  void _buttonPressedStart() {
    setState(() {
      _isEditing = false;

      // Update letters and colors using word_gen_utils functions
      _currentLetters = changeFirstLetters(_currentLetters);
      _textController.text = _currentLetters.join('');
      _currentColors = generateRandomColors(_currentLetters);
    });
  }

  // Function to capture and share screenshot using modern APIs
  Future<void> _shareScreenshot() async {
    try {
      // Close keyboard if editing
      if (_isEditing) {
        _finishEditing();
        // Wait for UI to update
        await Future.delayed(Duration(milliseconds: 300));
      }

      // Capture screenshot using widgets_to_image
      final Uint8List? bytes = await _screenshotController.capture();

      if (bytes != null) {
        // Get temporary directory
        final directory = await getTemporaryDirectory();
        final imagePath = '${directory.path}/durilla_screenshot.png';

        // Save image to file
        final File imageFile = File(imagePath);
        await imageFile.writeAsBytes(bytes);

        // Show share options
        await _showShareOptions(imageFile);
      } else {
        throw Exception('Failed to capture screenshot');
      }
    } catch (e) {
      debugPrint('Error capturing screenshot: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to capture screenshot'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Function to show share options
  Future<void> _showShareOptions(File imageFile) async {
    final currentText = _currentLetters.join('');

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Share Your Creation',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),

                // Share image to social media
                _ShareOption(
                  icon: Icons.share,
                  title: 'Share Image',
                  subtitle: 'WhatsApp, Telegram, Instagram...',
                  onTap: () async {
                    Navigator.pop(context);
                    await Share.shareXFiles([
                      XFile(imageFile.path),
                    ], text: 'Check out my Durilla creation: $currentText');
                  },
                ),

                // Copy to clipboard
                _ShareOption(
                  icon: Icons.copy,
                  title: 'Copy to Clipboard',
                  subtitle: 'Copy text to clipboard',
                  onTap: () async {
                    Navigator.pop(context);
                    await Clipboard.setData(
                      ClipboardData(text: 'My Durilla creation: $currentText'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Copied to clipboard!'),
                        backgroundColor: Color(0xFF34C759),
                      ),
                    );
                  },
                ),

                // Save to gallery
                _ShareOption(
                  icon: Icons.download,
                  title: 'Save Image',
                  subtitle: 'Save to device',
                  onTap: () async {
                    Navigator.pop(context);
                    await Share.shareXFiles([XFile(imageFile.path)]);
                  },
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: WidgetsToImage(
          controller: _screenshotController,
          child: Container(
            color: Colors.black,
            child: Stack(
              children: [
                // Menu button (top-left)
                Positioned(
                  top: 16,
                  left: 16,
                  child: GestureDetector(
                    onTap: () {
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

                // Share button (top-right) - FULL SCREENSHOT FUNCTIONALITY
                Positioned(
                  top: 16,
                  right: 16,
                  child: GestureDetector(
                    onTap: _shareScreenshot,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: Color(0xFF34C759),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.share, color: Colors.white),
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
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Color(0xFF34C759),
                                    width: 3,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                              onSubmitted: (value) => _finishEditing(),
                              onTapOutside: (event) => _finishEditing(),
                              textCapitalization: TextCapitalization.characters,
                              maxLength: 20,
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
