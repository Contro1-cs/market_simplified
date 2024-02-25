import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hushh_proto/main.dart';
import 'package:hushh_proto/modules/chats/models/message_model.dart';
import 'package:hushh_proto/modules/chats/screens/results.dart';
import 'package:hushh_proto/modules/chats/widgets/chart.dart';
import 'package:hushh_proto/modules/chats/widgets/lists.dart';
import 'package:hushh_proto/modules/home/pages/home.dart';
import 'package:hushh_proto/widgets/colors.dart';
import 'package:hushh_proto/widgets/functions.dart';

class AdvancedChat extends StatefulWidget {
  const AdvancedChat({
    super.key,
    required this.title,
    required this.table,
  });
  final String title;
  final String table;

  @override
  State<AdvancedChat> createState() => _AdvancedChatState();
}

class _AdvancedChatState extends State<AdvancedChat> {
  //Variables
  List<Message> advanceChatList = [];
  int questionIndex = 0;
  int currentScore = 0;
  List<FlSpot> barData = [];
  List<Map<String, dynamic>> graphData = [];
  List<Map<String, dynamic>> advanceChatData = [];

  //Controllers
  final StreamController<List<Message>> _streamController =
      StreamController<List<Message>>();
  ScrollController _chatScrollController = ScrollController();

  //Function
  void scrollToBottom() {
    _chatScrollController.animateTo(
      _chatScrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
    setState(() {});
  }

  void clearOptions() {
    advanceChatList.removeWhere((element) => element.format == 'option');
  }

  fetchData() async {
    graphData = await supabase.from(widget.table).select();
    String opt1 = graphData[0]['option1'];
    String opt2 = graphData[0]['option2'];
    String opt3 = graphData[0]['option3'];
    String opt4 = graphData[0]['option4'];
    List graph = graphData[0]['graph_data'];
    changeGraph(graph);

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        advanceChatList.add(Message(
          sender: 'model',
          content: nextPatternQuestions[randomNumGenerator(10)],
        ));
      });
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        advanceChatList.add(Message(
          sender: 'user',
          content: opt1,
          format: 'option',
        ));

        advanceChatList.add(Message(
          sender: 'user',
          content: opt2,
          format: 'option',
        ));

        advanceChatList.add(Message(
          sender: 'user',
          content: opt3,
          format: 'option',
        ));

        advanceChatList.add(Message(
          sender: 'user',
          content: opt4,
          format: 'option',
        ));
      });
    });
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  void dispose() {
    _streamController.close();
    _chatScrollController.dispose();
    advanceChatList = [];
    super.dispose();
  }

  changeGraph(List list) {
    barData = [];
    for (var element in list) {
      double x = double.parse(element['x'].toString());
      double y = double.parse(element['y'].toString());
      barData.add(FlSpot(x, y));
    }
    setState(() {});
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
      body: advanceChatList.isEmpty
          ? const Center(
              child: CircularProgressIndicator(
                color: Pallet.white,
              ),
            )
          : Column(
              children: [
                //Chart
                Container(
                  height: 200,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Pallet.white.withOpacity(0.1),
                  ),
                  child: LineChartWidget(
                    barData: barData,
                  ),
                ),

                //Chat Section
                Expanded(
                  child: StreamBuilder<List<Message>>(
                    initialData: advanceChatList,
                    stream: _streamController.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Message> data = snapshot.data as List<Message>;

                        //Function
                        nextQuestion() {
                          String question =
                              nextPatternQuestions[randomNumGenerator(10)];
                          String opt1 = graphData[questionIndex]['option1'];
                          String opt2 = graphData[questionIndex]['option2'];
                          String opt3 = graphData[questionIndex]['option3'];
                          String opt4 = graphData[questionIndex]['option4'];
                          List graph = graphData[questionIndex]['graph_data'];
                          List options = [opt1, opt2, opt3, opt4];

                          changeGraph(graph);

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
                          scrollToBottom();
                        }

                        checkAnswer(String selected) {
                          int answer = graphData[questionIndex]['answer'];
                          String option =
                              graphData[questionIndex]['option${answer}'];
                          debugPrint('opt:$questionIndex $answer $option');
                          debugPrint('selected: $selected');

                          int tempNum = randomNumGenerator(10);
                          Future.delayed(const Duration(seconds: 1), () {
                            if (selected == option) {
                              currentScore++;
                              data.add(
                                Message(
                                  sender: 'model',
                                  content: correctResponses[tempNum],
                                ),
                              );
                            } else {
                              currentScore--;
                              data.add(
                                Message(
                                  sender: 'model',
                                  content: wrongResponses[tempNum],
                                ),
                              );
                            }
                            setState(() {});
                          }).then((value) {
                            if (questionIndex == graphData.length - 1) {
                              Future.delayed(const Duration(seconds: 1), () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()),
                                    (route) => false);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ResultPage(
                                      score: currentScore,
                                      total: graphData.length,
                                      basic: false,
                                    ),
                                  ),
                                );
                              });
                            } else {
                              Future.delayed(const Duration(seconds: 1), () {
                                setState(() {
                                  nextQuestion();
                                });
                              }).then(
                                (value) => scrollToBottom(),
                              );
                            }
                          });
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
                                  });
                                  checkAnswer(message);
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
                const SizedBox(height: 10),
              ],
            ),
    );
  }
}
