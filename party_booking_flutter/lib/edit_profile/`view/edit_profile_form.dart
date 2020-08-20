import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:party_booking/data/network/model/account_response_model.dart';
import 'package:party_booking/edit_profile/bloc/edit_profile_bloc.dart';

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
          _CircleAvatar(
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

class _CircleAvatar extends StatelessWidget {
  final String avatarUrl;
  _CircleAvatar({@required this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileBloc, EditProfileState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        if (state.status == EditPrifileStatus.profileUpdated) {
          Navigator.of(context).canPop();
        }
        return CircleAvatar(
          radius: 60,
          backgroundImage: NetworkImage(
              state.avatarUrl != null ? state.avatarUrl : avatarUrl),
          child: IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () => _showBottomSheet(context),
            iconSize: 60,
          ),
        );
      },
    );
  }

  void _showBottomSheet(context) async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.camera),
                    title: new Text('Camera'),
                    onTap: () => context
                        .bloc<EditProfileBloc>()
                        .add(EditProfileChangeAvatar(ImageSource.camera))),
                new ListTile(
                    leading: new Icon(Icons.videocam),
                    title: new Text('Gallery'),
                    onTap: () => context
                        .bloc<EditProfileBloc>()
                        .add(EditProfileChangeAvatar(ImageSource.gallery))),
              ],
            ),
          );
        });
  }
}
