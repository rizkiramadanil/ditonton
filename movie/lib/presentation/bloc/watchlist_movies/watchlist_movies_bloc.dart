import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:core/domain/usecases/get_watchlist_movies.dart';
import 'package:core/domain/usecases/get_watchlist_status_movies.dart';
import 'package:core/domain/usecases/remove_watchlist_movies.dart';
import 'package:core/domain/usecases/save_watchlist_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'watchlist_movies_event.dart';
part 'watchlist_movies_state.dart';

class WatchlistMoviesBloc extends Bloc<WatchlistMoviesEvent, WatchlistMoviesState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetWatchlistMovies getWatchlistMovies;
  final GetWatchListStatusMovies getWatchlistStatusMovies;
  final SaveWatchlistMovies saveWatchlistMovies;
  final RemoveWatchlistMovies removeWatchlistMovies;

  WatchlistMoviesBloc(
      this.getWatchlistMovies,
      this.getWatchlistStatusMovies,
      this.saveWatchlistMovies,
      this.removeWatchlistMovies,
  ) : super(WatchlistMoviesEmpty()) {
    on<GetListEvent>((event, emit) async {
      emit(WatchlistMoviesLoading());
      final result = await getWatchlistMovies.execute();

      result.fold(
        (failure) {
          emit(WatchlistMoviesError(failure.message));
        },
        (data) {
          data.isEmpty ? emit(WatchlistMoviesEmpty()) : emit(WatchlistMoviesLoaded(data));
        }
      );
    });

    on<GetStatusMovieEvent>((event, emit) async {
      final result = await getWatchlistStatusMovies.execute(event.id);
      emit(WatchlistMoviesStatusLoaded(result));
    });

    on<AddItemMovieEvent>((event, emit) async {
      final movieDetail = event.movieDetail;
      final result = await saveWatchlistMovies.execute(movieDetail);

      result.fold(
        (failure) {
          emit(WatchlistMoviesError(failure.message));
        },
        (successMessage) {
          emit(WatchlistMoviesSuccess(successMessage));
        }
      );
    });

    on<RemoveItemMovieEvent>((event, emit) async {
      final movieDetail = event.movieDetail;
      final result = await removeWatchlistMovies.execute(movieDetail);

      result.fold(
        (failure) {
          emit(WatchlistMoviesError(failure.message));
        },
        (successMessage) {
          emit(WatchlistMoviesSuccess(successMessage));
        }
      );
    });
  }
}
