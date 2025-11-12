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

  factory EvidenceRequirement.fromJson(Map<String, dynamic> json) => EvidenceRequirement(
        id: json['id']?.toString() ?? json['evidenceId']?.toString() ?? '',
        title: json['title'] as String? ?? json['name'] as String? ?? 'Evidencia',
        description: json['description'] as String? ?? json['details'] as String? ?? '',
        isMandatory: json['isMandatory'] as bool? ?? json['mandatory'] as bool? ?? true,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'isMandatory': isMandatory,
      };

  @override
  List<Object?> get props => [id, title, description, isMandatory];
}
