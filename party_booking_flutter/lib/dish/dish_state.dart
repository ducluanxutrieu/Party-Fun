part of 'dish_bloc.dart';

class DishState extends Equatable {
  final List<File> listNewImage;
  final String messageListNewImage;

  DishState({this.listNewImage, this.messageListNewImage});

  DishState copyWith({List<File> listNewImage, String messageListNewImage}) {
    return DishState(
        listNewImage: listNewImage ?? this.listNewImage,
        messageListNewImage: messageListNewImage ?? this.messageListNewImage);
  }

  @override
  List<Object> get props => [listNewImage, messageListNewImage];
}
