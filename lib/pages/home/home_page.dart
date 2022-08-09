import 'package:flutter/material.dart';
import 'package:wager/pages/company/company_list_page.dart';
import 'package:wager/pages/layout/w_scaffold.dart';
import 'package:wager/pages/role/role_list_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return WScaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 32),
          child: Wrap(
            spacing: 32,
            runSpacing: 32,
            children: [
              _HomeCard(
                label: 'EMPRESAS',
                onTap: () => Navigator.restorablePushNamed(
                  context,
                  CompanyListPage.routeName,
                ),
              ),
              _HomeCard(
                label: 'CARGOS',
                onTap: () => Navigator.restorablePushNamed(
                  context,
                  RoleListPage.routeName,
                ),
              ),
              _HomeCard(
                label: 'SALÁRIOS',
                onTap: () {},
              ),
            ],
          ),
        ),
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
    return SizedBox(
      height: 140,
      width: 200,
      child: OutlinedButton(
        onPressed: onTap,
        child: Text(label),
      ),
    );
  }
}
