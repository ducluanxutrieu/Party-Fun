import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:party_booking/data/network/model/base_response_model.dart';
import 'package:party_booking/data/network/model/book_party_request_model.dart';
import 'package:party_booking/data/network/model/list_dishes_response_model.dart';
import 'package:party_booking/data/network/service/app_api_service.dart';
import 'package:party_booking/res/constants.dart';
import 'package:party_booking/screen/book_party_success_screen.dart';
import 'package:party_booking/screen/book_success.dart';
import 'package:party_booking/widgets/common/app_button.dart';
import 'package:party_booking/widgets/common/utiu.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookPartyScreen extends StatefulWidget {
//  Note selectedNote;
  BookPartyScreen();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _BookPartyScreenState();
  }
}

class _BookPartyScreenState extends State<BookPartyScreen> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  List<FormFieldValidator> listValidators = <FormFieldValidator>[
    FormBuilderValidators.required(),
  ];

  final List<ListDishes> listDish = new List();

  Widget _showDatePicker() {
    return FormBuilderDateTimePicker(
      attribute: "day",
      inputType: InputType.both,
      initialDate: DateTime.now().add(Duration(seconds: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      format: DateFormat('MM/dd/yyyy hh:mm'),
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
      style: TextStyle(
          fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.black),
      decoration: InputDecoration(
          labelText: "NumberTable",
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32))),
      // initialValue: 'Male',
      hint: Text(
        'Number Tables',
        style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0),
      ),
      validators: [FormBuilderValidators.required()],
      items: List.generate(15, (generator) => generator + 1)
          .map((item) => DropdownMenuItem(value: item, child: Text("$item")))
          .toList(),
    );
  }

  void _onUpdateClicked() {
    final day = _fbKey.currentState.fields['day'].currentState.value;
    final num = _fbKey.currentState.fields['num'].currentState.value;
    if (day != null && num != null) {
      requestBookParty();
      ScopedModel.of<CartModel>(context).clearCart();

      //    Navigator.push(context, MaterialPageRoute(builder: (context)=>BookParty(listDish)));
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => EditProfileScreen())); //Sao
    } else {
      Fluttertoast.showToast(
          msg: "Please fill all fields",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(
        title: Text('Book Party'),
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
                    AppButtonWidget(
                      buttonText: 'Book',
                      buttonHandler: _onUpdateClicked,
                      //stateButton: _stateButton,
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

  void requestBookParty() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final day = _fbKey.currentState.fields['day'].currentState.value;
    final num = _fbKey.currentState.fields['num'].currentState.value;
    // listDish.add(ListDishes(id: ))

    ScopedModel.of<CartModel>(context, rebuildOnChange: true).cart.forEach(
        (item) =>
            {listDish.add(ListDishes(numberDish: item.qty, id: item.id))});

    var model = BookPartyRequestModel(
        dateParty: DateFormat(Constants.DATE_TIME_FORMAT_SERVER).format(day),
        numberTable: num,
        lishDishs: listDish);
    var result = await AppApiService.create().bookParty(
      token: prefs.getString(Constants.USER_TOKEN),
      model: model,
    );
    if (result.isSuccessful) {
      UTiu.showToast(result.body.message);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => BookPartySuccessScreen(result.body.bill)));
    } else {
      BaseResponseModel model = BaseResponseModel.fromJson(result.error);
      UTiu.showToast(model.message);
    }
  }
}