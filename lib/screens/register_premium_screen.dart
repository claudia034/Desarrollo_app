import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import 'register_screen.dart';

// Pantalla 4: Promoción Premium
class RegisterPremiumScreen extends StatefulWidget {
  final RegistrationData registrationData;
  
  const RegisterPremiumScreen({
    super.key,
    required this.registrationData,
  });

  @override
  State<RegisterPremiumScreen> createState() => _RegisterPremiumScreenState();
}

class _RegisterPremiumScreenState extends State<RegisterPremiumScreen> {
  bool _isLoading = false;

  void _handleFinishRegistration(bool choosePremium) async {
    setState(() => _isLoading = true);
    
    try {
      // Determinar el status del customer
      CustomerStatus status = choosePremium 
          ? CustomerStatus.premium 
          : CustomerStatus.nuevo;

      // Crear el usuario
      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: widget.registrationData.email!,
        password: widget.registrationData.password!,
        firstName: widget.registrationData.firstName!,
        lastName: widget.registrationData.lastName!,
        address: widget.registrationData.address!,
        status: status,
        businessType: widget.registrationData.businessType!,
        businessName: widget.registrationData.businessName,
      );

      // Registrar el usuario
      final authService = Provider.of<AuthService>(context, listen: false);
      final success = await authService.register(user);
      
      if (!success) {
        throw Exception('Error en el registro');
      }
      
      // Mostrar mensaje de éxito
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              choosePremium 
                  ? '¡Registro exitoso! Bienvenido a KexGo Premium' 
                  : '¡Registro exitoso! Bienvenido a KexGo',
            ),
            backgroundColor: Colors.green,
          ),
        );

        // Navegar directamente a la app ya que el usuario está logueado
        Navigator.pushNamedAndRemoveUntil(
          context, 
          '/home', 
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error en el registro: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.primary),
          onPressed: _isLoading ? null : () => Navigator.pop(context),
        ),
        title: Text(
          'KexGo Premium',
          style: TextStyle(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Indicador de progreso
              LinearProgressIndicator(
                value: 1.0,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
              ),
              const SizedBox(height: 32),
              
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título premium
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.amber, Colors.orange],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.star,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'KexGo Premium',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.primary,
                                  ),
                                ),
                                Text(
                                  'Lleva tu negocio al siguiente nivel',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Beneficios
                      Text(
                        'Beneficios exclusivos',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 16),

                      _buildBenefitCard(
                        'Descuentos especiales',
                        'Hasta 25% de descuento en repuestos y servicios',
                        Icons.discount,
                        Colors.green,
                      ),
                      const SizedBox(height: 12),
                      _buildBenefitCard(
                        'Envío gratuito',
                        'Envío gratis en pedidos superiores a \$50',
                        Icons.local_shipping,
                        Colors.blue,
                      ),
                      const SizedBox(height: 12),
                      _buildBenefitCard(
                        'Soporte prioritario',
                        'Atención preferencial 24/7',
                        Icons.support_agent,
                        Colors.purple,
                      ),
                      const SizedBox(height: 12),
                      _buildBenefitCard(
                        'Acceso anticipado',
                        'Primero en conocer nuevos productos y ofertas',
                        Icons.new_releases,
                        Colors.orange,
                      ),
                      const SizedBox(height: 12),
                      _buildBenefitCard(
                        'Garantía extendida',
                        'Garantía adicional en todas tus compras',
                        Icons.verified,
                        Colors.teal,
                      ),

                      const SizedBox(height: 24),

                      // Precio
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              colorScheme.primary.withOpacity(0.1),
                              Colors.amber.withOpacity(0.1),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: colorScheme.primary.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Oferta de lanzamiento',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '\$19.99',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.primary,
                                  ),
                                ),
                                Text(
                                  '/mes',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Primer mes gratis',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
              
              // Botones
              if (_isLoading) ...[
                const Center(
                  child: CircularProgressIndicator(),
                ),
              ] else ...[
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => _handleFinishRegistration(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Comenzar Premium',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () => _handleFinishRegistration(false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.primary,
                      side: BorderSide(color: colorScheme.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Continuar con cuenta gratuita',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitCard(
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
