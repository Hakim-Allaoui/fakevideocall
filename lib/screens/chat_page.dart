import 'package:fakevideocall/utils/constansts.dart';
import 'package:fakevideocall/utils/tools.dart';
import 'package:fakevideocall/widgets.dart';
import 'package:flutter/material.dart';
import 'package:fakevideocall/models/chat_model.dart';
import 'package:fakevideocall/models/user_model.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final User? user;

  const ChatPage({super.key, this.user});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<MessageModel> messages = [];
  final ScrollController _controller = ScrollController();
  int msgIndex = 0;

  void _scrollDown() {
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 1), () {
      MessageModel otherMessageModel = MessageModel(
        sender: james,
        avatarUrl: james.avatarUrl,
        text: Tools.allData!.messages![msgIndex],
        time: DateTime.now(),
        unread: true,
      );

      messages.add(otherMessageModel);

      msgIndex++;

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffece5dd),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
              foregroundColor: Theme.of(context).primaryColor,
              backgroundColor: Colors.grey,
              backgroundImage: Image.asset(
                "assets/bg.png",
                fit: BoxFit.cover,
              ).image,
            ),
            const SizedBox(
              width: 8.0,
            ),
            const Expanded(
              child: Text(
                appName,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: const [
          Icon(Icons.videocam),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
          ),
          Icon(Icons.call),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
          ),
          Icon(Icons.more_vert),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
                controller: _controller,
                reverse: false,
                shrinkWrap: true,
                itemCount:
                    messages.length < Tools.allData!.messages!.length * 2 - 1
                        ? messages.length
                        : messages.length + 1,
                itemBuilder: (context, i) {
                  if (i == messages.length) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MButton(
                        text: "Rate Me",
                        borderRadius: 100.0,
                        height: 50.0,
                        onClicked: () {
                          Tools.launchURL(
                              "https://play.google.com/store/apps/details?id=${Tools.packageInfo.packageName}");
                        },
                      ),
                    );
                  }
                  final bool isMe = messages[i].sender!.id! == currentUser.id;
                  return _buildMessage(messages[i], isMe);
                }),
          ),
          _bulidMessageComposer(
            onMessageSent: (mes) async {
              if (msgIndex == Tools.allData!.messages!.length) {
                Navigator.pop(context);
                return;
              }

              MessageModel myMessage = MessageModel(
                sender: currentUser,
                avatarUrl: currentUser.avatarUrl,
                text: mes,
                time: DateTime.now(),
                unread: true,
              );

              messages.add(myMessage);

              _scrollDown();

              await Future.delayed(
                  Duration(seconds: Tools.getRandomInt(maxNumber: 3)), () {
                MessageModel otherMessage = MessageModel(
                  sender: james,
                  avatarUrl: james.avatarUrl,
                  text: Tools.allData!.messages![msgIndex],
                  time: DateTime.now(),
                  unread: true,
                );

                messages.add(otherMessage);

                msgIndex++;

                _scrollDown();

                setState(() {});
              });
            },
          ),
        ],
      ),
    );
  }

  _buildMessage(MessageModel message, bool isMe) {
    return Container(
      //  child: Text(message.text),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: isMe ? const Color(0xffdcf8c6) : const Color(0xffffffff),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 15.0,
      ),
      margin: isMe
          ? const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 80.0, right: 6.0)
          : const EdgeInsets.only(
              top: 8.0, bottom: 8.0, right: 80.0, left: 6.0),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(message.text!),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(DateFormat('hh:mm a').format(message.time!).toString(),
                  style: const TextStyle(fontSize: 12.0)),
              isMe
                  ? const Icon(
                      Icons.done_all,
                      size: 20.0,
                      color: Colors.blueAccent,
                    )
                  : const Text(''),
            ],
          ),
        ],
      ),
    );
  }

  _bulidMessageComposer({Function(String mes)? onMessageSent}) {
    TextEditingController textEditingController = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              height: 60.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60.0),
                color: Colors.white,
              ),
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.insert_emoticon),
                    iconSize: 25.0,
                    color: Colors.grey,
                    onPressed: () {},
                  ),
                  Expanded(
                    child: TextField(
                      controller: textEditingController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration.collapsed(
                          hintText: 'Type a message'),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.attach_file),
                    iconSize: 25.0,
                    color: Colors.grey,
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.camera_alt),
                    iconSize: 25.0,
                    color: Colors.grey,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 10.0,
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            height: 60.0,
            width: 60.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60.0),
              color: Theme.of(context).primaryColor,
            ),
            child: IconButton(
              icon: const Icon(Icons.send),
              iconSize: 25.0,
              color: Colors.white,
              onPressed: () {
                onMessageSent!(textEditingController.text);
                textEditingController.clear();
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }
}
