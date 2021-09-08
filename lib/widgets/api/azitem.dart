import 'package:azlistview/azlistview.dart';

class AZItem extends ISuspensionBean {
  AZItem({
    required this.title,
    required this.tag,
  });

  final String title, tag;

  @override
  String getSuspensionTag() => tag;
}
