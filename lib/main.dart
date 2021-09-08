import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:polipass/db/db.dart';
import 'package:polipass/models/passkey.dart';
import 'package:polipass/utils/lang.dart';

import 'package:provider/provider.dart';

import 'utils/custom_page.dart';
import 'utils/globals.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(PassKeyAdapter());
  Hive.registerAdapter(PassKeyItemAdapter());
  await Hive.openBox<PassKey>('passkeys');
  // if (Globals.debugMode) {
  //   KeyStore.passkeys.clear();
  // }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    super.dispose();

    Hive.close();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GlobalModel(),
      builder: (context, _) {
        return MaterialApp(
          title: Globals.appName,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
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
              showUnselectedLabels: true,
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.black87,
              currentIndex: selectedIndex,
              onTap: (int index) {
                context.read<GlobalModel>().selectedIndex = index;
              },
              items: [
                BottomNavigationBarItem(
                    icon: const Icon(Icons.security), label: Lang.tr("Vault")),
                BottomNavigationBarItem(
                    icon: const Icon(Icons.settings),
                    label: Lang.tr("Settings")),
              ],
            ),
          );
        });
  }
}
