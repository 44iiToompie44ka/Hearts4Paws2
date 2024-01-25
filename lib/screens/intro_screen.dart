import 'package:flutter/material.dart';
import '../main.dart';

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/intro_image.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const Positioned(
            top: 60.0,
            left: 20.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Код для изображения app_icon удален
                SizedBox(width: 10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome to \nHeart4Paws',
                      style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Where Every Paw \nFinds a Home',
                      style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20.0,
            left: 20.0,
            right: 20.0,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MyHomePage()),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
