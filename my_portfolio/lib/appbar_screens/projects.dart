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
    final deviceType = _getDeviceType(screenWidth);
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
            horizontal: deviceType == DeviceType.mobile ? 20 : screenWidth * 0.1,
            vertical: 30,
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
              
              const SizedBox(height: 20),
              
              Text(
                'Here are some of my recent projects',
                style: TextStyle(
                  fontSize: deviceType == DeviceType.mobile ? 16 : 18,
                  color: Colors.grey[400],
                  height: 1.6,
                ),
              ).animate().fadeIn(),
              
              const SizedBox(height: 40),
              
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: deviceType == DeviceType.mobile ? 1 : 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: _getResponsiveAspectRatio(deviceType),
                children: [
                  _buildProjectCard(
                    context,
                    'Project 1',
                    'Description of project 1. This is a brief overview of what the project does and the technologies used.',
                    'assets/poerfolioimg.jpg',
                    ['Flutter', 'Firebase', 'REST API'],
                    0,
                    deviceType,
                  ),
                  _buildProjectCard(
                    context,
                    'Project 2',
                    'Description of project 2. This is a brief overview of what the project does and the technologies used.',
                    'assets/poerfolioimg.jpg',
                    ['React', 'Node.js', 'MongoDB'],
                    1,
                    deviceType,
                  ),
                  _buildProjectCard(
                    context,
                    'Project 3',
                    'Description of project 3. This is a brief overview of what the project does and the technologies used.',
                    'assets/poerfolioimg.jpg',
                    ['Vue.js', 'Express', 'PostgreSQL'],
                    2,
                    deviceType,
                  ),
                  _buildProjectCard(
                    context,
                    'Project 4',
                    'Description of project 4. This is a brief overview of what the project does and the technologies used.',
                    'assets/poerfolioimg.jpg',
                    ['Flutter', 'GraphQL', 'AWS'],
                    3,
                    deviceType,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectCard(BuildContext context, String title, String description, String imagePath, List<String> technologies, int index, DeviceType deviceType) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.asset(
              imagePath,
              height: _getResponsiveImageHeight(deviceType) * 2, // Doubled the height
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: _getResponsiveFontSize(deviceType, 20),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: _getResponsiveFontSize(deviceType, 14),
                    ),
                    maxLines: deviceType == DeviceType.smallTablet ? 2 : 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: technologies.map((tech) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Chip(
                          label: Text(
                            tech,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: _getResponsiveFontSize(deviceType, 12),
                            ),
                          ),
                          backgroundColor: Colors.purple.withOpacity(0.3),
                        ),
                      )).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: 200 * index));
  }

  DeviceType _getDeviceType(double screenWidth) {
    if (screenWidth < 600) return DeviceType.mobile;
    if (screenWidth < 800) return DeviceType.smallTablet;
    if (screenWidth < 1000) return DeviceType.tablet;
    if (screenWidth < 1200) return DeviceType.largeTablet;
    return DeviceType.desktop;
  }

  double _getResponsiveAspectRatio(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return 0.8;
      case DeviceType.smallTablet:
        return 0.75;
      case DeviceType.tablet:
        return 0.9;
      case DeviceType.largeTablet:
        return 0.95;
      case DeviceType.desktop:
        return 1.0;
    }
  }

  double _getResponsiveImageHeight(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return 180;
      case DeviceType.smallTablet:
        return 140;
      case DeviceType.tablet:
        return 140;
      case DeviceType.largeTablet:
        return 160;
      case DeviceType.desktop:
        return 180;
    }
  }

  double _getResponsiveFontSize(DeviceType deviceType, double baseSize) {
    switch (deviceType) {
      case DeviceType.mobile:
        return baseSize;
      case DeviceType.smallTablet:
        return baseSize * 0.85;
      case DeviceType.tablet:
        return baseSize * 0.85;
      case DeviceType.largeTablet:
        return baseSize * 0.95;
      case DeviceType.desktop:
        return baseSize;
    }
  }
}
