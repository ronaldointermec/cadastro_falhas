import 'package:cadastro_falhas/infra/dao/register_dao.dart';
import 'package:flutter/material.dart';

class RegisterProvider extends ChangeNotifier {
  bool isNewFamily = false;
  final formKey = GlobalKey<FormState>();
  final familyController = TextEditingController();
  final reasonController = TextEditingController();
  final RegisterDAO dao = RegisterDAO();

  void taggleFamily() {
    isNewFamily = !isNewFamily;
    notifyListeners();
  }

  void submit(context) {
    if (formKey.currentState!.validate()) {
      if (isNewFamily) {
        createFamily(context);
      } else {
        createReason(context);
      }
    }
  }

  void createFamily(context) async {
    String message =
        await dao.createFamily(family: reasonController.value.text);
    bool isError = message.contains('Erro');

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
    clean();
    debugPrint('start provider');
    debugPrint('end provider');
  }

  void createReason(context) async {
    String message = await dao.createReason(
        family: familyController.value.text,
        reason: reasonController.value.text);
    bool isError = message.contains('Erro');

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
    clean();
  }

  void clean() {
    familyController.clear();
    reasonController.clear();
  }
}
