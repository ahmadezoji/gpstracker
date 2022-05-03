
import 'package:get/get.dart';

class LocaleString extends Translations{
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
    'en_US':{
      'App_Name' : 'GPS Tracker',
      'Login': 'Login',
      'Registration':'Registeration',
      'Save':'Save',
      'Live':'Live',
      'History':'History',
      'Art':'Settings',
      'Apply' : 'Apply',
      'Training' : 'Training Mode'
    },
    'fa_IR':{
      'App_Name' : 'موقعیت یاب',
      'Login': 'ورود',
      'Registration':'ثبت نام',
      'Save':'ذخیره',
      'Live':'زنده',
      'History':'تاریخچه',
      'Art':'تنظیمات',
      'Apply' : 'قبول',
      'Training' : 'نسخه آزمایش'
    },
  };

}