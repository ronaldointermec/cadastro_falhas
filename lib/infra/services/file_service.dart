import 'dart:io';
import 'package:share_plus/share_plus.dart';
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

  // código original Gabriel
  // createCsvMobile(List<int> data) async {
  //   if (await Permission.storage.status.isDenied) {
  //     await Permission.storage.request();
  //   } else {
  //     var dir = await getDownloadsDirectory();
  //     String file = dir?.path ?? '';
  //     File f = File("$file/${DateTime.now()}.csv");
  //     await f.writeAsBytes(data, flush: true);
  //   }
  // }



  Future<void> createCsvMobile(List<int> data) async {
    try {
      // 1. No Android 7, precisamos garantir a permissão de escrita
      if (await Permission.storage.request().isGranted) {

        // 2. Força o caminho da pasta pública de Downloads do Android 7
        final String path = '/storage/emulated/0/Download';
        final Directory downloadDir = Directory(path);

        if (!await downloadDir.exists()) {
          await downloadDir.create(recursive: true);
        }

        String fileName = "relatorio_falhas_${DateTime.now().millisecondsSinceEpoch}.csv";
        File f = File("${downloadDir.path}/$fileName");

        // 3. Grava o arquivo físico na pasta pública
        await f.writeAsBytes(data, flush: true);

        debugPrint("Arquivo gravado com sucesso em: ${f.path}");

        // 4. Abre a folha de compartilhamento nativa para garantir que o usuário veja o arquivo no Android 7
        await Share.shareXFiles(
          [XFile(f.path)],
          text: 'Aqui está o seu relatório extraído.',
        );
      } else {
        debugPrint("Permissão de armazenamento foi negada pelo usuário.");
      }
    } catch (e) {
      debugPrint("Erro ao exportar CSV no Android 7: $e");
    }
  }

// para usar em todos as versões de Android

  // Future<void> createCsvMobile(List<int> data) async {
  //   try {
  //     // 1. Salva em um diretório temporário isolado do app (Funciona do Android 4.4 ao 14+ sem pedir permissão)
  //     var dir = await getTemporaryDirectory();
  //     String fileName = "relatorio_falhas_${DateTime.now().millisecondsSinceEpoch}.csv";
  //     File f = File("${dir.path}/$fileName");
  //
  //     // 2. Grava o arquivo físico na área segura
  //     await f.writeAsBytes(data, flush: true);
  //
  //     debugPrint("Arquivo gerado temporariamente em: ${f.path}");
  //
  //     // 3. Abre a janela nativa do sistema operacional (Funciona em todos os Androids)
  //     // Nos Androids novos, o usuário clica em "Salvar no dispositivo" ou "Salvar em Arquivos" para escolher a pasta Downloads
  //     await Share.shareXFiles(
  //       [XFile(f.path)],
  //       text: 'Relatório de Falhas Extraído',
  //     );
  //   } catch (e) {
  //     debugPrint("Erro ao exportar CSV no ambiente Mobile: $e");
  //   }
  // }



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
