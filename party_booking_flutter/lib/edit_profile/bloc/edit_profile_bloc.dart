import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:party_booking/data/network/model/update_profile_request_model.dart';
import 'package:party_booking/data/network/service/app_image_api_service.dart';
import 'package:party_booking/src/authentication_repository.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc({@required AuthenticationRepository authenticationRepository})
      : assert(authenticationRepository != null),
        _authenticationRepository = authenticationRepository,
        super(EditProfileState.unknown());

  final AuthenticationRepository _authenticationRepository;
  @override
  Stream<EditProfileState> mapEventToState(
    EditProfileEvent event,
  ) async* {
    if (event is EditProfileSubmitted) {
      yield* _mapEditProfileSubmittedToState(event, state);
    } else if (event is EditProfileChangeAvatar) {
      yield* _mapEditProfileChangeAvatarToState(event, state);
    }
  }

  Stream<EditProfileState> _mapEditProfileSubmittedToState(
      EditProfileSubmitted event, EditProfileState state) async* {
    yield EditProfileState.profileUpdating();

    try {
      String result = await _authenticationRepository.updateUserProfile(
          updateProfileModel: event.updateProfileModel);
      if (result == "Update Profile Successful!")
        yield EditProfileState.profileUpdated();
      else {
        yield EditProfileState.profileUpdateFailed();
        await Future<void>.delayed(const Duration(seconds: 1));
        yield EditProfileState.unknown();
      }
    } on Exception catch (_) {
      yield EditProfileState.profileUpdateFailed();
      await Future<void>.delayed(const Duration(seconds: 1));
      yield EditProfileState.unknown();
    }
  }

  Stream<EditProfileState> _mapEditProfileChangeAvatarToState(
      EditProfileChangeAvatar event, EditProfileState state) async* {
    yield EditProfileState.avatarChanging();

    try {
      String result = await _updateAvatar(event.imageSource);
      if (result != null) {
        _authenticationRepository.changeAuthenticationStatus(
            AuthenticationStatus.authenticatedOnlyServerUpdate);
        yield EditProfileState.avatarChanged(result);
      } else {
        yield EditProfileState.avatarChangeFailed();
        await Future<void>.delayed(const Duration(seconds: 1));
        yield EditProfileState.unknown();
      }
    } on Exception catch (_) {
      yield EditProfileState.avatarChangeFailed();
      await Future<void>.delayed(const Duration(seconds: 1));
      yield EditProfileState.unknown();
    }
  }

  Future<String> _updateAvatar(source) async {
    final picker = ImagePicker();
    PickedFile pickedFile = await picker.getImage(source: source);
    File image = File(pickedFile.path);

    if (image != null && image.path != null && image.path.isNotEmpty) {
      var result = await AppImageAPIService.create().updateAvatar(image);
      if (result != null) {
        return result.data;
      }
    }

    return null;
  }
}
