import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:party_booking/widgets/common/app_button.dart';
import 'package:party_booking/widgets/common/logo_check.dart';
import 'package:party_booking/screen/main_screen.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  List<FormFieldValidator> listValidators = <FormFieldValidator>[
    FormBuilderValidators.required(),
  ];
  int _stateButton = 0;

  void _onUpdateClicked() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MainScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RESERVATION SUCCESS'),
      ),
      body: Center(
        child: FormBuilder(
          key: _fbKey,
          autovalidate: true,
          initialValue: {},
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(left: 36, right: 36),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 0,
                    ),
                    LogoCheckWidget(
                      mLogoSize: 200,
                    ),
                    SizedBox(height: 40.0),
                    Text(
                      'Reservation completed successfully',
                      style: TextStyle(
                        fontSize: 23.0,
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                        fontFamily: 'Pacifico',
                      ),
                    ),
                    SizedBox(
                      height: 35.0,
                    ),
                    AppButtonWidget(
                      buttonText: 'Back To Menu',
                      buttonHandler: _onUpdateClicked,
                      stateButton: _stateButton,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
