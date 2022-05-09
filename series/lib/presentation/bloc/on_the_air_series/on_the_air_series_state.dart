part of 'on_the_air_series_bloc.dart';

abstract class OnTheAirSeriesState extends Equatable {
  const OnTheAirSeriesState();

  @override
  List<Object> get props => [];
}

class OnTheAirSeriesEmpty extends OnTheAirSeriesState {
  final String message = 'No Data';
}

class OnTheAirSeriesLoading extends OnTheAirSeriesState {}

class OnTheAirSeriesError extends OnTheAirSeriesState {
  final String message;

  const OnTheAirSeriesError(this.message);

  @override
  List<Object> get props => [message];
}

class OnTheAirSeriesLoaded extends OnTheAirSeriesState {
  final List<Series> result;

  const OnTheAirSeriesLoaded(this.result);

  @override
  List<Object> get props => [result];
}
