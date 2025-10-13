import 'dart:convert';
import 'package:http/http.dart' as http;
// void main() {
//   l('''从前，有一大一小两个和尚出门化缘，起到一条河边时，看见一个妙龄女子被水围困着不能过河，于是大和尚毫不犹豫地将她背起过了河。小和尚大为不解，晚上便忍不住问道：

// “师兄，出家人六根清净，你背了那女人，不是犯了戒吗?”

// 大和尚答道：“我背那女子一过河就放下了，可师弟你，为什么到现在还背着她放不下来?”,''');

//   // sendRequest(
//   //     '从前，有一大一小两个和尚出门化缘，起到一条河边时，看见一个妙龄女子被水围困着不能过河，于是大和尚毫不犹豫地将她背起过了河。小和尚大为不解，晚上便忍不住问道：');
// }

l(String s) async {
  String sumstring = '';

  s = s.replaceAll('\n', '\\');
  // s = s.replaceAll('\n', '\\');
  // s = s.trim();

  List<String> g = s.split('，');
  List<String> sumlist = [];

  for (var i = 0; i < g.length; i++) {
    if (g[i].trim().isEmpty) continue;

    String? f = await sendRequest(g[i]);
    sumlist.add(f);
  }
  sumstring = sumlist.join();
  return sumstring = sumstring.replaceAll('\\', '\n');
}

Future<String> sendRequest(String s) async {
  final url = Uri.parse('http://127.0.0.1:8000/res/dd');

  final headers = {
    'accept': 'application/json',
    'Content-Type': 'application/json',
  };

  final body = jsonEncode({'chinese_text': s});

  try {
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      var response2 = TranslationResponse.fromJson(jsonDecode(response.body));
      String fs =
          response2.result.translations.first.beams.first.sentences.first.text;
      return fs;
    } else {
      return ('Request failed with status: ${response.statusCode}'
          'Body: ${response.body}');
    }
  } catch (e) {
    return ('Error occurred: $e');
  }
}

class TranslationResponse {
  final String jsonrpc;
  final int id;
  final TranslationResult result;

  TranslationResponse({
    required this.jsonrpc,
    required this.id,
    required this.result,
  });

  factory TranslationResponse.fromJson(Map<String, dynamic> json) {
    return TranslationResponse(
      jsonrpc: json['jsonrpc'],
      id: json['id'],
      result: TranslationResult.fromJson(json['result']),
    );
  }
}

class TranslationResult {
  final List<Translation> translations;
  final String targetLang;
  final String sourceLang;
  final bool sourceLangIsConfident;

  TranslationResult({
    required this.translations,
    required this.targetLang,
    required this.sourceLang,
    required this.sourceLangIsConfident,
  });

  factory TranslationResult.fromJson(Map<String, dynamic> json) {
    return TranslationResult(
      translations: (json['translations'] as List)
          .map((t) => Translation.fromJson(t))
          .toList(),
      targetLang: json['target_lang'],
      sourceLang: json['source_lang'],
      sourceLangIsConfident: json['source_lang_is_confident'],
    );
  }
}

class Translation {
  final List<Beam> beams;
  final String quality;

  Translation({
    required this.beams,
    required this.quality,
  });

  factory Translation.fromJson(Map<String, dynamic> json) {
    return Translation(
      beams: (json['beams'] as List).map((b) => Beam.fromJson(b)).toList(),
      quality: json['quality'],
    );
  }
}

class Beam {
  final List<Sentence> sentences;
  final int numSymbols;
  final RephraseVariant rephraseVariant;

  Beam({
    required this.sentences,
    required this.numSymbols,
    required this.rephraseVariant,
  });

  factory Beam.fromJson(Map<String, dynamic> json) {
    return Beam(
      sentences:
          (json['sentences'] as List).map((s) => Sentence.fromJson(s)).toList(),
      numSymbols: json['num_symbols'],
      rephraseVariant: RephraseVariant.fromJson(json['rephrase_variant']),
    );
  }
}

class Sentence {
  final String text;
  final List<int> ids;

  Sentence({
    required this.text,
    required this.ids,
  });

  factory Sentence.fromJson(Map<String, dynamic> json) {
    return Sentence(
      text: json['text'],
      ids: List<int>.from(json['ids']),
    );
  }
}

class RephraseVariant {
  final String name;

  RephraseVariant({required this.name});

  factory RephraseVariant.fromJson(Map<String, dynamic> json) {
    return RephraseVariant(
      name: json['name'],
    );
  }
}
