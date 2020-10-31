import 'dart:convert';
import 'dart:io';

import 'package:string_similarity/string_similarity.dart';

class TweetService {
  static Future<bool> containMisLeadingContent(String text) async {
    // get misleading information
    HttpClientRequest request = await HttpClient().getUrl(Uri.parse('https://www2.yoslab.net/~kakimoto/rumor_background/get_rumors/rumors.txt'));
    HttpClientResponse response = await request.close();
    String responseBodyText = await utf8.decodeStream(response);

    bool result = false;
    for (String line in responseBodyText.split("\n\n")) {
      List<String> info = line.split("\t");

      if (info.length < 6) continue;
      if (text.similarityTo(info[4]) >= 0.5) { // TODO: 0.5 is tentative
        result = true;
        break;
      }
    }
    return result;
  }
}