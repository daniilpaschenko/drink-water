import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../user/domain/repositories/i_user_repository.dart';
import '../../domain/repositories/i_water_repository.dart';
import '../../domain/usecases/add_water_usecase.dart';
import '../../domain/usecases/remove_water_entry_usecase.dart';
import 'water_progress_bar.dart';
import 'water_cards_grid.dart';
import 'water_entry_tile.dart';
import '../../../../core/constants.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/di/injection.dart';

class HomeBody extends StatelessWidget {
  final Function(double) onSuccess;

  const HomeBody({super.key, required this.onSuccess});

  @override
  Widget build(BuildContext context) {
    final userRepo = context.watch<IUserRepository>();
    final waterRepo = context.watch<IWaterRepository>();
    final user = userRepo.currentUser!;
    final loc = AppLocalizations.of(context)!;

    final addWater = getIt<AddWaterUsecase>();
    final removeEntry = getIt<RemoveWaterEntryUsecase>();

    double screenW = MediaQuery.of(context).size.width;
    double titleSize = screenW * 0.04;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenW * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: screenW * 0.05),

            WaterProgressBar(
              drankLiters: waterRepo.drankLiters,
              dailyGoal: user.dailyGoal,
              width: screenW - (screenW * 0.1),
              lineHeight: screenW * 0.08,
              fontSize: screenW * 0.04,
            ),

            SizedBox(height: screenW * 0.04),
            Text(
              "${loc.hello}, ${user.name}!\n${loc.drankToday} ${waterRepo.drankLiters.toStringAsFixed(2)} ${loc.unitL} ${loc.outOf} ${user.dailyGoal.toStringAsFixed(2)} ${loc.unitL}",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: titleSize),
            ),

            SizedBox(height: screenW * 0.05),
            Text(
              loc.addWaterPrompt,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: titleSize),
            ),
            Text(
              loc.longPressToDelete,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: titleSize * 0.8,
                fontWeight: FontWeight.w300,
              ),
            ),

            SizedBox(height: screenW * 0.06),

            WaterCardsGrid(
              onCardTap: (card) async {
                await addWater(
                  card.liters,
                  cardTitle: card.title,
                  iconName: card.iconName,
                );
                onSuccess(card.liters);
              },
            ),

            SizedBox(height: screenW * 0.1),
            Text(loc.todayEntries, style: TextStyle(fontSize: titleSize)),

            if (waterRepo.todayEntries.isNotEmpty) ...[
              SizedBox(height: screenW * 0.02),
              ...waterRepo.todayEntries.asMap().entries.map((entry) {
                return WaterEntryTile(
                  entry: entry.value,
                  index: entry.key,
                  iconMap: appIcons,
                  onDelete: () => removeEntry(entry.key),
                );
              }),
            ],

            SizedBox(height: screenW * 0.1),
          ],
        ),
      ),
    );
  }
}
