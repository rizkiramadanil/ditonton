part of 'popular_series_bloc.dart';

abstract class PopularSeriesState extends Equatable {
  const PopularSeriesState();

  @override
  List<Object> get props => [];
}

class PopularSeriesEmpty extends PopularSeriesState {
  final String message = 'No Data';
}

class PopularSeriesLoading extends PopularSeriesState {}

class PopularSeriesError extends PopularSeriesState {
  final String message;

  const PopularSeriesError(this.message);

  @override
  List<Object> get props => [message];
}

class PopularSeriesLoaded extends PopularSeriesState {
  final List<Series> result;

  const PopularSeriesLoaded(this.result);

  @override
  List<Object> get props => [result];
}
