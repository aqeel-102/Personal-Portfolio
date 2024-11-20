import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:my_portfolio/appbar_screens/about.dart';
import 'package:my_portfolio/appbar_screens/projects.dart';
import '../widgets/custom_widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Screens/home_screen.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  DeviceType _getDeviceType(double screenWidth) {
    if (screenWidth < 600) return DeviceType.mobile;
    if (screenWidth < 800) return DeviceType.smallTablet;
    if (screenWidth < 1000) return DeviceType.tablet;
    if (screenWidth < 1200) return DeviceType.largeTablet;
    return DeviceType.desktop;
  }

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
                "Get in Touch",
                style: TextStyle(
                  fontSize: deviceType == DeviceType.mobile ? 32 : 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ).animate().fadeIn().slideX(),

              const SizedBox(height: 20),

              Text(
                "I'm always open to discussing new projects, opportunities, and collaborations.",
                style: TextStyle(
                  fontSize: deviceType == DeviceType.mobile ? 16 : 20,
                  color: Colors.grey[400],
                ),
              ).animate().fadeIn(),

              const SizedBox(height: 40),

              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF211F3D), Colors.purple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildContactMethod(
                      icon: Icons.email,
                      title: 'Email',
                      content: 'aqeelahmad.dev@gmail.com',
                      onTap: () => launchURL('mailto:aqeelahmad.dev@gmail.com'),
                    ).animate().fadeIn().slideX(),

                    const SizedBox(height: 30),

                    _buildContactMethod(
                      icon: Icons.phone,
                      title: 'Phone',
                      content: '+92 323 4085182',
                      onTap: () => launchURL('tel:+923234085182'),
                    ).animate().fadeIn().slideX(delay: const Duration(milliseconds: 200)),

                    const SizedBox(height: 30),

                    _buildContactMethod(
                      icon: Icons.location_on,
                      title: 'Location',
                      content: 'Lahore, Pakistan',
                      onTap: () {},
                    ).animate().fadeIn().slideX(delay: const Duration(milliseconds: 400)),
                  ],
                ),
              ).animate().fadeIn(),

              const SizedBox(height: 40),

              Text(
                "Social Media",
                style: TextStyle(
                  fontSize: deviceType == DeviceType.mobile ? 24 : 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ).animate().fadeIn(),

              const SizedBox(height: 20),

              Wrap(
                spacing: 20,
                runSpacing: 20,
                children: [
                  _buildSocialButton(
                    'GitHub',
                    Icons.code,
                    () => launchURL('https://github.com/aqeel-102'),
                  ),
                  _buildSocialButton(
                    'LinkedIn',
                    Icons.work,
                    () => launchURL('https://www.linkedin.com/in/aqeel-ahmad-534530311'),
                  ),
                  _buildSocialButton(
                    'Twitter',
                    Icons.chat_bubble,
                    () => launchURL('https://twitter.com/aqeel_dev'),
                  ),
                ],
              ).animate().fadeIn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactMethod({
    required IconData icon,
    required String title,
    required String content,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 30),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                content,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(String label, IconData icon, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple.withOpacity(0.3),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}
