part of 'watchlist_series_bloc.dart';

abstract class WatchlistSeriesState extends Equatable {
  const WatchlistSeriesState();

  @override
  List<Object> get props => [];
}

class WatchlistSeriesEmpty extends WatchlistSeriesState {
  final String message = 'You haven\'t saved any series yet!';
}

class WatchlistSeriesLoading extends WatchlistSeriesState {}

class WatchlistSeriesError extends WatchlistSeriesState {
  final String message;

  const WatchlistSeriesError(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistSeriesSuccess extends WatchlistSeriesState {
  final String message;

  const WatchlistSeriesSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistSeriesLoaded extends WatchlistSeriesState {
  final List<Series> result;

  const WatchlistSeriesLoaded(this.result);

  @override
  List<Object> get props => [result];
}

class WatchlistSeriesStatusLoaded extends WatchlistSeriesState {
  final bool result;

  const WatchlistSeriesStatusLoaded(this.result);

  @override
  List<Object> get props => [result];
}
