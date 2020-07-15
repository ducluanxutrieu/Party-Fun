import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:party_booking/data/network/model/base_response_model.dart';
import 'package:party_booking/data/network/model/book_party_request_model.dart';
import 'package:party_booking/data/network/model/list_dishes_response_model.dart';
import 'package:party_booking/data/network/service/app_api_service.dart';
import 'package:party_booking/res/constants.dart';
import 'package:party_booking/widgets/common/app_button.dart';
import 'package:party_booking/widgets/common/text_field.dart';
import 'package:party_booking/widgets/common/utiu.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'book_party_success_screen.dart';

class BookPartyScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BookPartyScreenState();
}

class _BookPartyScreenState extends State<BookPartyScreen> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  List<FormFieldValidator> listValidators = <FormFieldValidator>[
    FormBuilderValidators.required(),
  ];
  static var now = new DateTime.now();
  var twoDaysFromNow = now.add(new Duration(days: 2));

  final List<ListDishes> listDish = new List();

  Widget _showDatePicker() {
    return FormBuilderDateTimePicker(
      attribute: "day",
      inputType: InputType.both,
      initialDate: DateTime.now().add(Duration(seconds: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      format: DateFormat(Constants.DATE_TIME_FORMAT_SERVER),
      style: kPrimaryTextStyle,
      decoration: InputDecoration(
          labelText: 'Your booking Date',
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32))),
    );
  }

  Widget _selectNumberTable() {
    return FormBuilderDropdown(
      attribute: "num",
      style: TextStyle(
          fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.black),
      decoration: InputDecoration(
          labelText: "Number of Table",
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32))),
      // initialValue: 'Male',
      hint: Text(
        'Number Tables',
        style: kPrimaryTextStyle,
      ),
      validators: [FormBuilderValidators.required()],
      items: List.generate(15, (generator) => generator + 1)
          .map((item) => DropdownMenuItem(value: item, child: Text("$item")))
          .toList(),
    );
  }

  Widget _selectNumberCustomer() {
    return TextFieldWidget(
      mAttribute: "cus",
      mTextInputType: TextInputType.phone,
      mHindText: 'Number of Customer',
      mValidators: listValidators,
    );
  }

  void _onUpdateClicked() async {
    if (_fbKey.currentState.saveAndValidate()) {
      final day = _fbKey.currentState.fields['day'].currentState.value;
      final num = _fbKey.currentState.fields['num'].currentState.value;
      final cus = _fbKey.currentState.fields['cus'].currentState.value;
      final discountCode =
          _fbKey.currentState.fields['discount_code'].currentState.value;
      print(discountCode);
      if (day != null && num != null) {
        await requestBookParty(day, num, int.parse(cus), discountCode);
      } else {
        UiUtiu.showToast(message: 'Please fill all fields', isFalse: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Party'),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: FormBuilder(
          key: _fbKey,
          autovalidate: false,
          initialValue: {
            'day': twoDaysFromNow,
            'num': 5,
            'cus': '50',
            'discount_code': "",
          },
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.only(left: 36, right: 36),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 15.0),
                  _selectNumberTable(),
                  SizedBox(height: 15.0),
                  _showDatePicker(),
                  SizedBox(height: 15.0),
                  _selectNumberCustomer(),
                  SizedBox(height: 15.0),
                  TextFieldWidget(
                      mHindText: 'Discount Code', mAttribute: 'discount_code', mValidators: List(),),
                  SizedBox(
                    height: 15.0,
                  ),
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
    );
  }

  Future requestBookParty(
      DateTime day, int num, int cus, String discountCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    ScopedModel.of<CartModel>(context, rebuildOnChange: true).cart.forEach(
        (item) =>
            {listDish.add(ListDishes(id: item.id, numberDish: item.quantity))});

    var model = BookPartyRequestModel(
        dateParty: DateFormat(Constants.DATE_TIME_FORMAT_SERVER).format(day),
        numberTable: num,
        numberCustomer: cus,
        discountCode: discountCode,
        listDishes: listDish);
    var result = await AppApiService.create().bookParty(
      token: prefs.getString(Constants.USER_TOKEN),
      model: model,
    );
    if (result.isSuccessful) {
      ScopedModel.of<CartModel>(context).clearCart();
      UiUtiu.showToast(message: result.body.message);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => BookPartySuccessScreen(result.body.bill)));
    } else {
      BaseResponseModel model = BaseResponseModel.fromJson(result.error);
      UiUtiu.showToast(message: model.message, isFalse: true);
    }
  }
}
