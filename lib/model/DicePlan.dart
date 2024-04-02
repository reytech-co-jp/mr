import 'package:objectbox/objectbox.dart';

@Entity()
class DicePlan {
  int id = 0;
  String plan;

  DicePlan({
    required this.plan
  });
}