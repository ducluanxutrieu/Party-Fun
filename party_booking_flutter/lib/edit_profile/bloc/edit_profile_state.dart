part of 'edit_profile_bloc.dart';

enum EditPrifileStatus {
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
      {this.status = EditPrifileStatus.unknown,
      this.avatarUrl,
      this.updateProfileModel});

  final EditPrifileStatus status;
  final String avatarUrl;
  final UpdateProfileRequestModel updateProfileModel;

  const EditProfileState.unknown() : this._();

  const EditProfileState.avatarChanging()
      : this._(status: EditPrifileStatus.avatarChanging);

  const EditProfileState.avatarChanged(String avatarUrl)
      : this._(status: EditPrifileStatus.avatarChanged, avatarUrl: avatarUrl);

  const EditProfileState.avatarChangeFailed()
      : this._(status: EditPrifileStatus.avatarChangeFailed);

  const EditProfileState.profileUpdating()
      : this._(status: EditPrifileStatus.profileUpdating);

  const EditProfileState.profileUpdated()
      : this._(status: EditPrifileStatus.profileUpdated);

  const EditProfileState.profileUpdateFailed()
      : this._(status: EditPrifileStatus.profileUpdateFailed);

  @override
  List<Object> get props => [status, avatarUrl, updateProfileModel];
}
