import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

main() {
  runApp(
    const MaterialApp(
      home: FirebaseDemo(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class FirebaseDemo extends StatefulWidget {
  const FirebaseDemo({Key? key}) : super(key: key);

  @override
  State<FirebaseDemo> createState() => _FirebaseDemoState();
}

class _FirebaseDemoState extends State<FirebaseDemo> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  FirebaseDatabase database = FirebaseDatabase.instance;
  List<Map> userList = [];
  String storeKey = '';

  Future<void> insertData() async {
    DatabaseReference ref = database.ref("User").child("jaydip");
    String? key = ref.push().key;
    await ref.child(key!).set({
      "email": emailController.text,
      "pass": passController.text,
    }).whenComplete(() {
      emailController.clear();
      passController.clear();
      setState(() {});
    });
  }

  Future<void> update() async {
    DatabaseReference ref =
        database.ref("User").child("jaydip").child(storeKey);
    await ref.update({
      "email": emailController.text,
      "pass": passController.text,
    }).whenComplete(() {
      emailController.clear();
      passController.clear();
      storeKey = '';
      setState(() {
        select();
      });
    });
  }

  Future<void> delete() async {
    DatabaseReference ref = database.ref("User").child("jaydip");
    await ref.remove();
  }

  Future<void> select() async {
    userList.clear();
    DatabaseReference ref = database.ref("User");
    await ref.get().then((value) {
      Map data = value.value as Map;
      data.forEach((key, value) {
        print(key);
        print(value);
        value.forEach((key, value) {
          print(key);
          print(value);
          value["id"] = key;
          userList.add(value);
        });
      });
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hello User"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Row(
                children: [
                  Text(
                    "This is Firebase Demo",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25),
                  ),
                ],
              ),
              TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: "Email")),
              TextField(
                  controller: passController,
                  decoration: const InputDecoration(labelText: "password")),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => insertData(),
                    child: const Text("Insert"),
                  ),
                  ElevatedButton(
                    onPressed: () => update(),
                    child: const Text("Update"),
                  ),
                  ElevatedButton(
                    onPressed: () => delete(),
                    child: const Text("Delete"),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () => select(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.3,
                  ),
                  child: const Text("Select"),
                ),
              ),
              Column(
                children: userList
                    .map(
                      (e) => ListTile(
                        onTap: () {
                          setState(() {
                            emailController.text = e["email"];
                            passController.text = e["pass"];
                            storeKey = e["id"];
                          });
                        },
                        title: Text(e["email"]),
                        subtitle: Text(e["pass"]),
                      ),
                    )
                    .toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
