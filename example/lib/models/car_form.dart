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

FormFieldValidator<DateTime> validatorDate = (value) {
  if (value.isBefore(DateTime(2001, 10, 10))) {
    return 'Low date!';
  }

  return null;
};

@UForm()
class CarForm {
  @UFormField(validator: 'validatorNotEmpty', fieldName: 'Модель машины:')
  final String name;

  final int power;
  final DateTime orderDate;

  CarForm(this.name, this.power, this.orderDate);

  @override
  String toString() =>
      'CarForm(name: $name, power: $power, orderDate: $orderDate)';
}
