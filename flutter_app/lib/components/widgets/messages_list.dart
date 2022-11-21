import 'package:test_project/data/messages.dart';
import 'package:flutter/material.dart';

class MessagesList extends StatefulWidget {
  const MessagesList({
    Key? key,
  }) : super(key: key);

  @override
  State<MessagesList> createState() => _MessagesListState();
}

class _MessagesListState extends State<MessagesList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: staticMessages.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          final message = staticMessages[index];
          return TweenAnimationBuilder<double>(
            duration: Duration(
              milliseconds: (200 + (index * 100)).toInt() < 1500
                  ? (200 + (index * 100)).toInt()
                  : 1500,
            ),
            tween: Tween(begin: 0, end: 1),
            builder: (_, value, __) => TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 500),
              tween: Tween(begin: (80 * index).toDouble(), end: 0),
              builder: ((_, paddingValue, __) => Container(
                    padding: EdgeInsets.only(top: paddingValue),
                    child: Opacity(
                      opacity: value,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 30),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                                width: 40,
                                height: 40,
                                child: Image.asset(message.image)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        message.contact,
                                        style: const TextStyle(
                                            fontSize: 17,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        message.date,
                                        style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w400),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    message.messageTitle,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    message.message,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black.withOpacity(0.8),
                                        fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )),
            ),
          );
        });
  }
}
