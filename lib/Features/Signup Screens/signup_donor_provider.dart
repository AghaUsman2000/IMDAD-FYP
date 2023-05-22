import 'package:flutter/cupertino.dart';

class SignupDonorProvider extends ChangeNotifier{

  TextEditingController name = TextEditingController();
  TextEditingController number = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    name.dispose();
    number.dispose();
    super.dispose();
  }

}