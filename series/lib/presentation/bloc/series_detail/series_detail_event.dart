part of 'series_detail_bloc.dart';

abstract class SeriesDetailEvent extends Equatable {
  const SeriesDetailEvent();

  @override
  List<Object> get props => [];
}

class GetSeriesDetailEvent extends SeriesDetailEvent {
  final int id;

  const GetSeriesDetailEvent(this.id);

  @override
  List<Object> get props => [id];
}
