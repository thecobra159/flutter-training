import 'package:http/http.dart' as http;
import 'dart:convert';

import 'model/Video.dart';

const YOUTUBE_API_KEY = "AIzaSyA3TsLpfShwE_lYl_WIclFap9ofUbJjzu8";
const CHANNEL_ID = "UC2oZNzo6o37qejkFQE2dIAA";
const URL_BASE = "https://www.googleapis.com/youtube/v3/";

class API {
  // ignore: missing_return
  Future<List<Video>> search(String search) async {
    http.Response response = await http.get(
        URL_BASE + "search"
            "?part=snippet"
            "&type=video"
            "&maxResults=20"
            "&order=date"
            "&key=$YOUTUBE_API_KEY"
            "&channelId=$CHANNEL_ID"
            "&q=$search"
    );

    if(response.statusCode == 200) {
      var body = response.body;
      Map<String, dynamic> jsonData = json.decode(body);
      List<Video> videos = jsonData["items"].map<Video> (
          (map) {
            return Video.fromJson(map);
          }
      ).toList();

      for(var video in videos) {
        print("resultado: " + video.title);
      }

      return videos;
    } else {

    }
  }
}