import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../components/_commons/custom_input.dart';
import '../components/_commons/custom_button.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../services/auth_service.dart';

class ForgotPasswordPage extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();
  final AuthService _authService = AuthService();

  ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.lock_reset, size: 80, color: Colors.blueAccent),
              const SizedBox(height: 24),
              const Text(
                "Recuperar Senha",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Digite seu e-mail cadastrado para receber as instruções de recuperação.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 40),

              CustomInput(
                name: 'email',
                label: "E-mail",
                icon: Icons.email_outlined,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                    errorText: "E-mail obrigatório",
                  ),
                  FormBuilderValidators.email(errorText: "E-mail inválido"),
                ]),
              ),

              const SizedBox(height: 32),

              CustomButton(
                text: "Enviar Instruções",
                onPressed: () async {
                  if (_formKey.currentState?.saveAndValidate() ?? false) {
                    final formData = _formKey.currentState!.value;

                    try {
                      final message = await _authService.forgotPassword(
                        formData['email'] as String,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(message),
                          backgroundColor: Colors.green,
                        ),
                      );

                      Navigator.pop(context); // Volta para o login
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.toString()),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
