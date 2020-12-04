part of 'edit_profile_bloc.dart';

enum EditProfileStatus {
  unknown,
  avatarChanging,
  avatarChanged,
  avatarChangeFailed,
  profileUpdating,
  profileUpdated,
  profileUpdateFailed
}

class EditProfileState extends Equatable {
  const EditProfileState._(
      {this.status = EditProfileStatus.unknown,
      this.avatarResponse,
      this.updateProfileResMes});

  final EditProfileStatus status;
  final BaseResponseModel avatarResponse;
  final String updateProfileResMes;

  const EditProfileState.unknown() : this._();

  const EditProfileState.avatarChanging()
      : this._(status: EditProfileStatus.avatarChanging);

  const EditProfileState.avatarChanged(BaseResponseModel avatarUrl)
      : this._(status: EditProfileStatus.avatarChanged, avatarResponse: avatarUrl);

  const EditProfileState.avatarChangeFailed()
      : this._(status: EditProfileStatus.avatarChangeFailed);

  const EditProfileState.profileUpdating()
      : this._(status: EditProfileStatus.profileUpdating);

  const EditProfileState.profileUpdated(String updateProfileResMes)
      : this._(status: EditProfileStatus.profileUpdated, updateProfileResMes: updateProfileResMes);

  const EditProfileState.profileUpdateFailed()
      : this._(status: EditProfileStatus.profileUpdateFailed);

  @override
  List<Object> get props => [status, avatarResponse, updateProfileResMes];
}
