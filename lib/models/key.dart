import 'package:hive/hive.dart';
part 'key.g.dart';

@HiveType(typeId: 1)
class PassKey {
  PassKey({
    required this.desc,
    required this.value,
  });
  @HiveField(0)
  String desc;
  @HiveField(1)
  String value;
}
