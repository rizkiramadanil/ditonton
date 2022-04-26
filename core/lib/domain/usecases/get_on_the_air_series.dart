import 'package:dartz/dartz.dart';

import '../../utils/failure.dart';
import '../entities/series.dart';
import '../repositories/series_repository.dart';

class GetOnTheAirSeries {
  final SeriesRepository repository;

  GetOnTheAirSeries(this.repository);

  Future<Either<Failure, List<Series>>> execute() {
    return repository.getOnTheAirSeries();
  }
}
