import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:my_portfolio/Screens/home_screen.dart';

// Single source of truth for app configuration
class AppConfig {
  static const int imageCacheSize = 100;
  static const int imageCacheSizeBytes = 50 << 20; // 50 MB
  
  static const systemOverlays = [
    SystemUiOverlay.top,
    SystemUiOverlay.bottom,
  ];
  
  static final pageTransitions = {
    TargetPlatform.android: const CupertinoPageTransitionsBuilder(),
    TargetPlatform.iOS: const CupertinoPageTransitionsBuilder(),
    TargetPlatform.macOS: const CupertinoPageTransitionsBuilder(),
    TargetPlatform.windows: const CupertinoPageTransitionsBuilder(),
    TargetPlatform.linux: const CupertinoPageTransitionsBuilder(),
  };
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _initializeApp();
  runApp(const MyApp());
}

void _initializeApp() {
  // Configure system UI
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  
  // Configure image cache
  final imageCache = PaintingBinding.instance.imageCache;
  imageCache.maximumSize = AppConfig.imageCacheSize;
  imageCache.maximumSizeBytes = AppConfig.imageCacheSizeBytes;
  
  // Configure system UI mode
  WidgetsBinding.instance.addPostFrameCallback((_) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: AppConfig.systemOverlays,
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Developer Portfolio',
      theme: _buildTheme(),
      defaultTransition: Transition.fade, // GetX transition
      builder: _buildAppWithScrollBehavior,
      home: const PortfolioHomePage(),
      initialBinding: AppBinding(), // Initialize bindings
    );
  }
  
  ThemeData _buildTheme() {
    return ThemeData.dark().copyWith(
      platform: TargetPlatform.android,
      pageTransitionsTheme: PageTransitionsTheme(
        builders: AppConfig.pageTransitions,
      ),
      splashFactory: InkRipple.splashFactory,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
  
  Widget _buildAppWithScrollBehavior(BuildContext context, Widget? child) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        physics: const ClampingScrollPhysics(),
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        },
      ),
      child: child!,
    );
  }
}

// Controllers for theme and navigation
class ThemeController extends GetxController {
  // Add theme related logic here
}

class NavigationController extends GetxController {
  // Add navigation related logic here  
}

// Bindings for dependency injection
class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Register your controllers here
    Get.put(ThemeController());
    Get.put(NavigationController());
  }
}
