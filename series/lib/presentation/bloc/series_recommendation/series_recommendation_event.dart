part of 'series_recommendation_bloc.dart';

abstract class SeriesRecommendationEvent extends Equatable {
  const SeriesRecommendationEvent();

  @override
  List<Object> get props => [];
}

class GetSeriesRecommendationEvent extends SeriesRecommendationEvent {
  final int id;

  const GetSeriesRecommendationEvent(this.id);

  @override
  List<Object> get props => [id];
}
