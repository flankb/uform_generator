import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';

import 'models/car_form.dart';

class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  CarForm _formModel;

  @override
  void initState() {
    super.initState();

    _formModel = CarForm("Bmw M3", 350);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Order car'),
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CarFormForm(
              formModel: _formModel,
              callback: (CarForm car) {
                Navigator.pop(context, car);
              },
            ),
          ),
        ));
  }
}
