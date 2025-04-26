import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomDrawer extends StatelessWidget {
  final Function(String) onNavigate;

  const CustomDrawer({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: Material(
        color: Colors.transparent,
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Close button
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: () => Navigator.pop(context),
                          hoverColor: Colors.purple.withOpacity(0.2),
                          splashRadius: 24,
                        )
                            .animate()
                            .fadeIn(duration: const Duration(milliseconds: 400))
                            .scale(delay: const Duration(milliseconds: 200))
                            .slideX(
                                begin: 2,
                                end: 0,
                                duration: const Duration(milliseconds: 600)),
                      ),

                      const SizedBox(height: 100),
                      // Navigation Links
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildDrawerItem('Home     ', Icons.home,
                              () => onNavigate('/home')),
                          _buildDrawerItem('About    ', Icons.person,
                              () => onNavigate('/about')),
                          _buildDrawerItem('Projects', Icons.work,
                              () => onNavigate('/projects')),
                          _buildDrawerItem('Contact', Icons.email,
                              () => onNavigate('/contact')),
                          _buildDrawerItem('Resume', Icons.description,
                              () async {
                            const url =
                                'https://drive.google.com/file/d/1FprehvGxejg2NPpFzUei33j4DIGUo5Dz/view?usp=drive_link';
                            if (!await launchUrl(Uri.parse(url))) {
                              throw Exception('Could not launch $url');
                            }
                          }),
                        ],
                      ),
                      const SizedBox(height: 100),
                      // Social Icons
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildSocialIcon(
                                Icons.code, 'https://github.com/aqeel-102'),
                            _buildSocialIcon(Icons.work,
                                'https://www.linkedin.com/in/aqeel-ahmad-534530311'),
                            _buildSocialIcon(Icons.alternate_email,
                                'mailto:aqeelahmad.dev@gmail.com'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Footer
                      const Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Text(
                          '© 2024 Built by Aqeel Ahmad.',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            letterSpacing: 1.2,
                          ),
                        ),
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

  Widget _buildDrawerItem(String text, IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          hoverColor: Colors.purple.withOpacity(0.1),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.grey, size: 22),
                const SizedBox(width: 12),
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 22,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      )
          .animate()
          .fadeIn(duration: const Duration(milliseconds: 400))
          .slideX(duration: const Duration(milliseconds: 300)),
    );
  }

  Widget _buildSocialIcon(IconData icon, String url) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.purple.withOpacity(0.3)),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.grey, size: 22),
        onPressed: () async {
          if (!await launchUrl(Uri.parse(url))) {
            throw Exception('Could not launch $url');
          }
        },
        hoverColor: Colors.purple.withOpacity(0.2),
        splashRadius: 24,
      )
          .animate()
          .fadeIn(duration: const Duration(milliseconds: 400))
          .scale(duration: const Duration(milliseconds: 300)),
    );
  }
}
