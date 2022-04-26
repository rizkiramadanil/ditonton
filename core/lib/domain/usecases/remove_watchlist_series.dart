import 'package:dartz/dartz.dart';

import '../../utils/failure.dart';
import '../entities/series_detail.dart';
import '../repositories/series_repository.dart';

class RemoveWatchlistSeries {
  final SeriesRepository repository;

  RemoveWatchlistSeries(this.repository);

  Future<Either<Failure, String>> execute(SeriesDetail series) {
    return repository.removeWatchlist(series);
  }
}
