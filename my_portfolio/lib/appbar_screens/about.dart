import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:my_portfolio/appbar_screens/contact.dart';
import 'package:my_portfolio/appbar_screens/projects.dart';
import '../widgets/custom_widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Screens/home_screen.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

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

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final contentPadding = screenWidth * (isMobile ? 0.08 : 0.15);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A1A),
      appBar: CustomAppBar(
        isMobile: isMobile,
        screenWidth: screenWidth,
        contentPadding: contentPadding,
        onNavigate: navigateToScreen,
        onLaunchURL: _launchURL,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : screenWidth * 0.1,
            vertical: 30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Image
              Center(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.purple, width: 4),
                    image: const DecorationImage(
                      image: AssetImage('assets/profile.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ).animate().fadeIn().scale(),
              ),
              
              const SizedBox(height: 40),
              
              // Introduction
              Text(
                "Hi, I'm Aqeel Ahmad",
                style: TextStyle(
                  fontSize: isMobile ? 28 : 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ).animate().fadeIn().slideX(),
              
              const SizedBox(height: 20),
              
              Text(
                'Flutter Developer & UI/UX Enthusiast',
                style: TextStyle(
                  fontSize: isMobile ? 20 : 24,
                  color: Colors.purple,
                  fontWeight: FontWeight.w500,
                ),
              ).animate().fadeIn().slideX(),
              
              const SizedBox(height: 30),
              
              // About Description
              Text(
                'I am a passionate Flutter developer with a strong foundation in mobile and web application development. With several years of experience in the field, I specialize in creating beautiful, responsive, and user-friendly applications that deliver exceptional user experiences.',
                style: TextStyle(
                  fontSize: isMobile ? 16 : 18,
                  color: Colors.grey[400],
                  height: 1.6,
                ),
              ).animate().fadeIn(),
              
              const SizedBox(height: 40),
              
              // Skills Section
              Text(
                'Skills & Expertise',
                style: TextStyle(
                  fontSize: isMobile ? 24 : 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ).animate().fadeIn(),
              
              const SizedBox(height: 20),
              
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  'Flutter',
                  'Dart',
                  'Firebase',
                  'REST APIs',
                  'Git',
                  'UI/UX Design',
                  'State Management',
                  'Clean Architecture',
                  'Mobile Development',
                  'Web Development',
                ].map((skill) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    skill,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                )).toList(),
              ).animate().fadeIn(),
              
              const SizedBox(height: 40),
              
              // Education Section
              Text(
                'Education',
                style: TextStyle(
                  fontSize: isMobile ? 24 : 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ).animate().fadeIn(),
              
              const SizedBox(height: 20),
              
              _buildEducationItem(
                'Bachelor of Science in Computer Science',
                'University Name',
                '2018 - 2022',
              ).animate().fadeIn().slideX(),
              
              const SizedBox(height: 40),
              
              // Contact Information
              Text(
                'Get in Touch',
                style: TextStyle(
                  fontSize: isMobile ? 24 : 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ).animate().fadeIn(),
              
              const SizedBox(height: 20),
              
              _buildContactInfo(
                Icons.email,
                'Email:',
                'your.email@example.com',
              ).animate().fadeIn().slideX(),
              
              const SizedBox(height: 10),
              
              _buildContactInfo(
                Icons.location_on,
                'Location:',
                'Your City, Country',
              ).animate().fadeIn().slideX(),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildEducationItem(String degree, String university, String period) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            degree,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            university,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            period,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildContactInfo(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.purple, size: 24),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          value,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
