import 'dart:developer' as developer;

import 'package:absensi_dede/absensi/models/login_model.dart';
import 'package:absensi_dede/absensi/models/register_model.dart';
import 'package:absensi_dede/absensi/router/routes.dart';
import 'package:absensi_dede/absensi/services/login_preferences.dart';
import 'package:absensi_dede/controllers/login_user.dart';
import 'package:absensi_dede/controllers/register_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:forui/forui.dart';

class FormAuth extends ConsumerStatefulWidget {
  final bool isRegister;
  const FormAuth({super.key, this.isRegister = false});

  @override
  ConsumerState<FormAuth> createState() => _FormAuthState();
}

class _FormAuthState extends ConsumerState<FormAuth> {
  final _key = GlobalKey<FormBuilderState>();

  String? _name;
  String? _email;
  String? _password;

  @override
  Widget build(BuildContext context) {
    ref.listen(registerUserProvider, (previous, next) {
      next.whenOrNull(
        data: (response) {
          if (response == null) return;
          showFToast(
            context: context,
            duration: const Duration(seconds: 4),
            title: const Text('Registrasi Berhasil!'),
            description: Text(
              response.message ?? 'Akun berhasil dibuat, silakan masuk.',
            ),
            icon: const Icon(Icons.check_circle_outline, color: Colors.green),
          );
        },
        error: (error, _) {
          showFToast(
            context: context,
            duration: const Duration(seconds: 4),
            title: const Text('Registrasi Gagal'),
            description: Text(error.toString()),
            icon: const Icon(Icons.error_outline, color: Colors.red),
          );
        },
      );
    });

    ref.listen(loginUserProvider, (previous, next) {
      next.whenOrNull(
        data: (response) async {
          if (response == null) return;
          showFToast(
            context: context,
            duration: const Duration(seconds: 4),
            title: const Text('Login Berhasil!'),
            description: Text(response.message ?? 'Langsung terbang ke home'),
            icon: const Icon(Icons.check_circle_outline, color: Colors.green),
          );

          await LoginPreferences.saveLoginResponse(response);

          if (context.mounted) {
            HomeRoute().go(context);
          }
        },
        error: (error, _) {
          showFToast(
            context: context,
            duration: const Duration(seconds: 4),
            title: const Text('Login Gagal'),
            description: Text(error.toString()),
            icon: const Icon(Icons.error_outline, color: Colors.red),
          );
        },
      );
    });

    final registerState = ref.watch(registerUserProvider);
    final loginState = ref.watch(loginUserProvider);
    final isLoading = widget.isRegister
        ? registerState.isLoading
        : loginState.isLoading;

    return FormBuilder(
      key: _key,
      child: Column(
        children: [
          Column(
            spacing: 10,
            children: [
              if (widget.isRegister)
                FormBuilderField<String>(
                  name: 'nama',
                  onChanged: (value) => setState(() {
                    _name = value;
                  }),
                  valueTransformer: (text) =>
                      text?.trim().replaceAll(RegExp(r'\s+'), ' '),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                      errorText: 'Nama wajib diisi',
                    ),
                    FormBuilderValidators.minLength(
                      3,
                      errorText: 'Minimal 3 karakter',
                    ),
                    FormBuilderValidators.alphabetical(
                      regex: RegExp(r'^[a-zA-Z ]+$'),
                      errorText: 'Hanya boleh huruf alfabet',
                    ),
                  ]),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  builder: (FormFieldState<String> field) {
                    return FTextFormField(
                      label: const Text('Nama'),
                      hint: 'misal : Gibrun',
                      control: FTextFieldControl.managed(
                        initial: TextEditingValue(text: field.value ?? ''),
                        onChange: (value) => field.didChange(value.text),
                      ),
                      forceErrorText: field.errorText,
                    );
                  },
                ),
              FormBuilderField<String>(
                name: 'email',
                onChanged: (value) => setState(() {
                  _email = value;
                }),
                valueTransformer: (text) =>
                    text?.trim().replaceAll(RegExp(r'\s+'), ' '),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                    errorText: 'Email wajib diisi',
                  ),
                  FormBuilderValidators.email(
                    errorText: 'Yang bener donk ngisi emailnya 🤬',
                  ),
                ]),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                builder: (FormFieldState<String> field) {
                  return FTextFormField.email(
                    label: const Text('Email'),
                    hint: 'misal : manager@kopdes.go.id',
                    control: FTextFieldControl.managed(
                      initial: TextEditingValue(text: field.value ?? ''),
                      onChange: (value) => field.didChange(value.text),
                    ),
                    forceErrorText: field.errorText,
                  );
                },
              ),
              FormBuilderField<String>(
                name: 'password',
                onChanged: (value) => setState(() {
                  _password = value;
                }),
                validator: widget.isRegister
                    ? FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          errorText: "Isi donk passwordnya 😡",
                        ),
                        FormBuilderValidators.minLength(
                          8,
                          errorText: 'minimal 8 karakter 😤',
                        ),
                        FormBuilderValidators.hasLowercaseChars(
                          atLeast: 1,
                          errorText: 'minimal ada 1 huruf kecil 😤',
                        ),
                        FormBuilderValidators.hasNumericChars(
                          atLeast: 1,
                          errorText: 'minimal ada 1 angka 😤',
                        ),
                        FormBuilderValidators.hasSpecialChars(
                          atLeast: 1,
                          errorText: 'minimal ada 1 simbol 😤',
                        ),
                        FormBuilderValidators.hasUppercaseChars(
                          atLeast: 1,
                          errorText: 'minimal ada 1 huruf besar 😤',
                        ),
                      ])
                    : FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          errorText: "Isi donk passwordnya 😡",
                        ),
                      ]),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                builder: (FormFieldState<String> field) {
                  return FTextFormField.password(
                    label: const Text('Password'),
                    hint: 'isi password',
                    control: FTextFieldControl.managed(
                      initial: TextEditingValue(text: field.value ?? ''),
                      onChange: (value) => field.didChange(value.text),
                    ),
                    forceErrorText: field.errorText,
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FButton(
              size: .sm,
              mainAxisSize: .min,
              onPress: isLoading
                  ? null
                  : () {
                      if (_key.currentState?.saveAndValidate() ?? false) {
                        final values = _key.currentState!.value;
                        final email =
                            (values['email'] ?? _email)?.toString().trim() ??
                            '';
                        final password =
                            (values['password'] ?? _password)
                                ?.toString()
                                .trim() ??
                            '';

                        if (widget.isRegister) {
                          final name =
                              (values['nama'] ?? _name)?.toString().trim() ??
                              '';
                          final signUpRequest = RegisterRequest(
                            name: name,
                            email: email,
                            password: password,
                          );

                          ref
                              .read(registerUserProvider.notifier)
                              .register(signUpRequest);
                        } else {
                          final loginRequest = LoginRequest(
                            email: email,
                            password: password,
                          );

                          developer.log(
                            'Submitting login: ${loginRequest.email}',
                          );

                          ref
                              .read(loginUserProvider.notifier)
                              .login(loginRequest);
                        }
                      }
                    },
              child: Text(widget.isRegister ? 'Daftar' : 'Masuk'),
            ),
          ),
        ],
      ),
    );
  }
}
