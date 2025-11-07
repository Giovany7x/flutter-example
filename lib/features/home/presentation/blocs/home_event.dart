abstract class HomeEvent {
  const HomeEvent();
}

class GetDestinationsByCategory extends HomeEvent {
  final String category;
  const GetDestinationsByCategory({required this.category});
}
