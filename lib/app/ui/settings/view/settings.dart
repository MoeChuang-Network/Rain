import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rain/app/controller/controller.dart';
import 'package:rain/app/data/db.dart';
import 'package:rain/app/ui/settings/widgets/widget_settings.dart';
import 'package:rain/main.dart';
import 'package:rain/theme/theme_controller.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final themeController = Get.put(ThemeController());
  final weatherController = Get.put(WeatherController());
  String? appVersion;
  String? colorBackground;
  String? colorText;

  Future<void> infoVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version;
    });
  }

  @override
  void initState() {
    infoVersion();
    super.initState();
  }

  updateLanguage(Locale locale) {
    settings.language = '$locale';
    isar.writeTxnSync(() => isar.settings.putSync(settings));
    Get.updateLocale(locale);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SettingCard(
              icon: const Icon(IconsaxPlusLinear.brush_1),
              text: 'appearance'.tr,
              onPressed: () => appearanceMenu(context, themeController)),
          SettingCard(
              icon: const Icon(IconsaxPlusLinear.code_1),
              text: 'functions'.tr,
              onPressed: () => functionMenu(context, weatherController)),
          SettingCard(
              icon: const Icon(IconsaxPlusLinear.d_square),
              text: 'data'.tr,
              onPressed: () => dataMenu(context, weatherController)),
          if (Platform.isAndroid)
            SettingCard(
                icon: const Icon(IconsaxPlusLinear.setting_3),
                text: 'widget'.tr,
                onPressed: () => widgetMenu(
                    context, colorBackground, weatherController, colorText)),
          SettingCard(
            icon: const Icon(IconsaxPlusLinear.map),
            text: 'map'.tr,
            onPressed: () => mapMenu(context),
          ),
          SettingCard(
              icon: const Icon(IconsaxPlusLinear.language_square),
              text: 'language'.tr,
              info: true,
              infoSettings: true,
              infoWidget: _TextInfo(
                info: appLanguages.firstWhere(
                    (element) => (element['locale'] == locale),
                    orElse: () =>
                        appLanguages[4])['name'], // The fourth is English
              ),
              onPressed: () => languageMenu(context, updateLanguage)),
          SettingCard(
            icon: const Icon(IconsaxPlusLinear.dollar_square),
            text: 'support'.tr,
            onPressed: () {
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
                                  'support'.tr,
                                  style: context.textTheme.titleLarge?.copyWith(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              SettingCard(
                                elevation: 4,
                                icon: const Icon(IconsaxPlusLinear.card),
                                text: 'DonationAlerts',
                                onPressed: () => weatherController.urlLauncher(
                                    'https://www.donationalerts.com/r/darkmoonight'),
                              ),
                              SettingCard(
                                elevation: 4,
                                icon: const Icon(IconsaxPlusLinear.wallet),
                                text: 'ЮMoney',
                                onPressed: () => weatherController.urlLauncher(
                                    'https://yoomoney.ru/to/4100117672775961'),
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
            },
          ),
          SettingCard(
            icon: const Icon(IconsaxPlusLinear.link_square),
            text: 'groups'.tr,
            onPressed: () {
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                child: Text(
                                  'groups'.tr,
                                  style: context.textTheme.titleLarge?.copyWith(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              SettingCard(
                                elevation: 4,
                                icon: const Icon(LineAwesomeIcons.discord),
                                text: 'Discord',
                                onPressed: () => weatherController.urlLauncher(
                                    'https://discord.gg/JMMa9aHh8f'),
                              ),
                              SettingCard(
                                elevation: 4,
                                icon: const Icon(LineAwesomeIcons.telegram),
                                text: 'Telegram',
                                onPressed: () => weatherController
                                    .urlLauncher('https://t.me/darkmoonightX'),
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
            },
          ),
          SettingCard(
            icon: const Icon(IconsaxPlusLinear.document),
            text: 'license'.tr,
            onPressed: () => Get.to(
              () => LicensePage(
                applicationIcon: Container(
                  width: 100,
                  height: 100,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    image: DecorationImage(
                      image: AssetImage('assets/icons/icon.png'),
                    ),
                  ),
                ),
                applicationName: 'Rain',
                applicationVersion: appVersion,
              ),
              transition: Transition.downToUp,
            ),
          ),
          SettingCard(
            icon: const Icon(IconsaxPlusLinear.hierarchy_square_2),
            text: 'version'.tr,
            info: true,
            infoWidget: _TextInfo(
              info: '$appVersion',
            ),
          ),
          SettingCard(
            icon: const Icon(LineAwesomeIcons.github),
            text: '${'project'.tr} GitHub',
            onPressed: () => weatherController
                .urlLauncher('https://github.com/darkmoonight/Rain'),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: GestureDetector(
              child: Text(
                'openMeteo'.tr,
                style: context.textTheme.bodyMedium,
                overflow: TextOverflow.visible,
                textAlign: TextAlign.center,
              ),
              onTap: () =>
                  weatherController.urlLauncher('https://open-meteo.com/'),
            ),
          ),
          const Gap(10),
        ],
      ),
    );
  }
}

class _TextInfo extends StatelessWidget {
  const _TextInfo({required this.info});

  final String info;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: Text(
        info,
        style: context.textTheme.bodyMedium,
        overflow: TextOverflow.visible,
      ),
    );
  }
}
