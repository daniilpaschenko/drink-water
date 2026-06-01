import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../domain/entities/water_entry.dart';
import '../../../../core/l10n/app_localizations.dart';

class WaterEntryTile extends StatelessWidget {
  final WaterEntry entry;
  final int index;
  final VoidCallback onDelete;
  final Map<String, dynamic> iconMap;

  const WaterEntryTile({
    super.key,
    required this.entry,
    required this.index,
    required this.onDelete,
    required this.iconMap,
  });

  @override
  Widget build(BuildContext context) {
    double screenW = MediaQuery.of(context).size.width;
    double titleSize = screenW * 0.04;
    final loc = AppLocalizations.of(context)!;
    final icon = iconMap[entry.iconName] ?? FontAwesomeIcons.droplet;
    final time = "${entry.time.hour.toString().padLeft(2, '0')}:${entry.time.minute.toString().padLeft(2, '0')}";
    final ml = (entry.liters * 1000).toInt();

    return Container(
      margin: EdgeInsets.symmetric(vertical: screenW * 0.01),
      padding: EdgeInsets.symmetric(horizontal: screenW * 0.04, vertical: screenW * 0.03),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color.fromARGB(255, 15, 11, 218))
      ),
      child: Row(
        children: [
          // иконка
          FaIcon(icon, color: const Color.fromARGB(255, 15, 11, 218), size: screenW * 0.06),
          SizedBox(width: screenW * 0.03),
          // название и объём
          Expanded(
            child: Text(
              "${entry.cardTitle} — $ml ${loc.unitMl}",
              style: TextStyle(fontSize: titleSize),
            ),
          ),
          // время
          Text(
            time,
            style: TextStyle(fontSize: titleSize * 0.85, color: Colors.grey),
          ),
          SizedBox(width: screenW * 0.02),
          // иконка удаления
          IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.red, size: screenW * 0.06),
            onPressed: onDelete,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}