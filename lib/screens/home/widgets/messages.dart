import 'package:flutter/material.dart';

import 'package:bubble/bubble.dart';

class Messages extends StatefulWidget {
  final List<Map<String, dynamic>> messages;
  const Messages({super.key, required this.messages});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView.builder(
        itemCount: widget.messages.length,
        itemBuilder: (context, index) => chat(
            widget.messages[index]['message'].text.text[0],
            widget.messages[index]['isUserMessage']),
      ),
    );
  }

  Widget chat(String message, bool isUserMessage) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment:
            isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          isUserMessage
              ? Container()
              : const SizedBox(
                  height: 60,
                  width: 60,
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/robot.png"),
                  ),
                ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Bubble(
              radius: const Radius.circular(15),
              color: isUserMessage ? Colors.black : Colors.grey.shade200,
              elevation: 0.0,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 200),
                  child: Text(
                    message,
                    style: TextStyle(
                      color: isUserMessage ? Colors.white : Colors.black,
                      fontWeight:
                          isUserMessage ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
          isUserMessage
              ? const SizedBox(
                  height: 60,
                  width: 60,
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/default.jpg"),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
