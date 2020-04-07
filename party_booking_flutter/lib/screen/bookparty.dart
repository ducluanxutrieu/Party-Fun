import 'package:flutter/material.dart';
import 'package:party_booking/data/network/model/base_response_model.dart';
import 'package:party_booking/data/network/model/book_party_request_model.dart';
import 'package:party_booking/data/network/service/app_api_service.dart';
import 'package:party_booking/res/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:party_booking/screen/main_screen.dart';
class BookParty extends StatefulWidget {
//  Note selectedNote;
  List<ListDishes> listDish;
  BookParty(this.listDish);

 // @override
  //_BookParty createState() => _BookParty();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _BookParty(listDish);
  }
}

class _BookParty extends State<BookParty> {
  List<ListDishes> listDish ;
  _BookParty(this.listDish);

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  List<FormFieldValidator> listValidators = <FormFieldValidator>[
    FormBuilderValidators.required(),
  ];



  Widget _showDatePicker() {
    return FormBuilderDateTimePicker(
      attribute: "day",
      inputType: InputType.date,
      format: DateFormat('MM/dd/yyyy'),
      style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0),
      decoration: InputDecoration(
          labelText: 'Your booking Date',
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32))),
    );
  }
  Widget _selectGender() {
    return FormBuilderDropdown(
      attribute: "num",
      style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.black),
      decoration: InputDecoration(
          labelText: "NumberTable",
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32))),
      // initialValue: 'Male',
      hint: Text('Number Tables', style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0),),
      validators: [FormBuilderValidators.required()],
      items: ['1', '2', '3','4','5', '6', '7','8','9', '10', '11','12','12', '13', '14','15']
          .map((gender) =>
          DropdownMenuItem(value: gender, child: Text("$gender")))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build


    return Scaffold(
      appBar: AppBar(
        title: Text( 'MORE INFORMATION'),

        backgroundColor: Colors.green,
      ),

      body: Center(
        child: FormBuilder(
          key: _fbKey,
          autovalidate: true,

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

                    SizedBox(height: 15.0),
                    _selectGender(),

                    SizedBox(height: 15.0),
                    _showDatePicker(),
                    SizedBox(height: 15.0),
                    SizedBox(height: 15.0),
                    SizedBox(
                        width: double.infinity,
                        child: RaisedButton(
                          color: Colors.lightGreen,
                          textColor: Colors.white,
                          elevation: 0,
                          child: Text("BUY"),
                          onPressed: () {
                               requestBookParty();
                        //    Navigator.push(context, MaterialPageRoute(builder: (context)=>BookParty(listDish)));
                               Navigator.pushReplacement(
                                   context, MaterialPageRoute(builder: (context) => MainScreen()));
                          },
                        ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Future<BaseResponseModel> requestBookParty() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // List<ListDishes> listDish = new List();
    final day = _fbKey.currentState.fields['day'].currentState.value;
    final num = _fbKey.currentState.fields['num'].currentState.value;
    // listDish.add(ListDishes(id: ))
    var model = BookPartyRequestModel(
        dateParty: day.toString(), numbertable: num, lishDishs: listDish);
    var result = AppApiService.create().bookParty(
      token: prefs.getString(Constants.USER_TOKEN),
      model:  BookPartyRequestModel(
          dateParty: DateFormat('MM/dd/yyyy hh:mm').format(day), numbertable: num, lishDishs: listDish),
    );
  }
}