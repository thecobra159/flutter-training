import 'package:flutter/material.dart';
import 'package:youtube/API.dart';
import 'package:youtube/model/Video.dart';
import 'package:flutter_youtube/flutter_youtube.dart';

// ignore: must_be_immutable
class Initial extends StatefulWidget {
  String search;

  Initial(this.search);

  @override
  _InitialState createState() => _InitialState();
}

class _InitialState extends State<Initial> {
  _listVideos(String search) {
    var api = API();
    return api.search(search);
  }

  @override
  void initState() {
    super.initState();
    print("chmado 1 - initState");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("chmado 2 - didChangeDependencies");
  }

  @override
  void didUpdateWidget(Initial oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("chmado 2 - didUpdateWidget");
  }

  @override
  void dispose() {
    super.dispose();
    print("chmado 4 - dispose");
  }

  @override
  Widget build(BuildContext context) {
    print("chmado 3 - build");
    return FutureBuilder<List<Video>>(
      future: _listVideos(widget.search),
      // ignore: missing_return
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
            break;
          case ConnectionState.active:
            // TODO: Handle this case.
            break;
          case ConnectionState.done:
            if (snapshot.hasData) {
              return ListView.separated(
                  itemBuilder: (context, index) {
                    var videos = snapshot.data;
                    var video = videos[index];
                    return GestureDetector(
                      onTap: () {
                        FlutterYoutube.playYoutubeVideoById(
                            apiKey: YOUTUBE_API_KEY,
                            videoId: video.id,
                            autoPlay: true,
                          fullScreen: true
                        );
                      },
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                                image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(video.image))),
                          ),
                          ListTile(
                            title: Text(video.title),
                            subtitle: Text(video.channel),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => Divider(
                        height: 2,
                        color: Colors.grey,
                      ),
                  itemCount: snapshot.data.length);
            } else {
              return Center(
                child: Text("Nenhum dado a ser exibido"),
              );
            }
            break;
        }
      },
    );
  }
}
