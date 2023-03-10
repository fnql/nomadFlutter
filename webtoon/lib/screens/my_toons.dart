import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webtoon/screens/detail_screen.dart';

import '../models/webtoon_detail_model.dart';
import '../services/api_service.dart';

class MyToons extends StatefulWidget {
  const MyToons({super.key});

  @override
  State<MyToons> createState() => _MyToonsState();
}

class _MyToonsState extends State<MyToons> {
  late List<Future<WebtoonDetailModel>> webtoons = [];
  late SharedPreferences prefs;
  late Future<List<String>?> likedToons;

  @override
  void initState() {
    super.initState();
    // likedToons = initPrefs();
    initPrefs();
  }

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final likedToons = prefs.getStringList('likedToons');
    if (likedToons != null) {
      for (int k = 0; k < likedToons.length; k++) {
        var test = ApiService.getToonById(likedToons[k]);
        webtoons.add(test);
      }
    } else {
      await prefs.setStringList('likedToons', []);
    }
    setState(() {});
  }

  // 776255

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        title: const Text('좋아하는 웹툰'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            for (int i = 0; i < webtoons.length; i++)
              FutureBuilder(
                future: webtoons[i],
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(
                                id: prefs.getStringList('likedToons')![i],
                                thumb: snapshot.data!.thumb,
                                title: snapshot.data!.title,
                              ),
                            ));
                      },
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 100,
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 7,
                                        offset: const Offset(5, 5),
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                    ],
                                  ),
                                  child: Image.network(snapshot.data!.thumb),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 8,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data!.title,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '${snapshot.data!.genre} / ${snapshot.data!.age}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    );
                  }
                  return const CircularProgressIndicator();
                }),
              ),
          ],
        ),
      ),
    );
  }
}
