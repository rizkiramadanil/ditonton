import 'package:core/domain/entities/series.dart';
import 'package:core/domain/repositories/series_repository.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

class GetOnTheAirSeries {
  final SeriesRepository repository;

  GetOnTheAirSeries(this.repository);

  Future<Either<Failure, List<Series>>> execute() {
    return repository.getOnTheAirSeries();
  }
}
