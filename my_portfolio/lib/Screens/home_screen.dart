import 'package:flutter/material.dart';
import 'package:my_portfolio/appbar_screens/about.dart';
import 'package:my_portfolio/appbar_screens/contact.dart';
import 'package:my_portfolio/appbar_screens/projects.dart';
import '../widgets/custom_widgets.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PortfolioHomePage extends StatefulWidget {
  const PortfolioHomePage({super.key});

  @override
  State<PortfolioHomePage> createState() => _PortfolioHomePageState();
}

class _PortfolioHomePageState extends State<PortfolioHomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  final ScrollController _scrollController = ScrollController();

  void _navigateToScreen(String route) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          switch (route) {
            case '/home':
              return const PortfolioHomePage();
            case '/about':
              return const AboutPage();
            case '/projects':
              return const ProjectsPage(); // Replace with actual projects page
            case '/contact':
              return const ContactPage(); // Replace with actual contact page
            default:
              return const PortfolioHomePage();
          }
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          var fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(animation);

          return SlideTransition(
            position: offsetAnimation,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    try {
      if (!await url_launcher.launchUrl(uri, mode: url_launcher.LaunchMode.externalApplication)) {
        throw 'Could not launch $url';
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final contentPadding = screenWidth * (isMobile ? 0.08 : 0.15);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A1A),
      appBar: CustomAppBar(
        isMobile: isMobile,
        screenWidth: screenWidth,
        contentPadding: contentPadding,
        onNavigate: _navigateToScreen, // Changed to use _navigateToScreen
        onLaunchURL: _launchURL,
      ),
      body: ScrollConfiguration(
        behavior: CustomScrollBehavior(),
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: contentPadding,
              vertical: 40.0,
            ),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (isMobile) ...[
                      Center(
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: const DecorationImage(
                              image: AssetImage('assets/dp.jpg'),
                              fit: BoxFit.cover,
                            ),
                            border: Border.all(color: Colors.purple, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purple.withOpacity(0.3),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ).animate().fadeIn().scale(),
                      ),
                      const SizedBox(height: 50),
                      _buildIntroSection(isMobile),
                    ] else
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: _buildIntroSection(isMobile),
                          ),
                          const SizedBox(width: 50),
                          Expanded(
                            flex: 2,
                            child: Container(
                              width: 300,
                              height: 300,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: const DecorationImage(
                                  image: AssetImage('assets/dp.jpg'),
                                  fit: BoxFit.cover,
                                ),
                                border: Border.all(color: Colors.purple, width: 3),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.purple.withOpacity(0.3),
                                    blurRadius: 15,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                            ).animate().fadeIn().scale(),
                          ),
                        ],
                      ),
                    
                    const SizedBox(height: 120),
                    
                    // Skills Section
                    Text(
                      'Professional Skills',
                      style: TextStyle(
                        fontSize: isMobile ? 28 : 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ).animate().fadeIn().slideX(),
                    
                    const SizedBox(height: 50),
                    
                    Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      children: [
                        'Flutter', 'Dart', 'Firebase', 'Node.js', 
                        'React', 'JavaScript', 'Python', 'Git'
                      ].map((skill) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.purple.withOpacity(0.3)),
                        ),
                        child: Text(
                          skill,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ).animate().fadeIn().scale(),
                      ).toList(),
                    ),
                    
                    const SizedBox(height: 120),
                    
                    // Projects Section
                    Text(
                      'Featured Projects',
                      style: TextStyle(
                        fontSize: isMobile ? 28 : 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ).animate().fadeIn().slideX(),
                    
                    const SizedBox(height: 50),
                    
                    // Projects Grid
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: isMobile ? 1 : 2,
                      crossAxisSpacing: 30,
                      mainAxisSpacing: 30,
                      childAspectRatio: isMobile ? 1 : 1.2,
                      children: [
                        _buildProjectCard(
                          'Project 1',
                          'Simple Tools',
                          'A simple tools app built with Flutter and Firebase.',
                          ['Flutter', 'Firebase', 'State Management'],
                          'assets/project1.jpg',
                        ),
                        _buildProjectCard(
                          'Project 2',
                          'Weather App',
                          'A weather app built with Flutter with real-time weather data.',
                          ['Flutter','State Management'],
                          'assets/project2.jpg',
                        ),
                        _buildProjectCard(
                          'Project 3',
                          'Money Tracker',
                          'A money tracker app built with Flutter with laravel backend.',
                          ['Flutter', 'State Management', 'Laravel'],
                          'assets/project3.jpg',
                        ),
                        _buildProjectCard(
                          'Project 4',
                          'Portfolio Website',
                          'A portfolio website built with Flutter.',
                          ['Flutter', 'State Management'],
                          'assets/project4.jpg',
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 120),
                    
                    // Footer
                    Center(
                      child: Column(
                        children: [
                          const Text(
                            'Let\'s Connect',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Container(
                            width: isMobile ? double.infinity : screenWidth * 0.6,
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            child: Text(
                              'I\'m always open to discussing new projects, creative ideas or opportunities to be part of your visions.',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ).animate().fadeIn().scale(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProjectCard(String title, String subtitle, String description, List<String> technologies, String imagePath) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.purple.withOpacity(0.1),
          border: Border.all(color: Colors.purple.withOpacity(0.3)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Project Image
              Positioned.fill(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
              // Gradient Overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.grey[300],
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: technologies.map((tech) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          tech,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      )).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ).animate()
        .fadeIn()
        .scale(),
    );
  }

  Widget _buildIntroSection(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              'Welcome to my portfolio',
              textStyle: TextStyle(
                fontSize: isMobile ? 20 : 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              speed: const Duration(milliseconds: 100),
            ),
          ],
        ),
        const SizedBox(height: 30),
        Text(
          "I'm Aqeel Ahmad",
          style: TextStyle(
            fontSize: isMobile ? 32 : 48,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ).animate().fadeIn().slideX(),
        const SizedBox(height: 30),
        Text(
          'Flutter Developer',
          style: TextStyle(
            fontSize: isMobile ? 24 : 32,
            color: Colors.purple,
            fontWeight: FontWeight.w500,
          ),
        ).animate().fadeIn().slideX(),
        const SizedBox(height: 30),
        Text(
          'Experienced in crafting robust and scalable applications with a focus on clean code and exceptional user experiences. Specialized in modern web and mobile development technologies.',
          style: TextStyle(
            fontSize: isMobile ? 16 : 20,
            color: Colors.grey[400],
            height: 1.5,
          ),
        ).animate().fadeIn().slideX(),
      ],
    );
  }
}

class CustomScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }
}
