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

// TODO Интересные поля формы:
// https://pub.dev/packages/dropdown_formfield
// https://pub.dev/packages/datetime_picker_formfield
// https://pub.dev/packages/checkbox_formfield

// TODO Генераторы форм:
// https://pub.dev/packages/reactive_forms
// https://pub.dev/packages/flutter_form_builder/

// TODO В каждом поле есть метод onSave

// TODO М.б. лучше использовать  onSaved: (value) => _note = value, где _note - это поле внутри state
// Тогда можно не использовать TextEditingController

// class PrototypeCarForm extends StatelessWidget {
//   final _formKey = GlobalKey<FormState>();

// Пример из todo, при сабмите форм (автора flutter_bloc):
/*
                          if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          widget.onSave(_task, _note);
                          Navigator.pop(context);
                  }
                  */

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           TextFormField(
//             decoration: const InputDecoration(
//               labelText: 'name',
//             ),
//             validator: (value) {
//               if (value.isEmpty) {
//                 return 'Please enter some text';
//               }
//               return null;
//             },
//           ),
//           TextFormField(
//             decoration: const InputDecoration(
//               labelText: 'power',
//             ),
//             validator: (value) {
//               if (value.isEmpty) {
//                 return 'Please enter some text';
//               }
//               return null;
//             },
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 16.0),
//             child: ElevatedButton(
//               onPressed: () {
//                 if (_formKey.currentState.validate()) {}
//               },
//               child: Text('Submit'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// GENERATED CODE - DO NOT MODIFY BY HAND

// part of 'car_form.dart';

// // **************************************************************************
// // FormGenerator
// // **************************************************************************

// class CarFormForm extends StatefulWidget {
//   final CarForm formModel;
//   final Function(CarForm carForm) callback;

//   CarFormForm({Key key, this.formModel, this.callback}) : super(key: key);

//   @override
//   _CarFormFormState createState() => _CarFormFormState();
// }

// class _CarFormFormState extends State<CarFormForm> {
//   final _formKey = GlobalKey<FormState>();
//   TextEditingController _nameTextEditingController;
//   TextEditingController _powerTextEditingController;
//   TextEditingController _orderDateTextEditingController;

//   final format = DateFormat("yyyy-MM-dd");

//   @override
//   void initState() {
//     super.initState();

//     _nameTextEditingController =
//         TextEditingController(text: widget.formModel.name);
//     _powerTextEditingController =
//         TextEditingController(text: widget.formModel.power.toString());

//     _orderDateTextEditingController =
//         TextEditingController(text: format.format(widget.formModel.orderDate));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           TextFormField(
//             controller: _nameTextEditingController,
//             decoration: const InputDecoration(
//               labelText: 'name',
//             ),
//             validator: (value) {
//               if (value.isEmpty) {
//                 return 'Please enter some text';
//               }
//               return null;
//             },
//           ),
//           TextFormField(
//             controller: _powerTextEditingController,
//             decoration: const InputDecoration(
//               labelText: 'power',
//             ),
//             validator: (value) {
//               if (value.isEmpty) {
//                 return 'Please enter some text';
//               }

//               return null;
//             },
//           ),
//           DateTimeField(
//             format: format,
//             controller: _orderDateTextEditingController,
//             decoration: const InputDecoration(
//               labelText: 'date',
//             ),
//             validator: (value) {
//               if (value.isBefore(DateTime(2001, 10, 10))) {
//                 return 'Low date!';
//               }

//               return null;
//             },
//             onShowPicker: (context, currentValue) {
//               return showDatePicker(
//                   context: context,
//                   firstDate: DateTime(1900),
//                   initialDate: currentValue ?? DateTime.now(),
//                   lastDate: DateTime(2100));
//             },
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 16.0),
//             child: ElevatedButton(
//               onPressed: () {
//                 if (_formKey.currentState.validate()) {
//                   // Нужно вернуть измененную модель вызывающему коду
//                   final newFormModel = CarForm(
//                       _nameTextEditingController.value.text,
//                       int.parse(_powerTextEditingController.value.text),
//                       format.parse(_orderDateTextEditingController.value.text));

//                   widget.callback(newFormModel);
//                 }
//               },
//               child: Text('Submit'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
