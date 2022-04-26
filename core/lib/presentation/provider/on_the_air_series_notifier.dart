import 'package:flutter/foundation.dart';

import '../../domain/entities/series.dart';
import '../../domain/usecases/get_on_the_air_series.dart';
import '../../utils/state_enum.dart';

class OnTheAirSeriesNotifier extends ChangeNotifier {
  final GetOnTheAirSeries getOnTheAirSeries;

  OnTheAirSeriesNotifier(this.getOnTheAirSeries);

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<Series> _series = [];
  List<Series> get series => _series;

  String _message = '';
  String get message => _message;

  Future<void> fetchOnTheAirSeries() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getOnTheAirSeries.execute();

    result.fold(
          (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
          (seriesData) {
        _series = seriesData;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}