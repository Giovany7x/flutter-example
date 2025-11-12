import 'package:equatable/equatable.dart';

/// Representa la información pública del conductor autenticado.
class DriverProfile extends Equatable {
  final String id;
  final String fullName;
  final String licenseNumber;
  final String email;
  final String avatarUrl;

  const DriverProfile({
    required this.id,
    required this.fullName,
    required this.licenseNumber,
    required this.email,
    required this.avatarUrl,
  });

  @override
  List<Object?> get props => [id, fullName, licenseNumber, email, avatarUrl];
}
