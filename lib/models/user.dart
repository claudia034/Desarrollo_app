enum CustomerStatus {
  nuevo('Nuevo Cliente'),
  regular('Cliente Regular'),
  premium('Cliente Premium');

  const CustomerStatus(this.label);
  final String label;
}

enum BusinessType {
  person('Persona Natural'),
  mechanic('Mecánico'),
  partsStore('Negocio de Repuestos'),
  business('Otro Negocio');

  const BusinessType(this.label);
  final String label;
}

class User {
  final String id;
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String address;
  final CustomerStatus status;
  final BusinessType businessType;
  final String? businessName; // Solo para negocios

  const User({
    required this.id,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.status,
    required this.businessType,
    this.businessName,
  });

  String get fullName => '$firstName $lastName';
  String get displayName => businessName ?? fullName;
  bool get isBusiness => businessType != BusinessType.person;
}
