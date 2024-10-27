import 'package:flutter/material.dart';
import '../images/images.dart';

Widget buildMobileLayout(BuildContext context) {
  return const Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      CircleAvatar(
        radius: 60,
        backgroundImage: AssetImage(Images.profilePicture),
      ),
      SizedBox(height: 20),
      Text(
        'John Doe',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 10),
      Text(
        'Flutter Developer',
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
      SizedBox(height: 20),
      Text(
        'About Me',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 10),
      Text(
        'I am a passionate Flutter developer with 3 years of experience in creating beautiful and functional cross-platform applications.',
        textAlign: TextAlign.center,
      ),
    ],
  );
}
