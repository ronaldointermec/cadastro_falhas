import 'package:flutter/material.dart';

class Label {
  final String pn, op;
  final String classificacao, motivo, obs;
  final String req, qtd, data;

  Label({
    required this.pn,
    required this.op,
    required this.classificacao,
    required this.motivo,
    required this.obs,
    required this.req,
    required this.qtd,
    required this.data,
  });

  // Método para dividir a string em duas partes
  List<String> splitText(String text) {
    // Se a string tiver mais de 25 caracteres, divide em duas partes
    if (text.length > 25) {
      String firstPart = text.substring(0, 25);
      String secondPart = text.substring(25);
      return [firstPart, secondPart];
    } else {
      // Se a string tiver 25 caracteres ou menos, retorna a string original e uma vazia
      return [text, ''];
    }
  }

  // As partes da string estão acessíveis através de getters
  List<String> get classificacaoParts => splitText(classificacao);

  List<String> get motivoParts => splitText(motivo);

  List<String> get obsParts => splitText(obs);

  String getTemplate() {
    // String status = dto.aproved.toString().split('.')[1];

    return '''
'Seagull:2.1:DP
INPUT OFF
VERBOFF
INPUT ON
SYSVAR(48) = 0
ERROR 15,"FONT NOT FOUND"
ERROR 18,"DISK FULL"
ERROR 26,"PARAMETER TOO LARGE"
ERROR 27,"PARAMETER TOO SMALL"
ERROR 37,"CUTTER DEVICE NOT FOUND"
ERROR 1003,"FIELD OUT OF LABEL"
SYSVAR(35)=0
OPEN "tmp:setup.sys" FOR OUTPUT AS #1
PRINT#1,"Printing,Media,Media Margin (X),0"
PRINT#1,"Printing,Media,Clip Default,On"
CLOSE #1
SETUP "tmp:setup.sys"
KILL "tmp:setup.sys"
CLIP ON
CLIP BARCODE ON
LBLCOND 3,2
CLL
OPTIMIZE "BATCH" ON
PP371,647:AN7
DIR4
NASC 8
FT "CG Triumvirate Condensed Bold"
FONTSIZE 10
FONTSLANT 0
PT "${op}"
PP87,799:AN1
DIR2
PL736,179
PP89,233:AN7
DIR4
II
FONTSIZE 12
PT "NAO UTILIZAR"
PP178,123:PT "MATERIAL REJEITADO"
PP323,643:NI
FONTSIZE 7
PT "Op"
PP381,56:FONTSIZE 10
PT "${pn}"
PP456,55:FONTSIZE 7
PT "Classificacao"
PP501,53:FONTSIZE 10
PT "${classificacaoParts[0]}"
PP573,53:PT "${classificacaoParts[1]}"
PP646,54:FONTSIZE 7
PT "Motivo de rejeicao"
PP875,51:FONTSIZE 10
PT "${obsParts[0]}"
PP947,51:PT "${obsParts[1]}"
PP829,52:FONTSIZE 7
PT "Observacao"
PP1074,57:FONTSIZE 10
PT "${req}"
PP1025,59:FONTSIZE 7
PT "Requisicao"
PP1020,422:PT "Quantidade"
PP1153,56:PT "Data"
PP1199,55:FONTSIZE 10
PT "${data}"
PP328,57:FONTSIZE 7
PT "Part number"
PP689,53:FONTSIZE 10
PT "${motivoParts[0]}"
PP761,53:PT "${motivoParts[1]}"
PP1065,426:PT "${qtd}"
PP324,626:AN1
DIR1
PL127,6
PP1273,838:DIR2
PL808,6
PP1020,411:DIR1
PL127,6
PP1144,837:DIR2
PL806,6
PP1016,838:PL808,6
PP827,833:PL802,6
PP637,834:PL803,6
PP450,834:PL803,6
PP320,838:PL807,6
PP48,30:DIR1
PL1225,6
PP48,839:DIR2
PL809,6
PP51,833:DIR1
PL1227,6
LAYOUT RUN ""
PF
PRINT KEY OFF
''';
  }
}
