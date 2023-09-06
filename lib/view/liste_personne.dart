import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstbd233/controller/firebase_helper.dart';
import 'package:firstbd233/model/my_user.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';




class ListPersonne extends StatefulWidget {
  const ListPersonne({Key? key});

  @override
  State<ListPersonne> createState() => _ListPersonneState();
}

class _ListPersonneState extends State<ListPersonne> {
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
              return Card(
                elevation: 5,
                color: Colors.purple,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(user.avatar!),
                  ),
                  title: Text(user.email),
                  subtitle: Text(user.email),
                  onTap: () {
                    _showUserInfoDialog(context,user); // Afficher la boîte de dialogue avec les informations de l'utilisateur.
                  },
                  trailing: IconButton(
                    icon: Icon(user.favoris ? Icons.favorite : Icons.favorite_border),
                    onPressed: () {
                      setState(() {
                          user.favoris = !user.favoris;
                      });

                      Map<String,dynamic> map = {
                          "FAVORIS": user.favoris
                      };

                      FirebaseHelper().updateUser(currentUserUid, map);

                    },
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}

void _showUserInfoDialog(BuildContext context, MyUser user) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text("Informations de l'utilisateur"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nom: ${user.nom}"),
            Text("Prénom: ${user.prenom}"),
            Text("Email: ${user.email}"),
            // Ajoutez d'autres informations que vous souhaitez afficher.
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(); // Utilisez dialogContext ici.
            },
            child: Text("Fermer"),
          ),
        ],
      );
    },
  );
}
