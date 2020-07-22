import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:party_booking/res/constants.dart';
import 'package:party_booking/res/static_variable.dart';
import 'package:party_booking/widgets/common/text_field.dart';

class FormModifyDish extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      double sizeWidth = (MediaQuery.of(context).size.width - 30);

    return Column(
      children: <Widget>[
        SizedBox(
          height: 15,
        ),
        TextFieldWidget(
          mAttribute: 'name',
          mHindText: 'Dish name',
          mValidators: StaticVariable.listValidatorsRequired,
        ),
        SizedBox(
          height: 15,
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 300,
            maxWidth: double.infinity,
          ),
          child: FormBuilderTextField(
              attribute: 'description',
              style: kPrimaryTextStyle,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  labelText: 'Description',
                  contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32))),
              validators: StaticVariable.listValidatorsRequired),
        ),
        SizedBox(
          height: 15,
        ),
        _selectDishType(),
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: sizeWidth * 0.5,
              child: TextFieldWidget(
                mAttribute: 'price',
                mHindText: 'Price',
                mValidators: StaticVariable.listValidatorsRequired,
                mTextInputType: TextInputType.number,
              ),
            ),
            Container(
              width: sizeWidth * 0.45,
              child: TextFieldWidget(
                mAttribute: 'discount',
                mHindText: 'Discount(%)',
                mValidators: [...StaticVariable.listValidatorsRequired, FormBuilderValidators.max(100)],
                mTextInputType: TextInputType.number,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }

    Widget _selectDishType() {
    return FormBuilderCheckboxList(
      attribute: "type",
      decoration: InputDecoration(
          labelText: "Dish Type",
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32))),
      validators: StaticVariable.listValidatorsRequired,
      options: [
        FormBuilderFieldOption(value: "Holiday Offers"),
        FormBuilderFieldOption(value: "First Dishes"),
        FormBuilderFieldOption(value: "Main Dishes"),
        FormBuilderFieldOption(value: "Seafood"),
        FormBuilderFieldOption(value: "Drinks"),
        FormBuilderFieldOption(value: "Dessert"),
      ],
    );
  }
}