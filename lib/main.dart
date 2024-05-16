
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Categories.dart';
import 'auth/login.dart';
import 'auth/register.dart';
import '/Home.dart';
import 'models/TaskModel.dart';
import 'models/CategoryModel.dart';
void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseOptions fireBaseOptions=const FirebaseOptions(appId:"1:587110936641:android:1df0ef40a5171224c616c0",
      apiKey:"AIzaSyDz_1IuHNX4VqZCygx2Ed8wNBqMjMtttBk",
      projectId:"task-management-a45b8",
      messagingSenderId:"587110936641",
      storageBucket:'task-management-a45b8.appspot.com');
  await Firebase.initializeApp(options:fireBaseOptions

  );


  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => taskProvider()),
          ChangeNotifierProvider(create: (context) => CategoryProvider()),
        ],

        child: const MyApp(),
      )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print(
            '================================== User is currently signed out!');
      } else {
        print('================================== User is signed in!');
      }
    });

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
          primaryColor: Colors.cyan, // Set primary color to turquoise
      ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: FirebaseAuth.instance.currentUser != null ? const Homepage() : const Login(),
      routes: {
        "signup": (context) => const SignUp(),
        "login": (context) => const Login(),
        "home": (context) => const Homepage(),
        "Categories": (context) => const Categories(),
      },
    );
  }
}
