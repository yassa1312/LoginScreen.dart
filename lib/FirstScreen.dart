import 'package:flutter/material.dart';
import 'LoginScreen.dart';

void main() {
  runApp(const SPLTApp());
}

class MoreWaysToUseItem {
  final String imagePath;
  final String title;
  final String description;

  MoreWaysToUseItem({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}

class HomePageContent extends StatelessWidget {
  final String lastLocation;
  final List<String> suggestions;
  final List<String> suggestionImages;
  final List<MoreWaysToUseItem> moreWaysToUseItems;

  const HomePageContent({super.key,
    required this.lastLocation,
    required this.suggestions,
    required this.suggestionImages,
    required this.moreWaysToUseItems,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.orange,
        title: const Text('SPLT'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              logout(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Widgets for Search Bar and Last Chosen Location Bar...

            SuggestionsSection(
              suggestions: suggestions,
              suggestionImages: suggestionImages,
            ),

            const SizedBox(height: 25.0),

            MoreWaysToUseSection(
              moreWaysToUseItems: moreWaysToUseItems,
            ),
          ],
        ),
      ),
    );
  }
}

class SuggestionsSection extends StatelessWidget {
  final List<String> suggestions;
  final List<String> suggestionImages;

  const SuggestionsSection({super.key,
    required this.suggestions,
    required this.suggestionImages,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Suggestions',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 10.0),
          SizedBox(
            height: 120.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 100.0,
                  margin: const EdgeInsets.only(right: 10.0),
                  child: Column(
                    children: [
                      Image.asset(
                        suggestionImages[index],
                        height: 80.0,
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        suggestions[index],
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MoreWaysToUseSection extends StatelessWidget {
  final List<MoreWaysToUseItem> moreWaysToUseItems;

  const MoreWaysToUseSection({super.key,
    required this.moreWaysToUseItems,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'More ways to use SPLT',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10.0),
          SizedBox(
            height: 200.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: moreWaysToUseItems.length,
              itemBuilder: (context, index) {
                var item = moreWaysToUseItems[index];
                return Container(
                  width: 150.0,
                  margin: const EdgeInsets.only(right: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 100.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(item.imagePath),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        item.description,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SPLTApp extends StatelessWidget {
  const SPLTApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  String lastLocation = "Previous Location";

  List<String> suggestions = [
    "Normal Transportation",
    "Packaging",
    "Scheduling",
    "Extra Services",
  ];

  List<String> suggestionImages = [
    "assets/icon1.png",
    "assets/icon2.png",
    "assets/icon3.png",
    "assets/icon1.png",
  ];

  List<MoreWaysToUseItem> moreWaysToUseItems = [
    MoreWaysToUseItem(
      imagePath: "assets/portrait1.png",
      title: "Insured Transportation",
      description:
      "Transport your goods in safety without any concerns about the damage of your goods",
    ),
    MoreWaysToUseItem(
      imagePath: "assets/portrait2.png",
      title: "TakeCare",
      description:
      "A special option for those who want their goods handled with extra care",
    ),
    MoreWaysToUseItem(
      imagePath: "assets/portrait3.png",
      title: "Wrapper",
      description:
      "Additional wrapping options to protect fragile or valuable items.",
    ),
  ];

  int _selectedIndex = 0;

  late HomePageContent _homePageContent;

  @override
  void initState() {
    super.initState();
    _homePageContent = HomePageContent(
      lastLocation: lastLocation,
      suggestions: suggestions,
      suggestionImages: suggestionImages,
      moreWaysToUseItems: moreWaysToUseItems,
    );
  }

  late List<Widget> _pages;

  @override
  Widget build(BuildContext context) {
    _pages = [
      _homePageContent,
      const ServicesPage(),
      const ActivityPage(),
      const AccountPage(),
    ];

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.room_service),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Services'),
    );
  }
}

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Activity'),
    );
  }
}

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Account'),
    );
  }
}

void logout(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const LoginScreen()),
  );
}
