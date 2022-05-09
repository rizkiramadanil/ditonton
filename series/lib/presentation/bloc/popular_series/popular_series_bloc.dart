import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:series/domain/entities/series.dart';
import 'package:series/domain/usecases/get_popular_series.dart';

part 'popular_series_event.dart';
part 'popular_series_state.dart';

class PopularSeriesBloc extends Bloc<PopularSeriesEvent, PopularSeriesState> {
  final GetPopularSeries getPopularSeries;

  PopularSeriesBloc(
      this.getPopularSeries
  ) : super(PopularSeriesEmpty()) {
    on<GetPopularSeriesEvent>((event, emit) async {
      emit(PopularSeriesLoading());
      final result = await getPopularSeries.execute();

      result.fold(
        (failure) {
          emit(PopularSeriesError(failure.message));
        },
        (data) {
          data.isEmpty ? emit(PopularSeriesEmpty()) : emit(PopularSeriesLoaded(data));
        }
      );
    });
  }
}
