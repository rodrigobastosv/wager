import 'package:flutter/material.dart';
import 'package:wager/pages/company/company_list_page.dart';
import 'package:wager/pages/role/role_list_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Wrap(
        children: [
          _HomeCard(
            label: 'EMPRESAS',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const CompanyListPage(),
              ),
            ),
          ),
          _HomeCard(
            label: 'CARGOS',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const RoleListPage(),
              ),
            ),
          ),
          _HomeCard(
            label: 'SALÁRIOS',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _HomeCard extends StatelessWidget {
  const _HomeCard({
    Key? key,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 80,
        width: 80,
        child: Text(label),
      ),
    );
  }
}
