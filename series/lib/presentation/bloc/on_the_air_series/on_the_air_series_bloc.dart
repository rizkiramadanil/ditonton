import 'package:core/domain/entities/series.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/domain/usecases/get_on_the_air_series.dart';

part 'on_the_air_series_event.dart';
part 'on_the_air_series_state.dart';

class OnTheAirSeriesBloc extends Bloc<OnTheAirSeriesEvent, OnTheAirSeriesState> {
  final GetOnTheAirSeries getOnTheAirSeries;

  OnTheAirSeriesBloc(
      this.getOnTheAirSeries
  ) : super(OnTheAirSeriesEmpty()) {
    on<GetOnTheAirSeriesEvent>((event, emit) async {
      emit(OnTheAirSeriesLoading());
      final result = await getOnTheAirSeries.execute();

      result.fold(
        (failure) {
          emit(OnTheAirSeriesError(failure.message));
        },
        (data) {
          data.isEmpty ? emit(OnTheAirSeriesEmpty()) : emit(OnTheAirSeriesLoaded(data));
        }
      );
    });
  }
}
