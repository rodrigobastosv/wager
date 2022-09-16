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
      title: 'Cargos',
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('cargos').snapshots(),
        builder: ((_, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              itemCount: snapshot.data!.docs.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (_, i) {
                final doc = snapshot.data!.docs.elementAt(i);
                final data = doc.data();
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(data['nome']),
                  subtitle: Text(data['descricao']),
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
