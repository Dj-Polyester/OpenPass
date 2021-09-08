import 'package:flutter/material.dart';
import 'package:polipass/utils/custom_page.dart';
import 'package:polipass/utils/globals.dart';
import 'package:polipass/utils/lang.dart';
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
    // below expression throws ConcurrentModificationError
    // for (String key in keys) selectedItems.remove(key);
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
    // print("custom_list: $selectedItems");

    globalModel!.notifyCheckbox();
  }

  void setListTitleNotified() {
    customPageModel!.setCurrTitle(
      (itemSelectVisible)
          ? Lang.tr("Selected %s", [selectedNum])
          : customPageModel!.title!,
    );
  }

  void setListTitle() {
    customPageModel!.currTitle = (itemSelectVisible)
        ? Lang.tr("Selected %s", [selectedNum])
        : customPageModel!.title!;
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
