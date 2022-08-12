import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wager/pages/company/company_form_page.dart';
import 'package:wager/pages/layout/w_scaffold.dart';

class CompanyListPage extends StatelessWidget {
  const CompanyListPage({Key? key}) : super(key: key);

  static const routeName = 'companyList';

  @override
  Widget build(BuildContext context) {
    return WScaffold(
      title: 'Empresas',
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('company').snapshots(),
        builder: ((_, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              itemCount: snapshot.data!.docs.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (_, i) {
                final doc = snapshot.data!.docs.elementAt(i);
                final data = doc.data();
                return ListTile(
                  title: Text(data['name']),
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
          CompanyFormPage.routeName,
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
