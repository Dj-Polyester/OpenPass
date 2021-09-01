import 'package:hive/hive.dart';
part 'passkey.g.dart';

@HiveType(typeId: 0)
class PassKey extends HiveObject {
  PassKey({
    required this.desc,
    required this.value,
  });
  @HiveField(0)
  String desc;
  @HiveField(1)
  String value;
}
