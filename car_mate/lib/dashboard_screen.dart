
import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:convert';  // For JSON processing
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'local_adress.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreen createState() => _DashboardScreen();
}

class Expense {
  String type;
  double cost;
  DateTime date;

  Expense({required this.type, required this.cost, required this.date});
}

class ChartData {
  String x;
  double y;

  ChartData({required this.x, required this.y});
}

class DailyExpenseData {
  DateTime date;
  double totalCost;

  DailyExpenseData({required this.date, required this.totalCost});
}

class _DashboardScreen extends State<DashboardScreen> {
  List<Expense> expenses = [];
  List<DailyExpenseData> dailyData = [];
  List<ChartData> typeData = [];

  @override
  void initState() {
    super.initState();
    fetchExpenses();
  }

  Future<void> fetchExpenses() async {
    var url = 'http://$environmentIpAddress:5242/user/expenses';
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body) as List;
      setState(() {
        for (var item in jsonResponse) {
          expenses.add(Expense(
              type: item['type'],
              cost: double.parse(item['cost'].toString()),
              date: DateTime.parse(item['expense_date'])
          ));
        }
      });
    } else {
      throw Exception('Failed to load expenses from API');
    }
    processExpenses();
  }

  void processExpenses() {
    Map<DateTime, double> dailyExpenses = {};
    Map<String, double> typeExpenses = {};

    for (var expense in expenses) {
      DateTime date = DateTime(expense.date.year, expense.date.month, expense.date.day);
      dailyExpenses.update(date, (value) => value + expense.cost, ifAbsent: () => expense.cost);
      typeExpenses.update(expense.type, (value) => value + expense.cost, ifAbsent: () => expense.cost);
    }

    setState(() {
      dailyData = dailyExpenses.keys.map((date) => DailyExpenseData(date: date, totalCost: dailyExpenses[date]!)).toList();
      dailyData.sort((a, b) => a.date.compareTo(b.date)); // Ensure the data is sorted by date
      typeData = typeExpenses.entries.map((e) => ChartData(x: e.key, y: e.value)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: createLineChart()),
        Expanded(child: createPieChart()),
      ],
    );
  }
  SfCartesianChart createLineChart() {
    return SfCartesianChart(
      primaryXAxis: DateTimeAxis(
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        dateFormat: DateFormat('MM/dd'),
        intervalType: DateTimeIntervalType.days,
        interval: 30, // daily interval
      ),
      primaryYAxis: NumericAxis(
        labelFormat: '{value}',
        numberFormat: NumberFormat.simpleCurrency(decimalDigits: 2),
      ),
      title: ChartTitle(text: 'Daily Expenses'),
      series: <CartesianSeries>[
        LineSeries<DailyExpenseData, DateTime>(
          dataSource: dailyData,
          xValueMapper: (DailyExpenseData data, _) => data.date,
          yValueMapper: (DailyExpenseData data, _) => data.totalCost,
          name: 'Daily Cost',
        )
      ],
    );
  }

  SfCircularChart createPieChart() {
    return SfCircularChart(
      title: ChartTitle(text: 'Expenses by Type'),
      legend: Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
      series: <CircularSeries>[
        PieSeries<ChartData, String>(
          dataSource: typeData,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
          dataLabelSettings: DataLabelSettings(isVisible: true),
          enableTooltip: true,
        ),
      ],
    );
  }
}