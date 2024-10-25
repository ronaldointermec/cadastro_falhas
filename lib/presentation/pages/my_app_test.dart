import 'package:cadastro_falhas/infra/services/mobile_socket_service.dart';
import 'package:cadastro_falhas/presentation/dto/failure_register_dto.dart';
import 'package:cadastro_falhas/presentation/dto/part_number_dto.dart';
import 'package:flutter/material.dart';

class MyAppTest extends StatelessWidget {
  const MyAppTest({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('For Testing  Only'),
          ),
        ),
        body: Center(
          child: IconButton(
            onPressed: () {
              // PartNumberDTO dtoPN = PartNumberDTO(partNumber: '123-456-789',
              //     orderNumber: '911',
              //     requestDate: DateTime.now(),
              //     quantity: 9,
              //     family: 'Tag',
              //     rejectionReasonNEW: "Qualidade",
              //     numberMircossiga: '897',
              //     aproved: ApprovalStatus.Aberto,
              //     failureClassification: 'Flat quebrado');
              // FailureRegisterDTO dto = FailureRegisterDTO(
              //     requester: 'Ronaldo', partNumbers: [dtoPN]);
              // MobileSocketService service = MobileSocketService(dto: dto,index: 0);
              //    service.connectToSocket();
              // // WebSocketService serviceWeb = WebSocketService(dto: dto,index: 0);
              // // serviceWeb.connectToWebSocket();

            },
            icon: Icon(
              Icons.print,
              size: 80,
            ),
          ),
        ),
      ),
    );
  }
}
