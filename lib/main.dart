import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_todo/providers/task_provider.dart';
import 'package:provider/provider.dart';
import 'Screens/home_screen.dart';
import 'Screens/login_screen.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()..loadTasks()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'To-Do App',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.system,
        home: Consumer<AuthProvider>(
          builder: (context, auth, _) =>
          auth.isAuthenticated ? const HomeScreen() : const LoginScreen(),
        ),
      ),
    );
  }
}
