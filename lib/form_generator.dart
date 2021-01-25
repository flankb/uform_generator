import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'utils.dart';
import 'annotations.dart';

class FormGenerator extends GeneratorForAnnotation<UForm> {
  @override
  String generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element.kind != ElementKind.CLASS) {
      throw Exception("This is not a class!");
    }

    final formClass = element as ClassElement;

    final formName = formClass.name;

    //StringBuffer fieldsBuffer = StringBuffer();

    List<String> fields = [];
    List<String> controllers = [];
    List<String> controllersInit = [];
    List<String> controllersFallback = [];

    formClass.fields.forEach((FieldElement elementField) {
      //final classElement = elementField.type.element as ClassElement;

      var validator;
      var fieldName = elementField.name;
      var fieldCaption = elementField.name;

      if (elementField.hasAnnotation(UFormField)) {
        final uformObject = elementField.getAnnotation(UFormField);

        // 1. Get field name
        fieldCaption = uformObject.getField(FIELD_NAME).toStringValue();

        // 2. Get validator
        validator = uformObject.getField(VALIDATOR).toStringValue();
      }

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

      if (fieldType == DateTime) {
        fields.add(_buildDateTimeFieldForm(fieldName, fieldCaption, validator));
      } else {
        fields.add(
            _buildTextFieldForm(fieldName, fieldType, fieldCaption, validator));
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

String _buildValidatorDefinition(String validator) {
  return validator == null || validator == ''
      ? ''
      : '''validator: $validator,
  ''';
}

String _buildTextFieldForm(
    String fieldName, Type fieldType, String captionField, String validator) {
  final keyboard = fieldType == int || fieldType == double
      ? '''inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          keyboardType: TextInputType.number,'''
      : '';

  final validatorDef = _buildValidatorDefinition(validator);

  final field = '''
    TextFormField(
                controller: _${fieldName}TextEditingController,
                decoration: const InputDecoration(
                  labelText: '$captionField',
                ),
                $keyboard
                $validatorDef
              ),
  ''';

  return field;
}

String _buildDateTimeFieldForm(
    String fieldName, String captionField, String validator) {
  final validatorDef = _buildValidatorDefinition(validator);

  final field = '''
   DateTimeField(
            format: format,
            controller: _${fieldName}TextEditingController,
            decoration: const InputDecoration(
              labelText: '$captionField',
            ),
            $validatorDef
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
