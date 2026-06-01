import 'package:flutter/material.dart';
import '../../../../core/widgets/appbar.dart';
import '../../../../core/constants.dart';
import '../../../../core/widgets/info_section.dart';
import '../../../../core/widgets/faq_item.dart';
import '../../../../core/l10n/app_localizations.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenW = MediaQuery.of(context).size.width;
    double titleSize = screenW * 0.04;
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: buildMainAppBar(context: context, isInfoEnabled: false),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenW * 0.05),
          child: Column(
            children: [
              SizedBox(height: screenW * 0.02),

              InfoSection(
                title: loc.aboutApp,
                titleSize: titleSize,
                screenW: screenW,
                child: _buildAboutText(titleSize, loc),
              ),

              InfoSection(
                title: loc.dailyGoalFormula,
                titleSize: titleSize,
                screenW: screenW,
                child: _buildFormulaSection(titleSize, screenW, loc),
              ),

              InfoSection(
                title: loc.faq,
                titleSize: titleSize,
                screenW: screenW,
                child: Column(
                  children: getFaq(loc).map((item) => FaqItem(
                    question: item["question"]!,
                    answer: item["answer"]!,
                    titleSize: titleSize,
                    screenW: screenW,
                  )).toList(),
                ),
              ),

              InfoSection(
                title: loc.devContacts,
                titleSize: titleSize,
                screenW: screenW,
                child: _buildContacts(titleSize, loc),
              ),

              SizedBox(height: screenW * 0.05),
              Center(
                child: Text(
                  loc.drinkWaterSlogan,
                  style: TextStyle(
                    fontSize: titleSize * 0.75,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(height: screenW * 0.05),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAboutText(double titleSize, AppLocalizations loc) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(
          fontSize: titleSize,
          fontWeight: FontWeight.w300,
          color: Colors.black,
          fontFamily: 'Rubik',
        ),
        children: [
          TextSpan(
            text: loc.appTitle,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: loc.aboutAppText),
        ],
      ),
    );
  }

  Widget _buildFormulaSection(double titleSize, double screenW, AppLocalizations loc) {
    return Column(
      children: [
        Text(
          loc.formulaRule,
          style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: screenW * 0.02),
        Text(
          loc.formulaExample,
          style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.w300),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: screenW * 0.02),
        Text(
          loc.formulaLimits,
          style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.w300),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildContacts(double titleSize, AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(loc.telegram,
            style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.w300)),
        const SizedBox(height: 12),
        Text(loc.github,
            style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.w300)),
      ],
    );
  }
}