import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/info_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/account_screen.dart';
import '../screens/history_screen.dart';

PreferredSizeWidget buildMainAppBar({
  required BuildContext context,
  bool isAccountEnabled = true, // управляет кнопкой аккаунта
  bool isSettingsEnabled = true, // управляет кнопкой настроек
  bool isInfoEnabled = true, // управляет кнопкой инфо
  bool isHistoryEnabled = true, // управляет уведомлениями
  bool isHomeEnabled = true,
}) {
  double screenW = MediaQuery.of(context).size.width;
  double titleSize = screenW * 0.04;
  return PreferredSize(
    preferredSize: Size.fromHeight(screenW * 0.1),
    child: AppBar(
      toolbarHeight: screenW * 0.1,
      backgroundColor: const Color.fromARGB(255, 15, 11, 218),
      foregroundColor: Colors.white,
      centerTitle: true,
      title: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: isHomeEnabled
              ? () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                  (route) => false,
                )
              : null,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              "Drink Water",
              style: TextStyle(
                fontSize: titleSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
      leadingWidth: screenW * 0.25,
      leading: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              iconSize: screenW * 0.05,
              onPressed: isAccountEnabled
                  ? () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const AccountScreen()),
                      (route) => false,
                    )
                  : null,
              icon: const Icon(Icons.account_box_rounded),
            ),
            IconButton(
              iconSize: screenW * 0.05,
              onPressed: isHistoryEnabled
                  ? () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const HistoryScreen()),
                      (route) => false,
                    )
                  : null,
              icon: const Icon(Icons.calendar_month),
            ),
          ],
        ),
      ),
      actions: [
        Center(
          child: IconButton(
            iconSize: screenW * 0.05,
            onPressed: isInfoEnabled
                ? () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const InfoScreen()),
                    (route) => false,
                  )
                : null,
            icon: const Icon(Icons.info),
          ),
        ),
        Center(
          child: IconButton(
            iconSize: screenW * 0.05,
            onPressed: isSettingsEnabled
                ? () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                    (route) => false,
                  )
                : null,
            icon: const Icon(Icons.settings),
          ),
        ),
      ],
    ),
  );
}
