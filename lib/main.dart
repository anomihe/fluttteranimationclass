import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const Chained());
}

enum CircleSide {
  left,
  right,
}

extension ToPath on CircleSide {
  Path toPath(Size size) {
    final path = Path();
    late Offset offset;
    late bool clockwise;
    switch (this) {
      case CircleSide.left:
        path.moveTo(size.width, 0);
        offset = Offset(size.width, size.height);
        clockwise = false;
        break;
      case CircleSide.right:
        //path.moveTo(, y)
        offset = Offset(0, size.height);
        clockwise = true;
        break;
    }
    path.arcToPoint(offset,
        radius: Radius.elliptical(
          size.width / 2,
          size.height / 2,
        ),
        clockwise: clockwise);
    path.close();
    return path;
  }
}

class HalfCircleClipper extends CustomClipper<Path> {
  final CircleSide side;
  const HalfCircleClipper({
    required this.side,
  });
  @override
  Path getClip(Size size) => side.toPath(size);
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

extension on VoidCallback {
  Future<void> delayed(Duration duration) => Future.delayed(duration, this);
}

class Chained extends StatefulWidget {
  const Chained({super.key});

  @override
  State<Chained> createState() => _ChainedState();
}

class _ChainedState extends State<Chained> with TickerProviderStateMixin {
  late AnimationController _counterClockwiseRotationController;
  late Animation<double> _counterClockwiseRotationAnimation;
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _counterClockwiseRotationController = AnimationController(
        vsync: this,
        duration: const Duration(
          seconds: 1,
        ));
    _counterClockwiseRotationAnimation = Tween<double>(
      begin: 0,
      end: -(pi / 2),
    ).animate(CurvedAnimation(
      parent: _counterClockwiseRotationController,
      curve: Curves.bounceInOut,
    ));

//flipping

    _flipController = AnimationController(
        vsync: this,
        duration: const Duration(
          seconds: 1,
        ));
    _flipAnimation = Tween<double>(
      begin: 0,
      end: pi,
    ).animate(CurvedAnimation(
      parent: _flipController,
      curve: Curves.bounceInOut,
    ));
    //status listenert

    _counterClockwiseRotationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _flipAnimation = Tween<double>(
          begin: _flipAnimation.value,
          end: _flipAnimation.value + pi,
        ).animate(
          CurvedAnimation(
            parent: _flipController,
            curve: Curves.bounceOut,
          ),
        );
        //reset the anition and start again
        _flipController
          ..reset()
          ..forward();
      }
    });
    _flipController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _counterClockwiseRotationAnimation = Tween<double>(
          begin: _counterClockwiseRotationAnimation.value,
          end: _counterClockwiseRotationAnimation.value + -(pi / 2),
        ).animate(
          CurvedAnimation(
            parent: _counterClockwiseRotationController,
            curve: Curves.bounceOut,
          ),
        );
        _counterClockwiseRotationController
          ..reset()
          ..forward();
      }
    });
  }

  @override
  void dispose() {
    _counterClockwiseRotationController.dispose();
    _flipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Future.delayed(const Duration(seconds: 1), () {
    //   _counterClockwiseRotationController
    //     ..reset()
    //     ..forward();
    // });
    _counterClockwiseRotationController
      ..reset()
      ..forward.delayed(const Duration(
        seconds: 1,
      ));
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Chained anime'),
        ),
        body: SafeArea(
          child: AnimatedBuilder(
              animation: _counterClockwiseRotationController,
              builder: (context, child) {
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..rotateZ(
                      _counterClockwiseRotationAnimation.value,
                    ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 50),
                        AnimatedBuilder(
                            animation: _flipController,
                            builder: (context, child) {
                              return Transform(
                                alignment: Alignment.centerRight,
                                transform: Matrix4.identity()
                                  ..rotateY(_flipAnimation.value),
                                child: ClipPath(
                                  clipper: const HalfCircleClipper(
                                      side: CircleSide.left),
                                  child: Container(
                                    color: const Color(0xff0057b7),
                                    height: 200,
                                    width: 200,
                                  ),
                                ),
                              );
                            }),
                        AnimatedBuilder(
                            animation: _flipAnimation,
                            builder: (context, child) {
                              return Transform(
                                alignment: Alignment.centerLeft,
                                transform: Matrix4.identity()
                                  ..rotateY(_flipAnimation.value),
                                child: ClipPath(
                                  clipper: const HalfCircleClipper(
                                      side: CircleSide.right),
                                  child: Container(
                                    color: const Color(0xffffd700),
                                    height: 200,
                                    width: 200,
                                  ),
                                ),
                              );
                            }),
                      ]),
                );
              }),
        ),
      ),
    );
  }
}
