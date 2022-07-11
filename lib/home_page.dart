import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:final_todo_firebase/auth/login/login.dart';
import 'package:final_todo_firebase/widgets/add_note.dart';
import 'package:final_todo_firebase/widgets/edit_notes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' ;
 import 'widgets/view_notes.dart';
import 'package:http/http.dart' as http;



class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  CollectionReference notesRef = FirebaseFirestore.instance.collection("notes");
  getUserData()
  {
    var user = FirebaseAuth.instance.currentUser;
    print("5555555555555555555");
    print(user?.email);
  }

  getData()async
  {
    CollectionReference usersRef = FirebaseFirestore.instance.collection("users");
      await  usersRef.get().then((value)
      {
        for (var element in value.docs) {
          print("----------------------------");
          print(element.data());
          print("----------------------------");
        }
      });

  }

  getOneUserData()async
  {
    DocumentReference doc = FirebaseFirestore.instance.collection("users")
        .doc("aZM9G1hDIM8JYxifirue");
    await doc.get().then((value)
     {
       print(value.data());
       print("///////////////////");
     });
  }

  getOneThing()async
  {
    CollectionReference useRef = FirebaseFirestore.instance.collection("users");
    await useRef.where("age",whereIn: [20,40]).get().then((value)
    {
      for (var element in value.docs) {
        print(element.data());
        print("rrrrrrrrrrrrrrrrr");
      }
    });
  }
  
  getTwoThings()async
  {
    CollectionReference useRef = FirebaseFirestore.instance.collection("users");
    await useRef.where("age",whereIn: [20,40]).where("name",isEqualTo: "mostafa").get().then((value)
    {
      for (var element in value.docs) {
        print(element.data());
        print("rrrrrrrrrrrrrrrrr");
      }
    });
  }

  getDataOrder()async
  {
    //descending (تنازليا) تحدد نوع الترتيب
    CollectionReference useRef = FirebaseFirestore.instance.collection("users");
    await useRef.orderBy("age",descending: true).get().then((value)
    {
      for (var element in value.docs) {
        print(element.data());
        print("rrrrrrrrrrrrrrrrr");
      }
    });
  }

  getLimitData()async
  {
    
    CollectionReference useRef = FirebaseFirestore.instance.collection("users");
    await useRef.limit(2).get().then((value)
    {
      for (var element in value.docs) {
        print(element.data());
        print("rrrrrrrrrrrrrrrrr");
      }
    });
  }
  
  getStartData()async
  {
    CollectionReference useRef = FirebaseFirestore.instance.collection("users");
    await useRef.orderBy("age",descending: false).startAt([21]).get().then((value)
    {
      for (var element in value.docs) {
        print(element.data());
        print("rrrrrrrrrrrrrrrrr");
      }
    });
  }

  getDataRealTime()async
  {
    FirebaseFirestore.instance.collection("users").snapshots().listen((event)
    {
      for (var element in event.docs) {
        print("name = ${element.data()['name']}");
        print("email = ${element.data()['email']}");
        print("age = ${element.data()['age']}");
        print("*********************");
      }
    });
  }

  addDataToFireBase()async
  {
    var userRef = FirebaseFirestore.instance.collection("users");
    userRef.add({
      "name":"ahmed",
      "age":58,
      "email":"ahmed@gmail.com",
      "phone" : "12345",

    });
  }

  addDataToFireBaseWithId()async
  {
    var userRef = FirebaseFirestore.instance.collection("users");
    userRef.doc("123456789").set({
      "name":"ali",
      "age" : 25,
      "email":"ali@gmail.com",
      "phone":"0111",
    });
  }

  upDateDataWithId()async
  {
    var userRef = FirebaseFirestore.instance.collection("users");
    userRef.doc("123456789").update({
      "name":"mmmm",
    });
  }

  //تحذف كل البيانات اللى لم يتم عليها تعديل
  newWayToUpDateData()async
  {
    var userRef = FirebaseFirestore.instance.collection("users");
    userRef.doc("123456789").set({
      "name":"omar",
      "age":30,
    });
  }
//عشان اعدل على عنصر واحد فقط
  // تختلف عن ال update فى انها لو ال doc مش موجود تعمله create
  newWayToUpDateOptionData()async
  {
    var userRef = FirebaseFirestore.instance.collection("users");
    userRef.doc("123456789").set({
      "name":"nn",
    }, SetOptions(merge: true),
    );
  }

  deleteData()async
  {
    var userRef = FirebaseFirestore.instance.collection("users");
    userRef.doc("123456789").delete();
  }

  deleteOneThingOption()async
  {
    var addressRef = FirebaseFirestore.instance.collection("users").doc("aZM9G1hDIM8JYxifirue").collection("Address");
    addressRef.add({
      "bb":"bb"
    });
  }

  var userDoc = FirebaseFirestore.instance.collection("users").doc("aZM9G1hDIM8JYxifirue");
  var userDoc2 = FirebaseFirestore.instance.collection("users").doc("yQPQhWgCjztnXqa6Z7qh");


  trans()async
  {
    FirebaseFirestore.instance.runTransaction((transaction)async
    {
      DocumentSnapshot documentSnapshot =await transaction.get(userDoc);
      if(documentSnapshot.exists)
      {
        transaction.update(userDoc,{
          "phone":"111111",
        });
      }else
      {
        print("no no");
      }
    });

  }
// عشان ينفذ العمليات ف نفس الوقت مع بعضها يا تتغير كلها يا ولا حاجه تتغير
  batchWrite()async
  {
 var batch = FirebaseFirestore.instance.batch();
 batch.delete(userDoc2);
 batch.update(userDoc,{
   "phone":"010101",
 });
 batch.commit();
  }

  CollectionReference userRef = FirebaseFirestore.instance.collection("users");
  List usersList = [];
  getDataToShowItInUi() async
  {
    var responseBody = await userRef.get();
    responseBody.docs.forEach((element){
     setState(() {
       usersList.add(element.data());
     });
    });
    print(usersList);
    }

  DocumentReference userRef2 = FirebaseFirestore.instance.collection("users").doc("CCuHzsvAv2fozqlsUkRR");
  List usersList2 = [];
  getSingleDataToUi()async
    {
      var response = await userRef2.get();
      setState(() {
        usersList2.add(response.data());
      });
    }

    CollectionReference userRef3 = FirebaseFirestore.instance.collection("users");
   secondWayToShowDataInUi()
    {
      // FutureBuilder<dynamic>()
      // by using future builder
    }
  CollectionReference userRef4 = FirebaseFirestore.instance.collection("users");

  thirdRealTimeWayToShowDataInUi()
  {
    // by using stream builder
    // StreamBuilder<dynamic>(
    //   stream: userRef4.snapshots(),
    //   builder: (context,snapShot)
    //   {
    //     if(snapShot.hasError)
    //     {
    //       return Text("errro");
    //     }
    //     if(snapShot.hasData)
    //     {
    //       return ListView.builder(
    //           itemCount: snapShot.data.docs.length,
    //           itemBuilder: (context,index)
    //           {
    //             return Text("${snapShot.data.docs[index].data()['title']}");
    //           });
    //     }
    //     return Text("");
    //   },
    // ),
  }

File? file;
  var imagePicker = ImagePicker();
  upLoad()async
  {
var imgPicked = await imagePicker.pickImage(source: ImageSource.camera);
if(imgPicked != null)
{
  file = File(imgPicked.path);
  var name = basename(imgPicked.path);
  print(imgPicked.path);
  print("*******************");
  print(name);

  // start upload

  var random = Random().nextInt(1000000000000);  // عشان اضمن ان اسم الصورة ميتكررش
  name = "$random$name";
  var imgStorage = FirebaseStorage.instance.ref("images/$name");
  // var imgStorage = FirebaseStorage.instance.ref("images/$name").child("path");

  await imgStorage.putFile(file!);
  var imgUrl = await imgStorage.getDownloadURL();
  print("imgeurl : $imgUrl");
  // end upload
}
else
{
  print("please choose image");
}
  }

  getImagesAndFolder()async
  {
    var ref =await FirebaseStorage.instance.ref("images/images").list(const ListOptions(maxResults: 2));
    ref.items.forEach((element){
      print("**------------****0");
      print(element.fullPath);
    });
    // عشان اجيب اسماء الفولدرات
    ref.prefixes.forEach((element){
      print("**------------****0");
      print(element.fullPath);
    });

  }

// عشان اجيب ال token واحطه ف الفاير بيز
  var fbm = FirebaseMessaging.instance;
// تستخدم ف حالة ان الابليكشن مفتوح
  printNotification( BuildContext context)
  {
    FirebaseMessaging.onMessage.listen((event){
      print("------------notification---------");
      print("${event.notification?.body}");
      print("------------notification---------");
      // احط اى حاجه انا عاوزها
      AwesomeDialog(
        title: "notification",
        body: Text("${event.notification?.body}"),
        context:  context,
      ).show();
    });
  }

  openNotificationWhenItInBackground()
  {
    FirebaseMessaging.onMessageOpenedApp.listen((event){
      Navigator.of(this.context).push(MaterialPageRoute(
          builder: (context)
          {
            return AddNotes();
          }
      ));

    });
  }

  openNotificationWhenItInTerminalClose(BuildContext context)async
  {
    var message =await  FirebaseMessaging.instance.getInitialMessage();
    if(message != null)
    {
      Navigator.of(this.context).push(MaterialPageRoute(
          builder: (context)
          {
            return AddNotes();
          }
      ));
    }
  }

  requestPermissionForIosToGetNotification()async
  {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  // notification from api
  // var serverToken = "AAAAEAbd_ck:APA91bEo9G0-3msJxIEEnofP3iyOODvBCJbnUQWwdJvXJLPi38ndXx006KkqXf3L1vKGCphB1oAv4au_6Ub1SB_63FDKNFa1WN6Cc2ilEM7ojGyS-WwdXrgTjIQFIDEnL8zt7xTNHFts";
  // sendNotification(String title,String body , int id)async
  // {
  //       await http.post(
  //         Uri.parse('https://api.rnfirebase.io/messaging/send'),
  //         headers: <String, String>{
  //           'Content-Type': 'application/json; charset=UTF-8',
  //           "Authorization": "key = $serverToken",
  //         },
  //         body: jsonEncode(
  //           <String,dynamic>
  //           {
  //             "notification" :  <String,dynamic>
  //             {
  //               "body":body.toString(),
  //               "title":title.toString(),
  //             },
  //             "priority": "high",
  //             "data": <String,dynamic>
  //             {
  //               "id":id.toString(),
  //               "name" : "mostafa bahr",
  //             },
  //             "to" : await FirebaseMessaging.instance.getToken(),
  //           }
  //         ),
  //       );
  //       print('FCM request for device sent!');
  //     }

  @override
  void initState()
  {
    fbm.getToken().then((token)
    {
      print("--------------------");
      print(token);
      print("--------------------");

    });
    printNotification(this.context);
    // openNotificationWhenItInBackground();
    openNotificationWhenItInTerminalClose(this.context);
    // requestPermissionForIosToGetNotification();
    // getUserData();
    // getData();
    // getOneUserData();
    // getOneThing();
    // getTwoThings();
    // getDataOrder();
    // getLimitData();
    // getStartData();
    // getDataRealTime();
    // addDataToFireBase();
    // addDataToFireBaseWithId();
    // upDateDataWithId();
    // newWayToUpDateData();
    // newWayToUpDateOptionData();
    // deleteData();
    // deleteOneThingOption();
    // trans();
    // batchWrite();
    // getDataToShowItInUi();
    // getSingleDataToUi();
    getImagesAndFolder();
    super.initState();
  }
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context)=>const LoginScreen()));
          },
              icon: const Icon(Icons.exit_to_app),
          ),
        ],
        leading: const Icon(Icons.menu),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(context,
            MaterialPageRoute(builder: (context)
            {
              return AddNotes();
            }));
          }),
      body: FutureBuilder<dynamic>(
        // عشان كل نوت تتحفظ بال user ألخاص بيها عن طريق ال id
        future: notesRef.where("userid",isEqualTo: FirebaseAuth.instance.currentUser?.uid).get(),
        builder: (context,snapShot)
        {
          if(snapShot.hasData)
          {
            return ListView.builder(
              itemCount: snapShot.data.docs.length,
              itemBuilder: (context,index)
              {
                // عشان نعرف نمسح ال note
                return Dismissible(
                  onDismissed: (direction) async
                  {
                    var userRef = FirebaseFirestore.instance.collection("notes");
                    await userRef.doc(snapShot.data.docs[index].id).delete();
                    // عشان نمسح الصورة علطول
                    await FirebaseStorage.instance.refFromURL(snapShot.data.docs[index]['imageUrl']).delete();
                  },
                  key: UniqueKey(),
                  child: ListNotes(
                    notes: snapShot.data.docs[index],
                    docId: snapShot.data.docs[index].id,
                  ),
                );
              },
            );
          }
          return const Text("");
        },
      ),
    );
  }
}

class ListNotes extends StatelessWidget {
  final notes;
final docId;
  const ListNotes({Key? key, this.notes, this.docId,}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ViewNote(notes: notes);
        }));
      },
      child: Card(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Image.network(
                "${notes['imageUrl']}",
                fit: BoxFit.fill,
                height: 80,
              ),
            ),
            Expanded(
              flex: 3,
              child: ListTile(
                title: Text("${notes['title']}"),
                subtitle: Text(
                  "${notes['note']}",
                  style: const TextStyle(fontSize: 14),
                ),
                trailing: IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return EditNotes(docid: docId,list: notes);
                    }));
                  },
                  icon: const Icon(Icons.edit),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
