import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool obscure = true;
  bool isLoading = false;

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (emailCtrl.text.isEmpty || passCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final authService = context.read<AuthService>();
    final success = await authService.login(emailCtrl.text, passCtrl.text);

    setState(() {
      isLoading = false;
    });

    if (success) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Credenciales incorrectas')),
        );
      }
    }
  }

  Widget _buildTestUser(String email, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: Text(email, style: const TextStyle(fontSize: 12)),
          ),
          Text(status, 
            style: TextStyle(
              fontSize: 11, 
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500
            )
          ),
        ],
      ),
    );
  }

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
                SizedBox(
                  width: double.infinity, 
                  height: 48, 
                  child: FilledButton(
                    onPressed: isLoading ? null : _login, 
                    child: isLoading 
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Iniciar sesión')
                  )
                ),
                const SizedBox(height: 24),
                
                // Información de usuarios de prueba
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color.primaryContainer.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color.primary.withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('👤 Usuarios de Prueba:', 
                        style: TextStyle(fontWeight: FontWeight.bold, color: color.primary)),
                      const SizedBox(height: 8),
                      _buildTestUser('maria.gonzalez@email.com', 'Nuevo Cliente'),
                      _buildTestUser('carlos.rodriguez@email.com', 'Cliente Regular'),
                      _buildTestUser('ana.martinez@email.com', 'Cliente Premium'),
                      const SizedBox(height: 8),
                      Text('🔑 Contraseña: 123456', 
                        style: TextStyle(fontSize: 12, color: color.onSurface.withOpacity(0.7))),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                const Row(children: [Expanded(child: Divider()), Padding(padding: EdgeInsets.symmetric(horizontal: 8.0), child: Text('O')), Expanded(child: Divider())]),
                const SizedBox(height: 16),
                OutlinedButton.icon(onPressed: () => Navigator.pushReplacementNamed(context, '/home'), icon: const Icon(Icons.g_mobiledata, size: 28), label: const Text('Continuar con Google'), style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),),
                const SizedBox(height: 16),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Text('¿No tienes cuenta todavía? '), TextButton(onPressed: () => Navigator.pushNamed(context, '/register'), child: const Text('Regístrate'))]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
