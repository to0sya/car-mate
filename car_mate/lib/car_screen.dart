import 'package:flutter/material.dart';
import 'custom_input.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CarScreen extends StatefulWidget {
  const CarScreen({super.key});

  @override
  _CarScreen createState() {
    return _CarScreen();
  }
}


class _CarScreen extends State<CarScreen> {
  final TextEditingController _mileage = TextEditingController();
  final TextEditingController _nextService = TextEditingController();
  final TextEditingController _fuelConsumption = TextEditingController();
  final TextEditingController _moneySpent = TextEditingController();
  final TextEditingController _insuranceExpire = TextEditingController();

  @override
  void initState() {
    super.initState();

    _mileage.text = '241534';
    _nextService.text = '4234';
    _fuelConsumption.text = '10.7';
    _moneySpent.text = "422";
    _insuranceExpire.text = "22.12.2024";

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 20.0),
                Image.asset(
                  'assets/images/car.JPG',
                  fit: BoxFit.cover,
                  width: 320,
                  height: 200,
                ),

                InputWithValue(label: 'Current mileage', controller: _mileage),
                InputWithValue(label: 'Next service in', controller: _nextService),
                InputWithValue(label: 'Fuel consumption', controller: _fuelConsumption, suffix: ' l/100km',),
                InputWithValue(label: 'Money spent (this month)', controller: _moneySpent),
                InputWithValue(label: 'Insurance expires on', controller: _insuranceExpire),
              ]),
        )
    );
  }
}