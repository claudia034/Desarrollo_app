import 'package:flutter/foundation.dart';
import '../models/user.dart';

class AuthService extends ChangeNotifier {
  User? _currentUser;
  
  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  // Datos predefinidos de usuarios
  static const List<User> _users = [
    User(
      id: '1',
      email: 'maria.gonzalez@email.com',
      password: '123456',
      firstName: 'María',
      lastName: 'González',
      address: 'Calle San Salvador 123',
      status: CustomerStatus.nuevo,
      businessType: BusinessType.person,
    ),
    User(
      id: '2',
      email: 'carlos.rodriguez@email.com',
      password: '123456',
      firstName: 'Carlos',
      lastName: 'Rodríguez',
      address: 'Avenida Libertad 456',
      status: CustomerStatus.regular,
      businessType: BusinessType.mechanic,
      businessName: 'Taller Carlos',
    ),
    User(
      id: '3',
      email: 'ana.martinez@email.com',
      password: '123456',
      firstName: 'Ana',
      lastName: 'Martínez',
      address: 'Boulevard Los Próceres 789',
      status: CustomerStatus.premium,
      businessType: BusinessType.partsStore,
      businessName: 'Repuestos Ana',
    ),
  ];

  Future<bool> login(String email, String password) async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 500));
    
    try {
      final user = _users.firstWhere(
        (user) => user.email == email && user.password == password,
      );
      
      _currentUser = user;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> register(User user) async {
    // Simular delay de red
    await Future.delayed(const Duration(seconds: 2));
    
    // En una implementación real, aquí se enviaría al servidor
    // Por ahora solo simulamos que el registro fue exitoso
    
    _currentUser = user;
    notifyListeners();
    return true;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  // Método para obtener todos los usuarios (para testing)
  List<User> getAllUsers() => _users;
}
