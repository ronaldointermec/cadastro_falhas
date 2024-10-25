import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:universal_html/html.dart' as html;
import 'package:cadastro_falhas/presentation/dto/failure_register_dto.dart';
import 'package:csv/csv.dart';
import 'dart:convert' as convert;

class FileService {
  void createCsvWeb(List<int> data) {
    final blob =
        html.Blob([Uint8List.fromList(data)], 'text/csv;charset=utf-8');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..style.display = 'none'
      ..download = '${DateTime.now()}.csv';
    html.document.body?.children.add(anchor);

    anchor.click();
    html.document.body?.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }

  createCsvMobile(List<int> data) async {
    if (await Permission.storage.status.isDenied) {
      await Permission.storage.request();
    } else {
      var dir = await getDownloadsDirectory();
      String file = dir?.path ?? '';
      File f = File("$file/${DateTime.now()}.csv");
      await f.writeAsBytes(data, flush: true);
    }
  }

  void createFailureRegisterCsv(dynamic snapshot) async {
    List<List<dynamic>> rows = [];
    rows.add([
      "Requisitante",
      "Criado em",
      "Família",
      "Part number",
      "Número da ordem",
      "Classificação de falha",
      "Motivo de rejeição",
      "Observações",
      "Quantidade",
      "Quantidade atendida",
      "Número Microsiga",
      "Aprovação"
    ]);

    for (var row in snapshot) {
      FailureRegisterDTO dto = FailureRegisterDTO.fromJson(row.data());
      for (var failure in dto.partNumbers) {
        List<dynamic> cells = [
          dto.requester,
          DateFormat('dd/MM/yyyy').format(dto.createdAt!),
          failure.family,
          failure.partNumber,
          failure.orderNumber,
          failure.failureClassification,
          failure.rejectionReasonNEW,
          failure.observation,
          failure.quantity,
          failure.quantityServed,
          failure.numberMircossiga,
          failure.aproved,
        ];
        rows.add(cells);
      }
    }

    String csv = const ListToCsvConverter(
      fieldDelimiter: ';',
      textDelimiter: '"',
    ).convert(rows);

    List<int> csvBytes = convert.latin1.encode(csv);

    if (kIsWeb) {
      createCsvWeb(csvBytes);
    } else {
      await createCsvMobile(csvBytes);
    }
  }
}
