import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:my_portfolio/Screens/home_screen.dart';
import 'package:my_portfolio/appbar_screens/drawer.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? textColor;
  final double fontSize;
  final FontWeight fontWeight;

  const CustomTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.textColor,
    this.fontSize = 16.0,
    this.fontWeight = FontWeight.normal,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final responsiveFontSize = screenWidth < 800 ? 14.0 : fontSize;

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth < 800 ? 8 : 16,
          vertical: 8
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor ?? Theme.of(context).primaryColor,
          fontSize: responsiveFontSize,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}


// ProjectCard

class ProjectCard extends StatelessWidget {
  final String title;
  final String description;

  const ProjectCard({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(description),
          ],
        ),
      ),
    );
  }
}




class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final DeviceType deviceType;
  final double screenWidth;
  final double contentPadding;
  final Function(String) onNavigate;
  final Function(String) onLaunchURL;

  const CustomAppBar({
    super.key,
    required this.deviceType,
    required this.screenWidth,
    required this.contentPadding,
    required this.onNavigate,
    required this.onLaunchURL,
  });

  bool get isMobile => deviceType == DeviceType.mobile;

  @override
  Size get preferredSize => Size.fromHeight(isMobile ? 60 : 80);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const SizedBox.shrink(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      flexibleSpace: SafeArea(
        child: Center(
          child: Container(
            width: screenWidth * (isMobile ? 0.95 : 0.8),
            height: isMobile ? 50 : 60,
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(40)),
              gradient: const LinearGradient(
                colors: [Color(0xFF211F3D), Colors.purple],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: contentPadding * 0.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => onNavigate('/home'),
                      child: Text(
                        'AA',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()
                            ..shader = const LinearGradient(
                              colors: [Colors.white, Colors.purple],
                            ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                        ),
                      ).animate()
                        .fadeIn(duration: const Duration(milliseconds: 800))
                        .scale(delay: const Duration(milliseconds: 300)),
                    ),
                  ),
                  if (!isMobile)
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomTextButton(
                            text: 'Home',
                            onPressed: () => onNavigate('/home')
                          ).animate()
                            .fadeIn(delay: const Duration(milliseconds: 200)),
                          SizedBox(width: screenWidth < 850 ? 10 : 20),
                          CustomTextButton(
                            text: 'About',
                            onPressed: () => onNavigate('/about')
                          ).animate()
                            .fadeIn(delay: const Duration(milliseconds: 400)),
                          SizedBox(width: screenWidth < 850 ? 10 : 20),
                          CustomTextButton(
                            text: 'Projects',
                            onPressed: () => onNavigate('/projects')
                          ).animate()
                            .fadeIn(delay: const Duration(milliseconds: 600)),
                          SizedBox(width: screenWidth < 850 ? 10 : 20),
                          CustomTextButton(
                            text: 'Contact',
                            onPressed: () => onNavigate('/contact')
                          ).animate()
                            .fadeIn(delay: const Duration(milliseconds: 800)),
                          SizedBox(width: screenWidth < 850 ? 10 : 20),
                          CustomTextButton(
                            text: 'Resume',
                            onPressed: () => onLaunchURL('https://drive.google.com/file/d/12sKIQEJNvgieQCQ5C9La_6MS8uDFythk/view?usp=sharing'),
                          ).animate()
                            .fadeIn(delay: const Duration(milliseconds: 1000)),
                        ],
                      ),
                    )
                  else
                    IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CustomDrawer(onNavigate: onNavigate)));
                      },
                    ).animate()
                      .fadeIn()
                      .scale(delay: const Duration(milliseconds: 300)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
