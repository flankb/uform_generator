// Copyright (c) 2018, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
//import 'package:flutter/foundation.dart';
//import 'package:flutter/cupertino.dart';
import 'package:source_gen/source_gen.dart';

import 'annotations.dart';

class FormGenerator extends GeneratorForAnnotation<UForm> {
  @override
  String generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    //throw Exception("Нуну!");
    //return "final i = 78;";

    if (element.kind != ElementKind.CLASS) {
      throw Exception("Это не класс!");
    }

    final formClass = element as ClassElement;

    final formName = formClass.name;

    //StringBuffer fieldsBuffer = StringBuffer();

    List<String> fields = [];
    List<String> controllers = [];
    List<String> controllersInit = [];
    List<String> controllersFallback = [];

    // List controllers,
    //List controllerInit, List controllersFallback

    formClass.fields.forEach((elementField) {
      // Form field available types:
      // String
      // double
      // int
      // DateTime

      // debugPrint("Ttt " + elementField.type.toString());

      //final classElement = elementField.type.element as ClassElement;

      Type fieldType;

      if (elementField.type.isDartCoreString) {
        fieldType = String;
      } else if (elementField.type.isDartCoreInt) {
        fieldType = int;
      } else if (elementField.type.isDartCoreDouble) {
        fieldType = double;
      } else if (TypeChecker.fromRuntime(DateTime)
          .isExactlyType(elementField.type)) {
        fieldType = DateTime;
      } else {
        throw Exception('Unsupported type!');
      }

      final fieldName = elementField.name;
      //fieldsBuffer.writeln(_buildTextFieldForm(textFieldName));

      if (fieldType == DateTime) {
        fields.add(_buildDateTimeFieldForm(fieldName));
      } else {
        fields.add(_buildTextFieldForm(fieldName, fieldType));
      }

      controllers.add(_buildControllerDefinition(fieldName));
      controllersInit.add(_buildControllerInit(fieldName, fieldType));
      controllersFallback.add(_buildFallbackItem(fieldName, fieldType));
    });

    //final formCode = _buildTemplate(formName, fieldsBuffer.toString());

    final formCode = _buildFormTemplate(
        formName, fields, controllers, controllersInit, controllersFallback);

    //return '/*' + formCode + '*/';
    return formCode;
  }
}

String _buildTextFieldForm(String fieldName, Type fieldType) {
  final keyboard = fieldType == int || fieldType == double
      ? '''inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          keyboardType: TextInputType.number,'''
      : '';

  final field = '''
    TextFormField(
                decoration: const InputDecoration(
                  labelText: '$fieldName',
                ),
                $keyboard
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
  ''';

  return field;
}

String _buildDateTimeFieldForm(String fieldName) {
  final field = '''
   DateTimeField(
            format: format,
            controller: _${fieldName}TextEditingController,
            decoration: const InputDecoration(
              labelText: '$fieldName',
            ),
            validator: (value) {
              if (value.isBefore(DateTime(2001, 10, 10))) {
                return 'Low date!';
              }

              return null;
            },
            onShowPicker: (context, currentValue) {
              return showDatePicker(
                  context: context,
                  firstDate: DateTime(1900),
                  initialDate: currentValue ?? DateTime.now(),
                  lastDate: DateTime(2100));
            },
          ),
  ''';

  return field;
}

String _buildControllerDefinition(String fieldName) {
  return '''TextEditingController _${fieldName}TextEditingController;''';
}

String _buildControllerInit(String fieldName, Type fieldType) {
  switch (fieldType) {
    case int:
    case double:
      return '''_${fieldName}TextEditingController = 
                    TextEditingController(text: widget.formModel.$fieldName.toString());''';

    case String:
      return '''_${fieldName}TextEditingController =
        TextEditingController(text: widget.formModel.$fieldName);''';

    case DateTime:
      return '''_${fieldName}TextEditingController =
        TextEditingController(text: format.format(widget.formModel.$fieldName));''';
  }

  return '';
}

String _buildFallbackItem(String fieldName, Type fieldType) {
  switch (fieldType) {
    case int:
      return 'int.parse(_${fieldName}TextEditingController.value.text)';

    case double:
      return 'double.parse(_${fieldName}TextEditingController.value.text)';

    case String:
      return '_${fieldName}TextEditingController.value.text';

    case DateTime:
      return 'format.parse(_${fieldName}TextEditingController.value.text)';
  }

  return '';
}

String _buildFormTemplate(String formName, List fields, List controllers,
    List controllerInit, List controllersFallback) {
  final formTemplate = '''
class ${formName}Form extends StatefulWidget {
  final $formName formModel;
  final Function($formName carForm) callback;

  CarFormForm({Key key, this.formModel, this.callback}) : super(key: key);

  @override
  _${formName}FormState createState() => _${formName}FormState();
}

class _${formName}FormState extends State<${formName}Form> {
  final _formKey = GlobalKey<FormState>();
  final format = DateFormat("yyyy-MM-dd");
  
  ${controllers.join('\n')}

  @override
  void initState() {
    super.initState();

    ${controllerInit.join('\n')}
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ${fields.join('\n')}
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  final newFormModel = $formName(${controllersFallback.join(',\n')});

                  widget.callback(newFormModel);
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
''';

  return formTemplate;
}

//final f = ;
