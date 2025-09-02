import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                Icon(Icons.directions_car, size: 64, color: color.primary),
                const SizedBox(height: 8),
                Text('KexGO', style: TextStyle(fontSize: 28, color: color.primary, fontWeight: FontWeight.bold)),
                const SizedBox(height: 32),
                Align(alignment: Alignment.centerLeft, child: Text('Correo electrónico', style: Theme.of(context).textTheme.labelLarge)),
                const SizedBox(height: 8),
                TextField(controller: emailCtrl, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(hintText: 'Ingresa tu correo electrónico', border: OutlineInputBorder()),),
                const SizedBox(height: 16),
                Align(alignment: Alignment.centerLeft, child: Text('Contraseña', style: Theme.of(context).textTheme.labelLarge)),
                const SizedBox(height: 8),
                TextField(
                  controller: passCtrl,
                  obscureText: obscure,
                  decoration: InputDecoration(
                    hintText: 'Ingresa tu contraseña',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(icon: Icon(obscure ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => obscure = !obscure)),
                  ),
                ),
                const SizedBox(height: 8),
                Align(alignment: Alignment.centerRight, child: TextButton(onPressed: () {}, child: const Text('¿Olvidaste tu contraseña?'))),
                const SizedBox(height: 8),
                SizedBox(width: double.infinity, height: 48, child: FilledButton(onPressed: () => Navigator.pushReplacementNamed(context, '/home'), child: const Text('Iniciar sesión'))),
                const SizedBox(height: 16),
                const Row(children: [Expanded(child: Divider()), Padding(padding: EdgeInsets.symmetric(horizontal: 8.0), child: Text('O')), Expanded(child: Divider())]),
                const SizedBox(height: 16),
                OutlinedButton.icon(onPressed: () => Navigator.pushReplacementNamed(context, '/home'), icon: const Icon(Icons.g_mobiledata, size: 28), label: const Text('Continuar con Google'), style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),),
                const SizedBox(height: 16),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Text('¿No tienes cuenta todavía? '), TextButton(onPressed: () {}, child: const Text('Regístrate'))]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
