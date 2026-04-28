import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'state/aura_bloc.dart';
import 'ui/checkin_screen.dart';

void main() {
  runApp(const AuraApp());
}

class AuraApp extends StatelessWidget {
  const AuraApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aura Caregiver System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Inter', // Assuming Inter font is added in pubspec.yaml
      ),
      home: BlocProvider(
        create: (context) => AuraBloc(),
        child: Scaffold(
          body: CheckInScreen(),
        ),
      ),
    );
  }
}
