import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:party_booking/data/network/model/account_response_model.dart';

import 'edit_profile_avatar.dart';
import 'edit_profile_fill_form.dart';

class EditProfileForm extends StatelessWidget {
  const EditProfileForm({
    Key key,
    @required AccountModel accountModel,
  })  : assert(accountModel != null),
        _mAccountModel = accountModel,
        super(key: key);

  final AccountModel _mAccountModel;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 40,
          ),
          EditProfileAvatar(
            avatarUrl: _mAccountModel.avatar,
          ),
          EditProfileFillForm(
            fbKey: _fbKey,
            mAccountModel: _mAccountModel,
          ),
          SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}