import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:polipass/db/db.dart';
import 'package:polipass/models/globals.dart';
import 'package:polipass/utils/custom_theme.dart';
import 'package:polipass/utils/master_key.dart';

import 'package:provider/provider.dart';

import 'utils/custom_page.dart';
import 'utils/globals.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await KeyStore.deleteStorageKeys();
  await KeyStore.changePasswd(MASTERKEY);

  await Hive.initFlutter();
  await KeyStore.openBox();
  await Globals.openBox();
  // if (Globals.persistentGlobalsModel.requirePasswd) {
  //   bool authed = false;
  //   while (!authed) {
  //     authed = await CustomLocalAuth.authenticate();
  //   }
  // }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() async {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
    await Globals.close();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        // if (Globals.persistentGlobalsModel.requirePasswd) {
        //   bool authed = false;
        //   while (!authed) {
        //     authed = await CustomLocalAuth.authenticate();
        //   }
        // }

        await Globals.openBox();
        break;
      case AppLifecycleState.paused:
        Globals.close();
        break;
      default:
    }
  }

  @override
  Future<bool> didPopRoute() async {
    await Globals.close();
    return super.didPopRoute();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Globals.persistentGlobalsModel),
        ChangeNotifierProvider.value(value: Globals.globalModel),
      ],
      builder: (context, _) {
        return MaterialApp(
          title: Globals.appName,
          theme: CustomTheme.themes[context.select(
              (PersistentGlobalsModel persistentGlobalsModel) =>
                  persistentGlobalsModel.themeData)],
          darkTheme: CustomTheme.themes[context.select(
              (PersistentGlobalsModel persistentGlobalsModel) =>
                  persistentGlobalsModel.darkThemeData)],
          initialRoute: "/",
          routes: Globals.routes.cast(),
        );
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Selector<GlobalModel, int>(
        selector: (_, globalModel) => globalModel.selectedIndex,
        builder: (context, selectedIndex, _) {
          CustomPage page = Globals.pages[selectedIndex];
          return Scaffold(
            appBar: page.appbar as PreferredSizeWidget,
            body: page.body,
            floatingActionButton: page.fab,
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: selectedIndex,
              onTap: (int index) {
                context.read<GlobalModel>().selectedIndex = index;
              },
              items: Globals.navbarItems,
            ),
          );
        });
  }
}
