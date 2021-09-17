import 'package:polipass/models/globals.dart';
import 'package:polipass/utils/custom_theme.dart';
import 'package:polipass/utils/globals.dart';
import 'package:polipass/utils/lang.dart';
import 'package:polipass/widgets/api/custom_divider.dart';
import 'package:polipass/widgets/api/custom_switch.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:polipass/utils/custom_page.dart';

class Settings extends CustomPage {
  Settings()
      : super(
          appbar: _appbarBuilder,
          body: _bodyBuilder,
        );

  static Widget _appbarBuilder(BuildContext context) => AppBar(
        title: Text(context.select(
          (CustomPageModel customPageModel) => customPageModel.currTitle!,
        )),
      );
  static Widget _bodyBuilder(BuildContext context) =>
      ListView(padding: const EdgeInsets.all(8.0), children: [
        ListTile(
          leading: Icon(
            Icons.image,
            color: Theme.of(context).iconTheme.color,
          ),
          title: Text(Lang.tr("Set theme")),
          trailing: ThemeDropdownBox(),
        ),
        ListTile(
          leading: Icon(
            Icons.image,
            color: Theme.of(context).iconTheme.color,
          ),
          title: Text(Lang.tr("Set dark theme")),
          trailing: DarkThemeDropdownBox(),
        ),
        const CustomDivider(),
        ListTile(
          leading: Icon(
            Icons.password,
            color: Theme.of(context).iconTheme.color,
          ),
          title: Text(Lang.tr("Require password")),
          trailing: Switch.adaptive(
            value: context.select(
                (PersistentGlobalsModel persistentGlobalsModel) =>
                    persistentGlobalsModel.requirePasswd),
            onChanged: (bool? val) {
              context.read<PersistentGlobalsModel>().requirePasswd = val!;
            },
          ),
        ),
      ]);
}

class ThemeDropdownBox extends StatelessWidget {
  ThemeDropdownBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        dropdownColor: Theme.of(context).backgroundColor,
        style: Theme.of(context).textTheme.bodyText1,
        value: context.select((PersistentGlobalsModel persistentGlobalsModel) =>
            persistentGlobalsModel.themeData),
        items: CustomTheme.themes.entries
            .map((e) => e.key)
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? value) {
          context.read<PersistentGlobalsModel>().themeData = value!;
        },
      ),
    );
  }
}

class DarkThemeDropdownBox extends StatelessWidget {
  DarkThemeDropdownBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        dropdownColor: Theme.of(context).backgroundColor,
        style: Theme.of(context).textTheme.bodyText1,
        value: context.select((PersistentGlobalsModel persistentGlobalsModel) =>
            persistentGlobalsModel.darkThemeData),
        items: CustomTheme.themes.entries
            .map((e) => e.key)
            .where((element) => element != "Light")
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? value) {
          context.read<PersistentGlobalsModel>().darkThemeData = value!;
        },
      ),
    );
  }
}
