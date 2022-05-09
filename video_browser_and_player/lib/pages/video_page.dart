import 'package:flutter/material.dart';
import 'package:video_browser_and_player/model/user.dart';
import 'package:video_browser_and_player/utilities/constants.dart';
import 'package:video_browser_and_player/utilities/string.dart';
import 'package:video_browser_and_player/widgets/user_info_widget.dart';
import '../model/video.dart';
import 'package:pod_player/pod_player.dart';

import '../widgets/video_list_tile_widget.dart';

class VideoPage extends StatefulWidget {
  final Video video;
  final User user;
  const VideoPage({Key? key, required this.video, required this.user})
      : super(key: key);

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  bool _allowWriteMessage = true;
  int _countMessages = 0;
  late final PodPlayerController _controller;
  final _messageController = TextEditingController();
  late Future<VideoList> _relatedVideoList;

  @override
  void initState() {
    super.initState();
    _controller = PodPlayerController(
      playVideoFrom: PlayVideoFrom.vimeo(widget.video.url),
    )..initialise();
    _countMessages = widget.video.comments;
    _relatedVideoList = getVideoListForTags(widget.video.tags);
  }

  @override
  void dispose() {
    _controller.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
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
        child: Column(
          children: [
            PodVideoPlayer(controller: _controller),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                children: [
                  const SizedBox(height: 10),
                  _userInfoForm(widget.video),
                  _videoInfoForm(widget.video),
                  _messageForm(widget.video.comments),
                  _relatedVideoFrom(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _userInfoForm(Video video) {
    return Container(
      padding: const EdgeInsets.only(bottom: 2, left: 10, right: 10),
      child: Row(
        children: [
          video.userImage != ''
              ? CircleAvatar(
                  backgroundImage: NetworkImage(video.userImage),
                  radius: 18,
                )
              : const Icon(Icons.person),
          Flexible(
            child: Container(
              padding: EdgeInsets.only(left: 10, right: 5),
              child: Text(
                video.user,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _videoInfoForm(Video video) {
    return Container(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Column(
        children: [
          _tagsForm(video.tags),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${video.views} views'),
              Row(
                children: [
                  const Icon(
                    Icons.messenger_outline,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(_countMessages.toString()),
                  Switch(
                    value: _allowWriteMessage,
                    activeColor: Colors.blue,
                    activeTrackColor: Colors.lightBlueAccent,
                    onChanged: (value) {
                      setState(() {
                        _allowWriteMessage = value;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tagsForm(String tags) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: _getTags(tags),
    );
  }

  List<Widget> _getTags(String str) {
    List<String> tags = str.contains(',')
        ? str.split(',').map((e) => e.trim().capitalized()).toList()
        : [str.trim()];
    if (tags.length >= 4) {
      tags.removeRange(3, tags.length);
    }
    return List.generate(tags.length, (index) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: Text(tags[index]),
        margin: const EdgeInsets.symmetric(horizontal: 2.0),
      );
    });
  }

  Widget _messageForm(int count) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
      child: TextFormField(
        enabled: _allowWriteMessage,
        controller: _messageController,
        decoration: InputDecoration(
          hintText: 'Enter your comment',
          enabledBorder: myTextFieldBorderStyle,
          disabledBorder: myTextFieldDisabledBorderStyle,
          focusedBorder: myTextFieldBorderStyle,
          suffixIcon: GestureDetector(
            onTap: () {
              _messageController.clear();
              setState(() {
                _countMessages++;
              });
            },
            child: Icon(
              Icons.send,
              color: _allowWriteMessage ? Colors.green : Colors.grey,
            ),
          ),
        ),
        onSaved: (value) => count++,
      ),
    );
  }

  Widget _relatedVideoFrom() {
    return FutureBuilder<VideoList>(
      future: _relatedVideoList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: snapshot.data?.videos.length,
            itemBuilder: (context, index) {
              return Card(
                child: VideoListTile(
                    video: snapshot.data?.videos[index] as Video,
                    user: widget.user),
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

  void _showUserInfoDialog({required User user}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return UserInfoDialog(user: user);
        });
  }
}
