import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:party_booking/edit_profile/bloc/edit_profile_bloc.dart';

class EditProfileAvatar extends StatelessWidget {
  final String avatarUrl;
  EditProfileAvatar({@required this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileBloc, EditProfileState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return CircleAvatar(
          radius: 60,
          backgroundImage: NetworkImage(
              state.avatarUrl != null ? state.avatarUrl : avatarUrl),
          child: IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () async {
              ImageSource source = await _showBottomSheet(context);
              context
                  .bloc<EditProfileBloc>()
                  .add(EditProfileChangeAvatar(source));
            },
            iconSize: 60,
          ),
        );
      },
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