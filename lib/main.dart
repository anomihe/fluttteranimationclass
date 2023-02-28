import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

@immutable
class Person {
  final String name;
  final int age;
  final String emoji;
  const Person({
    required this.age,
    required this.emoji,
    required this.name,
  });
}

const people = [
  Person(age: 19, emoji: 'Nm', name: 'Nmesoma'),
  Person(age: 20, emoji: 'Gl', name: 'Glory'),
  Person(age: 21, emoji: 'Fa', name: 'Favour'),
];

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
        darkTheme: ThemeData(brightness: Brightness.dark),
        themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        debugShowMaterialGrid: false,
        home: Scaffold(
            appBar: AppBar(
              title: const Text('People'),
            ),
            body: ListView.builder(
                itemCount: people.length,
                itemBuilder: (context, index) {
                  final person = people[index];
                  return ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DetailsPage(
                            person: person,
                          ),
                        ),
                      );
                    },
                    leading: Hero(
                      tag: person.emoji,
                      child: Text(
                        person.emoji,
                        style: const TextStyle(
                          fontSize: 40,
                        ),
                      ),
                    ),
                    title: Text(person.name),
                    subtitle: Text('${person.age} years old'),
                    trailing: const Icon(Icons.arrow_forward),
                  );
                })));
  }
}

class DetailsPage extends StatelessWidget {
  final Person person;
  const DetailsPage({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: person.emoji,
          flightShuttleBuilder: (
            flightContext,
            animation,
            flightDirection,
            fromHeroContext,
            toHeroContext,
          ) {
            switch (flightDirection) {
              case HeroFlightDirection.push:
                return Material(
                  color: Colors.transparent,
                  child: ScaleTransition(
                      scale: animation.drive(Tween<double>(
                        begin: 0.0,
                        end: 10.0,
                      ).chain(CurveTween(curve: Curves.fastOutSlowIn))),
                      child: toHeroContext.widget),
                );
              case HeroFlightDirection.pop:
                return Material(
                    color: Colors.transparent, child: fromHeroContext.widget);
            }
          },
          child: Text(
            person.emoji,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              person.name,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              '${person.age} years old',
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
