import 'package:flutter/material.dart';
import 'package:my_portfolio/appbar_screens/about.dart';
import 'package:my_portfolio/appbar_screens/contact.dart';
import 'package:my_portfolio/appbar_screens/projects.dart';
import 'package:my_portfolio/images/images.dart';
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

class _PortfolioHomePageState extends State<PortfolioHomePage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  final ScrollController _scrollController = ScrollController();
  late AnimationController _orbitController;

  // Cache skill icons to avoid repeated asset loading
  final List<String> skillIcons = [
    'assets/flutter.png',
    'assets/dart.png',
    'assets/firebase.png',
    'assets/c.png',
    'assets/html.png',
    'assets/css.png',
    'assets/javascript.png',
    'assets/github.png'
  ];

  // Cache image assets
  final Map<String, Image> _cachedImages = {};

  @override
  void initState() {
    super.initState();

    // Pre-cache images
    for (String path in skillIcons) {
      _cachedImages[path] = Image.asset(path);
    }
    _cachedImages['assets/dp.jpg'] = Image.asset('assets/dp.jpg');
    _cachedImages['assets/2.jpg'] = Image.asset('assets/2.jpg');
    _cachedImages['assets/poerfolioimg.jpg'] =
        Image.asset('assets/poerfolioimg.jpg');
    _cachedImages['assets/1.jpg'] = Image.asset('assets/1.jpg');

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
    _cachedImages.clear();
    super.dispose();
  }

  Widget _buildOrbitingSkills(
      double radius, DeviceType deviceType, double screenWidth) {
    // Responsive sizing
    double containerSize = getResponsiveSize(screenWidth, deviceType,
        mobile: 150,
        smallTablet: 175,
        tablet: 200,
        largeTablet: 225,
        desktop: 250);

    double orbitRadius = getResponsiveSize(screenWidth, deviceType,
        mobile: 120,
        smallTablet: 135,
        tablet: 150,
        largeTablet: 175,
        desktop: radius);

    double fontSize = getResponsiveSize(screenWidth, deviceType,
        mobile: 10,
        smallTablet: 10.5,
        tablet: 11,
        largeTablet: 11.5,
        desktop: 12);

    double skillPadding = getResponsiveSize(screenWidth, deviceType,
        mobile: 6, smallTablet: 8, tablet: 10, largeTablet: 11, desktop: 12);

    // Adjust icon size for the orbiting skills
    double orbitingIconSize = getResponsiveSize(screenWidth, deviceType,
        mobile: 24, smallTablet: 28, tablet: 32, largeTablet: 36, desktop: 40);

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

          // Updated orbiting skills to show only icons
          ...List.generate(skillIcons.length, (index) {
            return AnimatedBuilder(
              animation: _orbitController,
              builder: (context, child) {
                final angle = 2 * pi * (index / skillIcons.length) +
                    _orbitController.value * 2 * pi;
                final x = orbitRadius * cos(angle);
                final y = orbitRadius * sin(angle);

                return Transform.translate(
                  offset: Offset(x, y),
                  child: Container(
                    padding: EdgeInsets.all(skillPadding),
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
                    child: Image.asset(
                      skillIcons[index],
                      height: orbitingIconSize,
                      width: orbitingIconSize,
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

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    try {
      if (!await url_launcher.launchUrl(uri,
          mode: url_launcher.LaunchMode.externalApplication)) {
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
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          var fadeAnimation =
              Tween<double>(begin: 0.0, end: 1.0).animate(animation);

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
    final deviceType = getDeviceType(screenWidth);
    final contentPadding = screenWidth *
        (deviceType == DeviceType.mobile
            ? 0.08
            : deviceType == DeviceType.smallTablet
                ? 0.09
                : deviceType == DeviceType.tablet
                    ? 0.1
                    : deviceType == DeviceType.largeTablet
                        ? 0.12
                        : 0.15);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A1A),
      appBar: CustomAppBar(
        deviceType: deviceType,
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
                vertical: getResponsiveSize(screenWidth, deviceType,
                    mobile: 30,
                    smallTablet: 35,
                    tablet: 40,
                    largeTablet: 45,
                    desktop: 50),
              ),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                          height: getResponsiveSize(screenWidth, deviceType,
                              mobile: 60,
                              smallTablet: 70,
                              tablet: 80,
                              largeTablet: 100,
                              desktop: 150)),

                      if (deviceType == DeviceType.mobile ||
                          deviceType == DeviceType.smallTablet ||
                          deviceType == DeviceType.tablet) ...[
                        Center(
                          child: Column(
                            children: [
                              _buildOrbitingSkills(
                                  150, deviceType, screenWidth),
                              const SizedBox(height: 16),
                              // Add main skills/tags below the image for mobile/tablet
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                alignment: WrapAlignment.center,
                                children: [
                                  'API Integration',
                                  'State Management',
                                  'UI/UX',
                                  'Web Development',
                                  'Flutter',
                                  'Firebase',
                                ]
                                    .map((tag) => Chip(
                                          label: Text(tag,
                                              style: const TextStyle(
                                                  color: Colors.white)),
                                          backgroundColor:
                                              Colors.purple.withOpacity(0.3),
                                        ))
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 50),
                        _buildIntroSection(deviceType, screenWidth),
                      ] else
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 3,
                              child:
                                  _buildIntroSection(deviceType, screenWidth),
                            ),
                            const SizedBox(width: 50),
                            Expanded(
                              flex: 2,
                              child: Center(
                                child: _buildOrbitingSkills(
                                    200, deviceType, screenWidth),
                              ),
                            ),
                          ],
                        ),

                      SizedBox(
                          height: getResponsiveSize(screenWidth, deviceType,
                              mobile: 80,
                              smallTablet: 90,
                              tablet: 100,
                              largeTablet: 110,
                              desktop: 120)),

                      const SizedBox(height: 20),

                      // Skills Section
                      Text(
                        'My Skills',
                        style: TextStyle(
                          fontSize: getResponsiveSize(screenWidth, deviceType,
                              mobile: 24,
                              smallTablet: 26,
                              tablet: 28,
                              largeTablet: 32,
                              desktop: 36),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ).animate().fadeIn().slideX(),

                      const SizedBox(height: 30),

                      Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        children: [
                          _buildSkillCard(
                              'Dart', Images.dart, deviceType, screenWidth),
                          _buildSkillCard('Flutter', Images.flutter, deviceType,
                              screenWidth),
                          _buildSkillCard('Firebase', Images.firebase,
                              deviceType, screenWidth),
                          _buildSkillCard(
                              'Github', Images.github, deviceType, screenWidth),
                          _buildSkillCard(
                              'HTML', Images.html, deviceType, screenWidth),
                          _buildSkillCard(
                              'CSS', Images.css, deviceType, screenWidth),
                          _buildSkillCard(
                              'JavaScript', Images.js, deviceType, screenWidth),
                          _buildSkillCard(
                              'Git', Images.github, deviceType, screenWidth),
                          _buildSkillCard(
                              'C/C++', Images.c, deviceType, screenWidth)
                        ],
                      ),

                      SizedBox(
                          height: getResponsiveSize(screenWidth, deviceType,
                              mobile: 80,
                              smallTablet: 90,
                              tablet: 100,
                              largeTablet: 110,
                              desktop: 120)),

                      const SizedBox(height: 20),
                      // Projects Section
                      Text(
                        'Featured Projects',
                        style: TextStyle(
                          fontSize: getResponsiveSize(screenWidth, deviceType,
                              mobile: 24,
                              smallTablet: 26,
                              tablet: 28,
                              largeTablet: 32,
                              desktop: 36),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ).animate().fadeIn().slideX(),

                      const SizedBox(height: 50),

                      // Projects Grid
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: getGridCrossAxisCount(deviceType),
                          crossAxisSpacing: getResponsiveSize(
                              screenWidth, deviceType,
                              mobile: 16,
                              smallTablet: 20,
                              tablet: 24,
                              largeTablet: 30,
                              desktop: 40),
                          mainAxisSpacing: getResponsiveSize(
                              screenWidth, deviceType,
                              mobile: 16,
                              smallTablet: 20,
                              tablet: 24,
                              largeTablet: 30,
                              desktop: 40),
                          childAspectRatio: getResponsiveSize(
                              screenWidth, deviceType,
                              mobile: 1.0,
                              smallTablet: 1.05,
                              tablet: 1.1,
                              largeTablet: 1.15,
                              desktop: 1.2),
                        ),
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          final List<Map<String, dynamic>> projects = [
                            {
                              'title': 'Project 1',
                              'subtitle': 'Simple Tools',
                              'description':
                                  'A simple tools app built with Flutter and Api integration.',
                              'image': 'assets/2.jpg',
                              'technologies': <String>[
                                'Flutter',
                                'Api Integration',
                                'State Management',
                                'UI/UX'
                              ],
                            },
                            {
                              'title': 'Project 2',
                              'subtitle': 'Money Tracker',
                              'description':
                                  'A money tracker app built with Flutter with laravel backend.',
                              'image': 'assets/1.jpg',
                              'technologies': <String>[
                                'Flutter',
                                'Rest Api',
                                'Laravel',
                                'Authentication'
                              ],
                            },
                            {
                              'title': 'Project 3',
                              'subtitle': 'Portfolio Website',
                              'description':
                                  'A portfolio website built with Flutter.',
                              'image': 'assets/Portfoilio Website.png',
                              'technologies': <String>[
                                'Flutter',
                                'State Management',
                                'UI/UX',
                                'Web Development'
                              ],
                            },
                          ];

                          final project = projects[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProjectsPage(),
                                ),
                              );
                            },
                            child: buildProjectCard(
                              context,
                              project['title'] as String,
                              project['subtitle'] as String,
                              project['description'] as String,
                              project['image'] as String,
                              project['technologies'] as List<String>,
                              index,
                              deviceType,
                              screenWidth,
                            ),
                          );
                        },
                      ),
                      SizedBox(
                          height: getResponsiveSize(screenWidth, deviceType,
                              mobile: 80,
                              smallTablet: 90,
                              tablet: 100,
                              largeTablet: 110,
                              desktop: 120)),

                      // Footer
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                                color: Colors.purple.withOpacity(0.3),
                                width: 1),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Get in Touch',
                              style: TextStyle(
                                fontSize: getResponsiveSize(
                                    screenWidth, deviceType,
                                    mobile: 24,
                                    smallTablet: 26,
                                    tablet: 28,
                                    largeTablet: 30,
                                    desktop: 32),
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: deviceType == DeviceType.mobile
                                  ? double.infinity
                                  : screenWidth *
                                      (deviceType == DeviceType.smallTablet
                                          ? 0.8
                                          : deviceType == DeviceType.tablet
                                              ? 0.7
                                              : deviceType ==
                                                      DeviceType.largeTablet
                                                  ? 0.65
                                                  : 0.6),
                              child: Text(
                                'Im always open to discussing product design work or partnership opportunities.',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: getResponsiveSize(
                                      screenWidth, deviceType,
                                      mobile: 14,
                                      smallTablet: 15,
                                      tablet: 16,
                                      largeTablet: 17,
                                      desktop: 18),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.email),
                                  onPressed: () => _launchURL(
                                      'mailto:aqeelahmad.dev@gmail.com'),
                                  color: Colors.white,
                                  tooltip: 'Email',
                                ),
                                IconButton(
                                  icon: const Icon(Icons.message),
                                  onPressed: () => _launchURL(
                                      'https://www.linkedin.com/in/aqeel-ahmad-534530311'),
                                  color: Colors.white,
                                  tooltip: 'LinkedIn',
                                ),
                                IconButton(
                                  icon: const Icon(Icons.code),
                                  onPressed: () => _launchURL(
                                      'https://github.com/aqeel-102'),
                                  color: Colors.white,
                                  tooltip: 'GitHub',
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Text(
                              '© 2023 Aqeel Ahmad. All rights reserved.',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: getResponsiveSize(
                                    screenWidth, deviceType,
                                    mobile: 12,
                                    smallTablet: 13,
                                    tablet: 14,
                                    largeTablet: 15,
                                    desktop: 16),
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn().scale(),
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

  Widget _buildSkillCard(String skill, String imagePath, DeviceType deviceType,
      double screenWidth) {
    double cardSize = getResponsiveSize(screenWidth, deviceType,
        mobile: 80,
        smallTablet: 90,
        tablet: 100,
        largeTablet: 120,
        desktop: 140);

    double imageSize = getResponsiveSize(screenWidth, deviceType,
        mobile: 18, smallTablet: 22, tablet: 26, largeTablet: 30, desktop: 35);

    double fontSize = getResponsiveSize(screenWidth, deviceType,
        mobile: 12, smallTablet: 14, tablet: 16, largeTablet: 18, desktop: 20);

    return Container(
      width: cardSize,
      height: cardSize,
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.purple.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            width: imageSize,
            height: imageSize,
          ),
          SizedBox(height: cardSize * 0.1),
          Text(
            skill,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: const Duration(milliseconds: 600))
        .scale(delay: const Duration(milliseconds: 200))
        .shimmer(duration: const Duration(seconds: 1), curve: Curves.easeInOut)
        .then()
        .shake(hz: 2, curve: Curves.easeInOut)
        .then()
        .elevation(
          begin: 0,
          end: 8,
          curve: Curves.easeInOut,
          duration: const Duration(seconds: 1),
        );
  }

  Widget buildProjectCard(
      BuildContext context,
      String title,
      String subtitle,
      String description,
      String imagePath,
      List<String> technologies,
      int index,
      DeviceType deviceType,
      double screenWidth) {
    double titleSize = getResponsiveSize(screenWidth, deviceType,
        mobile: 12, smallTablet: 9, tablet: 10, largeTablet: 11, desktop: 23);
    double subtitleSize = getResponsiveSize(screenWidth, deviceType,
        mobile: 16, smallTablet: 10, tablet: 11, largeTablet: 13, desktop: 26);
    double descriptionSize = getResponsiveSize(screenWidth, deviceType,
        mobile: 12, smallTablet: 8, tablet: 9, largeTablet: 11, desktop: 20);

    double cardPadding = getResponsiveSize(screenWidth, deviceType,
        mobile: 12, smallTablet: 14, tablet: 16, largeTablet: 18, desktop: 20);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.purple.withOpacity(0.05),
          border: Border.all(color: Colors.purple.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.1),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(cardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title.toUpperCase(),
                        style: TextStyle(
                          color: Colors.purple[200],
                          fontSize: titleSize,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: subtitleSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: descriptionSize,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: technologies
                            .map((tech) => Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: cardPadding * 0.4,
                                    vertical: cardPadding * 0.2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.purple.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.purple.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Text(
                                    tech,
                                    style: TextStyle(
                                      color: Colors.purple[100],
                                      fontSize: descriptionSize * 0.9,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIntroSection(DeviceType deviceType, double screenWidth) {
    double welcomeSize = getResponsiveSize(screenWidth, deviceType,
        mobile: 16, smallTablet: 18, tablet: 20, largeTablet: 22, desktop: 24);
    double nameSize = getResponsiveSize(screenWidth, deviceType,
        mobile: 28, smallTablet: 32, tablet: 36, largeTablet: 42, desktop: 48);
    double roleSize = getResponsiveSize(screenWidth, deviceType,
        mobile: 20, smallTablet: 23, tablet: 26, largeTablet: 29, desktop: 32);
    double descriptionSize = getResponsiveSize(screenWidth, deviceType,
        mobile: 14, smallTablet: 15, tablet: 16, largeTablet: 18, desktop: 20);

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

enum DeviceType {
  mobile,
  smallTablet,
  tablet,
  largeTablet,
  desktop,
}

DeviceType getDeviceType(double screenWidth) {
  if (screenWidth < 600) return DeviceType.mobile;
  if (screenWidth < 900) return DeviceType.smallTablet;
  if (screenWidth < 1200) return DeviceType.tablet;
  if (screenWidth < 1536) return DeviceType.largeTablet;
  return DeviceType.desktop;
}

double getResponsiveSize(
  double screenWidth,
  DeviceType deviceType, {
  required double mobile,
  required double smallTablet,
  required double tablet,
  required double largeTablet,
  required double desktop,
}) {
  switch (deviceType) {
    case DeviceType.mobile:
      return mobile;
    case DeviceType.smallTablet:
      return smallTablet;
    case DeviceType.tablet:
      return tablet;
    case DeviceType.largeTablet:
      return largeTablet;
    case DeviceType.desktop:
      return desktop;
  }
}

int getGridCrossAxisCount(DeviceType deviceType) {
  switch (deviceType) {
    case DeviceType.mobile:
      return 1;
    case DeviceType.smallTablet:
      return 2;
    case DeviceType.tablet:
      return 2;
    case DeviceType.largeTablet:
      return 2;
    case DeviceType.desktop:
      return 2;
  }
}
