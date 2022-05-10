import 'package:core/domain/entities/series.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/domain/usecases/get_series_recommendations.dart';

part 'series_recommendation_event.dart';
part 'series_recommendation_state.dart';

class SeriesRecommendationBloc extends Bloc<SeriesRecommendationEvent, SeriesRecommendationState> {
  final GetSeriesRecommendations getSeriesRecommendations;

  SeriesRecommendationBloc(
      this.getSeriesRecommendations
  ) : super(SeriesRecommendationEmpty()) {
    on<GetSeriesRecommendationEvent>((event, emit) async {
      emit(SeriesRecommendationLoading());
      final result = await getSeriesRecommendations.execute(event.id);

      result.fold(
        (failure) {
          emit(SeriesRecommendationError(failure.message));
        },
        (data) {
          data.isEmpty ? emit(SeriesRecommendationEmpty()) : emit(SeriesRecommendationLoaded(data));
        }
      );
    });
  }
}
