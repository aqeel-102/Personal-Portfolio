import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/custom_widgets.dart';
import '../Screens/home_screen.dart';
import '../widgets/projectdetails.dart';
import '../appbar_screens/about.dart';
import '../appbar_screens/contact.dart';

class Project {
  final String title;
  final String subtitle; 
  final String description;
  final List<String> images;
  final List<String> presentation;
  final List<String> technologies;
  final Color accentColor;

  Project({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.images,
    required this.presentation,
    required this.technologies,
    this.accentColor = Colors.purple,
  });
}

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> with SingleTickerProviderStateMixin {


  final List<Project> projects = [
    Project(
      title: 'Expense Tracker',
      subtitle: 'Finance Management App',
      description: 'A comprehensive finance management app with expense tracking, budgeting, and insightful analytics.',
      images: ['assets/1.jpg'],
      technologies: ['Flutter', 'Laravel', 'Restful API'],
      presentation: ['assets/tracker.png'], 
      accentColor: Colors.green,
    ),
    Project(
      title: 'Simple Tools',
      subtitle: 'Utility App Suite', 
      description: 'A collection of handy utility tools including multiple daily usage timers, time zone converter, and more.',
      images: ['assets/2.jpg'],
      technologies: ['Flutter', 'Dart', 'Custom Animations'],
       presentation: ['assets/simpletools.png'],  
        accentColor: Colors.blue,
    ),
    Project(
      title: 'Personal Portfolio',
      subtitle: 'Interactive Web Portfolio',
      description: 'A dynamic and responsive web portfolio showcasing my projects and skills with interactive elements.',
      images: ['assets/Portfoilio Website.png'],
      technologies: ['Flutter Web', 'Responsive Design', 'Animation'],
       presentation: ['assets/portolio_final.png'], 
      accentColor: Colors.purple,
    ),
  ];

  late AnimationController _controller;
  late Animation<double> _animation;
  int? hoveredIndex;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final deviceType = getDeviceType(screenWidth);
    final contentPadding = screenWidth * (deviceType == DeviceType.mobile ? 0.04 : 0.15);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A1A),
      appBar: CustomAppBar(
        deviceType: deviceType,
        screenWidth: screenWidth,
        contentPadding: contentPadding,
        onNavigate: _handleNavigation,
        onLaunchURL: _launchURL,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                minHeight: screenHeight - kToolbarHeight, // Subtract AppBar height
              ),
              child: Column(
                children: [
                  _buildHeader(deviceType),
                  _buildProjectsList(deviceType, screenWidth),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildHeader(DeviceType deviceType) {
    return Padding(
      padding: EdgeInsets.all(deviceType == DeviceType.mobile ? 16.0 : 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Innovative Projects",
            style: TextStyle(
              fontSize: deviceType == DeviceType.mobile ? 28 : 56,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ).animate()
            .fadeIn(duration: const Duration(milliseconds: 800))
            .slideX(begin: -0.2, end: 0),
          
          const SizedBox(height: 16),
          
          Text(
            'Pushing the boundaries of technology and design',
            style: TextStyle(
              fontSize: deviceType == DeviceType.mobile ? 16 : 24,
              color: Colors.grey[300],
              height: 1.6,
            ),
          ).animate()
            .fadeIn(delay: const Duration(milliseconds: 400))
            .slideX(begin: -0.2, end: 0),
        ],
      ),
    );
  }

  Widget _buildProjectsList(DeviceType deviceType, double screenWidth) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        return _buildProjectTile(
          context,
          projects[index],
          index,
          deviceType,
          screenWidth,
        );
      },
    );
  }

  Widget _buildProjectTile(
    BuildContext context,
    Project project,
    int index,
    DeviceType deviceType,
    double screenWidth,
  ) {
    bool isHovered = hoveredIndex == index;
    bool isImageOnLeft = index.isEven;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: deviceType == DeviceType.mobile ? 8 : 32,
        vertical: deviceType == DeviceType.mobile ? 16 : 24,
      ),
      child: MouseRegion(
        onEnter: (_) => setState(() => hoveredIndex = index),
        onExit: (_) => setState(() => hoveredIndex = null),
        child: GestureDetector(
          onTap: () => _navigateToProjectDetails(context, project),
          child: Container(
            height: getResponsiveSize(screenWidth, deviceType,
              mobile: 400,
              smallTablet: 350,
              tablet: 400,
              largeTablet: 450,
              desktop: 500,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: project.accentColor.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: deviceType == DeviceType.mobile
                ? _buildMobileProjectTile(project, isHovered, screenWidth)
                : _buildDesktopProjectTile(project, isHovered, isImageOnLeft, screenWidth, deviceType),
          ),
        ),
      ),
    ).animate()
      .fadeIn(
        duration: const Duration(milliseconds: 600),
        delay: Duration(milliseconds: index * 200),
      )
      .slideY(begin: 0.2, end: 0);
  }

  Widget _buildMobileProjectTile(Project project, bool isHovered, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 2,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                child: ShaderMask(
                  shaderCallback: (rect) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        project.accentColor.withOpacity(0.8),
                      ],
                    ).createShader(rect);
                  },
                  blendMode: BlendMode.darken,
                  child: SizedBox(
                    height: double.infinity,
                    child: Image.asset(
                      project.images[0],
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              if (isHovered)
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        project.accentColor.withOpacity(0.9),
                      ],
                    ),
                  ),
                ).animate().fadeIn(),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  project.subtitle,
                  style: TextStyle(
                    color: Colors.grey[300],
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Text(
                    project.description,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: project.technologies.map((tech) => _buildTechChip(tech, project.accentColor)).toList(),
                ),
                if (isHovered) ...[
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () => _navigateToProjectDetails(context, project),
                    icon: const Icon(Icons.arrow_forward, size: 16),
                    label: const Text('View More', style: TextStyle(fontSize: 12)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: project.accentColor,
                      side: BorderSide(color: project.accentColor),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopProjectTile(Project project, bool isHovered, bool isImageOnLeft, double screenWidth, DeviceType deviceType) {
    return Row(
      children: [
        if (isImageOnLeft) Expanded(
          child: _buildProjectImage(project, isHovered),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  project.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: getResponsiveSize(screenWidth, deviceType,
                      mobile: 26,
                      smallTablet: 26,
                      tablet: 28,
                      largeTablet: 30,
                      desktop: 42,
                    ),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: getResponsiveSize(screenWidth, deviceType,
                  mobile: 12,
                  smallTablet: 14,
                  tablet: 16,
                  largeTablet: 18,
                  desktop: 20,
                )),
                Text(
                  project.subtitle,
                  style: TextStyle(
                    color: Colors.grey[300],
                    fontSize: getResponsiveSize(screenWidth, deviceType,
                      mobile: 18,
                      smallTablet: 20,
                      tablet: 22,
                      largeTablet: 24,
                      desktop: 26,
                    ),
                  ),
                ),
                SizedBox(height: getResponsiveSize(screenWidth, deviceType,
                  mobile: 12,
                  smallTablet: 14,
                  tablet: 16,
                  largeTablet: 18,
                  desktop: 20,
                )),
                Text(
                  project.description,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: getResponsiveSize(screenWidth, deviceType,
                      mobile: 14,
                      smallTablet: 12,
                      tablet: 14,
                      largeTablet: 16,
                      desktop: 22,
                    ),
                  ),
                ),
                SizedBox(height: getResponsiveSize(screenWidth, deviceType,
                  mobile: 12,
                  smallTablet: 14,
                  tablet: 16,
                  largeTablet: 18,
                  desktop: 20,
                )),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: project.technologies.map((tech) => _buildTechChip(tech, project.accentColor)).toList(),
                ),
                if (isHovered) ...[
                  const SizedBox(height: 24),
                  OutlinedButton.icon(
                    onPressed: () => _navigateToProjectDetails(context, project),
                    icon: Icon(Icons.arrow_forward, size: getResponsiveSize(screenWidth, deviceType,
                      mobile: 16,
                      smallTablet: 18,
                      tablet: 20,
                      largeTablet: 22,
                      desktop: 24,
                    )),
                    label: Text(
                      'View More',
                      style: TextStyle(
                        fontSize: getResponsiveSize(screenWidth, deviceType,
                          mobile: 12,
                          smallTablet: 14,
                          tablet: 16,
                          largeTablet: 18,
                          desktop: 20,
                        ),
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: project.accentColor,
                      side: BorderSide(color: project.accentColor),
                      padding: EdgeInsets.symmetric(
                        horizontal: getResponsiveSize(screenWidth, deviceType,
                          mobile: 16,
                          smallTablet: 18,
                          tablet: 20,
                          largeTablet: 22,
                          desktop: 24,
                        ),
                        vertical: getResponsiveSize(screenWidth, deviceType,
                          mobile: 8,
                          smallTablet: 10,
                          tablet: 12,
                          largeTablet: 14,
                          desktop: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        if (!isImageOnLeft) Expanded(
          child: _buildProjectImage(project, isHovered),
        ),
      ],
    );
  }

  Widget _buildProjectImage(Project project, bool isHovered) {
    return Container(
      constraints: const BoxConstraints.expand(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ShaderMask(
              shaderCallback: (rect) {
                return LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    project.accentColor.withOpacity(0.5),
                    Colors.transparent,
                    project.accentColor.withOpacity(0.5),
                  ],
                ).createShader(rect);
              },
              blendMode: BlendMode.darken,
              child: Image.asset(
                project.images[0],
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            if (isHovered)
              Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.0,
                    colors: [
                      project.accentColor.withOpacity(0.2),
                      project.accentColor.withOpacity(0.6),
                    ],
                  ),
                ),
              ).animate().fadeIn(),
          ],
        ),
      ),
    );
  }

  Widget _buildTechChip(String tech, Color accentColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withOpacity(0.3)),
      ),
      child: Text(
        tech,
        style: TextStyle(
          color: accentColor.withOpacity(0.9),
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _navigateToProjectDetails(BuildContext context, Project project) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ProjectDetailsScreen(
          project: project,
          imageUrl: project.images.isNotEmpty ? project.images[0] : null,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeOutExpo;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  void _handleNavigation(String route) {
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

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
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
