import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    '/profile/',
                  );
                },
                icon: const Image(
                  image: AssetImage('assets/userprofileimage.png'),
                )),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.teal),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Flexible(
                                    child: Image(
                                  image: AssetImage('assets/allOrders.png'),
                                )),
                              ],
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            const Text(
                              'All Orders',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                      '/posts/',
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    foregroundColor: Colors.white,
                                    side: const BorderSide(color: Colors.white),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                  ),
                                  child: Text('View All'.toUpperCase())),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.teal),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      child: Column(
                        children: [
                          Row(
                            children: const [
                              Flexible(
                                  child: Image(
                                image: AssetImage('assets/inprogress.png'),
                              )),
                            ],
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          const Text(
                            'In Progress',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed(
                                    '/inprogress/',
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(color: Colors.white),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                ),
                                child: Text('View'.toUpperCase())),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.teal),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Flexible(
                                    child: Image(
                                  image: AssetImage('assets/history.png'),
                                )),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                      '/riderhistory/',
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    foregroundColor: Colors.white,
                                    side: const BorderSide(color: Colors.white),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                  ),
                                  child: Text('Order History'.toUpperCase())),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.teal),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Flexible(
                                    child: Image(
                                  image: AssetImage('assets/logout.png'),
                                )),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                  onPressed: () async {
                                    await FirebaseAuth.instance.signOut();
                                    // ignore: use_build_context_synchronously
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      '/welcome/',
                                      (route) => false,
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    foregroundColor: Colors.white,
                                    side: const BorderSide(color: Colors.white),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                  ),
                                  child: Text('Log Out'.toUpperCase())),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
