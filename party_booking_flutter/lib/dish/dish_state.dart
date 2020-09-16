part of 'dish_bloc.dart';

class DishState extends Equatable {
  final List<File> listNewImage;
  final String messageListNewImage;
  final RateDataModel rateDataModel;
  final String messageRate;

  DishState(
      {this.listNewImage,
      this.messageListNewImage,
      this.rateDataModel,
      this.messageRate});

  DishState copyWith(
      {List<File> listNewImage,
      String messageListNewImage,
      String messageRate,
      RateDataModel rateDataModel}) {
    return DishState(
      listNewImage: listNewImage ?? this.listNewImage,
      messageListNewImage: messageListNewImage ?? this.messageListNewImage,
      messageRate: messageRate ?? this.messageRate,
      rateDataModel: rateDataModel ?? this.rateDataModel,
    );
  }

  @override
  List<Object> get props => [listNewImage, messageListNewImage, messageRate, rateDataModel];
}
