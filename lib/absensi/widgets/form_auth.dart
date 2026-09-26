import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class FormAuth extends StatefulWidget {
  const new({super.key});

  @override
  State<FormAuth> createState() => _FormAuthState();
}

class _FormAuthState extends State<FormAuth> {
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      child: Column(
        children: [
          FTextFormField.email(
            hint: 'misal : manager@kopdes.com',
            autovalidateMode: .onUserInteraction,
            validator: (value) => (value?.contains('@') ?? false)
                ? null
                : 'Please enter a valid email.',
          ),
          const SizedBox(height: 10),
          FTextFormField.password(
            hint: 'misal : isi password',
            autovalidateMode: .onUserInteraction,
            validator: (value) => 8 <= (value?.length ?? 0)
                ? null
                : 'Password must be at least 8 characters long.',
          ),
          SizedBox(height: 20),
          SizedBox(
            width: .infinity,
            child: FButton(
              size: .sm,
              mainAxisSize: .min,
              child: const Text('Login'),
              onPress: () {
                if (_key.currentState!.validate()) {
                  // Form is valid, do something.
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
