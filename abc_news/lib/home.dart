import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchController = TextEditingController();
  List<String> navBarItem = [
    "Top News",
    "India",
    "World",
    "Finance",
    "Health",
    "Stocks"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ABC News"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(24)),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        child: const Icon(Icons.search),
                        margin: const EdgeInsets.fromLTRB(3, 0, 7, 0),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: SearchController(),
                        textInputAction: TextInputAction.search,
                        onSubmitted: (value) {
                          print(value);
                        },
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: "Take a Ride"),
                      ),
                    ),
                  ],
                )),
            Container(
              height: 50,
              child: InkWell(
                onTap: () {
                  
                },
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: navBarItem.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
