import 'package:equatable/equatable.dart';

/// Elemento de la lista de verificación de Check-In/Check-Out.
class CheckItem extends Equatable {
  final String id;
  final String title;
  final bool isCritical;
  final String? description;

  const CheckItem({
    required this.id,
    required this.title,
    this.isCritical = false,
    this.description,
  });

  factory CheckItem.fromJson(Map<String, dynamic> json) => CheckItem(
        id: json['id']?.toString() ?? json['itemId']?.toString() ?? '',
        title: json['title'] as String? ?? json['name'] as String? ?? 'Elemento',
        isCritical: json['isCritical'] as bool? ?? json['critical'] as bool? ?? false,
        description: json['description'] as String? ?? json['details'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'isCritical': isCritical,
        'description': description,
      };

  @override
  List<Object?> get props => [id, title, isCritical, description];
}
