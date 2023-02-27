import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const Anime());
}

class Anime extends StatefulWidget {
  const Anime({super.key});

  @override
  State<Anime> createState() => _AnimeState();
}

class _AnimeState extends State<Anime> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 2 * pi,
    ).animate(
      controller,
    );
    controller.repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('First Animation'),
        ),
        body: Center(
          child: AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..rotateY(_animation.value),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.red,
                              spreadRadius: 8,
                              blurRadius: 8,
                              offset: Offset(0, 3))
                        ]),
                  ),
                );
              }),
        ),
      ),
    );
  }
}



//animationcontroller is an object that  allows one to control the changes in double value which is between 0 and 1 
 /*
 what animation controller does 
 0.0 =0 degress 
 0-5 = 180 degress 
 1.0 = 360 degress 
 animation ties itself to animation controller so that if the animationcontroller 
 changes it does the same
 */
