import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:uform_generator/annotations.dart';

part 'car_form.g.dart';

@UForm()
class CarForm {
  final String name;
  final int power;

  CarForm(this.name, this.power);

  @override
  String toString() => 'CarForm(name: $name, power: $power)';
}

// TODO В каждом поле есть метод onSave

// class PrototypeCarForm extends StatelessWidget {
//   final _formKey = GlobalKey<FormState>();

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
