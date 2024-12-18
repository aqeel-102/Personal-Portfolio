import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/theme_controller.dart';

class ThemeToggle extends GetWidget<ThemeController> {
  const ThemeToggle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => IconButton(
      icon: Icon(
        controller.isDarkMode.value 
          ? Icons.light_mode 
          : Icons.dark_mode
      ),
      onPressed: controller.toggleTheme,
    ));
  }
} 