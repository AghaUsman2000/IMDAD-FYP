import 'package:flutter/cupertino.dart';

class SignupNgoProvider extends ChangeNotifier{

  TextEditingController name = TextEditingController();
  TextEditingController number = TextEditingController();
  late String organisation ;

// @override
// void dispose() {
//   // TODO: implement dispose
//   name.dispose();
//   number.dispose();
//   super.dispose();
// }

}