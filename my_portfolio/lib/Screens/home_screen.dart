import 'package:flutter/material.dart';
import '../images/images.dart';
import '../widgets/custom_widgets.dart';

class PortfolioHomePage extends StatelessWidget {
  const PortfolioHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width * 0.8,
            MediaQuery.of(context).size.height * 0.115),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.1,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                  gradient: LinearGradient(
                    colors: [Color.fromARGB(255, 33, 31, 61), Colors.purple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'AA',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            CustomTextButton(text: 'Home', onPressed: () {}),
                            CustomTextButton(text: 'About', onPressed: () {}),
                            CustomTextButton(text: 'Projects', onPressed: () {}),
                            CustomTextButton(text: 'Contact', onPressed: () {}),
                            CustomTextButton(text: 'Resume', onPressed: () {}),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: ScrollConfiguration(
        behavior: CustomScrollBehavior(),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: const Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 110.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Hi',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'I am Aqeel',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.grey ,fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    'Flutter Developer',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 30),
                                  Text(
                                    'Mobile App Developer / Ios Developer  / Web Developer ',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 10),
                                  TextButton(
                                    onPressed: null,
                                    child: Text(
                                      'See My Work.',
                                      style: TextStyle(fontSize: 14, color: Colors.blue),
                                    ),
                                  ),
                                Row(
                                  children: [
                                    TextButton(
                                      onPressed: null,
                                      child: Text('GitHub'),
                                    ),
                                    SizedBox(width: 10),
                                    TextButton(
                                      onPressed: null,
                                      child: Text('LinkedIn'),
                                    ),
                                  ],
                                ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: CircleAvatar(
                              radius: 80,
                              backgroundImage:
                                  AssetImage(Images.profilePicture),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Skills',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Chip(label: Text('Flutter')),
                    Chip(label: Text('Dart')),
                    Chip(label: Text('Firebase')),
                    Chip(label: Text('RESTful APIs')),
                    Chip(label: Text('Git')),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Projects',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const ProjectCard(
                  title: 'E-commerce App',
                  description:
                      'A fully functional e-commerce app with Firebase backend.',
                ),
                const ProjectCard(
                  title: 'Weather App',
                  description:
                      'Real-time weather app using OpenWeatherMap API.',
                ),
                const ProjectCard(
                  title: 'Task Manager',
                  description:
                      'A productivity app with local storage and notifications.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }
}
