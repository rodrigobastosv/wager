import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wager/pages/layout/w_scaffold.dart';

import 'role_form_page.dart';

class RoleListPage extends StatelessWidget {
  const RoleListPage({Key? key}) : super(key: key);

  static const routeName = 'roleList';

  @override
  Widget build(BuildContext context) {
    return WScaffold(
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('role').snapshots(),
        builder: ((_, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (_, i) {
                final doc = snapshot.data!.docs.elementAt(i);
                final data = doc.data();
                return ListTile(
                  title: Text(data['name']),
                  subtitle: Text(data['description']),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(
          context,
          RoleFormPage.routeName,
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
