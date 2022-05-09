import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:series/domain/entities/series_detail.dart';
import 'package:series/domain/usecases/get_series_detail.dart';

part 'series_detail_event.dart';
part 'series_detail_state.dart';

class SeriesDetailBloc extends Bloc<SeriesDetailEvent, SeriesDetailState> {
  final GetSeriesDetail getSeriesDetail;

  SeriesDetailBloc(
      this.getSeriesDetail
  ) : super(SeriesDetailEmpty()) {
    on<GetSeriesDetailEvent>((event, emit) async {
      emit(SeriesDetailLoading());
      final result = await getSeriesDetail.execute(event.id);

      result.fold(
        (failure) {
          emit(SeriesDetailError(failure.message));
        },
        (data) {
          emit(SeriesDetailLoaded(data));
        }
      );
    });
  }
}
