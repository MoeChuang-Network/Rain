import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:rain/main.dart';

void languageMenu(context, updateLanguage) async {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) => Padding(
      padding: EdgeInsets.only(
          left: 20, right: 20, bottom: MediaQuery.of(context).padding.bottom),
      child: StatefulBuilder(
        builder: (BuildContext context, setState) {
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  'language'.tr,
                  style: context.textTheme.titleLarge?.copyWith(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: appLanguages.length,
                separatorBuilder: (context, index) => const SizedBox(height: 5),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          title: Text(
                            appLanguages[index]['name'],
                            style: context.textTheme.labelLarge,
                            textAlign: TextAlign.center,
                          ),
                          onTap: () {
                            MyApp.updateAppState(context,
                                newLocale: appLanguages[index]['locale']);
                            updateLanguage(appLanguages[index]['locale']);
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
              const Gap(10),
            ],
          );
        },
      ),
    ),
  );
}