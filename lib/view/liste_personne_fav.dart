import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstbd233/controller/firebase_helper.dart';
import 'package:firstbd233/model/my_user.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';




class ListPersonneFav extends StatefulWidget {
  const ListPersonneFav({Key? key});

  @override
  State<ListPersonneFav> createState() => _ListPersonneFavState();
}

class _ListPersonneFavState extends State<ListPersonneFav> {
  late String currentUserUid; // Variable pour stocker l'ID de l'utilisateur connecté

  @override
  void initState() {
    super.initState();
    // Obtenir l'ID de l'utilisateur actuellement connecté lors de l'initialisation
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      currentUserUid = user.uid;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseHelper().cloud_users.snapshots(),
      builder: (context, snap) {
        if (snap.data == null) {
          return Center(child: Text("Aucun utilisateur"),);
        } else {
          
            List<DocumentSnapshot> documents = snap.data!.docs;
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                MyUser user = MyUser.bdd(documents[index]);
                  if(user.favoris != false){

                  return Card(
                  elevation: 5,
                  color: Color.fromARGB(255, 39, 176, 78),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(user.avatar!),
                    ),
                    title: Text(user.email),
                    subtitle: Text(user.email),
                  ),
                );
                }
              }
          );
          }
          
        }
    );
  }
}

