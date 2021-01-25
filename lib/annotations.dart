class UForm {
  const UForm();
}

class UFormField {
  final String validator;
  final String fieldName;

  const UFormField({this.fieldName, this.validator});
}

const VALIDATOR = 'validator';
const FIELD_NAME = 'fieldName';
