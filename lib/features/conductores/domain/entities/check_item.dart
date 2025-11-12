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

  @override
  List<Object?> get props => [id, title, isCritical, description];
}
