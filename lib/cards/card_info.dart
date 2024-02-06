import 'package:flutter/material.dart';

class InfoPet extends StatelessWidget {
  const InfoPet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: 400,
              child: Stack(
                children: [
                  PageView(
                    children: [
                      Image.network(
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/8/89/Zunge_raus.JPG/800px-Zunge_raus.JPG',
                        fit: BoxFit.cover,
                      ),
                      Image.network(
                        'https://via.placeholder.com/800x400', // Замените на URL вашего второго изображения
                        fit: BoxFit.cover,
                      ),
                      Image.network(
                        'https://via.placeholder.com/800x400', // Замените на URL вашего третьего изображения
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: IconButton(
                  color: Colors.white,
                  icon: Icon(Icons.arrow_back),
                  iconSize: 30,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 350,
                ),
                SizedBox(height: 20.0),
                Container(
                    padding: EdgeInsets.all(20),
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height - 370,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    alignment: Alignment.topCenter,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Текст',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 35.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(
                                icon: Icon(
                                  Icons.favorite_border,
                                  color: Colors.black,
                                ),
                                iconSize: 40,
                                onPressed: () {
                                  // Действие по нажатию на кнопку сердца
                                },
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Text(
                            'Текст',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Текст',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
