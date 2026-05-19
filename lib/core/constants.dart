import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const Map<String, dynamic> appIcons = {
  "droplet": FontAwesomeIcons.droplet,
  "glass": FontAwesomeIcons.glassWater,
  "bottle": FontAwesomeIcons.bottleWater,
  "mug": FontAwesomeIcons.mugHot,
  "bucket": FontAwesomeIcons.bucket,
  "plate": FontAwesomeIcons.bowlFood,
};

const Map<String, String> iconLabels = {
  "droplet": "Капля",
  "glass": "Стакан",
  "bottle": "Бутылка",
  "mug": "Кружка",
  "bucket": "Ведро",
  "plate": "Тарелка",
};

const defaultIcon = FontAwesomeIcons.glassWater;

final List<Map<String, String>> faq = [
  {
    "question": "Как работает счётчик воды?",
    "answer": "Счётчик выпитой воды сбрасывается автоматически каждый день в полночь."
  },
  {
    "question": "Можно ли добавить свою тару?",
    "answer": "Да! На главном экране нажмите карточку 'Новая тара' и введите название и объём. Для удаления — долгое нажатие на карточку."
  },
];

String translateFirebaseError(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Неверный формат email';
      case 'too-many-requests':
        return 'Слишком много попыток. Попробуйте позже';
      case 'network-request-failed':
        return 'Проблема с подключением к интернету';
      case 'expired-action-code':
        return 'Ссылка устарела. Запросите новую';
      case 'invalid-action-code':
        return 'Неверная или уже использованная ссылка';
      default:
        return 'Ошибка: $code';
    }
  }