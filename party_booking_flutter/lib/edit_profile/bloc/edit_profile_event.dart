part of 'edit_profile_bloc.dart';

abstract class EditProfileEvent extends Equatable {
  const EditProfileEvent();

  @override
  List<Object> get props => [];
}

class EditProfileSubmitted extends EditProfileEvent {
  final UpdateProfileRequestModel updateProfileModel;

  EditProfileSubmitted(this.updateProfileModel);

  @override
  List<Object> get props => [updateProfileModel];
}

class EditProfileChangeAvatar extends EditProfileEvent {
  final ImageSource imageSource;

  EditProfileChangeAvatar(this.imageSource);

  @override
  List<Object> get props => [imageSource];
}
