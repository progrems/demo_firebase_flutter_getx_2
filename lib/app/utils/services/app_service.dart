// ignore: unnecessary_library_name
library app_service;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../constans/app_constans.dart';
import '../helpers/app_helpers.dart';
import '../models/models.dart';

// src
part './src/auth_service.dart';
part './src/firestorage_service.dart';
part './src/firestore_service.dart';

class AppService extends GetxService {
  static Locale getLocale() {
    var locale = const Locale('fr', 'CA');
    final languageCode = GetStorage().read<String>(AppHelpers.langKey);

    if (languageCode != null) {
      locale = Locale(languageCode, 'CA');
    }

    return locale;
  }

  static void changeLocale(String languageCode) {
    Get.updateLocale(Locale(languageCode, 'CA'));
    GetStorage().write(AppHelpers.langKey, languageCode);
  }
}
