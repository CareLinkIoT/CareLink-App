import 'dart:convert';
import 'package:http/http.dart' as http;

/// Mobius 서버에 센서 데이터를 전송하는 함수
Future<void> sendToMobius(String data, String containerName) async {
  final String mobiusUrl = 'http://13.125.234.57:7579/Mobius/justin/$containerName';
  const String origin = 'CAdmin';

  final response = await http.post(
    Uri.parse(mobiusUrl),
    headers: {
      'X-M2M-Origin': origin,
      'X-M2M-RI': 'req123456',
      'Content-Type': 'application/vnd.onem2m-res+json; ty=4',
      'Accept': 'application/json',
    },
    body: jsonEncode({
      "m2m:cin": {
        "con": data,
      }
    }),
  );

  if (response.statusCode == 201) {
    print("✅ Mobius 전송 성공 ($containerName): $data");
  } else {
    print("❌ Mobius 전송 실패: ${response.statusCode}");
    print(response.body);
  }
}