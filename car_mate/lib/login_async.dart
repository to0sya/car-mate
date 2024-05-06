import 'dart:convert';
import 'package:flutter/material.dart';

import 'local_adress.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> _login() async {
    setState(() {
      isLoading = true;
    });

    final String username = usernameController.text;
    final String password = passwordController.text;

    var query = {
      'login': username,
      'password': password
    };

    // Send login request to backend
    final response = await http.get(
      Uri.parse('http://$getIpAdress:5242/user/login').replace(queryParameters: query)
    );

    if (response.statusCode == 200) {
      Navigator.pushNamed(context, '/home');
    } else {
      // Login failed
      // Show error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Login Failed'),
            content: Text('Invalid username or password.'),
            actions: <Widget>[
              ElevatedButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                child: TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                  ),
                ),
              ),
              Padding(padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                ),),
              SizedBox(height: 20),
              SizedBox(
                width: 140,
                height: 35,
                child: ElevatedButton(
                  onPressed: _login,
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
              const SizedBox(height: 100.0),
            ],
          ),
        ),
      )
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LoginScreen(),
  ));
}
