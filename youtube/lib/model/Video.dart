class Video {
  String id;
  String title;
  String description;
  String image;
  String channel;

  Video({this.id, this.title, this.description, this.image, this.channel});

  factory Video.fromJson(Map<String, dynamic> map) {
    return Video(
        id: map["id"]["videoId"],
        title: map["snippet"]["title"],
        description: map["snippet"]["description"],
        image: map["snippet"]["thumbnails"]["high"]["url"],
        channel: map["snippet"]["channelTitle"]);
  }
}
