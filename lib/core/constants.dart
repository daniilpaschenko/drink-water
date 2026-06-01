import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'l10n/app_localizations.dart';

const Map<String, dynamic> appIcons = {
  "droplet": FontAwesomeIcons.droplet,
  "glass": FontAwesomeIcons.glassWater,
  "bottle": FontAwesomeIcons.bottleWater,
  "mug": FontAwesomeIcons.mugHot,
  "bucket": FontAwesomeIcons.bucket,
  "plate": FontAwesomeIcons.bowlFood,
};

const defaultIcon = FontAwesomeIcons.glassWater;

Map<String, String> getIconLabels(AppLocalizations loc) => {
  "droplet": loc.iconDroplet,
  "glass": loc.iconGlass,
  "bottle": loc.iconBottle,
  "mug": loc.iconMug,
  "bucket": loc.iconBucket,
  "plate": loc.iconPlate,
};

List<Map<String, String>> getFaq(AppLocalizations loc) => [
  {
    "question": loc.faqQuestion1,
    "answer": loc.faqAnswer1,
  },
  {
    "question": loc.faqQuestion2,
    "answer": loc.faqAnswer2,
  },
];

String translateFirebaseError(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Invalid email format';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      case 'network-request-failed':
        return 'No internet connection';
      case 'expired-action-code':
        return 'The link has expired. Please request a new one';
      case 'invalid-action-code':
        return 'Invalid or already used link';
      default:
        return 'Error: $code';
    }
  }
