import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:series/domain/entities/series.dart';
import 'package:series/domain/entities/series_detail.dart';
import 'package:series/domain/usecases/get_watchlist_series.dart';
import 'package:series/domain/usecases/get_watchlist_status_series.dart';
import 'package:series/domain/usecases/remove_watchlist_series.dart';
import 'package:series/domain/usecases/save_watchlist_series.dart';

part 'watchlist_series_event.dart';
part 'watchlist_series_state.dart';

class WatchlistSeriesBloc extends Bloc<WatchlistSeriesEvent, WatchlistSeriesState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetWatchlistSeries getWatchlistSeries;
  final GetWatchListStatusSeries getWatchlistStatusSeries;
  final SaveWatchlistSeries saveWatchlistSeries;
  final RemoveWatchlistSeries removeWatchlistSeries;

  WatchlistSeriesBloc(
      this.getWatchlistSeries,
      this.getWatchlistStatusSeries,
      this.saveWatchlistSeries,
      this.removeWatchlistSeries,
  ) : super(WatchlistSeriesEmpty()) {
    on<GetListEvent>((event, emit) async {
      emit(WatchlistSeriesLoading());
      final result = await getWatchlistSeries.execute();

      result.fold(
        (failure) {
          emit(WatchlistSeriesError(failure.message));
        },
        (data) {
          data.isEmpty ? emit(WatchlistSeriesEmpty()) : emit(WatchlistSeriesLoaded(data));
        }
      );
    });

    on<GetStatusSeriesEvent>((event, emit) async {
      final result = await getWatchlistStatusSeries.execute(event.id);
      emit(WatchlistSeriesStatusLoaded(result));
    });

    on<AddItemSeriesEvent>((event, emit) async {
      final movieDetail = event.seriesDetail;
      final result = await saveWatchlistSeries.execute(movieDetail);

      result.fold(
        (failure) {
          emit(WatchlistSeriesError(failure.message));
        },
        (successMessage) {
          emit(WatchlistSeriesSuccess(successMessage));
        }
      );
    });

    on<RemoveItemSeriesEvent>((event, emit) async {
      final movieDetail = event.seriesDetail;
      final result = await removeWatchlistSeries.execute(movieDetail);

      result.fold(
        (failure) {
          emit(WatchlistSeriesError(failure.message));
        },
        (successMessage) {
          emit(WatchlistSeriesSuccess(successMessage));
        }
      );
    });
  }
}
