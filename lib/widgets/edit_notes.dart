import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_todo_firebase/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
 import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../components/alret.dart';

class EditNotes extends StatefulWidget {
  final docid;
  final list;
  EditNotes({Key? key, this.docid, this.list}) : super(key: key);

  @override
  _EditNotesState createState() => _EditNotesState();
}

class _EditNotesState extends State<EditNotes> {
  CollectionReference notesRef = FirebaseFirestore.instance.collection("notes");

  Reference? ref;

  File? file;

  var title, note, imageurl;

  GlobalKey<FormState> formKey =   GlobalKey<FormState>();

  editNotes(context) async {
    var formData = formKey.currentState;

    if (file == null) {
      if (formData!.validate()) {
        showLoading(context);
        formData.save();
        await notesRef.doc(widget.docid).update({
          "title": title,
          "note": note,
          // "userid" : FirebaseAuth.instance.currentUser?.uid,
        }).then((value) {
          Navigator.push(context,
          MaterialPageRoute(
            builder: (context)
            {
              return const HomePage();
            }
          ));
        }).catchError((e) {
          print("ERROR in edit notes ${e.toString()}");
        });
      }
    } else {
      if (formData!.validate()) {
        showLoading(context);
        formData.save();
        await ref?.putFile(file!);
        imageurl = await ref?.getDownloadURL();
        await notesRef.doc(widget.docid).update({
          "title": title,
          "note": note,
          "imageUrl": imageurl,
          // لازم هنا نمرر ال uid عشان يغير ف ال note المطلوبة تغييرها
          // "userid" : FirebaseAuth.instance.currentUser?.uid,
        }).then((value) {
          Navigator.push(context,
              MaterialPageRoute(
                  builder: (context)
                  {
                    return const HomePage();
                  }
              ));
        }).catchError((e) {
          print("error in edit notes 222 ${e.toString()}");
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Note'),
      ),
      body: Column(
        children: [
          Form(
              key: formKey,
              child: Column(children: [
                TextFormField(
                  initialValue: widget.list['title'],
                  validator: (val) {
                    if (val!.length > 30) {
                      return "Title can't to be larger than 30 letter";
                    }
                    if (val.length < 2) {
                      return "Title can't to be less than 2 letter";
                    }
                    return null;
                  },
                  onSaved: (val) {
                    title = val;
                  },
                  maxLength: 30,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Title Note",
                      prefixIcon: Icon(Icons.note)),
                ),
                TextFormField(
                  initialValue: widget.list['note'],
                  validator: (val) {
                    if (val!.length > 255) {
                      return "Notes can't to be larger than 255 letter";
                    }
                    if (val.length < 10) {
                      return "Notes can't to be less than 10 letter";
                    }
                    return null;
                  },
                  onSaved: (val) {
                    note = val;
                  },
                  minLines: 1,
                  maxLines: 3,
                  maxLength: 200,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Note",
                      prefixIcon: Icon(Icons.note)),
                ),
                ElevatedButton(
                  onPressed: () {
                    showBottomSheet(context);
                  },

                  child: const Text("Edit Image For Note"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await editNotes(context);
                  },
                   child: Text(
                    "Edit Note",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                )
              ]))
        ],
      ),
    );
  }

  showBottomSheet(context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(20),
            height: 180,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Edit Image",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                InkWell(
                  onTap: () async {
                    var picked = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    if (picked != null) {
                      file = File(picked.path);
                      var rand = Random().nextInt(100000);
                      var imageName = "$rand" + basename(picked.path);
                      ref = FirebaseStorage.instance
                          .ref("images")
                          .child(imageName);

                      Navigator.of(context).pop();
                    }
                  },
                  child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.photo_outlined,
                            size: 30,
                          ),
                          SizedBox(width: 20),
                          Text(
                            "From Gallery",
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      )),
                ),
                InkWell(
                  onTap: () async {
                    var picked = await ImagePicker()
                        .pickImage(source: ImageSource.camera);
                    if (picked != null) {
                      file = File(picked.path);
                      var rand = Random().nextInt(100000);
                      var imageName = "$rand" + basename(picked.path);
                      ref = FirebaseStorage.instance
                          .ref("images")
                          .child(imageName);
                      Navigator.of(context).pop();
                    }
                  },
                  child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.camera,
                            size: 30,
                          ),
                          SizedBox(width: 20),
                          Text(
                            "From Camera",
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      )),
                ),
              ],
            ),
          );
        });
  }
}