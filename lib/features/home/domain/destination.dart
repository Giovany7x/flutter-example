class Destination {
  final int id;
  final String title;
  final String posterPath;

  Destination({
    required this.id,
    required this.title,
    required this.posterPath,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      id: json['id'],
      title: json['title'],
      posterPath: json['posterPath'],
    );
  }
}
