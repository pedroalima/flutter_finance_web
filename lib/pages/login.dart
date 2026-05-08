import 'package:flutter/material.dart';
import 'package:flutter_finance_web/pages/forgot_password.dart';
import 'package:flutter_finance_web/pages/home.dart';
import 'package:flutter_finance_web/pages/register.dart';
import '../components/_commons/custom_input.dart';
import '../components/_commons/custom_button.dart';
import '../services/auth_service.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo ou Ícone do App
                const Icon(
                  Icons.account_balance_wallet,
                  size: 80,
                  color: Colors.blueAccent,
                ),
                const SizedBox(height: 16),

                const Text(
                  "Finanças App",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                const Text(
                  "Gerencie seu dinheiro com inteligência",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 40),

                // Campos de Entrada
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

                // Esqueci minha senha
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgotPasswordPage(),
                        ),
                      );
                    },
                    child: const Text("Esqueceu a senha?"),
                  ),
                ),
                const SizedBox(height: 24),

                // Ações
                CustomButton(
                  text: "Entrar",
                  onPressed: () async {
                    // Lógica de autenticação
                    final result = await _authService.login(
                      _emailController.text,
                      _passwordController.text,
                    );

                    if (result != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Não tem uma conta?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterPage(),
                          ),
                        );
                      },
                      child: const Text(
                        "Cadastre-se",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
