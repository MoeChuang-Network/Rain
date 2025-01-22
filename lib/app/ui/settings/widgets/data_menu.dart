
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:rain/app/ui/settings/widgets/setting_card.dart';
import 'package:rain/main.dart';
import 'package:rain/app/data/db.dart';

void dataMenu(context, weatherController) async {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom),
        child: StatefulBuilder(
          builder: (BuildContext context, setState) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      'data'.tr,
                      style: context.textTheme.titleLarge?.copyWith(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SettingCard(
                    elevation: 4,
                    icon: const Icon(IconsaxPlusLinear.cloud_notif),
                    text: 'roundDegree'.tr,
                    switcher: true,
                    value: settings.roundDegree,
                    onChange: (value) {
                      settings.roundDegree = value;
                      isar.writeTxnSync(
                            () => isar.settings.putSync(settings),
                      );
                      MyApp.updateAppState(
                        context,
                        newRoundDegree: value,
                      );
                      setState(() {});
                    },
                  ),
                  SettingCard(
                    elevation: 4,
                    icon: const Icon(IconsaxPlusLinear.sun_1),
                    text: 'degrees'.tr,
                    dropdown: true,
                    dropdownName: settings.degrees.tr,
                    dropdownList: <String>[
                      'celsius'.tr,
                      'fahrenheit'.tr
                    ],
                    dropdownChange: (String? newValue) async {
                      isar.writeTxnSync(() {
                        settings.degrees = newValue == 'celsius'.tr
                            ? 'celsius'
                            : 'fahrenheit';
                        isar.settings.putSync(settings);
                      });
                      await weatherController.deleteAll(false);
                      await weatherController.setLocation();
                      await weatherController.updateCacheCard(true);
                      setState(() {});
                    },
                  ),
                  SettingCard(
                    elevation: 4,
                    icon: const Icon(IconsaxPlusLinear.rulerpen),
                    text: 'measurements'.tr,
                    dropdown: true,
                    dropdownName: settings.measurements.tr,
                    dropdownList: <String>[
                      'metric'.tr,
                      'imperial'.tr
                    ],
                    dropdownChange: (String? newValue) async {
                      isar.writeTxnSync(() {
                        settings.measurements =
                        newValue == 'metric'.tr
                            ? 'metric'
                            : 'imperial';
                        isar.settings.putSync(settings);
                      });
                      await weatherController.deleteAll(false);
                      await weatherController.setLocation();
                      await weatherController.updateCacheCard(true);
                      setState(() {});
                    },
                  ),
                  SettingCard(
                    elevation: 4,
                    icon: const Icon(IconsaxPlusLinear.wind),
                    text: 'wind'.tr,
                    dropdown: true,
                    dropdownName: settings.wind.tr,
                    dropdownList: <String>['kph'.tr, 'm/s'.tr],
                    dropdownChange: (String? newValue) async {
                      isar.writeTxnSync(() {
                        settings.wind =
                        newValue == 'kph'.tr ? 'kph' : 'm/s';
                        isar.settings.putSync(settings);
                      });
                      setState(() {});
                    },
                  ),
                  SettingCard(
                    elevation: 4,
                    icon: const Icon(IconsaxPlusLinear.ruler),
                    text: 'pressure'.tr,
                    dropdown: true,
                    dropdownName: settings.pressure.tr,
                    dropdownList: <String>['hPa'.tr, 'mmHg'.tr],
                    dropdownChange: (String? newValue) async {
                      isar.writeTxnSync(() {
                        settings.pressure =
                        newValue == 'hPa'.tr ? 'hPa' : 'mmHg';
                        isar.settings.putSync(settings);
                      });
                      setState(() {});
                    },
                  ),
                  SettingCard(
                    elevation: 4,
                    icon: const Icon(IconsaxPlusLinear.clock_1),
                    text: 'timeformat'.tr,
                    dropdown: true,
                    dropdownName: settings.timeformat.tr,
                    dropdownList: <String>['12'.tr, '24'.tr],
                    dropdownChange: (String? newValue) {
                      isar.writeTxnSync(() {
                        settings.timeformat =
                        newValue == '12'.tr ? '12' : '24';
                        isar.settings.putSync(settings);
                      });
                      setState(() {});
                    },
                  ),
                  const Gap(10),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}