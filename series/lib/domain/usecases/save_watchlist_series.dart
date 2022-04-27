import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:series/domain/entities/series_detail.dart';
import 'package:series/domain/repositories/series_repository.dart';

class SaveWatchlistSeries {
  final SeriesRepository repository;

  SaveWatchlistSeries(this.repository);

  Future<Either<Failure, String>> execute(SeriesDetail series) {
    return repository.saveWatchlist(series);
  }
}
