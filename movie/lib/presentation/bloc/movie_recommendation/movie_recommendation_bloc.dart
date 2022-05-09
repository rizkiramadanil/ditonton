import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/usecases/get_movie_recommendations.dart';

part 'movie_recommendation_event.dart';
part 'movie_recommendation_state.dart';

class MovieRecommendationBloc extends Bloc<MovieRecommendationEvent, MovieRecommendationState> {
  final GetMovieRecommendations getMovieRecommendations;

  MovieRecommendationBloc(
      this.getMovieRecommendations
  ) : super(MovieRecommendationEmpty()) {
    on<GetMovieRecommendationEvent>((event, emit) async {
      emit(MovieRecommendationLoading());
      final result = await getMovieRecommendations.execute(event.id);

      result.fold(
        (failure) {
          emit(MovieRecommendationError(failure.message));
        },
        (data) {
          data.isEmpty ? emit(MovieRecommendationEmpty()) : emit(MovieRecommendationLoaded(data));
        }
      );
    });
  }
}
