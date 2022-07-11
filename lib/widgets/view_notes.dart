import 'package:flutter/material.dart';

class ViewNote extends StatefulWidget {
  final notes;
  const ViewNote({Key? key, this.notes}) : super(key: key);

  @override
  _ViewNoteState createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Notes'),
      ),
      body: Column(
        children: [
          Image.network(
            "${widget.notes['imageUrl']}",
            width: double.infinity,
            height: 300,
            fit: BoxFit.fill,
          ),
          Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: Text(
                "${widget.notes['title']}",
                style:const TextStyle(
                  color: Colors.blue,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              )),
          Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: Text(
                "${widget.notes['note']}",
                style: const TextStyle(
                  fontSize: 20,
                ),
              )),
        ],
      ),
    );
  }
}