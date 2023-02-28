import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      home: const MyAnimated(),
    );
  }
}

class CircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width / 2,
    );
    path.addOval(
      rect,
    );
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

Color getRandomColor() => Color(
      0xFF000000 + math.Random().nextInt(0x00FFFFFF),
    );

class MyAnimated extends StatefulWidget {
  const MyAnimated({super.key});

  @override
  State<MyAnimated> createState() => _MyAnimatedState();
}

class _MyAnimatedState extends State<MyAnimated> {
  var _color = getRandomColor();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ClipPath(
        clipper: CircleClipper(),
        child: TweenAnimationBuilder(
          tween: ColorTween(
            begin: getRandomColor(),
            end: _color,
          ),
          onEnd: () {
            setState(() {
              _color = getRandomColor();
            });
          },
          builder: (BuildContext context, Color? color, Widget? child) {
            return ColorFiltered(
              colorFilter: ColorFilter.mode(color!, BlendMode.srcATop),
              child: child,
            );
          },
          duration: const Duration(seconds: 1),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            color: Colors.red,
          ),
        ),
      )),
    );
  }
}
