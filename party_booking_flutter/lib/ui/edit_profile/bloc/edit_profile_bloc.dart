import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:party_booking/data/network/model/account_response_model.dart';
import 'package:party_booking/data/network/model/base_response_model.dart';
import 'package:party_booking/data/network/model/update_profile_request_model.dart';
import 'package:party_booking/src/authentication_repository.dart';
import 'package:party_booking/src/user_repository.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc(
      {@required AuthenticationRepository authenticationRepository,
      @required UserRepository userRepository})
      : assert(authenticationRepository != null),
        _authenticationRepository = authenticationRepository,
        _userRepository = userRepository,
        super(EditProfileState.unknown());

  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;

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
      MapEntry<AccountModel, String> result = await _authenticationRepository
          .updateUserProfile(updateProfileModel: event.updateProfileModel);
      if (result.key != null) {
        _userRepository.logout();
        _authenticationRepository.saveAccountToSharedPre(result.key, false);
        yield EditProfileState.profileUpdated(result.value);
      } else {
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
      BaseResponseModel result = await _userRepository.updateAvatar(event.imageSource);
      if (result != null) {
        _userRepository.logout();
        // _authenticationRepository.changeAuthenticationStatus(
        //     AuthenticationStatus.authenticatedOnlyServerUpdate);
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
}
