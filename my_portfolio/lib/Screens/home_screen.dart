import 'package:flutter/material.dart';
import 'package:my_portfolio/appbar_screens/about.dart';
import 'package:my_portfolio/appbar_screens/contact.dart';
import 'package:my_portfolio/appbar_screens/projects.dart';
import '../widgets/custom_widgets.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' show cos, pi, sin;

class PortfolioHomePage extends StatefulWidget {
  const PortfolioHomePage({super.key});

  @override
  State<PortfolioHomePage> createState() => _PortfolioHomePageState();
}

class _PortfolioHomePageState extends State<PortfolioHomePage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  final ScrollController _scrollController = ScrollController();
  late AnimationController _orbitController;

  final List<String> skills = [
    'Flutter', 'Dart', 'Firebase', 'Node.js',
    'React', 'JavaScript', 'Python', 'Git'
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _orbitController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

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
    _orbitController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildOrbitingSkills(double radius, bool isMobile, double screenWidth) {
    // Responsive sizing
    double containerSize = _getResponsiveSize(screenWidth, 
      mobile: 150,
      tablet: 200, 
      desktop: 250
    );
    
    double orbitRadius = _getResponsiveSize(screenWidth,
      mobile: 120,
      tablet: 150,
      desktop: radius
    );
    
    double fontSize = _getResponsiveSize(screenWidth,
      mobile: 10,
      tablet: 11,
      desktop: 12
    );
    
    double skillPadding = _getResponsiveSize(screenWidth,
      mobile: 6,
      tablet: 10,
      desktop: 12
    );

    return SizedBox(
      width: orbitRadius * 2.5,
      height: orbitRadius * 2.5,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Profile picture
          Container(
            width: containerSize,
            height: containerSize,
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
          
          // Orbiting skills
          ...List.generate(skills.length, (index) {
            return AnimatedBuilder(
              animation: _orbitController,
              builder: (context, child) {
                final angle = 2 * pi * (index / skills.length) + _orbitController.value * 2 * pi;
                final x = orbitRadius * cos(angle);
                final y = orbitRadius * sin(angle);
                
                return Transform.translate(
                  offset: Offset(x, y),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: skillPadding, vertical: skillPadding/2),
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.purple.withOpacity(0.3)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.1),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Text(
                      skills[index],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSize,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }

  double _getResponsiveSize(double screenWidth, {
    required double mobile,
    required double tablet,
    required double desktop,
  }) {
    if (screenWidth < 600) return mobile;
    if (screenWidth < 1000) return tablet;
    return desktop;
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    try {
      if (!await url_launcher.launchUrl(uri, mode: url_launcher.LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }

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
              return const ProjectsPage();
            case '/contact':
              return const ContactPage();
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
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1000;
    final contentPadding = screenWidth * (isMobile ? 0.08 : isTablet ? 0.1 : 0.15);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A1A),
      appBar: CustomAppBar(
        isMobile: isMobile,
        screenWidth: screenWidth,
        contentPadding: contentPadding,
        onNavigate: _navigateToScreen,
        onLaunchURL: _launchURL,
      ),
      body: ScrollConfiguration(
        behavior: CustomScrollBehavior(),
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: screenHeight - kToolbarHeight,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: contentPadding,
                vertical: _getResponsiveSize(screenWidth,
                  mobile: 30,
                  tablet: 40,
                  desktop: 50
                ),
              ),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: _getResponsiveSize(screenWidth,
                        mobile: 60,
                        tablet: 80,
                        desktop: 150
                      )),
                      
                      if (isMobile || isTablet) ...[
                        Center(
                          child: _buildOrbitingSkills(150, isMobile, screenWidth),
                        ),
                        const SizedBox(height: 50),
                        _buildIntroSection(isMobile, screenWidth),
                      ] else
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center, // Changed from start to center
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Added mainAxisAlignment
                          children: [
                            Expanded(
                              flex: 3,
                              child: _buildIntroSection(isMobile, screenWidth),
                            ),
                            const SizedBox(width: 50),
                            Expanded(
                              flex: 2,
                              child: Center( // Wrapped with Center
                                child: _buildOrbitingSkills(200, isMobile, screenWidth),
                              ),
                            ),
                          ],
                        ),
                      
                      SizedBox(height: _getResponsiveSize(screenWidth,
                        mobile: 80,
                        tablet: 100,
                        desktop: 120
                      )),
                      
                      // Projects Section
                      Text(
                        'Featured Projects',
                        style: TextStyle(
                          fontSize: _getResponsiveSize(screenWidth,
                            mobile: 24,
                            tablet: 28,
                            desktop: 36
                          ),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ).animate().fadeIn().slideX(),
                      
                      const SizedBox(height: 50),
                      
                      // Projects Grid
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: isMobile ? 1 : isTablet ? 2 : 2,
                        crossAxisSpacing: 30,
                        mainAxisSpacing: 30,
                        childAspectRatio: _getResponsiveSize(screenWidth,
                          mobile: 1.2,
                          tablet: 1.1,
                          desktop: 1.2
                        ),
                        children: [
                          _buildProjectCard(
                            'Project 1',
                            'Simple Tools',
                            'A simple tools app built with Flutter and Firebase.',
                            ['Flutter', 'Firebase', 'State Management'],
                            'assets/poertfolioimg.png',
                            screenWidth,
                          ),
                          _buildProjectCard(
                            'Project 2',
                            'Weather App',
                            'A weather app built with Flutter with real-time weather data.',
                            ['Flutter','State Management'],
                            'assets/project2.jpg',
                            screenWidth,
                          ),
                          _buildProjectCard(
                            'Project 3',
                            'Money Tracker',
                            'A money tracker app built with Flutter with laravel backend.',
                            ['Flutter', 'State Management', 'Laravel'],
                            'assets/project3.jpg',
                            screenWidth,
                          ),
                          _buildProjectCard(
                            'Project 4',
                            'Portfolio Website',
                            'A portfolio website built with Flutter.',
                            ['Flutter', 'State Management'],
                            'assets/project4.jpg',
                            screenWidth,
                          ),
                        ],
                      ),
                      
                      SizedBox(height: _getResponsiveSize(screenWidth,
                        mobile: 80,
                        tablet: 100,
                        desktop: 120
                      )),
                      
                      // Footer
                      Center(
                        child: Column(
                          children: [
                            Text(
                              'Let\'s Connect',
                              style: TextStyle(
                                fontSize: _getResponsiveSize(screenWidth,
                                  mobile: 24,
                                  tablet: 28,
                                  desktop: 32
                                ),
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 30),
                            Container(
                              width: isMobile ? double.infinity : screenWidth * (isTablet ? 0.7 : 0.6),
                              padding: const EdgeInsets.symmetric(vertical: 30),
                              child: Text(
                                'I\'m always open to discussing new projects, creative ideas or opportunities to be part of your visions.',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: _getResponsiveSize(screenWidth,
                                    mobile: 14,
                                    tablet: 16,
                                    desktop: 18
                                  ),
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
      ),
    );
  }

  Widget _buildProjectCard(String title, String subtitle, String description, List<String> technologies, String imagePath, double screenWidth) {
    double titleSize = _getResponsiveSize(screenWidth,
      mobile: 12,
      tablet: 13,
      desktop: 14
    );
    double subtitleSize = _getResponsiveSize(screenWidth,
      mobile: 20,
      tablet: 22,
      desktop: 24
    );
    double descriptionSize = _getResponsiveSize(screenWidth,
      mobile: 14,
      tablet: 15,
      desktop: 16
    );
    double techSize = _getResponsiveSize(screenWidth,
      mobile: 10,
      tablet: 11,
      desktop: 12
    );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.purple.withOpacity(0.1),
          border: Border.all(color: Colors.purple.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
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
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: titleSize,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: subtitleSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.grey[300],
                        fontSize: descriptionSize,
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
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purple.withOpacity(0.1),
                              blurRadius: 5,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Text(
                          tech,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: techSize,
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

  Widget _buildIntroSection(bool isMobile, double screenWidth) {
    double welcomeSize = _getResponsiveSize(screenWidth,
      mobile: 16,
      tablet: 20,
      desktop: 24
    );
    double nameSize = _getResponsiveSize(screenWidth,
      mobile: 28,
      tablet: 36,
      desktop: 48
    );
    double roleSize = _getResponsiveSize(screenWidth,
      mobile: 20,
      tablet: 26,
      desktop: 32
    );
    double descriptionSize = _getResponsiveSize(screenWidth,
      mobile: 14,
      tablet: 16,
      desktop: 20
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              'Welcome to my portfolio',
              textStyle: TextStyle(
                fontSize: welcomeSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              speed: const Duration(milliseconds: 100),
            ),
          ],
          displayFullTextOnTap: true,
          stopPauseOnTap: true,
          isRepeatingAnimation: false,
        ),
        const SizedBox(height: 30),
        Text(
          "I'm Aqeel Ahmad",
          style: TextStyle(
            fontSize: nameSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ).animate().fadeIn().slideX(),
        const SizedBox(height: 30),
        Text(
          'Flutter Developer',
          style: TextStyle(
            fontSize: roleSize,
            color: Colors.purple,
            fontWeight: FontWeight.w500,
          ),
        ).animate().fadeIn().slideX(),
        const SizedBox(height: 30),
        Text(
          'Experienced in crafting robust and scalable applications with a focus on clean code and exceptional user experiences. Specialized in modern web and mobile development technologies.',
          style: TextStyle(
            fontSize: descriptionSize,
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
