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

  factory DriverProfile.fromJson(Map<String, dynamic> json) {
    final fullName = json['fullName'] as String? ?? json['name'] as String? ?? '';
    final email = json['email'] as String? ?? '';
    final license = json['licenseNumber'] as String? ?? json['license'] as String? ?? '';
    final id = json['id']?.toString() ?? json['driverId']?.toString() ?? '';
    final avatar = (json['avatarUrl'] as String?)?.trim();
    final fallbackAvatar = fullName.isEmpty
        ? 'https://ui-avatars.com/api/?background=0E86FE&color=fff&name=Driver'
        : 'https://ui-avatars.com/api/?background=0E86FE&color=fff&name=${Uri.encodeComponent(fullName)}';

    return DriverProfile(
      id: id,
      fullName: fullName.isEmpty ? 'Conductor' : fullName,
      licenseNumber: license,
      email: email,
      avatarUrl: (avatar == null || avatar.isEmpty) ? fallbackAvatar : avatar,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'licenseNumber': licenseNumber,
        'email': email,
        'avatarUrl': avatarUrl,
      };

  @override
  List<Object?> get props => [id, fullName, licenseNumber, email, avatarUrl];
}
