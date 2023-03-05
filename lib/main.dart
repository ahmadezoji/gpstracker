import 'package:cargpstracker/LacaleString.dart';
import 'package:cargpstracker/autentication.dart';
import 'package:cargpstracker/mainTabScreens/GpsPlus.dart';
import 'package:cargpstracker/mainTabScreens/login.dart';
import 'package:cargpstracker/mainTabScreens/shared.dart';
import 'package:cargpstracker/models/device.dart';
import 'package:cargpstracker/models/myUser.dart';
import 'package:cargpstracker/myRequests.dart';
import 'package:cargpstracker/spalshScreen.dart';
import 'package:cargpstracker/theme_model.dart';
import 'package:cargpstracker/util.dart';
// import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification!.body}');
}

class AppState {
  final List<Device> _devices;
  final myUser? _user;
  List<Device> get devices => _devices;
  myUser? get user => _user;
  AppState(this._devices, this._user);

  AppState.initialState()
      : _devices = [],
        _user = null;

  @override
  String toString() {
    return '$_devices+$_user';
  }
}

class FetchDataAction {
  final List<Device> _devices;
  final myUser? _user;

  List<Device> get devices => _devices;
  myUser? get user => _user;

  FetchDataAction(this._devices, this._user);
}

AppState reducer(AppState prev, dynamic action) {
  if (action is FetchDataAction) {
    return AppState(action.devices, action.user);
  } else if (action is AddAction) {
    prev._devices.add(action.input);
    return prev;
  } else if (action is UpdateAction) {
    int index =
        prev._devices.indexWhere((item) => item.serial == action.input.serial);
    prev._devices[index] = action.input;
    return prev;
  } else if (action is DeleteAction) {
    prev._devices.remove(action.input);
    return prev;
  } else {
    return prev;
  }
}

ThunkAction<AppState> getDeviceAction = (Store<AppState> store) async {
  String? email = await load(SHARED_EMAIL_KEY);
  email = "saam.ezoji@gmail.com";
  List<Device> devicesList = [];
  late myUser currentUser;
  currentUser = (await getUser(email))!;
  devicesList = (await getUserDevice(currentUser))!;
  store.dispatch(FetchDataAction(devicesList, currentUser));
};

class AddAction {
  final Device input;
  AddAction({required this.input});
}

class UpdateAction {
  final Device input;
  UpdateAction({required this.input});
}

class DeleteAction {
  final Device input;
  DeleteAction({required this.input});
}

typedef GetDevice(List<Device> devices);
typedef AddDevice(Device device);
typedef UpdateDevice(Device device);
typedef DeleteDevice(Device device);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Authentication.initializeFirebase();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final store = Store(reducer,
      initialState: AppState.initialState(), middleware: [thunkMiddleware]);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeModel(),
      child: Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
          return StoreProvider(
            store: store,
            child: GetMaterialApp(
              debugShowCheckedModeBanner: false,
              translations: LocaleString(),
              locale: const Locale('en', 'US'),
              title: "app_name".tr,
              // theme: themeNotifier.isDark ? ThemeData.dark() : ThemeData.light(),
              theme: themeNotifier.isDark
                  ? ThemeData(
                      brightness: Brightness.dark,
                    )
                  : ThemeData(
                      brightness: Brightness.light,
                      appBarTheme: const AppBarTheme(backgroundColor: NabColor),
                      floatingActionButtonTheme:
                          const FloatingActionButtonThemeData(
                              backgroundColor: Colors.white)),
              initialRoute: '/',
              routes: {
                // When navigating to the "/" route, build the FirstScreen widget.
                '/': (context) => SpalshScreen(
                      onInit: () {
                        StoreProvider.of<AppState>(context)
                            .dispatch(getDeviceAction);
                      },
                    ),
                // When navigating to the "/second" route, build the SecondScreen widget.
                '/gpsplus': (context) => const GpsPlus(),
                '/login': (context) => LoginPage(),
              },
              // home: SpalshScreen(),
            ),
          );
        },
      ),
    );
  }
}
