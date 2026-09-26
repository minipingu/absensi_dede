import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:forui/forui.dart';

class FormAuth extends StatefulWidget {
  final bool isRegister;
  new({super.key, this.isRegister = false});

  @override
  State<FormAuth> createState() => _FormAuthState();
}

class _FormAuthState extends State<FormAuth> {
  final _key = GlobalKey<FormBuilderState>();

  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _key,
      child: Column(
        children: [
          Column(
            spacing: 10,
            children: [
              FormBuilderField(
                name: 'nama',
                builder: (FormFieldState<dynamic> field) {
                  return FTextFormField(
                    label: Text('Nama'),
                    control: .managed(initial: .empty, onChange: (value) {}),
                    hint: 'misal : Gibrun',
                    autovalidateMode: .onUserInteraction,
                    validator: (value) => (value?.contains('@') ?? false)
                        ? null
                        : 'Please enter a valid email.',
                  );
                },
              ),
              FormBuilderField(
                name: 'email',
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                    errorText: "Isi donk emailnya 😡",
                  ),
                  FormBuilderValidators.email(
                    errorText: 'yang donk bener ngisi emailnya 😤🤬',
                  ),
                ]),
                builder: (FormFieldState<dynamic> field) {
                  return FTextFormField.email(
                    control: .managed(initial: .empty, onChange: (value) {}),
                    hint: 'misal : manager@kopdes.com',
                    autovalidateMode: .onUserInteraction,
                    validator: (value) => (value?.contains('@') ?? false)
                        ? null
                        : 'Please enter a valid email.',
                  );
                },
              ),
              FormBuilderField(
                name: 'password',
                builder: (FormFieldState<dynamic> field) {
                  return FTextFormField.password(
                    hint: 'isi password',
                    autovalidateMode: .onUserInteraction,
                    validator: (value) => 8 <= (value?.length ?? 0)
                        ? null
                        : 'Password must be at least 8 characters long.',
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          SizedBox(
            width: .infinity,
            child: FButton(
              size: .sm,
              mainAxisSize: .min,
              child: Text(widget.isRegister ? 'Daftar' : 'Masuk'),
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
