import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:series/domain/entities/series_detail.dart';
import 'package:series/domain/repositories/series_repository.dart';

class RemoveWatchlistSeries {
  final SeriesRepository repository;

  RemoveWatchlistSeries(this.repository);

  Future<Either<Failure, String>> execute(SeriesDetail series) {
    return repository.removeWatchlist(series);
  }
}
