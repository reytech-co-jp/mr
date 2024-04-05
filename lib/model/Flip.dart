import 'package:objectbox/objectbox.dart';

@Entity()
class Flip {
  int id = 0;
  String title;
  List<String> plan;

  Flip({
    required this.title,
    required this.plan,
  });
}
