import 'package:flutter/material.dart';

class ChatAdopt extends StatefulWidget {
  @override
  _ChatAdoptState createState() => _ChatAdoptState();
}

class _ChatAdoptState extends State<ChatAdopt> {
  List<String> _messages = [];
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 24, 24, 24),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 24, 24, 24),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/555.jpg'),
              radius: 20,
            ),
            SizedBox(
              width: 8,
            ),
            Text('Ивис Бот', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true, // Чтобы список скроллился к последнему сообщению
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: _messages[index].startsWith('You')
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: _messages[index].startsWith('You')
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Transform.rotate(
                          angle: _messages[index].startsWith('You')
                              ? 0
                              : 3.14, // Поворот на 180 градусов (пи)
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width *
                                  0.7, // Устанавливаем максимальную ширину контейнера
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 12.0,
                              horizontal: 16.0,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 228, 124, 93),
                                  Color.fromARGB(255, 232, 76, 128),
                                  Color.fromARGB(196, 184, 87, 233),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(14.0),
                            ),
                            child: Text(
                              _messages[index],
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      controller: _textEditingController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Enter message',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none, // Убираем границу
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(30.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30.0),
                    onTap: () {
                      _sendMessage();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    setState(() {
      String message = _textEditingController.text;
      _messages.insert(0, 'You: $message');
      _textEditingController.clear();
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
