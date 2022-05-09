part of 'top_rated_series_bloc.dart';

abstract class TopRatedSeriesState extends Equatable {
  const TopRatedSeriesState();

  @override
  List<Object> get props => [];
}

class TopRatedSeriesEmpty extends TopRatedSeriesState {
  final String message = 'No Data';
}

class TopRatedSeriesLoading extends TopRatedSeriesState {}

class TopRatedSeriesError extends TopRatedSeriesState {
  final String message;

  const TopRatedSeriesError(this.message);

  @override
  List<Object> get props => [message];
}

class TopRatedSeriesLoaded extends TopRatedSeriesState {
  final List<Series> result;

  const TopRatedSeriesLoaded(this.result);

  @override
  List<Object> get props => [result];
}
