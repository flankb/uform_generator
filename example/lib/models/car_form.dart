import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'package:uform_generator/annotations.dart';

part 'car_form.g.dart';

@UForm()
class CarForm {
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
