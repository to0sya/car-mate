
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';

import 'local_adress.dart';
import 'package:http/http.dart' as http;


class ExpensesList extends StatefulWidget {
  const ExpensesList({super.key});

  @override
  _ExpensesList createState() {
    return _ExpensesList();
  }
}

class _ExpensesList extends State<ExpensesList> {
  List<Map<String, dynamic>> expenses = [];

  var sortBy = 'newest_date';

  @override
  void initState() {
    super.initState();
    fetchExpenses();
  }

  void sortExpenses(String sortBy) {
    if (sortBy == 'lowest_cost') {
      expenses.sort((a, b) => (double.parse(a['cost']) as double).compareTo(double.parse(b['cost']) as double));
    } else if (sortBy == 'newest_date') {
      expenses.sort((a, b) => b['date'].compareTo(a['date']));
    }  else if (sortBy == 'highest_cost') {
      expenses.sort((a, b) => (double.parse(b['cost']) as double).compareTo(double.parse(a['cost']) as double));
    } else if (sortBy == 'latest_date') {
      expenses.sort((a, b) => a['date'].compareTo(b['date']));
    }
  }

  Future<void> fetchExpenses() async {
    var url = 'http://$environmentIpAddress:5242/user/expenses';
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body) as List;
      setState(() {
        expenses = jsonResponse.map((item) => {
          'type': item['type'],
          'cost': item['cost'].toString(),
          'date': DateTime.parse(item['expense_date']).toString().substring(0,10)
        }).toList();
      });
    } else {
      throw Exception('Failed to load expenses from API');
    }
  }

  String getIconPath(String type) {
    switch (type) {
      case 'Fuel':
        return 'assets/icons/fuel.svg';
      case 'Service':
        return 'assets/icons/service.svg';
      case 'Parking':
        return 'assets/icons/parking.svg';
      case 'Washing':
        return 'assets/icons/washing.svg';
      default:
        return 'assets/icons/default.svg'; // A default icon if type is not matched
    }
  }

  final Map<String, String> dropdownItems = {
    'Latest Date': 'latest_date',
    'Newest Date': 'newest_date',
    'Lowest Cost': 'lowest_cost',
    'Highest Cost': 'highest_cost'
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        DropdownButton<String>(
                          value: sortBy,
                          onChanged: (String? newValue) {
                            setState(() {
                              sortBy = newValue!;
                              sortExpenses(newValue);
                            });
                          },
                          items: dropdownItems.entries.map<DropdownMenuItem<String>>((MapEntry<String, String> entry) {
                            return DropdownMenuItem<String>(
                              value: entry.value,
                              child: Text(entry.key),
                            );
                          }).toList(),

                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                              decoration: const BoxDecoration(
                                  border: Border.symmetric(
                                      horizontal: BorderSide(
                                          color: Colors.black
                                      )
                                  ),
                              ),
                              child: const Text(
                                'Type',
                                style: TextStyle(
                                    fontFamily: 'AudiWideBold',
                                    fontSize: 24
                                ),
                              ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                        Expanded(
                          flex: 2,
                          child: Container(
                              decoration: const BoxDecoration(
                                  border: Border.symmetric(
                                      horizontal: BorderSide(
                                          color: Colors.black
                                      )
                                  )
                              ),
                              child: const Text(
                                'Cost',
                                style: TextStyle(
                                    fontFamily: 'AudiWideBold',
                                    fontSize: 24
                                ),
                              )
                          ),
                        ),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                        Expanded(
                          flex: 3,
                          child: Container(
                              decoration: const BoxDecoration(
                                  border: Border.symmetric(
                                      horizontal: BorderSide(
                                          color: Colors.black
                                      )
                                  )
                              ),
                              child: const Text(
                                'Date',
                                style: TextStyle(
                                    fontFamily: 'AudiWideBold',
                                    fontSize: 24
                                ),
                              )
                          ),
                        ),
                      ],
                    ),
                    ...expenses.map((expense) {
                      return Padding(padding: EdgeInsets.symmetric(vertical: 5), child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                                decoration: const BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.black)),
                                ),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      getIconPath(expense['type']),
                                      height: 30,
                                      width: 30,
                                    ),
                                    Padding(padding: EdgeInsets.only(left: 4.0),),
                                    Text(
                                      expense['type'],
                                      style: TextStyle(fontFamily: 'AudiWideNormal', fontSize: 16),
                                    ),
                                  ],
                                )
                            ),
                          ),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                          Expanded(
                            flex: 2,
                            child: Container(
                              decoration: const BoxDecoration(
                                border: Border(bottom: BorderSide(color: Colors.black)),
                              ),
                              child: Text(
                                expense['cost'],
                                style: TextStyle(fontFamily: 'AudiWideNormal', fontSize: 20),
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                          Expanded(
                            flex: 3,
                            child: Container(
                              decoration: const BoxDecoration(

                                border: Border(bottom: BorderSide(color: Colors.black)),
                              ),
                              child: Text(
                                expense['date'],
                                style: TextStyle(fontFamily: 'AudiWideNormal', fontSize: 19),
                              ),
                            ),
                          ),
                        ],
                      ));
                    }),
                    Padding(padding: EdgeInsets.symmetric(vertical: 30))
                  ],

                )
            )

    );

  }
}