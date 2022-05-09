part of 'popular_series_bloc.dart';

abstract class PopularSeriesEvent extends Equatable {
  const PopularSeriesEvent();

  @override
  List<Object> get props => [];
}

class GetPopularSeriesEvent extends PopularSeriesEvent {}
