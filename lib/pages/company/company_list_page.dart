import 'package:flutter/material.dart';
import 'package:wager/pages/company/company_form_page.dart';

class CompanyListPage extends StatelessWidget {
  const CompanyListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const CompanyFormPage(),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
