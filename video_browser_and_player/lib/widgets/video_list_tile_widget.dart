import 'package:flutter/material.dart';

import '../model/user.dart';
import '../model/video.dart';
import '../pages/video_page.dart';

class VideoListTile extends StatelessWidget {
  final Video video;
  final User user;
  const VideoListTile({Key? key, required this.video, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network('https://vumbnail.com/${video.url}.jpg'),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          video.userImage != ''
              ? CircleAvatar(
                  backgroundImage: NetworkImage(video.userImage),
                  radius: 15,
                )
              : const Icon(Icons.person),
          Flexible(
            child: Container(
              padding: EdgeInsets.all(5.0),
              child: Text(
                video.user,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _videoViewsForm(video.views),
          _videoLikesForm(video.likes),
          _videoMessagesForm(video.comments),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VideoPage(video: video, user: user)),
        );
      },
    );
  }

  Widget _videoViewsForm(int videoViews) {
    return Row(
      children: [
        const Icon(Icons.remove_red_eye, color: Colors.grey),
        const SizedBox(width: 2),
        Text(videoViews.toString()),
      ],
    );
  }

  Widget _videoLikesForm(int videoLikes) {
    return Row(
      children: [
        const Icon(Icons.thumb_up_alt_outlined, color: Colors.grey),
        const SizedBox(width: 2),
        Text(videoLikes.toString()),
      ],
    );
  }

  Widget _videoMessagesForm(int videoMessages) {
    return Row(
      children: [
        const Icon(Icons.messenger_outline, color: Colors.grey),
        const SizedBox(width: 2),
        Text(videoMessages.toString()),
      ],
    );
  }
}
