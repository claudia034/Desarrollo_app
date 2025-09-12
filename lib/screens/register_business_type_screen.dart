import 'package:flutter/material.dart';
import '../models/user.dart';
import 'register_screen.dart';

// Pantalla 3: Tipo de negocio
class RegisterBusinessTypeScreen extends StatefulWidget {
  final RegistrationData registrationData;
  
  const RegisterBusinessTypeScreen({
    super.key,
    required this.registrationData,
  });

  @override
  State<RegisterBusinessTypeScreen> createState() => _RegisterBusinessTypeScreenState();
}

class _RegisterBusinessTypeScreenState extends State<RegisterBusinessTypeScreen> {
  BusinessType? _selectedBusinessType;

  @override
  void initState() {
    super.initState();
    _selectedBusinessType = widget.registrationData.businessType;
  }

  void _handleNext() {
    if (_selectedBusinessType != null) {
      widget.registrationData.businessType = _selectedBusinessType;
      
      // Navegar a la pantalla premium
      Navigator.pushNamed(
        context, 
        '/register/premium',
        arguments: widget.registrationData,
      );
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
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Tipo de Cuenta',
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
                value: 0.75,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
              ),
              const SizedBox(height: 32),
              
              // Título
              Text(
                '¿Qué describe mejor tu actividad?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Esto nos ayuda a personalizar precios y servicios especiales para ti',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 32),

              Expanded(
                child: ListView(
                  children: [
                    _buildBusinessTypeCard(
                      BusinessType.person,
                      'Persona Natural',
                      'Comprador individual de repuestos y servicios',
                      Icons.person,
                      'Precios regulares',
                    ),
                    const SizedBox(height: 16),
                    _buildBusinessTypeCard(
                      BusinessType.mechanic,
                      'Mecánico',
                      'Taller mecánico o profesional independiente',
                      Icons.build,
                      'Descuentos por volumen',
                    ),
                    const SizedBox(height: 16),
                    _buildBusinessTypeCard(
                      BusinessType.partsStore,
                      'Negocio de Repuestos',
                      'Venta de repuestos y accesorios automotrices',
                      Icons.store,
                      'Precios mayoristas',
                    ),
                    const SizedBox(height: 16),
                    _buildBusinessTypeCard(
                      BusinessType.business,
                      'Otro Negocio',
                      'Empresa de transporte, flota vehicular u otro',
                      Icons.business,
                      'Precios corporativos',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              
              // Botón continuar
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _selectedBusinessType != null ? _handleNext : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    disabledBackgroundColor: Colors.grey[300],
                  ),
                  child: const Text(
                    'Continuar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBusinessTypeCard(
    BusinessType businessType,
    String title,
    String description,
    IconData icon,
    String benefit,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = _selectedBusinessType == businessType;
    
    return GestureDetector(
      onTap: () => setState(() => _selectedBusinessType = businessType),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? colorScheme.primary : Colors.grey[300]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
          color: isSelected ? colorScheme.primary.withOpacity(0.05) : Colors.white,
          boxShadow: isSelected ? [
            BoxShadow(
              color: colorScheme.primary.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ] : null,
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isSelected 
                    ? colorScheme.primary 
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 28,
                color: isSelected 
                    ? Colors.white 
                    : Colors.grey[600],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected 
                          ? colorScheme.primary 
                          : Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? colorScheme.primary.withOpacity(0.1)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      benefit,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected 
                            ? colorScheme.primary 
                            : Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: colorScheme.primary,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
