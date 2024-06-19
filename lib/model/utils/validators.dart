String? onlyEnglishDigitsAndSomeSpecial(String value) {
  var re = RegExp(r"^[a-zA-Z\d$@!%]+$");
  if (!re.hasMatch(value)) {
    return "Поле может содержать только английские буквы, цифры, \$, @, !, %";
  }
  return null;
}

String? onlyEnglishAndDigits(String value) {
  var re = RegExp(r"^[a-zA-Z\d]+$");
  if (!re.hasMatch(value)) {
    return "Поле может содержать только английские буквы и цифры";
  }
  return null;
}

String? onlyWordsAndDash(String value) {
  var re = RegExp(r"^[a-zA-ZА-Яа-яеё-]+$");
  if (!re.hasMatch(value)) {
    return "Поле может содержать только буквы и дефис";
  }
  return null;
}

String? surnameValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return "Поле обязательное";
  }

  var contentCheck = onlyWordsAndDash(value);
  if (contentCheck != null) {
    return contentCheck;
  }

  if (value.length > 512) {
    return "Фамилия не должна быть длиннее 512 символов";
  }
  return null;
}

String? nameValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return "Поле обязательное";
  }

  var contentCheck = onlyWordsAndDash(value);
  if (contentCheck != null) {
    return contentCheck;
  }

  if (value.length > 512) {
    return "Имя не должно быть длиннее 512 символов";
  }
  return null;
}

String? patronymicValidator(String? value) {
  if (value != null && value.length > 512) {
    return "Отчество не должно быть длиннее 512 символов";
  }

  if (!(value == null || value.trim().isEmpty)) {
    var contentCheck = onlyWordsAndDash(value);
    if (contentCheck != null) {
      return contentCheck;
    }
  }
  return null;
}