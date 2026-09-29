import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';

class CheckOutButton extends StatelessWidget {
  const new({super.key});

  void _checkOut() {}

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: .infinity,
      child: FButton(
        variant: .secondary,
        onPress: _checkOut,
        child: Text('Check In Sekarang'),
      ),
    );
  }
}
