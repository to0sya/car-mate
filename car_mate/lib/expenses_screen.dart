import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';

import 'local_adress.dart';
import 'package:http/http.dart' as http;

import 'exprenses_list.dart';
import 'local_adress.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  _ExpensesScreen createState() {
    return _ExpensesScreen();
  }
}

class _ExpensesScreen extends State<ExpensesScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _type = 'Fuel';
  String _cost = '';
  DateTime _dateTime = DateTime.now();

  void _openForm() {
    showModalBottomSheet(context: context, builder: (BuildContext context) {
      return SingleChildScrollView(
        child: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  DropdownButtonFormField<String>(
                    value: _type,
                    onChanged: (String? newValue) {
                      setState(() {
                        _type = newValue!;
                      });
                    },
                    items: <String>['Fuel', 'Service', 'Parking', 'Washing']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      labelText: 'Type',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(

                    decoration: const InputDecoration(
                        labelText: 'Cost',
                    ),
                    keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter cost';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _cost = value!;
                    },
                  ),
                  SizedBox(
                    height: 200,
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      initialDateTime: DateTime.now(),
                      onDateTimeChanged: (DateTime newDateTime) {
                        _dateTime = newDateTime;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        Navigator.pop(context);
                        _postDataToServer();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero
                        ),
                        backgroundColor: Colors.black
                    ),
                    child: const Text(
                        'Add',
                        style: TextStyle(color: Colors.white)
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  void _postDataToServer() async {
    // Prepare data to send
    Map<String, dynamic> data = {
      'type': _type,
      'cost': _cost,
      'date': _dateTime.toIso8601String()
    };

    String jsonData = jsonEncode(data);

    // Send HTTP POST request to server
    Uri url = Uri.parse('http://$environmentIpAddress:5242/user/expenses' + '?type=${Uri.encodeComponent(_type)}&cost=${Uri.encodeComponent(_cost)}&date=${Uri.encodeComponent(_dateTime.toIso8601String())}');
    http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    // Check the response from the server
    if (response.statusCode == 200) {
      // Data posted successfully
      print('Data posted successfully');
    } else {
      // Data posting failed
      print('Failed to post data: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: ExpensesList(),
      ),
      floatingActionButton:
      FloatingActionButton(onPressed: _openForm,
        shape: const CircleBorder(),
        backgroundColor: Colors.white,
        child: const Text("+",
        style: TextStyle(
        fontFamily: 'AudiWideNormal',
        fontSize: 30,
            color: Colors.black)
        ),
        ),
    );
  }
}