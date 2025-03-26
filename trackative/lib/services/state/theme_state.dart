import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class ThemeState extends GetxController {
  RxBool themeChange = false.obs;

  void changeTheme() {
    themeChange.value = !themeChange.value;
    if (themeChange.value) {
      Get.changeThemeMode(ThemeMode.dark);
    } else {
      Get.changeThemeMode(ThemeMode.light);
    }
    setTheme();
    getTheme();
  }

  Future<void> setTheme() async {
    var box = await Hive.openBox("theme");
    await box.put("set", themeChange.value);
  }

  Future<void> getTheme() async {
    var box = await Hive.openBox("theme");
    bool? storedTheme = box.get("set", defaultValue: false);
    if (storedTheme != null && storedTheme) {
      themeChange.value = storedTheme;
      Get.changeThemeMode(ThemeMode.dark);
    } else {
      themeChange.value = false;
      Get.changeThemeMode(ThemeMode.light);
    }
  }
}
