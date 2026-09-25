import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext _) => Form(
    key: _key,
    child: Column(
      mainAxisAlignment: .center,
      children: [
        FTextFormField.email(
          hint: 'janedoe@foruslabs.com',
          autovalidateMode: .onUserInteraction,
          validator: (value) => (value?.contains('@') ?? false)
              ? null
              : 'Please enter a valid email.',
        ),
        const SizedBox(height: 10),
        FTextFormField.password(
          autovalidateMode: .onUserInteraction,
          validator: (value) => 8 <= (value?.length ?? 0)
              ? null
              : 'Password must be at least 8 characters long.',
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: .end,
          children: [
            FButton(
              size: .sm,
              mainAxisSize: .min,
              child: const Text('Login'),
              onPress: () {
                if (_key.currentState!.validate()) {
                  // Form is valid, do something.
                }
              },
            ),
          ],
        ),
      ],
    ),
  );
}
