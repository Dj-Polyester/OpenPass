import 'package:flutter/material.dart';
import 'package:polipass/screens/passwd_screen.dart';
import 'package:polipass/utils/custom_page.dart';
import 'package:provider/provider.dart';

class VaultDialogModel extends ChangeNotifier {
  VaultDialogModel({this.settingsHeightMax = 400})
      : settingsHeight = settingsHeightMax;
  final double settingsHeightMax;
  double settingsHeight;

  bool isSettingsVisible = false;
  void toggleVisibility() {
    isSettingsVisible = !isSettingsVisible;
    settingsHeight = (settingsHeight == 0) ? settingsHeightMax : 0;
    notifyListeners();
  }

  String currForm = "submit";
  void setCurrForm(String val) {
    currForm = val;
    notifyListeners();
  }
}

class Vault extends CustomPage {
  Vault()
      : super(
          appbar: (BuildContext context) => AppBar(
            title: Text(context.select(
              (CustomPageModel customPageModel) => customPageModel.currTitle!,
            )),
          ),
          body: (BuildContext context) => const Center(child: Text("1")),
          fab: _fabBuilder,
        );

  static Widget _fabBuilder(BuildContext context) => FloatingActionButton(
        onPressed: () async {
          await _dialogBuilder(context);
        },
        child: const Icon(Icons.add),
        tooltip: "Add a password",
      );

  static Future<void> _dialogBuilder(BuildContext context) async {
    return await showDialog<void>(
      context: context,
      builder: (BuildContext context) => PasswdScreen(),
    );
  }
}
