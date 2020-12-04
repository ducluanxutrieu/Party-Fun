import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:party_booking/res/constants.dart';
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
          name: 'name',
          mHindText: 'Dish name',
          mValidators: FormBuilderValidators.compose([FormBuilderValidators.required(context)]),
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
              name: 'description',
              style: kPrimaryTextStyle,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  labelText: 'Description',
                  contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32))),
              validator: FormBuilderValidators.compose([FormBuilderValidators.required(context),]),),
        ),
        SizedBox(
          height: 15,
        ),
        _selectDishType(context),
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: sizeWidth * 0.5,
              child: TextFieldWidget(
                name: 'price',
                mHindText: 'Price',
                mValidators: FormBuilderValidators.compose([FormBuilderValidators.required(context)]),
                mTextInputType: TextInputType.number,
              ),
            ),
            Container(
              width: sizeWidth * 0.45,
              child: TextFieldWidget(
                name: 'discount',
                mHindText: 'Discount(%)',
                mValidators: FormBuilderValidators.compose([FormBuilderValidators.required(context), FormBuilderValidators.max(context, 100)]),
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

    Widget _selectDishType(BuildContext context) {
    return FormBuilderFilterChip(
      name: "type",
      decoration: InputDecoration(
          labelText: "Dish Type",
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32))),
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