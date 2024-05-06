import 'package:flutter/material.dart';

class InputWithValue extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String? suffix;

  InputWithValue({required this.label, required this.controller, this.suffix});

  @override
  _InputWithValue createState() => _InputWithValue();
}

class _InputWithValue extends State<InputWithValue> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
      child:
      TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: widget.label,
          suffix: widget.suffix != null ? Text(widget.suffix!) : null
        ),

      ),
    );
  }
}