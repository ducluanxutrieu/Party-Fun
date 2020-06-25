import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:party_booking/widgets/common/text_field.dart';

class FormModifyDish extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      TextStyle mStyle = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
      double sizeWidth = (MediaQuery.of(context).size.width - 30);

    return Column(
      children: <Widget>[
        SizedBox(
          height: 15,
        ),
        TextFieldWidget(
          mAttribute: 'name',
          mHindText: 'Dish name',
          mValidators: [FormBuilderValidators.required()],
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
              style: mStyle,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  labelText: 'Description',
                  contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32))),
              validators: [FormBuilderValidators.required()]),
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
                mValidators: [FormBuilderValidators.required()],
                mTextInputType: TextInputType.number,
              ),
            ),
            Container(
              width: sizeWidth * 0.45,
              child: TextFieldWidget(
                mAttribute: 'discount',
                mHindText: 'Discount(%)',
                mValidators: [FormBuilderValidators.required(), FormBuilderValidators.max(100)],
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
      validators: [FormBuilderValidators.required()],
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