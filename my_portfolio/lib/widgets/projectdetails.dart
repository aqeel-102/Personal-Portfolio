import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:my_portfolio/Screens/home_screen.dart' as home;
import '../appbar_screens/projects.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final Project project;
  final String? imageUrl;

  const ProjectDetailsScreen({
    super.key,
    required this.project,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final deviceType = home.getDeviceType(screenSize.width);
    
    return RepaintBoundary(
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A1A),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, 
              color: Colors.white.withOpacity(0.9),
              size: 22,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Hero Image with Parallax Effect
            SliverAppBar(
              expandedHeight: home.getResponsiveSize(
                screenSize.width,
                deviceType,
                mobile: screenSize.height * 0.5,
                smallTablet: screenSize.height * 0.6,
                tablet: screenSize.height * 0.7,
                largeTablet: screenSize.height * 0.8,
                desktop: screenSize.height * 0.9,
              ),
              stretch: true,
              pinned: true,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const [
                  StretchMode.zoomBackground,
                  StretchMode.blurBackground,
                ],
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Hero(
                      tag: project.title,
                      child: Image.asset(
                        imageUrl ?? project.images[0],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          print('Error loading image: $error');
                          return Container(
                            color: Colors.grey[900],
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error_outline_rounded,
                                    color: Colors.white.withOpacity(0.6),
                                    size: 48,
                                  ),
                                  const SizedBox(height: 16),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: Text(
                                      'Failed to load image\nPath: ${imageUrl ?? project.images[0]}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.6),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                          if (wasSynchronouslyLoaded) return child;
                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: frame != null
                                ? child
                                : Container(
                                    color: Colors.grey[900],
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: project.accentColor,
                                        strokeWidth: 3,
                                      ),
                                    ),
                                  ),
                          );
                        },
                      ),
                    ),
                    // Gradient Overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.3),
                            const Color(0xFF0A0A1A).withOpacity(0.9),
                          ],
                          stops: const [0.3, 0.7, 1.0],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Project Details Section
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.title,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.95),
                        fontSize: deviceType == home.DeviceType.mobile ? 36 : 52,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -1,
                      ),
                    ).animate()
                      .fadeIn()
                      .slideX(begin: -0.2, end: 0, curve: Curves.easeOutQuart),

                    const SizedBox(height: 12),

                    Text(
                      project.subtitle,
                      style: TextStyle(
                        color: project.accentColor.withOpacity(0.9),
                        fontSize: deviceType == home.DeviceType.mobile ? 20 : 26,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ).animate()
                      .fadeIn(delay: const Duration(milliseconds: 200))
                      .slideX(begin: -0.2, end: 0, curve: Curves.easeOutQuart),

                    const SizedBox(height: 40),

                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: project.technologies.map((tech) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: project.accentColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: project.accentColor.withOpacity(0.3),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: project.accentColor.withOpacity(0.15),
                                blurRadius: 20,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Text(
                            tech,
                            style: TextStyle(
                              color: project.accentColor.withOpacity(0.95),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ).animate()
                          .fadeIn(
                            delay: Duration(
                              milliseconds: 400 + project.technologies.indexOf(tech) * 100,
                            ),
                          )
                          .scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOutBack);
                      }).toList(),
                    ),

                    const SizedBox(height: 48),

                    Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Text(
                        project.description,
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: deviceType == home.DeviceType.mobile ? 16 : 18,
                          height: 1.8,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ).animate()
                      .fadeIn(delay: const Duration(milliseconds: 600))
                      .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuart),

                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),

            // Project Gallery Section
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, // Changed to center
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center, // Added center alignment
                      children: [
                        Icon(
                          Icons.photo_library_rounded,
                          color: project.accentColor,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          "Project Gallery",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ).animate()
                      .fadeIn()
                      .slideX(begin: -0.2, end: 0),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 800,
                        ),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: deviceType == home.DeviceType.mobile ? 1 : 2,
                            crossAxisSpacing: 150, // Increased from 15 to 30
                            mainAxisSpacing: 50,
                            childAspectRatio: 2.5 / 5,
                          ),
                          itemCount: project.images.length - 1,
                          itemBuilder: (context, index) {
                            final imageIndex = index + 1; // Skip first image by adding 1 to index
                            return GestureDetector(
                              onTap: () => _showFullScreenImage(context, project.images[imageIndex]),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[900],
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: project.accentColor.withOpacity(0.2),
                                      blurRadius: 30,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Image.asset(
                                  project.images[imageIndex],
                                  fit: BoxFit.fill,
                                  errorBuilder: (context, error, stackTrace) {
                                    
                                    return Container(
                                      color: Colors.grey[900],
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(
                                            Icons.error_outline_rounded,
                                            color: Colors.white.withOpacity(0.6),
                                            size: 48,
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'Failed to load image: ${project.images[imageIndex]}',
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(0.6),
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ).animate()
                              .fadeIn(delay: Duration(milliseconds: index * 200))
                              .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuart);
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            fit: StackFit.expand,
            children: [
              InteractiveViewer(
                minScale: 0.5,
                maxScale: 3.0,
                child: Center(
                  child: Image.asset(
                    imageUrl,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Positioned(
                top: 40,
                left: 20,
                child: IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}