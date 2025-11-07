import 'package:easy_travel/core/enums/status.dart';
import 'package:easy_travel/features/home/domain/destination.dart';


class HomeState {
  final Status status;
  final String selectedCategory;
  final List<Destination> destinations;
  final String? message;

  const HomeState({
    this.status = Status.initial,
    this.selectedCategory = 'All',
    this.destinations = const [],
    this.message,
  });

  HomeState copyWith({
    Status? status,
    String? selectedCategory,
    List<Destination>? destinations,
    String? message
  }) {
    return HomeState(
      status: status ?? this.status ,
      selectedCategory: selectedCategory ?? this.selectedCategory ,
      destinations: destinations ?? this.destinations,
      message: message ?? this.message 
    );
  }
  
}
