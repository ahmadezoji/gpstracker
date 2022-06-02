import 'package:get/get.dart';

class LocaleString extends Translations {
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'App_Name': 'GPS Tracker',
          'Login': 'Login',
          'Registration': 'Registeration',
          'Save': 'Save',
          'Live': 'Live',
          'History': 'History',
          'Art': 'Settings',
          'Apply': 'Apply',
          'Training': 'Training Mode',
          'alert-title': 'Switch On/Off Alert',
          "device-serial": "device serial",
          "device": "device",
          "change_lang": "change lang",
          "sending-varify-code": "sending code success",
          "add-user-msg": "your phone number registered"
        },
        'fa_IR': {
          'App_Name': 'موقعیت یاب',
          'Login': 'ورود',
          'Registration': 'ثبت نام',
          'Save': 'ذخیره',
          'Live': 'زنده',
          'History': 'تاریخچه',
          'Art': 'تنظیمات',
          'Apply': 'قبول',
          'Training': 'نسخه آزمایش',
          'alert-title': 'هشدار خاموش کردن',
          "device-serial": "سریال دستگاه",
          "device": "دستگاه",
          "change_lang": "تغییر زبان",
          "sending-varify-code": "کد مورد نظر ارسال شد",
          "add-user-msg": "موبایل شما در سامانه ثبت شد"
        },
      };
}
