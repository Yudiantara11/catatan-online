import 'dart:developer';

import 'package:catatan/presentation/controller/auth_controller.dart';
import 'package:catatan/presentation/pages/homepage/mobile/mobile_detail.dart';
import 'package:catatan/presentation/pages/mobile_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DesktopHome extends StatefulWidget {
  const DesktopHome({super.key, required this.user});

  final AsyncSnapshot<User?> user;
  @override
  State<DesktopHome> createState() => _DesktopHomeState();
}

class _DesktopHomeState extends State<DesktopHome> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late final AsyncSnapshot<User?> Fireusers;
  final authC = Get.put(AuthController());

  String nama = '';
  List<String> catatan = [];
  List<String> judul = [];
  List<String> tanggal = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firestore
        .collection('users')
        .doc(widget.user.data!.email)
        .get()
        .then((doc) {
      String data = doc.data()!['nama'];

      setState(() {
        nama = data;
      });
    });

    // check is there any firestore collection "catatan" with document name same as user email
    // if not, create one
    // then create an place to holds all catatan
    // consist of catatan title, catatan content, and catatan date

    fetchData();
  }

  void fetchData() async {
    firestore
        .collection('catatan')
        .doc(widget.user.data!.email)
        .get()
        .then((doc) async {
      if (!doc.exists) {
        firestore.collection('catatan').doc(widget.user.data!.email).set({
          'catatan': [],
          'judul': [],
          'tanggal': [],
        });
      } else {
        // read all catatan and put it into list
        // then show it to user
        log('here');
        await firestore
            .collection('catatan')
            .doc(widget.user.data!.email)
            .get()
            .then((doc) {
          catatan =
              List<String>.from(doc.data()!['catatan'] as List).cast<String>();
          judul =
              List<String>.from(doc.data()!['judul'] as List).cast<String>();
          tanggal =
              List<String>.from(doc.data()!['tanggal'] as List).cast<String>();
        });

        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "LiL Notes for Web",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: (catatan.isEmpty)
            ? Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Belum ada catatan',
                    style: TextStyle(
                        fontSize: 20, color: Color.fromARGB(255, 236, 0, 114)),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Tambahkan catatan dengan menekan tombol +',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              )
                // child: FloatingActionButton(onPressed: () {fetchData();}),
                )
            : Container(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 2,
                  ),
                  itemBuilder: ((context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(judul[index]),
                        onTap: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MobileDetail(
                                        user: widget.user,
                                        index: index,
                                      )));
                          fetchData();
                        },
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tanggal[index],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              catatan[index],
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        // onTap: () async{
                        //   await Navigator.push(context, MaterialPageRoute(builder: (context) => MobileDetail(user: widget.user, index: index,)));
                        //   fetchData();
                        // },
                      ),
                    );
                  }),
                  itemCount: catatan.length,
                ),
              ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 54, 54, 54),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                        radius: 30,
                        backgroundColor: Color.fromARGB(
                          1,
                          255,
                          255,
                          255,
                        )),
                    const SizedBox(height: 10),
                    Text(
                      nama,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.user.data!.email!,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  authC.logout();
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                String judul = '';
                String isi = '';
                return AlertDialog(
                  title: const Text('Tambah Catatan'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Judul',
                        ),
                        onChanged: (value) {
                          judul = value;
                        },
                      ),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Isi',
                        ),
                        onChanged: (value) {
                          isi = value;
                        },
                        minLines: 3,
                        maxLines: null,
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Batal'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Implement save functionality

                        // add new catatan to firestore
                        // then update the list
                        // then show it to user

                        firestore
                            .collection('catatan')
                            .doc(widget.user.data!.email)
                            .update({
                          'catatan': FieldValue.arrayUnion([isi]),
                          'judul': FieldValue.arrayUnion([judul]),
                          'tanggal': FieldValue.arrayUnion(
                              [DateTime.now().toString()]),
                        });

                        setState(() {
                          catatan.add(isi);
                          this.judul.add(judul);
                          tanggal.add(DateTime.now().toString());
                        });

                        Navigator.pop(context);
                      },
                      child: const Text('Simpan'),
                    ),
                  ],
                );
              },
            );
          },
          child: const Icon(Icons.add),
        ));
  }
}
