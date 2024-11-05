import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterProvider extends ChangeNotifier {
  bool isNewFamily = false;
  final formKey = GlobalKey<FormState>();
  final familyController = TextEditingController();
  final reasonController = TextEditingController();

  void taggleFamily() {
    isNewFamily = !isNewFamily;
    notifyListeners();
  }

  void submit(context) {
    if (formKey.currentState!.validate()) {
      if (isNewFamily) {
        print('Família: ${reasonController.value.text}');
        clean(context);
      } else {
        print('Família: ${familyController.value.text}');
        print('Moitvo: ${reasonController.value.text}');
        clean(context);
      }
    }
  }

  void clean(context) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Cadastro realizado com sucesso!'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );

    familyController.clear();
    reasonController.clear();
  }
}
