import 'dart:convert';
import 'dart:developer';

import 'package:abc_news/category.dart';
import 'package:abc_news/model.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:http/http.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchController = TextEditingController();
  List<NewsQueryModel> newsModelList = <NewsQueryModel>[];
  List<NewsQueryModel> newsModelListCarousel = <NewsQueryModel>[];

  List<String> navBarItem = [
    "Top News",
    "India",
    "World",
    "Finance",
    "Health",
    "Stocks"
  ];

  bool isDarkTheme = false;
  bool isloading = true;
  getNewsByQuery() async {
    String url =
        "https://newsapi.org/v2/everything?q=world&from=2024-09-11&sortBy=publishedAt&apiKey=76330944c0d743fea05acff6f5c8a931";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      data["articles"].forEach((element) {
        NewsQueryModel newsQueryModel = NewsQueryModel();
        newsQueryModel = NewsQueryModel.fromMap(element);
        newsModelList.add(newsQueryModel);
        setState(() {
          isloading = false;
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getNewsByQuery();
    getNewsOfIndia();
  }

  getNewsOfIndia() async {
    String url =
        "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=76330944c0d743fea05acff6f5c8a931";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);

    // log('$data', name: 'getNewsOfIndiaData');
    setState(() {
      data["articles"].forEach((element) {
        NewsQueryModel newsQueryModel = NewsQueryModel();
        newsQueryModel = NewsQueryModel.fromMap(element);

        newsModelListCarousel.add(newsQueryModel);
        setState(() {
          isloading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("ABC News"),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(isDarkTheme ? Icons.dark_mode : Icons.light_mode),
              onPressed: () {
                setState(() {
                  isDarkTheme = !isDarkTheme;
                });
              },
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 20),
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(24)),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            // ListView.builder(itemBuilder: (context, index) => navBarItem,

                            // );
                          },
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(3, 0, 7, 0),
                            child: const Icon(Icons.search),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            textInputAction: TextInputAction.search,
                            onSubmitted: (value) {},
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Take a Ride"),
                          ),
                        ),
                      ],
                    )),
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: navBarItem.length,
                    itemBuilder: (context, index) {
                      //
                      return InkWell(
                        onTap: () {
                          log('$index', name: 'index');
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Category(Query: navBarItem[index])));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                              child: Text(
                            navBarItem[index],
                            style: const TextStyle(
                                fontSize: 19,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    child: isloading
                        ? Container(child: CircularProgressIndicator())
                        : CarouselSlider(
                            items: newsModelListCarousel.map((instance) {
                              return Builder(builder: (BuildContext context) {
                                return Container(
                                  child: Card(
                                    elevation: 15,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            instance.newsImg,
                                            // fit: BoxFit.fitWidth,
                                            // width: double.infinity,
                                            // height: double.infinity,
                                          ),
                                        ),
                                        Positioned(
                                          left: 0,
                                          right: 0,
                                          bottom: 0,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                gradient: LinearGradient(
                                                    colors: [
                                                      Colors.greenAccent
                                                          .withOpacity(0),
                                                      const Color.fromARGB(
                                                          255, 252, 252, 252)
                                                    ],
                                                    begin: Alignment.topCenter,
                                                    end: Alignment
                                                        .bottomCenter)),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 6),
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: Text(
                                                  instance.newsHead,
                                                  maxLines: 2,
                                                  style: const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 59, 6, 5),
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                            }).toList(),
                            options: CarouselOptions(
                                height: 200,
                                autoPlay: true,
                                enlargeCenterPage: true))),
                Container(
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(15, 25, 0, 0),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Latest news",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 28),
                            ),
                          ],
                        ),
                      ),
                      ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: newsModelList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 10,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(
                                        newsModelList[index].newsImg,
                                        // fit: BoxFit.cover,
                                        // height: 200,
                                        // width: double.maxFinite,
                                        // height: double.infinity,
                                        // width: double.infinity,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const SizedBox(),
                                      ),
                                    ),
                                    Positioned(
                                        left: 0,
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                gradient: LinearGradient(
                                                    colors: [
                                                      Colors.greenAccent
                                                          .withOpacity(0),
                                                      const Color.fromARGB(
                                                          255, 252, 252, 252)
                                                    ],
                                                    begin: Alignment.topCenter,
                                                    end: Alignment
                                                        .bottomCenter)),
                                            padding: const EdgeInsets.fromLTRB(
                                                15, 15, 10, 8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  newsModelList[index].newsHead,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  newsModelList[index].newsDes,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 26, 12, 2),
                                                      fontSize: 12),
                                                )
                                              ],
                                            ))),
                                  ],
                                ),
                              ),
                            );
                          }),
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                onPressed: () {},
                                child: const Text("Show More"))
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  final List items = [
    Colors.blueAccent,
    Colors.orangeAccent,
    Colors.amberAccent,
    Colors.deepPurpleAccent,
    Colors.greenAccent
  ];
}
