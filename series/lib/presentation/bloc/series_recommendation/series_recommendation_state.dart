part of 'series_recommendation_bloc.dart';

abstract class SeriesRecommendationState extends Equatable {
  const SeriesRecommendationState();

  @override
  List<Object> get props => [];
}

class SeriesRecommendationEmpty extends SeriesRecommendationState {
  final String message = 'No Recommendation';
}

class SeriesRecommendationLoading extends SeriesRecommendationState {}

class SeriesRecommendationError extends SeriesRecommendationState {
  final String message;

  const SeriesRecommendationError(this.message);

  @override
  List<Object> get props => [message];
}

class SeriesRecommendationLoaded extends SeriesRecommendationState {
  final List<Series> result;

  const SeriesRecommendationLoaded(this.result);

  @override
  List<Object> get props => [result];
}
