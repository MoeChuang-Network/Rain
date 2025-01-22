import 'dart:io';

import 'package:dio_cache_interceptor_file_store/dio_cache_interceptor_file_store.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rain/app/ui/settings/widgets/setting_card.dart';
import 'package:rain/main.dart';
import 'package:rain/app/data/db.dart';
import 'package:restart_app/restart_app.dart';

void mapMenu(context) async {
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
                      'map'.tr,
                      style: context.textTheme.titleLarge?.copyWith(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SettingCard(
                    elevation: 4,
                    icon: const Icon(IconsaxPlusLinear.location_slash),
                    text: 'hideMap'.tr,
                    switcher: true,
                    value: settings.hideMap,
                    onChange: (value) {
                      settings.hideMap = value;
                      isar.writeTxnSync(
                        () => isar.settings.putSync(settings),
                      );
                      setState(() {});
                      Future.delayed(
                        const Duration(milliseconds: 500),
                        () => Restart.restartApp(),
                      );
                    },
                  ),
                  SettingCard(
                      elevation: 4,
                      icon: const Icon(IconsaxPlusLinear.trash_square),
                      text: 'clearCacheStore'.tr,
                      onPressed: () => mapCacheDialog(context)),
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

void mapCacheDialog(context) async {
  await showAdaptiveDialog(
    context: context,
    builder: (context) => AlertDialog.adaptive(
      title: Text(
        'deletedCacheStore'.tr,
        style: context.textTheme.titleLarge,
      ),
      content: Text(
        'deletedCacheStoreQuery'.tr,
        style: context.textTheme.titleMedium,
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text(
            'cancel'.tr,
            style: context.textTheme.titleMedium?.copyWith(
              color: Colors.blueAccent,
            ),
          ),
        ),
        TextButton(
          onPressed: () async {
            final dir = await getTemporaryDirectory();
            final cacheStoreFuture =
                FileCacheStore('${dir.path}${Platform.pathSeparator}MapTiles');
            cacheStoreFuture.clean();
            Get.back();
          },
          child: Text(
            'delete'.tr,
            style: context.textTheme.titleMedium?.copyWith(
              color: Colors.red,
            ),
          ),
        ),
      ],
    ),
  );
}
