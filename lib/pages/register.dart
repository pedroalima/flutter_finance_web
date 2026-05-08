import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../components/_commons/custom_button.dart';
import '../components/_commons/custom_input.dart';
import '../services/auth_service.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Botão de voltar automático no AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  "Nova Conta",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Cadastre-se para começar a organizar suas finanças",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 40),

                // Campos reutilizando seus componentes
                CustomInput(
                  label: "Nome Completo",
                  icon: Icons.person_outline,
                  controller: _nameController,
                ),
                const SizedBox(height: 16),

                CustomInput(
                  label: "E-mail",
                  icon: Icons.email_outlined,
                  controller: _emailController,
                ),
                const SizedBox(height: 16),

                CustomInput(
                  label: "Senha",
                  icon: Icons.lock_outline,
                  isPassword: true,
                  controller: _passwordController,
                ),
                const SizedBox(height: 32),

                CustomButton(
                  text: "Criar Conta",
                  onPressed: () async {
                    try {
                      final result = await _authService.register(
                        _nameController.text,
                        _emailController.text,
                        _passwordController.text,
                      );

                      if (result != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Usuário cadastrado com sucesso!"),
                          ),
                        );
                        Navigator.pop(context); // Volta para a tela de Login
                      }
                    } on DioException catch (e) {
                      String errorMessage =
                          "Falha ao cadastrar. Verifique os dados.";

                      if (e.response?.data != null &&
                          e.response?.data['message'] != null) {
                        errorMessage = e.response?.data['message'];
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(errorMessage),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    } catch (e) {
                      // Erros genéricos (fora do Dio)
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Ocorreu um erro inesperado."),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
