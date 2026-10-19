import 'dart:convert';
import 'package:cadastro_falhas/infra/services/global.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../presentation/dto/failure_register_dto.dart';

class WebPrintService {
  static Future<void> printFailure({
    required FailureRegisterDTO dto,
    required int index,
    required BuildContext context,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? printerIp = prefs.getString('ip_address');

      if (printerIp == null || printerIp.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Configure o IP da impressora/servidor primeiro.')),
        );
        return;
      }

      final uri = Uri.parse('${Global.backendUrl}/print');

      List<Map<String, dynamic>> items = [];

      if (index != -1) {
        final part = dto.partNumbers[index];
        items.add({
          'pn': part.partNumber,
          'op': part.orderNumber,
          'classificacao': part.failureClassification ?? '',
          'motivo': part.rejectionReasonNEW ?? '',
          'obs': part.observation ?? '',
          'req': dto.reqId ?? '',
          'qtd': part.quantity.toString(),
          'data': '${dto.createdAt!.day}/${dto.createdAt!.month}/${dto.createdAt!.year}',
        });
      } else {
        for (var part in dto.partNumbers) {
          items.add({
            'pn': part.partNumber,
            'op': part.orderNumber,
            'classificacao': part.failureClassification ?? '',
            'motivo': part.rejectionReasonNEW ?? '',
            'obs': part.observation ?? '',
            'req': dto.reqId ?? '',
            'qtd': part.quantity.toString(),
            'data': '${dto.createdAt!.day}/${dto.createdAt!.month}/${dto.createdAt!.year}',
          });
        }
      }

      final body = {
        'ip': printerIp,
        'template': 'failure_label',
        'data': items,
      };

      debugPrint('WebPrintService: enviando requisição para $uri');

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Impressão realizada com sucesso via Web!')),
        );
      } else {
        throw Exception('Erro ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      debugPrint('WebPrintService erro: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao imprimir: $e')),
      );
    }
  }
}
