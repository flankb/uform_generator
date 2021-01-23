// Copyright (c) 2018, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
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

    StringBuffer fieldsBuffer = StringBuffer();

    formClass.fields.forEach((elementField) {
      final textFieldName = elementField.name;
      fieldsBuffer.writeln(_buildTextFieldForm(textFieldName));
    });

    final formCode = _buildTemplate(formName, fieldsBuffer.toString());

    return formCode;
  }
}

String _buildTextFieldForm(String fieldName) {
  final field = '''
    TextFormField(
                decoration: const InputDecoration(
                  labelText: '$fieldName',
                ),
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

String _buildTemplate(String formName, String fields) {
  final formTemplate = '''class ${formName}Form extends StatelessWidget {
      final _formKey = GlobalKey<FormState>();

      @override
      Widget build(BuildContext context) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              $fields
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                    }
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        );
      }
    }''';

  return formTemplate;
}
