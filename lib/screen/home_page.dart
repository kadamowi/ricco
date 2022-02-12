import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:badges/badges.dart';
import '../model/task.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  final String userEmail;

  const HomePage({Key? key, required this.userEmail}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  CollectionReference tasks = FirebaseFirestore.instance.collection('zadania');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text('${widget.userEmail}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: tasks.where('Wykonujący', isEqualTo: 'KA').where('Status', isNotEqualTo: 4).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading");
                  }

                  List<Task> taskList = [];
                  for (var doc in snapshot.data!.docs) {
                    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                    Task t = Task.fromJson(data, doc.id);
                    taskList.add(t);
                  }
                  taskList.sort((a, b) => a.executed.compareTo(b.executed));
                  if (snapshot.data!.docs.length > snapshot.data!.docChanges.length) {
                    for (var doc in snapshot.data!.docChanges) {
                      Map<String, dynamic> data = doc.doc.data() as Map<String, dynamic>;
                      Task t = Task.fromJson(data, doc.doc.id);
                      final index = taskList.indexWhere((element) => element.id == t.id);
                      if (index >= 0) {
                        if (doc.type == DocumentChangeType.added) {
                          taskList[index].changes = 1;
                        }
                        if (doc.type == DocumentChangeType.modified) {
                          taskList[index].changes = 2;
                        }
                      }
                    }
                  }

                  if (taskList.isEmpty) {
                    return SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: const [
                          Text('Brak zadań', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 0),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    key: const PageStorageKey(0),
                    itemCount: taskList.length,
                    itemBuilder: (context, index) {
                      return Container(
                          margin: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                          decoration: BoxDecoration(
                            color: taskList[index].status == 3 ? Colors.lightGreen[100] : Colors.white,
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Badge(
                            showBadge: taskList[index].changes > 0,
                            badgeContent: Text(taskList[index].changes == 1 ? 'N' : 'Z'),
                            child: ListTile(
                              title: Text(taskList[index].name,
                                  style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                              subtitle: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(taskList[index].author),
                                  Text(DateFormat('d MMM (EEEE) HH:mm', 'pl').format(taskList[index].executed)),
                                ],
                              ),
                              dense: true,
                              onTap: () {},
                            ),
                          ));
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.logout),
        tooltip: 'Wyloguj',
        mini: true,
        onPressed: () {
          FirebaseAuth.instance.signOut().then((value) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPage(), //HomeScreen(),
              ),
            );
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
