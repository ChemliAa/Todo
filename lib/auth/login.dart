import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/CustomButtonAuth‎.dart';
import '../components/CustomLogoAuth.dart';
import '../components/CustomTextForm.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                const CustomLogoAuth(),
                const SizedBox(height: 20),
                const Text(
                  "Login",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Login To Continue Using The App",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Email",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                CustomTextForm(
                  hinttext: "Enter Your Email",
                  mycontroller: emailController,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Password",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                CustomTextForm(
                  hinttext: "Enter Your Password",
                  mycontroller: passwordController,
                ),
              ],
            ),
            const SizedBox(height: 20),
            CustomButtonAuth(
              title: "Login",
              onPressed: () async {
                try {
                  final credential =
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: emailController.text,
                    password: passwordController.text,
                  );
                  final User? user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    final CollectionReference users =
                    FirebaseFirestore.instance.collection('users');
                    final DocumentSnapshot userDoc =
                    await users.where('email', isEqualTo: user.email).get().then((querySnapshot) {
                      return querySnapshot.docs.first;
                    });

                    final Map<String, dynamic> userData =
                    userDoc.data() as Map<String, dynamic>;
                    final String? username = userData['username'];
                    if (username != null) {
                      user.updateDisplayName(username);
                    }
                  }
                  Navigator.of(context).pushReplacementNamed("home");
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Wrong credentials'),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                Navigator.of(context).pushReplacementNamed("signup");
              },
              child: Center(
                child: RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: "Don't Have An Account ? ",
                      ),
                      TextSpan(
                        text: "Register",
                        style: const TextStyle(
                          color: Colors.purple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
