import 'package:objectbox/objectbox.dart';

@Entity()
class BordTitle {
  int id = 0;
  String title;

  BordTitle({
    required this.title
  });
}