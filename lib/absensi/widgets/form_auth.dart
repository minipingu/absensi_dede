import 'package:absensi_dede/absensi/models/register_model.dart';
import 'package:absensi_dede/absensi/services/api_services.dart';
import 'package:absensi_dede/absensi/services/dio_client.dart';
import 'package:absensi_dede/controller/register_user.dart';
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

  late final ApiServices _apiServices;

  @override
  void initState() {
    super.initState();
    final dio = createDioClient();
    _apiServices = ApiServices(dio);
  }

  @override
  Widget build(BuildContext context) {
    // 1. Tangani efek samping (Success / Error) dengan ref.listen
    ref.listen<AsyncValue<void>>(registerUserProvider, (previous, next) {
      next.whenOrNull(
        data: (_) {
          showFToast(
            context: context,
            title: const Text('Registrasi Berhasil!'),
            description: const Text('Akun berhasil dibuat, silakan masuk.'),
            icon: const Icon(Icons.check_circle_outline, color: Colors.green),
          );
          // Navigasi ke halaman login / beranda jika diperlukan
        },
        error: (error, _) {
          showFToast(
            context: context,
            title: const Text('Registrasi Gagal'),
            description: Text(error.toString()),
            icon: const Icon(Icons.error_outline, color: Colors.red),
          );
        },
      );
    });

    // 2. Pantau status loading untuk menonaktifkan tombol atau menampilkan indikator
    final registerState = ref.watch(registerUserProvider);
    final isLoading = registerState.isLoading;

    return FormBuilder(
      key: _key,
      child: Column(
        children: [
          Column(
            spacing: 10,
            children: [
              if (widget.isRegister)
                FormBuilderField<String>(
                  onChanged: (value) => setState(() {
                    _name = value;
                  }),
                  name: 'nama',
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
                onChanged: (value) => setState(() {
                  _email = value;
                }),
                name: 'nama',
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
                onChanged: (value) => setState(() {
                  _password = value;
                }),
                name: 'password',
                validator: FormBuilderValidators.compose([
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
          SizedBox(height: 20),
          SizedBox(
            width: .infinity,
            child: FButton(
              size: .sm,
              mainAxisSize: .min,
              child: Text(widget.isRegister ? 'Daftar' : 'Masuk'),
              onPress: isLoading
                  ? null
                  : () {
                      if (_key.currentState?.saveAndValidate() ?? false) {
                        if (widget.isRegister) {
                          final requestUser = RegisterRequest(
                            name: _name!,
                            email: _email!,
                            password: _password!,
                          );

                          ref
                              .read(registerUserProvider.notifier)
                              .register(requestUser);
                        } else {
                          // Logika login
                        }
                      }
                    },
            ),
          ),
        ],
      ),
    );
  }
}
