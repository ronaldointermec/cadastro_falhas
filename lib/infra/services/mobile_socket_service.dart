import 'dart:io';
import 'dart:async';
import 'package:cadastro_falhas/presentation/formatters/label.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../presentation/dto/failure_register_dto.dart';
import '../../presentation/dto/part_number_dto.dart';

class MobileSocketService extends ChangeNotifier {
  static String? host;
  static final int port = 9100;
  Socket? socket;
  bool isPrinting = false;

  MobileSocketService();

  Future<void> connectToSocket({FailureRegisterDTO? dto, int? index}) async {
    try {
      isPrinting = true;
      notifyListeners();

      debugPrint('Debug: estabelecendo conexão com socket');

      SharedPreferences _prefs = await SharedPreferences.getInstance();

      host = _prefs?.getString('ip_address');
      socket ??= await Socket.connect(
        host,
        port,
        // sourceAddress: host,
        // sourcePort: port,
        //timeout: Duration(seconds: 10),
      );

      debugPrint(
          'Debug: conectando em: ${socket!.remoteAddress.address}:${socket!.remotePort}');

      // Send label(s) to the printer
      await _print(index, dto);

      // Listen for responses from the printer
      // _listenToPrinter();
    } on SocketException catch (e) {
      debugPrint('Debug: erro do socket: $e');

      _cleanup();
    } catch (e) {
      debugPrint('Debug: erro inesperado: $e');

      _cleanup();
    }
  }

  Future<void> _print(int? index, FailureRegisterDTO? dto) async {
    debugPrint('Debug: iniciando impressão');

    if (index != -1) {
      debugPrint('Debug: somente uma etiqueta');

      try {
        final label = _generateLabel(dto!.partNumbers[index!], dto);
        debugPrint('Debug: etiqueta gerada com sucesso');

        debugPrint('Debug: tentando imprimir');

        socket!.write(label);

        debugPrint('Debug: impressão realizada com sucesso');

        _cleanup();
      } catch (e) {
        debugPrint('Debug: erro inesperado: $e');
      }
    } else {
      debugPrint('Debug: quantidade de ${dto!.partNumbers.length} etiquetas');

      // int index = 1;
      for (var part in dto!.partNumbers) {
        final label = _generateLabel(part, dto);
        debugPrint('Debug: imprimindo etiqueta de número: $index ');

        socket!.write(label);
        //  index++;
        await Future.delayed(Duration(seconds: 2)); // Throttle the sending
      }
      _cleanup();
    }
  }

  String _generateLabel(PartNumberDTO part, FailureRegisterDTO? dto) {
    debugPrint('Debug: tentando gerar etiqueta...');

    Label label = Label(
      pn: part.partNumber,
      op: part.orderNumber,
      classificacao: part.failureClassification!,
      motivo: part.rejectionReasonNEW!,
      obs: part.observation!,
      req: dto!.reqId!,
      qtd: part.quantity.toString(),
      data:
          '${dto!.createdAt!.day}/${dto!.createdAt!.month}/${dto!.createdAt!.year}',
    );

    return label.getTemplate();
  }

  void _listenToPrinter() {
    try {
      debugPrint('Debug: tentando ouvir a impressora');

      socket!.listen((data) {
        debugPrint('Debug: recebido: ${String.fromCharCodes(data)}');
      }, onDone: () {
        debugPrint('Debug: impressora desconectada');

        _cleanup();
      }, onError: (error) {
        debugPrint('Debug: erro de conexão: $error');

        _cleanup();
      });
    } catch (e) {
      debugPrint('Debug: erro inesperado: $e');
    }
  }

  void _cleanup() {
    isPrinting = false;
    notifyListeners();
    debugPrint('Debug: fechando o socket');

    try {
      socket?.close(); // Use close instead of destroy for cleaner shutdown
      socket = null;
    } catch (e) {
      debugPrint('Debug: erro ao fechar socket: $e');
    }
    // Avoid dangling reference to socket
  }
}
