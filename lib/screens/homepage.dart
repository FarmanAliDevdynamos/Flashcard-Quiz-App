import 'package:flutter/material.dart';
import 'package:flashcard_quiz_app/models/model.dart';
import 'nextpage.dart'; // Import the page to navigate to

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final List<GridModel> _gridList = <GridModel>[
    GridModel(
      title: "General Knowledge",
      image: "assets/pictures/gk.jpg",
      cardId: 1,
    ),
    GridModel(
      title: "Literature",
      image: "assets/pictures/literature.jpg",
      cardId: 2,
    ),
    GridModel(
      title: "Science",
      image: "assets/pictures/technology.jpg",
      cardId: 3,
    ),
    GridModel(
      title: "Geography",
      image: "assets/pictures/history.jpg",
      cardId: 4,
    ),
    GridModel(
      title: "Sports",
      image: "assets/pictures/sport.jpg",
      cardId: 5,
    ),
    GridModel(
      title: "Nature",
      image: "assets/pictures/nature.jpg",
      cardId: 6,
    ),
    GridModel(
      title: "History",
      image: "assets/pictures/history1.jpg",
      cardId: 7,
    ),
    GridModel(
      title: "Random",
      image: "assets/pictures/random.jpeg",
      cardId: 8,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 81, 146),
        title: const Text(
          'FlashCard Quiz',
          style: TextStyle(
            color: Colors.white,
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
          child: Container(
            width: 57,
            height: 57,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(2, 2),
                ),
              ],
              image: const DecorationImage(
                image: AssetImage('assets/pictures/quiz.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: RichText(
                text: const TextSpan(children: [
                  TextSpan(
                    text: 'Topics to',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 25,
                    ),
                  ),
                  TextSpan(
                    text: ' Explore',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                      fontSize: 25,
                    ),
                  ),
                ]),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                children: List.generate(_gridList.length, (index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewPage(
                            title: _gridList[index].title,
                            image: _gridList[index].image,
                            cardId: _gridList[index].cardId, // Pass cardId
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 4,
                      margin: const EdgeInsets.all(5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(4)),
                              child: Image.asset(
                                _gridList[index].image,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              _gridList[index].title,
                              style: const TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
