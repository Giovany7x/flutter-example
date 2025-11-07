enum CategoryType {
  all(label: 'All'),
  beach(label: 'Beach'),
  adventure(label: 'Adventure'),
  city(label: 'City'),
  cultural(label: 'Cultural');

  final String label;
  const CategoryType({required this.label});
}