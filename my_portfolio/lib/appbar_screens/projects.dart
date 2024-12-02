import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:my_portfolio/appbar_screens/about.dart';
import 'package:my_portfolio/appbar_screens/contact.dart';
import '../widgets/custom_widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Screens/home_screen.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    void navigateToScreen(String route) {
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

    Future<void> launchURL(String url) async {
      final Uri uri = Uri.parse(url);
      if (!await launchUrl(uri)) {
        throw Exception('Could not launch $url');
      }
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final deviceType = getDeviceType(screenWidth);
    final contentPadding = screenWidth * (deviceType == DeviceType.mobile ? 0.08 : 0.15);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A1A),
      appBar: CustomAppBar(
        deviceType: deviceType,
        screenWidth: screenWidth,
        contentPadding: contentPadding,
        onNavigate: navigateToScreen,
        onLaunchURL: launchURL,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getResponsiveSize(screenWidth, deviceType,
              mobile: 16,
              smallTablet: screenWidth * 0.06,
              tablet: screenWidth * 0.08,
              largeTablet: screenWidth * 0.1,
              desktop: screenWidth * 0.15
            ),
            vertical: getResponsiveSize(screenWidth, deviceType,
              mobile: 16,
              smallTablet: 20,
              tablet: 24,
              largeTablet: 28,
              desktop: 32
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "My Projects",
                style: TextStyle(
                  fontSize: deviceType == DeviceType.mobile ? 28 : 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ).animate().fadeIn().slideX(),
              
              const SizedBox(height: 12),
              
              Text(
                'Here are some of my recent projects',
                style: TextStyle(
                  fontSize: deviceType == DeviceType.mobile ? 16 : 18,
                  color: Colors.grey[400],
                  height: 1.6,
                ),
              ).animate().fadeIn(),
              
              const SizedBox(height: 24),
              
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: getGridCrossAxisCount(deviceType),
                crossAxisSpacing: getResponsiveSize(screenWidth, deviceType,
                  mobile: 16,
                  smallTablet: 20,
                  tablet: 24,
                  largeTablet: 30,
                  desktop: 40
                ),
                mainAxisSpacing: getResponsiveSize(screenWidth, deviceType,
                  mobile: 16,
                  smallTablet: 20,
                  tablet: 24,
                  largeTablet: 30,
                  desktop: 40
                ),
                childAspectRatio: getResponsiveSize(screenWidth, deviceType,
                  mobile: 1.0,
                  smallTablet: 1.05,
                  tablet: 1.1,
                  largeTablet: 1.15,
                  desktop: 1.2
                ),
                padding: EdgeInsets.zero,
                children: [
                  buildProjectCard(
                    context,
                    'Project 1',
                    'Simple Tools',
                    'A simple tools app built with Flutter and Firebase.',
                    'assets/poerfolioimg.jpg',
                    ['Flutter', 'Firebase', 'State Management'],
                    0,
                    deviceType,
                    screenWidth,
                  ),
                  buildProjectCard(
                    context,
                    'Project 2',
                    'Weather App',
                    'A weather app built with Flutter with real-time weather data.',
                    'assets/poerfolioimg.jpg',
                    ['Flutter', 'State Management'],
                    1,
                    deviceType,
                    screenWidth,
                  ),
                  buildProjectCard(
                    context,
                    'Project 3',
                    'Money Tracker',
                    'A money tracker app built with Flutter with laravel backend.',
                    'assets/poerfolioimg.jpg',
                    ['Flutter', 'State Management', 'Laravel'],
                    2,
                    deviceType,
                    screenWidth,
                  ),
                  buildProjectCard(
                    context,
                    'Project 4',
                    'Portfolio Website',
                    'A portfolio website built with Flutter.',
                    'assets/poerfolioimg.jpg',
                    ['Flutter', 'State Management'],
                    3,
                    deviceType,
                    screenWidth,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProjectCard(BuildContext context, String title, String subtitle, String description, String imagePath, List<String> technologies, int index, DeviceType deviceType, double screenWidth) {
    double titleSize = getResponsiveSize(screenWidth, deviceType,
      mobile: 12,
      smallTablet: 13,
      tablet: 14,
      largeTablet: 15,
      desktop: 16
    );
    double subtitleSize = getResponsiveSize(screenWidth, deviceType,
      mobile: 16,
      smallTablet: 17,
      tablet: 18,
      largeTablet: 19,
      desktop: 20
    );
    double descriptionSize = getResponsiveSize(screenWidth, deviceType,
      mobile: 12,
      smallTablet: 12,
      tablet: 13,
      largeTablet: 13,
      desktop: 14
    );
    
    double cardPadding = getResponsiveSize(screenWidth, deviceType,
      mobile: 12,
      smallTablet: 14,
      tablet: 16,
      largeTablet: 18,
      desktop: 20
    );

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
                        children: technologies.map((tech) => Container(
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
                        )).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ).animate()
        .fadeIn(duration: const Duration(milliseconds: 600))
        .scale(delay: const Duration(milliseconds: 200)),
    );
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
}

DeviceType getDeviceType(double screenWidth) {
  if (screenWidth < 600) return DeviceType.mobile;
  if (screenWidth < 900) return DeviceType.smallTablet;
  if (screenWidth < 1200) return DeviceType.tablet;
  if (screenWidth < 1536) return DeviceType.largeTablet;
  return DeviceType.desktop;
}

double getResponsiveSize(double screenWidth, DeviceType deviceType, {
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
