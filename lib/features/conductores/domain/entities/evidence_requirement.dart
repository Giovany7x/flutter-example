import 'package:equatable/equatable.dart';

/// Evidencia solicitada al conductor durante la operación.
class EvidenceRequirement extends Equatable {
  final String id;
  final String title;
  final String description;
  final bool isMandatory;

  const EvidenceRequirement({
    required this.id,
    required this.title,
    required this.description,
    this.isMandatory = true,
  });

  @override
  List<Object?> get props => [id, title, description, isMandatory];
}
