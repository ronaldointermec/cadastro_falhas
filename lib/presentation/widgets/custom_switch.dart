import 'package:cadastro_falhas/infra/providers/register_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../infra/services/global.dart';

class CustomSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Provider.of<RegisterProvider>(context, listen: false).taggleFamily();
      },
      child: Consumer<RegisterProvider>(builder: (context, value, child) {
        bool _value = value.isNewFamily;
        return Container(
          width: 50,
          height: 25,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: _value ? Global.backgroundColor: Global.backgroundColor,
          ),
          child: Stack(
            children: [
              AnimatedAlign(
                alignment:
                    _value ? Alignment.centerRight : Alignment.centerLeft,
                duration: Duration(milliseconds: 300),
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: _value ? Colors.white : Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
