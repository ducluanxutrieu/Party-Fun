import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class StaticVariable{
  //Variable
  static List<FormFieldValidator> listValidatorsRequired = <FormFieldValidator>[
    FormBuilderValidators.required(),
  ];

  static List<FormFieldValidator> listValidatorsMinSix = <FormFieldValidator>[
    FormBuilderValidators.required(),
    FormBuilderValidators.minLength(6, errorText: 'Value must have at least 6 characters')
  ];
}