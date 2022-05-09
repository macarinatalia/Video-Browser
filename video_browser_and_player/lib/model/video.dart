import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

import '../utilities/constants.dart';

class VideoList {
  List<Video> videos;

  VideoList({required this.videos});

  factory VideoList.fromJson(Map<String, dynamic> json) {
    var videosJson = json['hits'] as List;

    List<Video> videos = videosJson.map((i) => Video.fromJson(i)).toList();
    return VideoList(videos: videos);
  }
}

class Video {
  final String url;
  final String tags;
  final String user;
  final String userImage;
  final int views;
  final int likes;
  final int comments;

  Video(
      {required this.url,
      required this.tags,
      required this.user,
      required this.userImage,
      required this.views,
      required this.likes,
      required this.comments});

  factory Video.fromJson(Map<String, dynamic> json) {
    String urlFromJson = (json['videos']['medium']['url'] as String);
    String videoId = '';
    if (urlFromJson.contains('/external/')) {
      videoId = urlFromJson.split('external/')[1].split('.')[0];
    } else {
      videoId = urlFromJson.split('playback/')[1].split('/')[0];
    }

    return Video(
      url: videoId,
      tags: json['tags'] as String,
      user: json['user'] as String,
      userImage: json['userImageURL'] as String,
      views: json['views'] as int,
      likes: json['likes'] as int,
      comments: json['comments'] as int,
    );
  }
}

Future<VideoList> getVideoList() async {
  const url = "https://pixabay.com/api/videos/?key=" + API_KEY;
  final response = await http.get(
    Uri.parse(url),
  );
  if (response.statusCode == 200) {
    return VideoList.fromJson(json.decode(response.body));
  } else {
    throw Exception('Error: ${response.reasonPhrase}');
  }
}

Future<VideoList> getVideoListForTags(String tags) async {
  String str = tags.replaceAll(',', '').replaceAll(' ', '+').trim();
  String url = "https://pixabay.com/api/videos/?key=" + API_KEY + "&q=" + str;
  final response = await http.get(
    Uri.parse(url),
  );
  if (response.statusCode == 200) {
    return VideoList.fromJson(json.decode(response.body));
  } else {
    throw Exception('Error: ${response.reasonPhrase}');
  }
}
