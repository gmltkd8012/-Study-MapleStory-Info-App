import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:maple_info_app/model/ocid_model.dart';

import '../model/character_base_model.dart';

class Apiservice {


  /// 공용 API 키 & Header
  static const String apiHeader = "x-nxopen-api-key";
  static const String apiKey = "test_3b6a949347190572d7375b76ab18f2ac0a7bfac78da8ade3a4243cf87808e139efe8d04e6d233bd35cf2fabdeb93fb0d";

  // Base Url
  static const String baseUrl = "https://open.api.nexon.com";

  // Ocid API 및 Params
  static const String ocidEndPoint = "maplestory/v1/id";
  static const String ocidCharacterParams1 = "character_name";


  // 캐릭터 기본 정보 조회 API 및 Params
  static const String characterBaseEndPoint = "maplestory/v1/character/basic";
  static const String characterBaseParams1 = "ocid";
  static const String characterBaseParams2 = "date";

  // 개별 Input 데이터
  static const List<String> characterNameList = ['억음스커', '예티쿠션'];

  // ocid cache list
  static const List<String> ocidListbyApi = [];


  static Future<OcidModel> getOcidData(String name) async {

    final response = await http.get(
      Uri.parse('$baseUrl/$ocidEndPoint?'
          '$ocidCharacterParams1=$name'),
      headers: <String, String> {
        apiHeader : apiKey
      },
    );

    if (response.statusCode == 200) {
      print('성공 -> ${response.body}');
      return OcidModel.fromjson(jsonDecode(response.body));
    }

    throw Error();
  }

  static Future<CharacterBaseModel> getCharacterBaseData(String name) async {
    try {
      OcidModel ocidData = await getOcidData(name);
      String ocid = ocidData.ocid;
      String date = "2024-07-31";

      //ocidListbyApi.add(ocid);

      final response = await http.get(
        Uri.parse('$baseUrl/$characterBaseEndPoint?'
            '$characterBaseParams1=$ocid&'
            '$characterBaseParams2=$date'),
        headers: <String, String> {
          apiHeader : apiKey
        },
      );

      if (response.statusCode == 200) {
        print('캐릭터 정보 조회 성공 -> ${response.body}');
        return CharacterBaseModel.fromjson(jsonDecode(response.body));
      } else {
        print('캐릭터 정보 조회 실패 -> ${response.body}');
      }
    } catch (e) {
      print('오류 -> $e');
    }

    throw Error();
  }


  static Future<List<CharacterBaseModel>> getCharacterBaseList() async {
    List<CharacterBaseModel> modelList = [];

    for (var name in characterNameList) {
      CharacterBaseModel characterBaseModel = await getCharacterBaseData(name);
      print('데이터 -> $characterBaseModel');
      modelList.add(characterBaseModel);
    }

    return modelList;
  }
}