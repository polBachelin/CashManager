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
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
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
                            const SizedBox(
                              width: 40,
                              height: 40,
                            ),
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
                                  ),
                                  const SizedBox(height: 3),
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
