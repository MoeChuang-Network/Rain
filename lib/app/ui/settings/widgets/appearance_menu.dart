import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:rain/app/ui/settings/widgets/setting_card.dart';
import 'package:rain/main.dart';
import 'package:rain/app/data/db.dart';

void appearanceMenu(context, themeController) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: StatefulBuilder(
          builder: (BuildContext context, setState) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      'appearance'.tr,
                      style: context.textTheme.titleLarge?.copyWith(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SettingCard(
                    elevation: 4,
                    icon: const Icon(IconsaxPlusLinear.moon),
                    text: 'theme'.tr,
                    dropdown: true,
                    dropdownName: settings.theme?.tr,
                    dropdownList: <String>['system'.tr, 'dark'.tr, 'light'.tr],
                    dropdownChange: (String? newValue) {
                      final newThemeMode = newValue?.tr;
                      final darkTheme = 'dark'.tr;
                      final systemTheme = 'system'.tr;
                      ThemeMode themeMode = newThemeMode == systemTheme
                          ? ThemeMode.system
                          : newThemeMode == darkTheme
                              ? ThemeMode.dark
                              : ThemeMode.light;
                      String theme = newThemeMode == systemTheme
                          ? 'system'
                          : newThemeMode == darkTheme
                              ? 'dark'
                              : 'light';
                      themeController.saveTheme(theme);
                      themeController.changeThemeMode(themeMode);
                      setState(() {});
                    },
                  ),
                  SettingCard(
                    elevation: 4,
                    icon: const Icon(IconsaxPlusLinear.mobile),
                    text: 'amoledTheme'.tr,
                    switcher: true,
                    value: settings.amoledTheme,
                    onChange: (value) {
                      themeController.saveOledTheme(value);
                      MyApp.updateAppState(context, newAmoledTheme: value);
                    },
                  ),
                  if (!Platform.isIOS)
                    SettingCard(
                      elevation: 4,
                      icon: const Icon(IconsaxPlusLinear.colorfilter),
                      text: 'materialColor'.tr,
                      switcher: true,
                      value: settings.materialColor,
                      onChange: (value) {
                        themeController.saveMaterialTheme(value);
                        MyApp.updateAppState(context, newMaterialColor: value);
                      },
                    ),
                  SettingCard(
                    elevation: 4,
                    icon: const Icon(IconsaxPlusLinear.additem),
                    text: 'largeElement'.tr,
                    switcher: true,
                    value: settings.largeElement,
                    onChange: (value) {
                      settings.largeElement = value;
                      isar.writeTxnSync(
                        () => isar.settings.putSync(settings),
                      );
                      MyApp.updateAppState(
                        context,
                        newLargeElement: value,
                      );
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
