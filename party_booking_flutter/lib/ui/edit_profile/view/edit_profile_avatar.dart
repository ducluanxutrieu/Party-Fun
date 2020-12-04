import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:party_booking/authentication/bloc/authentication_bloc.dart';
import 'package:party_booking/src/authentication_repository.dart';
import '../bloc/edit_profile_bloc.dart';

class EditProfileAvatar extends StatelessWidget {
  final String avatarUrl;
  EditProfileAvatar({@required this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditProfileBloc, EditProfileState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if(state.status == EditProfileStatus.avatarChanged || state.status == EditProfileStatus.avatarChangeFailed){
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.avatarResponse.message)),
            );

          if(state.status == EditProfileStatus.avatarChanged){
            context.read<AuthenticationBloc>().add(AuthenticationStatusChanged(AuthenticationStatus.authenticatedOnlyServerUpdate));
          }
        }
      },
      child: BlocBuilder<EditProfileBloc, EditProfileState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage(
                state.avatarResponse != null ? (state.avatarResponse.data as String) : avatarUrl),
            child: IconButton(
              icon: Icon(Icons.camera_alt),
              onPressed: () async {
                ImageSource source = await _showBottomSheet(context);
                context
                    .read<EditProfileBloc>()
                    .add(EditProfileChangeAvatar(source));
              },
              iconSize: 60,
            ),
          );
        },
      ),
    );
  }

  Future<ImageSource> _showBottomSheet(context) async {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.camera),
                    title: new Text('Camera'),
                    onTap: () =>
                      Navigator.of(context).pop(ImageSource.camera)),
                new ListTile(
                    leading: new Icon(Icons.videocam),
                    title: new Text('Gallery'),
                    onTap: () =>
                        Navigator.of(context).pop(ImageSource.gallery)),
              ],
            ),
          );
        });
  }
}