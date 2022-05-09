part of 'watchlist_movies_bloc.dart';

abstract class WatchlistMoviesState extends Equatable {
  const WatchlistMoviesState();

  @override
  List<Object> get props => [];
}

class WatchlistMoviesEmpty extends WatchlistMoviesState {
  final String message = 'You haven\'t saved any movies yet!';
}

class WatchlistMoviesLoading extends WatchlistMoviesState {}

class WatchlistMoviesError extends WatchlistMoviesState {
  final String message;

  const WatchlistMoviesError(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistMoviesSuccess extends WatchlistMoviesState {
  final String message;

  const WatchlistMoviesSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistMoviesLoaded extends WatchlistMoviesState {
  final List<Movie> result;

  const WatchlistMoviesLoaded(this.result);

  @override
  List<Object> get props => [result];
}

class WatchlistMoviesStatusLoaded extends WatchlistMoviesState {
  final bool result;

  const WatchlistMoviesStatusLoaded(this.result);

  @override
  List<Object> get props => [result];
}
