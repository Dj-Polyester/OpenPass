import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:polipass/utils/custom_page.dart';
import 'package:polipass/utils/globals.dart';
import 'package:provider/provider.dart';

class CustomListModel extends ChangeNotifier {
  CustomListModel();

  //PROPERTIES
  late Map<String, bool> selectedItems;
  bool checkboxValue = false,
      itemSelectVisible = false,
      itemSearchVisible = false;
  CustomPageModel? customPageModel;
  GlobalModel? globalModel;

  //METHODS
  void provide(Locator read, Map<String, bool> selectedI) {
    globalModel = globalModel ?? read<GlobalModel>();
    customPageModel = customPageModel ?? read<CustomPageModel>();
    selectedItems = selectedI;
  }

  void setSelectedItems(bool value) {
    for (var key in selectedItems.keys) {
      selectedItems[key] = value;
    }
    notifyListeners();
  }

  void updateSelectedItems(String key, bool value) {
    selectedItems[key] = value;
    notifyListeners();
  }

  void deleteFromSelectedItems(final Iterable<String> keys) {
    // throws ConcurrentModificationError
    // for (String key in keys) {
    //   selectedItems.remove(key);
    // }
    selectedItems.removeWhere((key, _) => keys.contains(key));
    notifyListeners();
  }

  bool toggleSelectedItems(String key) {
    selectedItems[key] = !selectedItems[key]!;
    notifyListeners();
    return selectedItems[key]!;
  }

  void setCheckbox(bool value) {
    setSelectedItems(value);
    checkboxValue = value;
    if (value) {
      selectedNum = selectedItems.length;
    } else {
      selectedNum = 0;
    }
    setListTitleNotified();
    print("custom_list: $selectedItems");

    globalModel!.notifyCheckbox();
  }

  void setListTitleNotified() {
    customPageModel!.setCurrTitle(
      (itemSelectVisible) ? "Selected $selectedNum" : customPageModel!.title!,
    );
  }

  void setListTitle() {
    customPageModel!.currTitle =
        (itemSelectVisible) ? "Selected $selectedNum" : customPageModel!.title!;
  }

  void toggleSelectVisibility() {
    itemSelectVisible = !itemSelectVisible;
    setCheckbox(false);
    notifyListeners();
  }

  void turnOffSelectVisibility() {
    itemSelectVisible = false;
    setCheckbox(false);
    notifyListeners();
  }

  void toggleSearchVisibility() {
    itemSearchVisible = !itemSearchVisible;
    notifyListeners();
  }

  void turnOffSearchVisibility() {
    itemSearchVisible = false;
    notifyListeners();
  }

  void reset() {
    itemSelectVisible = false;
    itemSearchVisible = false;
    setListTitle();
  }

  int selectedNum = 0;
  void incSelectedNum() {
    if (++selectedNum == selectedItems.length) checkboxValue = true;
    notifyListeners();
  }

  void decSelectedNum() {
    if (selectedNum-- == selectedItems.length) checkboxValue = false;
    notifyListeners();
  }
}

enum CustomListBuilderType {
  valueListenable,
  future,
  stream,
}

class CustomList extends StatelessWidget {
  CustomList({
    Key? key,
    required this.object,
    Function(dynamic, BuildContext)? prebuild,
    required this.itemBuilder,
    this.padding = const EdgeInsets.all(Globals.itemsPaddingMax),
    required this.builderType,
  })  : _prebuild = prebuild ?? ((obj, context) => obj),
        super(key: key);

  final EdgeInsets padding;
  final dynamic object;
  final Function(dynamic, BuildContext) _prebuild;
  final Function(BuildContext, List, int) itemBuilder;
  final CustomListBuilderType builderType;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CustomListModel(),
      builder: (context, _) => builder(context),
    );
  }

  builder(BuildContext context) {
    switch (builderType) {
      case CustomListBuilderType.valueListenable:
        return valueListenableBuilder(context);
      case CustomListBuilderType.future:
        return;
      case CustomListBuilderType.stream:
        return;
      default:
    }
  }

  ValueListenableBuilder valueListenableBuilder(BuildContext context) =>
      ValueListenableBuilder(
        valueListenable: object.listenable()!,
        builder: (context, obj, _) {
          List list = _prebuild(obj, context);
          return ListView.builder(
            padding: padding,
            //
            itemCount: list.length,
            itemBuilder: (BuildContext context, int i) =>
                itemBuilder(context, list, i),
          );
        },
      );
  // FutureBuilder futureBuilder(BuildContext context) => FutureBuilder(builder: builder);

  // StreamBuilder streamBuilder(BuildContext context) => FutureBuilder(builder: builder);
}
