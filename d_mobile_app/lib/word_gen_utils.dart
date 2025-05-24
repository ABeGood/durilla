import 'package:flutter/material.dart';
import 'dart:math';

final Random _random = Random();

// Function to generate random letters and shuffle colors
List<String> _generateRandomLetters(currentLettersList) {
  // Generate random letters
  final newLetters = List.generate(
    currentLettersList.length, // Keep the same number of letters as DURILLA
    (index) => _englishLetters[_random.nextInt(_englishLetters.length)],
  );

  return newLetters;
}

List<Color> generateRandomColors(currentLettersList) {
  // Shuffle colors randomly
  final newColors = List.generate(
    currentLettersList.length,
    (index) => _availableColors[_random.nextInt(_availableColors.length)],
  );

  return newColors;
}

// Function to generate random letters and shuffle colors
// Function to randomly change the first letters of each word
List<String> changeFirstLetters(currentLettersList) {
  // Join current letters into a string
  String currentText = currentLettersList.join('');

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
  return newText.split('');
}

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
