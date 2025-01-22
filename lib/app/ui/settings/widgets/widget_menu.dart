import 'package:flutter/material.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:home_widget/home_widget.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:rain/app/ui/settings/widgets/setting_card.dart';
import 'package:rain/main.dart';
import 'package:rain/app/utils/color_converter.dart';

void widgetMenu(context, colorBackground, weatherController, colorText) async {
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
                      'widget'.tr,
                      style: context.textTheme.titleLarge?.copyWith(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SettingCard(
                    elevation: 4,
                    icon: const Icon(IconsaxPlusLinear.add_square),
                    text: 'addWidget'.tr,
                    onPressed: () {
                      HomeWidget.requestPinWidget(
                        name: androidWidgetName,
                        androidName: androidWidgetName,
                        qualifiedAndroidName: 'com.yoshi.rain.OreoWidget',
                      );
                    },
                  ),
                  SettingCard(
                    elevation: 4,
                    icon: const Icon(IconsaxPlusLinear.bucket_square),
                    text: 'widgetBackground'.tr,
                    info: true,
                    infoWidget: CircleAvatar(
                      backgroundColor: context.theme.indicatorColor,
                      radius: 11,
                      child: CircleAvatar(
                        backgroundColor: widgetBackgroundColor.isEmpty
                            ? context.theme.primaryColor
                            : HexColor.fromHex(widgetBackgroundColor),
                        radius: 10,
                      ),
                    ),
                    onPressed: () {
                      colorBackground = null;
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  child: Text(
                                    'widgetBackground'.tr,
                                    style: context.textTheme.titleMedium
                                        ?.copyWith(fontSize: 18),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Theme(
                                    data: context.theme.copyWith(
                                      inputDecorationTheme:
                                          InputDecorationTheme(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                    child: ColorPicker(
                                      color: widgetBackgroundColor.isEmpty
                                          ? context.theme.primaryColor
                                          : HexColor.fromHex(
                                              widgetBackgroundColor),
                                      onChanged: (pickedColor) {
                                        colorBackground = pickedColor.toHex();
                                      },
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    IconsaxPlusLinear.tick_square,
                                  ),
                                  onPressed: () {
                                    if (colorBackground == null) {
                                      return;
                                    }
                                    weatherController
                                        .updateWidgetBackgroundColor(
                                            colorBackground!);
                                    MyApp.updateAppState(context,
                                        newWidgetBackgroundColor:
                                            colorBackground);
                                    Get.back();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SettingCard(
                    elevation: 4,
                    icon: const Icon(IconsaxPlusLinear.text_block),
                    text: 'widgetText'.tr,
                    info: true,
                    infoWidget: CircleAvatar(
                      backgroundColor: context.theme.indicatorColor,
                      radius: 11,
                      child: CircleAvatar(
                        backgroundColor: widgetTextColor.isEmpty
                            ? context.theme.primaryColor
                            : HexColor.fromHex(widgetTextColor),
                        radius: 10,
                      ),
                    ),
                    onPressed: () {
                      colorText = null;
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  child: Text(
                                    'widgetText'.tr,
                                    style: context.textTheme.titleMedium
                                        ?.copyWith(fontSize: 18),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Theme(
                                    data: context.theme.copyWith(
                                      inputDecorationTheme:
                                          InputDecorationTheme(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                    child: ColorPicker(
                                      color: widgetTextColor.isEmpty
                                          ? context.theme.primaryColor
                                          : HexColor.fromHex(widgetTextColor),
                                      onChanged: (pickedColor) {
                                        colorText = pickedColor.toHex();
                                      },
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    IconsaxPlusLinear.tick_square,
                                  ),
                                  onPressed: () {
                                    if (colorText == null) return;
                                    weatherController
                                        .updateWidgetTextColor(colorText!);
                                    MyApp.updateAppState(context,
                                        newWidgetTextColor: colorText);
                                    Get.back();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
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
