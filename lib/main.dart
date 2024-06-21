import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:toDo_brainwave/firebase_options.dart';

import 'package:toDo_brainwave/pages/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainScreen());
}
