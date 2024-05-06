import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/logo.svg',
                  height: 100,
                  width: 100,
                ),
                const SizedBox(width: 16.0),
                const Text(
                  'CarMate',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 100.0),
            const Padding(
              padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
              child:
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
              child:
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
              ),
            ),

            const SizedBox(height: 8.0),
            TextButton(
              onPressed: () {
              },
              child: const Text('Forgot Password?'),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: 140,
              height: 35,
              child: ElevatedButton(

                onPressed: () {

                  Navigator.pushNamed(context, '/home');
                },
                style: ElevatedButton.styleFrom(

                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero
                    ),
                    backgroundColor: Colors.black
                ),
                child:
                const Text(
                    'Log in',
                    style: TextStyle(color: Colors.white)
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text('Or sign in using:'),
            const SizedBox(height: 8.0),
            /* OutlinedButton.icon(
              onPressed: () {
              },
              icon: const Icon(Icons.),
              label: const Text('Google'),
            ),*/
            const SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
              },
              child: const Text("Don't have an account yet? Sign up."),
            ),
          ],
        ),
      ),
    );
  }
}