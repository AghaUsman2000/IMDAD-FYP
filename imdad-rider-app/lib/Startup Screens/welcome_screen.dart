import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image(
                image: const AssetImage('assets/wscreen.png'),
                height: height * 0.6),
            Column(
              children: const [
                Text('Start your journey',
                    style: TextStyle(
                        fontSize: 36,
                        color: Colors.black,
                        fontFamily: 'Montserrat',
                        shadows: [
                          Shadow(
                              color: Colors.black,
                              offset: Offset(1, 1),
                              blurRadius: 2)
                        ])),
                SizedBox(
                  height: 10.0,
                ),
                Text('Deliver Now!',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontFamily: 'Montserrat',
                        shadows: [
                          Shadow(
                              color: Colors.black,
                              offset: Offset(1, 1),
                              blurRadius: 2)
                        ])),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          '/login/',
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        shape: const RoundedRectangleBorder(),
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.black),
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                      ),
                      child: Text('Login'.toUpperCase())),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            '/register/',
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(),
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.teal,
                          side: const BorderSide(color: Colors.teal),
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                        ),
                        child: Text('Sign Up'.toUpperCase())))
              ],
            )
          ],
        ),
      ),
    );
  }
}
