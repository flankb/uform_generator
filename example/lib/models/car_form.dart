import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'package:uform_generator/annotations.dart';

part 'car_form.g.dart';

FormFieldValidator<String> validatorNotEmpty = (value) {
  if (value.isEmpty) {
    return 'Please enter some text';
  }
  return null;
};

FormFieldValidator<String> validatorNoZero = (value) {
  final parsedDigit = num.tryParse(value);

  if (parsedDigit == null) {
    return 'Parsing error!';
  }

  if (parsedDigit <= 0) {
    return 'Value must be more than 0!';
  }

  return null;
};

FormFieldValidator<DateTime> validatorDate = (value) {
  if (value == null) {
    return "Value must not be a null!";
  }

  if (value.isBefore(DateTime(2001, 10, 10))) {
    return 'Low date!';
  }

  return null;
};

@UForm()
class CarForm {
  @UFormField(validator: 'validatorNotEmpty', fieldName: 'Model of car')
  final String name;

  @UFormField(validator: 'validatorNoZero', fieldName: 'Engine power')
  final int power;

  @UFormField(validator: 'validatorDate', fieldName: 'Order date')
  final DateTime orderDate;

  @UFormField(validator: 'validatorNoZero', fieldName: 'Mass')
  final double mass;

  CarForm(this.name, this.power, this.orderDate, this.mass);

  @override
  String toString() {
    return 'CarForm(name: $name, power: $power, orderDate: $orderDate, mass: $mass)';
  }
}
