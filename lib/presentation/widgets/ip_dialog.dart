import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IpDialog extends StatefulWidget {
  @override
  _IpDialogState createState() => _IpDialogState();
}

class _IpDialogState extends State<IpDialog> {
  final TextEditingController _ipController = TextEditingController();
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _loadIP();
  }

  Future<void> _loadIP() async {
    _prefs = await SharedPreferences.getInstance();
    String? storedIP = _prefs?.getString('ip_address');
    if (storedIP != null) {
      _ipController.text = storedIP;
    }
  }

  Future<void> _saveIP() async {
    var input = _ipController.text;
    if (_isValidIP(input)) {
      await _prefs?.setString('ip_address', input);
      Navigator.pop(context); // close the dialog
    } else {
      // Show an error message if the IP address is invalid
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Endereço de IP inválido')),
      );
    }
  }

  bool _isValidIP(String ip) {
    RegExp ipRegExp = RegExp(
        r'^(([0-9]{1,3})\.){3}[0-9]{1,3}$'); // Pattern to check for a valid IP address
    return ipRegExp.hasMatch(ip);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _ipController,
            decoration: InputDecoration(labelText: "Insira o endereço de IP"),
            keyboardType: TextInputType.number,
            onChanged: (text) {
              // Optionally handle any other input logic here.
            },
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: _saveIP,
                child: Text("Salvar"),
              ),
              SizedBox(width: 8.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // close the dialog
                },
                child: Text("Fechar"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}