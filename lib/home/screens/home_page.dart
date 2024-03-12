import 'package:flutter/material.dart';
import 'package:tipot/home/screens/add_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Page')),
      body: const Center(
        child: Text(
          "sdbfhbdc",
          style: TextStyle(
            color: Colors.black,
            fontSize: 40.0,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 10.0,
        child: const Icon(Icons.add),
        onPressed: () {
          showChoices(context);

          // action on button press
        },
      ),
    );
  }
}

void showChoices(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.star),
              title: Text('Option 1'),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: ((context) => AddPage())));
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Option 2'),
              onTap: () {
                // Handle Option 2
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.music_note),
              title: Text('Option 3'),
              onTap: () {
                // Handle Option 3
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}
