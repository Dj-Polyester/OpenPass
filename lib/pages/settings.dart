import 'package:polipass/utils/custom_theme.dart';
import 'package:polipass/utils/globals.dart';
import 'package:polipass/utils/lang.dart';
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
  static Widget _bodyBuilder(BuildContext context) => ListView(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: Icon(
              Icons.image,
              color: Theme.of(context).iconTheme.color,
            ),
            title: Text(Lang.tr("Set theme")),
            subtitle: CustomDropdownBox(),
          ),
        ),
      ]);
}

class CustomDropdownBox extends StatelessWidget {
  CustomDropdownBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        dropdownColor: Theme.of(context).backgroundColor,
        style: Theme.of(context).textTheme.bodyText1,
        value:
            context.select((GlobalModel globalModel) => globalModel.themeData),
        items: CustomTheme.themes.entries
            .map((e) => e.key)
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {
          context.read<GlobalModel>().setTheme(newValue!);
        },
      ),
    );
  }
}
