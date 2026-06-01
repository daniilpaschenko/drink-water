import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/appbar.dart';
import '../../../../core/l10n/locale_provider.dart';
import '../../../../core/l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final localeProvider = context.watch<LocaleProvider>();
    final screenW = MediaQuery.of(context).size.width;
    final titleSize = screenW * 0.05;

    return Scaffold(
      appBar: buildMainAppBar(context: context, isSettingsEnabled: false),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenW * 0.05),
        child: Column(
          children: [
            SizedBox(height: screenW * 0.05),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(loc.chooseLanguage, style: TextStyle(fontSize: titleSize)),
                SizedBox(height: screenW * 0.05),
                SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<String>(
                    segments: [
                      ButtonSegment(value: 'ru', label: Text(loc.russian)),
                      ButtonSegment(value: 'en', label: Text(loc.english)),
                    ],
                    selected: {localeProvider.currentLocale.languageCode},
                    onSelectionChanged: (val) {
                      localeProvider.setLocale(Locale(val.first));
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
