import 'package:flutter/material.dart';
import '../images/images.dart';

Widget buildDesktopLayout(BuildContext context) {
  return SizedBox(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height * 0.8,
    child: const Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 110.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: CircleAvatar(
            radius: 80,
            backgroundImage: AssetImage(Images.profilePicture),
          ),
        ),
      ],
    ),
  );
}