import 'package:hive/hive.dart';
part 'passkey.g.dart';

@HiveType(typeId: 0)
class PassKey extends HiveObject {
  PassKey({
    required this.desc,
    this.username,
    this.email,
    required this.password,
  });
  @HiveField(0)
  String desc;
  @HiveField(1)
  String? username;
  @HiveField(2)
  String? email;
  @HiveField(3)
  String password;
}
