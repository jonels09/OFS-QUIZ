import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/providers/theme_provider.dart';
import 'package:quiz_app/widgets/color_picker_dialog.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return IconButton(
          icon: Icon(
            Icons.color_lens,
            color: themeProvider.primaryColor,
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const ColorPickerDialog(),
            );
          },
        );
      },
    );
  }
}
