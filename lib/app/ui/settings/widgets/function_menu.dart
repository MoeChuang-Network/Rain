import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import 'package:rain/app/ui/settings/widgets/setting_card.dart';
import 'package:rain/main.dart';
import 'package:rain/app/data/db.dart';
import 'package:url_launcher/url_launcher.dart';

void functionMenu(context, weatherController) {
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
                      'functions'.tr,
                      style: context.textTheme.titleLarge?.copyWith(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SettingCard(
                    elevation: 4,
                    icon: const Icon(IconsaxPlusLinear.map),
                    text: 'location'.tr,
                    switcher: true,
                    value: settings.location,
                    onChange: (value) async {
                      if (value) {
                        final loc =
                            await getLocation(context, weatherController);
                        if (!loc) return;
                      }
                      isar.writeTxnSync(() {
                        settings.location = value;
                        isar.settings.putSync(settings);
                      });
                      setState(() {});
                    },
                  ),
                  if (Platform.isAndroid || Platform.isIOS)
                    SettingCard(
                      elevation: 4,
                      icon: const Icon(IconsaxPlusLinear.notification_1),
                      text: 'notifications'.tr,
                      switcher: true,
                      value: settings.notifications,
                      onChange: (value) async {
                        if (!context.mounted) return;
                        bool hasPermission =
                            await checkNotificationPermission();
                        if (!hasPermission && !!value) {
                          if (!context.mounted) return;
                          notificationAlertDialog(context);
                          return;
                        }
                        if (value) {
                          weatherController
                              .notification(weatherController.mainWeather);
                        } else {
                          flutterLocalNotificationsPlugin.cancelAll();
                        }
                        isar.writeTxnSync(() {
                          settings.notifications = value;
                          isar.settings.putSync(settings);
                        });
                        setState(() {});
                      },
                    ),
                  SettingCard(
                    elevation: 4,
                    icon: const Icon(IconsaxPlusLinear.notification_status),
                    text: 'timeRange'.tr,
                    dropdown: true,
                    dropdownName: '$timeRange',
                    dropdownList: const <String>[
                      '1',
                      '2',
                      '3',
                      '4',
                      '5',
                    ],
                    dropdownChange: (String? newValue) {
                      isar.writeTxnSync(() {
                        settings.timeRange = int.parse(newValue!);
                        isar.settings.putSync(settings);
                      });
                      MyApp.updateAppState(context,
                          newTimeRange: int.parse(newValue!));
                      if (settings.notifications) {
                        flutterLocalNotificationsPlugin.cancelAll();
                        weatherController
                            .notification(weatherController.mainWeather);
                      }
                    },
                  ),
                  SettingCard(
                    elevation: 4,
                    icon: const Icon(IconsaxPlusLinear.timer_start),
                    text: 'timeStart'.tr,
                    info: true,
                    infoSettings: true,
                    infoWidget: _TextInfo(
                      info: () {
                        return timeFormat(timeStart);
                      }(),
                    ),
                    onPressed: () async {
                      timePicker(context, weatherController, timeStart);
                    },
                  ),
                  SettingCard(
                    elevation: 4,
                    icon: const Icon(IconsaxPlusLinear.timer_pause),
                    text: 'timeEnd'.tr,
                    info: true,
                    infoSettings: true,
                    infoWidget: _TextInfo(
                      info: () {
                        return timeFormat(timeEnd);
                      }(),
                    ),
                    onPressed: () async {
                      timePicker(context, weatherController, timeEnd);
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

Future<bool> getLocation(context, weatherController) async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    if (!context.mounted) return false;
    locationAlertDialog(context, null);
    return false;
  }
  try {
    await weatherController.determinePosition();
    return true;
  } catch (e) {
    locationAlertDialog(context, e.toString());
    return false;
  }
}

void locationAlertDialog(context, String? msg) async {
  await showAdaptiveDialog(
    context: context,
    builder: (BuildContext context) {
      final message = msg ?? 'no_location'.tr;
      return AlertDialog.adaptive(
        title: Text(
          'location'.tr,
          style: context.textTheme.titleLarge,
        ),
        content: Text(message, style: context.textTheme.titleMedium),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(
              'cancel'.tr,
              style: context.textTheme.titleMedium
                  ?.copyWith(color: Colors.blueAccent),
            ),
          ),
          TextButton(
            onPressed: () {
              Geolocator.openLocationSettings();
              Get.back(result: true);
            },
            child: Text(
              'settings'.tr,
              style:
                  context.textTheme.titleMedium?.copyWith(color: Colors.green),
            ),
          ),
        ],
      );
    },
  );
}

Future<bool> checkNotificationPermission() async {
  switch (Platform.operatingSystem) {
    case 'ios':
      {
        final notification = await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions();
        return (notification == true);
      }
    case 'android':
      {
        final alarm = await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestExactAlarmsPermission();
        final notification = await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission();
        return (notification == true && alarm == true);
      }
    default:
      return false;
  }
}

void notificationAlertDialog(context) async {
  await showAdaptiveDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog.adaptive(
          title: Text('notifications'.tr, style: context.textTheme.titleLarge),
          content: Text('errNotificationPermission'.tr,
              style: context.textTheme.titleMedium),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: Text(
                'cancel'.tr,
                style: context.textTheme.titleMedium?.copyWith(
                  color: Colors.blueAccent,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                openAppSettings();
                Get.back(result: true);
              },
              child: Text(
                'settings'.tr,
                style: context.textTheme.titleMedium
                    ?.copyWith(color: Colors.green),
              ),
            ),
          ],
        );
      });
}

void openAppSettings() {
  switch (Platform.operatingSystem) {
    case 'ios':
      launchUrl(Uri.parse('app-settings:'));
  }
}

String timeFormat(time) {
  try {
    final time24 = DateFormat.Hm('en_US').parse(time);
    return settings.timeformat == '12'
        ? DateFormat("h:mm a", locale.toLanguageTag()).format(time24)
        : DateFormat.Hm((locale.toLanguageTag())).format(time24);
  } catch (e) {
    debugPrint(e.toString());
    return time;
  }
}

void timePicker(context, weatherController, time) async {
  final TimeOfDay? timeEndPicker = await showTimePicker(
    context: context,
    initialTime: weatherController.timeConvert(time),
    builder: (context, child) {
      final Widget mediaQueryWrapper = MediaQuery(
        data: MediaQuery.of(context).copyWith(
          alwaysUse24HourFormat: settings.timeformat == '12' ? false : true,
        ),
        child: child!,
      );
      return mediaQueryWrapper;
    },
  );
  if (timeEndPicker != null) {
    isar.writeTxnSync(() {
      settings.timeEnd = timeEndPicker.format(context);
      isar.settings.putSync(settings);
    });
    if (!context.mounted) return;
    MyApp.updateAppState(context, newTimeEnd: timeEndPicker.format(context));
    if (settings.notifications) {
      flutterLocalNotificationsPlugin.cancelAll();
      weatherController.notification(weatherController.mainWeather);
    }
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
