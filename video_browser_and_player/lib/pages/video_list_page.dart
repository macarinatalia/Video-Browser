import 'package:flutter/material.dart';
import 'package:video_browser_and_player/model/video.dart';
import 'package:video_browser_and_player/widgets/video_list_tile_widget.dart';
import '../model/user.dart';
import '../utilities/constants.dart';
import '../widgets/user_info_widget.dart';

class VideoListPage extends StatefulWidget {
  final User user;
  const VideoListPage({Key? key, required this.user}) : super(key: key);

  @override
  State<VideoListPage> createState() => _VideoListPage();
}

class _VideoListPage extends State<VideoListPage> {
  late Future<VideoList> _videoList;
  String url = '';

  @override
  void initState() {
    super.initState();
    _videoList = getVideoList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _logoForm(),
        backgroundColor: Colors.white,
        title: Text(
          '${widget.user.login}\u0027s playlist',
          style: myAppBarTitleStyle,
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(
              onPressed: () {
                _showUserInfoDialog(user: widget.user);
              },
              icon: const Icon(Icons.person)),
        ],
        actionsIconTheme: myAppBarIconStyle,
      ),
      body: Container(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Expanded(
              child: _videoListForm(),
            )
          ],
        ),
      ),
    );
  }

  void _showUserInfoDialog({required User user}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return UserInfoDialog(user: user);
        });
  }

  Widget _logoForm() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Image.asset('assets/pixabay_logo_icon_small.png'),
    );
  }

  Widget _videoListForm() {
    return FutureBuilder<VideoList>(
      future: _videoList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data?.videos.length,
            itemBuilder: (context, index) {
              return Card(
                child: VideoListTile(
                  video: snapshot.data?.videos[index] as Video,
                  user: widget.user,
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return const Text('Error');
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
