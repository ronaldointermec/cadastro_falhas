import 'package:cadastro_falhas/infra/providers/family_provider.dart';
import 'package:cadastro_falhas/infra/providers/register_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'custom_switch.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({
    super.key,
  });

  //final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Provider.of<FamilyProvider>(context, listen: false).initData();
    Color _color = Colors.lightBlueAccent;
    return Drawer(
      // width: MediaQuery.of(context).size.width * 0.25,
      backgroundColor: _color,
      child: Column(
        children: [
          Column(
            children: [
              Container(
                height: 160,
                child: Center(
                  child: Text(
                    'Cadastro',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontSize: 50.0),
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    topLeft: Radius.circular(20.0)),
              ),
              child:
                  Consumer<RegisterProvider>(builder: (context, value, child) {
                bool _isNewFamily = value.isNewFamily;

                return Form(
                  key: Provider.of<RegisterProvider>(context, listen: false)
                      .formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 40.0,
                      ),
                      ListTile(
                        title: Text(
                          'Nova Família?',
                          style: TextStyle(color: _color, fontSize: 20.0),
                        ),
                        trailing: CustomSwitch(),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      _isNewFamily
                          ? Container()
                          : Consumer<FamilyProvider>(
                              builder: (context, value, child) {
                                return DropdownButtonFormField(

                                  validator: (String? value) {
                                    if (value == null || value.isEmpty)
                                      return "Selecione uma família";
                                    return null;
                                  },
                                  icon: Icon(
                                    Icons.list,
                                    color: _color,
                                  ),
                                  items: value.data
                                      .map(
                                        (name) => DropdownMenuItem(
                                          value: name,
                                          child: Text(
                                            name,
                                            style: TextStyle(color: _color),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (String? value) {
                                    if (value != null && value.isNotEmpty) {
                                      Provider.of<RegisterProvider>(context,
                                              listen: false)
                                          .familyController.text
                                           = value!;
                                    }
                                  },
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: _color, width: 2.0),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: _color, width: 2.0),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: _color, width: 2.0),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    label: Text(
                                      'Família',
                                      style: TextStyle(color: _color),
                                    ),
                                  ),
                                );
                              },
                            ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        controller: Provider.of<RegisterProvider>(context,
                                listen: false)
                            .reasonController,
                        style: TextStyle(color: _color),
                        keyboardType: TextInputType.text,
                        validator: (String? value) {
                          if (value == null || value.isEmpty)
                            return "Digite um valor";
                          return null;
                        },
                        //autofocus: true,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: _color, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: _color, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: _color, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          label: Text(
                            _isNewFamily ? 'Família' : 'Motivo',
                            style: TextStyle(color: _color),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(backgroundColor: _color),
                        onPressed:() {
                          Provider
                              .of<RegisterProvider>(context,
                              listen: false)
                              .submit(context);


                        },
                        child: Text(
                          'Salvar Cadastro',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      // ListTile(
                      //   title: Text('Tap me!'),
                      //   onTap: () => Navigator.of(context).pop(),
                      // ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
