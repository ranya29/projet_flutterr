import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';

class ThemeScreen extends StatelessWidget {
  const ThemeScreen({super.key});

  final List<Color> themeColors = const [
    Colors.purple,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.red,
    Colors.pink,
    Colors.teal,
    Colors.indigo,
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Thème'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Personnalisez l\'apparence de l\'application',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          const Divider(),

          // Choix du mode
          RadioListTile<ThemeMode>(
            title: const Text('Thème clair'),
            value: ThemeMode.light,
            groupValue: themeProvider.themeMode,
            activeColor: Colors.purple,
            secondary: const Icon(Icons.light_mode, color: Colors.orange),
            onChanged: themeProvider.setThemeMode,
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Thème sombre'),
            value: ThemeMode.dark,
            groupValue: themeProvider.themeMode,
            activeColor: Colors.purple,
            secondary: const Icon(Icons.dark_mode, color: Colors.indigo),
            onChanged: themeProvider.setThemeMode,
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Thème système'),
            value: ThemeMode.system,
            groupValue: themeProvider.themeMode,
            activeColor: Colors.purple,
            secondary: const Icon(Icons.smartphone, color: Colors.grey),
            onChanged: themeProvider.setThemeMode,
          ),

          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Couleur principale',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),

          // Choix de couleur
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              children: themeColors.map((color) {
                final isSelected = themeProvider.primaryColor == color;
                return GestureDetector(
                  onTap: () => themeProvider.setPrimaryColor(color),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: Colors.black, width: 3)
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.5),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 30)
                        : null,
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
