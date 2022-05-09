part of 'top_rated_series_bloc.dart';

abstract class TopRatedSeriesEvent extends Equatable {
  const TopRatedSeriesEvent();

  @override
  List<Object> get props => [];
}

class GetTopRatedSeriesEvent extends TopRatedSeriesEvent {}
