import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:formz/formz.dart';
import 'package:intl/intl.dart';
import 'package:party_booking/cart/cart_bloc.dart';
import 'package:party_booking/data/network/model/book_party_request_model.dart';
import 'package:party_booking/res/constants.dart';
import 'package:party_booking/ui/book_party_success_screen.dart';
import 'package:party_booking/widgets/common/app_button.dart';
import 'package:party_booking/widgets/common/text_field.dart';
import 'package:party_booking/widgets/common/utiu.dart';

class BookPartyScreen extends StatelessWidget {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  final twoDaysFromNow = new DateTime.now().add(new Duration(days: 2));

  final List<ListDishes> listDish = new List();

  Widget _showDatePicker() {
    return FormBuilderDateTimePicker(
      name: "day",
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

  Widget _selectNumberTable(BuildContext context) {
    return FormBuilderDropdown(
      name: "num",
      style: TextStyle(
          fontFamily: 'Montserrat', fontSize: 20.0),
      decoration: InputDecoration(
          labelText: "Number of Table",
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32))),
      // initialValue: 'Male',
      hint: Text(
        'Number Tables',
        style: kPrimaryTextStyle,
      ),
      validator: FormBuilderValidators.compose([FormBuilderValidators.required(context)]),
      items: List.generate(15, (generator) => generator + 1)
          .map((item) => DropdownMenuItem(value: item, child: Text("$item")))
          .toList(),
    );
  }

  Widget _selectNumberCustomer(BuildContext context) {
    return TextFieldWidget(
      name: "cus",
      mTextInputType: TextInputType.phone,
      mHindText: 'Number of Customer',
      mValidators: FormBuilderValidators.compose([FormBuilderValidators.required(context)]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Party'),
      ),
      body: BlocListener<CartBloc, CartState>(
        listenWhen: (previous, current) => (previous.status != current.status ||
            previous.message != current.message),
        listener: (context, state) {
          if (state.status == FormzStatus.submissionSuccess) {
            UiUtiu.showToast(message: state.message);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) => BookPartySuccessScreen(state.bill)));
          } else if (state.message.isNotEmpty) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(state.message)),
              );
          }
        },
        child: Center(
          child: FormBuilder(
            key: _fbKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            initialValue: {
              'day': twoDaysFromNow,
              'num': 5,
              'cus': '50',
              'discount_code': "",
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 36, right: 36),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: 15.0),
                    _selectNumberTable(context),
                    SizedBox(height: 15.0),
                    _showDatePicker(),
                    SizedBox(height: 15.0),
                    _selectNumberCustomer(context),
                    SizedBox(height: 15.0),
                    TextFieldWidget(
                      mHindText: 'Discount Code',
                      name: 'discount_code',
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    BookButton(
                      fbKey: _fbKey,
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

class BookButton extends StatelessWidget {
  const BookButton({Key key, @required GlobalKey<FormBuilderState> fbKey})
      : assert(fbKey != null),
        _fbKey = fbKey,
        super(key: key);

  final GlobalKey<FormBuilderState> _fbKey;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      buildWhen: (previous, current) => (previous.status != current.status),
      builder: (context, state) {
        return AppButtonWidget(
          buttonText: 'Book',
          buttonHandler: () => _onUpdateClicked(context),
          stateButton: state.status,
        );
      },
    );
  }

  void _onUpdateClicked(BuildContext context) {
    if (_fbKey.currentState.saveAndValidate()) {
      final day = _fbKey.currentState.fields['day'].value;
      final num = _fbKey.currentState.fields['num'].value;
      final cus = _fbKey.currentState.fields['cus'].value;
      final discountCode =
          _fbKey.currentState.fields['discount_code'].value;
      print(discountCode);
      if (day != null && num != null) {
        print(day);
        print(num);
        print(cus);
        print(discountCode);
        BlocProvider.of<CartBloc>(context).add(BookClickedEvent(
            partyDate: day,
            numberOfTable: num,
            numberOfCustomer: int.parse(cus),
            discountCode: discountCode));
      } else {
        UiUtiu.showToast(message: 'Please fill all fields', isFalse: true);
      }
    }
  }
}
