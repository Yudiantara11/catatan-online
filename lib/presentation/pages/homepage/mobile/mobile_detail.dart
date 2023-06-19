import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class MobileDetail extends StatefulWidget {
  const MobileDetail({super.key, required this.user, required this.index});

  final AsyncSnapshot<User?> user;
  final int index;

  @override
  State<MobileDetail> createState() => _MobileDetailState();
}

class _MobileDetailState extends State<MobileDetail> {

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late final AsyncSnapshot<User?> Fireusers;

  TextEditingController judulController = TextEditingController();
  TextEditingController catatanController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchData();
  }

  List<String> catatan = [];
  List<String> judul = [];
  List<String> tanggal = [];

  void fetchData () async{
    await firestore.collection('catatan').doc(widget.user.data!.email).get().then((doc) {
      catatan = List<String>.from(doc.data()!['catatan'] as List).cast<String>();
      judul = List<String>.from(doc.data()!['judul'] as List).cast<String>();
      tanggal = List<String>.from(doc.data()!['tanggal'] as List).cast<String>();
    });

    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Detail Catatan'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: (catatan.isEmpty) ? const Center(child: CircularProgressIndicator(),) :
        CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                    width: MediaQuery.of(context).size.width,
                    child: Text(judul[widget.index], style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 4),
                    width: MediaQuery.of(context).size.width,
                    child: Text("Dibuat: ${tanggal[widget.index]}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey),),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                    width: MediaQuery.of(context).size.width,
                    child: Text(catatan[widget.index], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),),
                  ),
                ],
              ),
            )
          ]
        ),
        // create a button to delete and edit this catatan
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: 'delete',
              onPressed: () {
                // delete this catatan
                // then go back to homepage
                showDialog(
                  context: context,
                  builder: (BuildContext contexts) {
                    return AlertDialog(
                      title: const Text('Hapus Catatan'),
                      content: const Text('Apakah anda yakin ingin menghapus catatan ini?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(contexts);
                          },
                          child: const Text('Tidak'),
                        ),
                        TextButton(
                          onPressed: () {
                            // delete this catatan
                            // then go back to homepage
                            firestore.collection('catatan').doc(widget.user.data!.email).update({
                              'catatan': FieldValue.arrayRemove([catatan[widget.index]]),
                              'judul': FieldValue.arrayRemove([judul[widget.index]]),
                              'tanggal': FieldValue.arrayRemove([tanggal[widget.index]]),
                            }).then((value) {
                              Navigator.of(contexts, rootNavigator: true).pop();
                              Navigator.maybePop(context);
                                                          

                            });
                            
                          },
                          child: const Text('Ya'),
                        ),
                      ],
                    );
                  }
                );
              },
              child: const Icon(Icons.delete),
            ),
            const SizedBox(width: 10,),
            FloatingActionButton(
              heroTag: 'edit',
              onPressed: () {
                // pop up a dialog to edit this catatan
                judulController.text = judul[widget.index];
                catatanController.text = catatan[widget.index];
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Edit Catatan'),
                      content: Container(
                        height: 210,
                        child: Column(
                          children: [
                            TextField(
                              controller: judulController,
                              decoration: const InputDecoration(
                                labelText: 'Judul',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 10,),
                            TextField(
                              controller: catatanController,
                              maxLines: 5,
                              decoration: const InputDecoration(
                                labelText: 'Catatan',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () {
                            // edit this catatan
                            // then go back to homepage
                            catatan[widget.index] = catatanController.text;
                            judul[widget.index] = judulController.text;
                            
                            firestore.collection('catatan').doc(widget.user.data!.email).update({
                              'catatan': catatan,
                              'judul': judul,
                            }).then((value) {
                              setState(() {
                                
                              });
                              Navigator.pop(context);
                              // Navigator.pop(context);
                            });
                          },
                          child: const Text('Simpan'),
                        ),
                      ],
                    );
                  }
                );
                
              },
              child: const Icon(Icons.edit),
            ),
          ],
        ),
    );
  }
}