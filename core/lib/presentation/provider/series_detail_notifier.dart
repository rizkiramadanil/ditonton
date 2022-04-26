import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/series.dart';
import '../../domain/entities/series_detail.dart';
import '../../domain/usecases/get_series_detail.dart';
import '../../domain/usecases/get_series_recommendations.dart';
import '../../domain/usecases/get_watchlist_status_series.dart';
import '../../domain/usecases/remove_watchlist_series.dart';
import '../../domain/usecases/save_watchlist_series.dart';
import '../../utils/state_enum.dart';

class SeriesDetailNotifier extends ChangeNotifier {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetSeriesDetail getSeriesDetail;
  final GetSeriesRecommendations getSeriesRecommendations;
  final GetWatchListStatusSeries getWatchListStatus;
  final SaveWatchlistSeries saveWatchlist;
  final RemoveWatchlistSeries removeWatchlist;

  SeriesDetailNotifier({
    required this.getSeriesDetail,
    required this.getSeriesRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  });

  late SeriesDetail _series;
  SeriesDetail get series => _series;

  RequestState _seriesState = RequestState.Empty;
  RequestState get seriesState => _seriesState;

  List<Series> _seriesRecommendations = [];
  List<Series> get seriesRecommendations => _seriesRecommendations;

  RequestState _recommendationState = RequestState.Empty;
  RequestState get recommendationState => _recommendationState;

  String _message = '';
  String get message => _message;

  bool _isAddedToWatchlist = false;
  bool get isAddedToWatchlist => _isAddedToWatchlist;

  Future<void> fetchSeriesDetail(int id) async {
    _seriesState = RequestState.Loading;
    notifyListeners();
    final detailResult = await getSeriesDetail.execute(id);
    final recommendationResult = await getSeriesRecommendations.execute(id);
    detailResult.fold(
          (failure) {
        _seriesState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
          (series) {
        _recommendationState = RequestState.Loading;
        _series = series;
        notifyListeners();
        recommendationResult.fold(
                (failure) {
              _recommendationState = RequestState.Error;
              _message = failure.message;
            },
                (series) {
              _recommendationState = RequestState.Loaded;
              _seriesRecommendations = series;
            }
        );
        _seriesState = RequestState.Loaded;
        notifyListeners();
      },
    );
  }

  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;

  Future<void> addWatchlist(SeriesDetail series) async {
    final result = await saveWatchlist.execute(series);

    await result.fold(
          (failure) async {
        _watchlistMessage = failure.message;
      },
          (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );
    await loadWatchlistStatus(series.id);
  }

  Future<void> removeFromWatchlist(SeriesDetail series) async {
    final result = await removeWatchlist.execute(series);

    await result.fold(
          (failure) async {
        _watchlistMessage = failure.message;
      },
          (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );
    await loadWatchlistStatus(series.id);
  }

  Future<void> loadWatchlistStatus(int id) async {
    final result = await getWatchListStatus.execute(id);
    _isAddedToWatchlist = result;
    notifyListeners();
  }
}
