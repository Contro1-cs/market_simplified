import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hushh_proto/modules/chats/models/message_model.dart';
import 'package:hushh_proto/modules/chats/screens/reference.dart';
import 'package:hushh_proto/modules/chats/widgets/lists.dart';
import 'package:hushh_proto/widgets/colors.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
    required this.title,
  });
  final String title;
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  //Variables
  List<Message> chatList = [];
  int questionIndex = 0;

  //Controllers
  ScrollController _chatScrollController = ScrollController();
  final StreamController<List<Message>> _streamController =
      StreamController<List<Message>>();

  //Functions
  clearOptions() {
    chatList.removeWhere((element) => element.format == 'option');
  }

  scrollToBottom() {
    _chatScrollController.animateTo(
      _chatScrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  fetchQuestions() {
    String question = technicalAnalysis[0]['question'];
    List options = technicalAnalysis[0]['options'];
    chatList.add(
      Message(
        sender: 'model',
        content: question,
      ),
    );
    options.forEach((element) {
      chatList.add(
        Message(
          sender: 'user',
          content: element,
          format: 'option',
        ),
      );
    });
  }

  int randomNumGenerator() {
    Random random = Random();
    int randomNumber = random.nextInt(10);
    return randomNumber;
  }

  @override
  void initState() {
    fetchQuestions();
    super.initState();
  }

  @override
  void dispose() {
    _streamController.close();
    _chatScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallet.black15,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Pallet.white),
        backgroundColor: Pallet.black15,
        title: Text(
          widget.title,
          style: TextStyle(
            color: Pallet.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 1,
            width: double.infinity,
            color: Pallet.white.withOpacity(0.5),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: chatList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        lightMode
                            ? SvgPicture.asset("assets/logo_dark.svg")
                            : SvgPicture.asset("assets/logo_light.svg"),
                        const SizedBox(height: 20),
                        Text(
                          'Market Simplified',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Pallet.white,
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  )
                : RawScrollbar(
                    thickness: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    controller: _chatScrollController,
                    child: StreamBuilder<List<Message>>(
                      initialData: chatList,
                      stream: _streamController.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<Message> data = snapshot.data as List<Message>;

                          //Function
                          nextQuestion() {
                            String question =
                                technicalAnalysis[questionIndex]['question'];
                            List options =
                                technicalAnalysis[questionIndex]['options'];
                            data.add(
                              Message(
                                sender: 'model',
                                content: question,
                              ),
                            );
                            options.forEach((element) {
                              scrollToBottom();

                              Future.delayed(const Duration(seconds: 1), () {
                                setState(() {
                                  data.add(
                                    Message(
                                      sender: 'user',
                                      content: element,
                                      format: 'option',
                                    ),
                                  );
                                });
                                scrollToBottom();
                              });
                              scrollToBottom();
                            });
                          }

                          checkAnswer(String selected) {
                            int answer =
                                technicalAnalysis[questionIndex]['answer'];
                            List options =
                                technicalAnalysis[questionIndex]['options'];
                            debugPrint('$questionIndex option: ${selected}');
                            debugPrint(
                                '$questionIndex answer: ${options[answer]}');
                            int tempNum = randomNumGenerator();
                            Future.delayed(const Duration(seconds: 1), () {
                              if (selected == options[answer]) {
                                data.add(
                                  Message(
                                    sender: 'model',
                                    content: correctResponses[tempNum],
                                  ),
                                );
                              } else {
                                data.add(
                                  Message(
                                    sender: 'model',
                                    content: wrongResponses[tempNum],
                                  ),
                                );
                              }
                              setState(() {});
                            }).then(
                              (value) => Future.delayed(
                                  const Duration(seconds: 1), () {
                                setState(() {
                                  nextQuestion();
                                });
                              }),
                            );
                            scrollToBottom();
                          }

                          return ListView.builder(
                            controller: _chatScrollController,
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              Message msg = data[index];
                              bool owner = msg.sender == 'user' ? true : false;
                              bool option = msg.format == 'option';
                              String message = msg.content;

                              return GestureDetector(
                                onTap: () {
                                  if (option) {
                                    clearOptions();
                                    setState(() {
                                      data.add(
                                        Message(
                                          sender: 'user',
                                          content: message,
                                        ),
                                      );
                                      checkAnswer(message);
                                    });
                                    questionIndex++;
                                  }
                                },
                                child: Wrap(
                                  alignment: owner
                                      ? WrapAlignment.end
                                      : WrapAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.fromLTRB(
                                        owner ? 70 : 10,
                                        5,
                                        owner
                                            ? option
                                                ? 25
                                                : 10
                                            : 70,
                                        5,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                          bottomLeft: owner
                                              ? Radius.circular(20)
                                              : Radius.circular(0),
                                          bottomRight: owner
                                              ? Radius.circular(0)
                                              : Radius.circular(20),
                                        ),
                                        color: owner
                                            ? option
                                                ? Colors.grey.withOpacity(0.5)
                                                : Pallet.userChat
                                            : Pallet.modelChat,
                                      ),
                                      child: Text(
                                        message.length < 4
                                            ? '   $message   '
                                            : message,
                                        softWrap: true,
                                        maxLines: null,
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: option
                                              ? Pallet.white.withOpacity(0.8)
                                              : lightMode
                                                  ? Pallet.white
                                                  : Pallet.black30,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
