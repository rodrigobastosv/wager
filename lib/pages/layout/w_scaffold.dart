import 'package:flutter/material.dart';
import 'package:wager/pages/company/company_list_page.dart';
import 'package:wager/pages/role/role_list_page.dart';

class WScaffold extends StatelessWidget {
  const WScaffold({
    Key? key,
    required this.body,
    this.title,
    this.floatingActionButton,
    this.withMenu = true,
  }) : super(key: key);

  final Widget body;
  final String? title;
  final Widget? floatingActionButton;
  final bool withMenu;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 10,
              ),
              child: Image.asset(
                './assets/images/logo-menor.png',
                fit: BoxFit.contain,
                width: 80,
                filterQuality: FilterQuality.high,
              ),
            ),
            const SizedBox(width: 40),
            if (title != null && title!.isNotEmpty) ...{
              Container(
                width: 2,
                height: 32,
                color: Theme.of(context).dividerColor,
              ),
              const SizedBox(width: 16),
              Text(title!),
            }
          ],
        ),
        leading: const SizedBox(),
        leadingWidth: 0,
        actions: [
          if (withMenu) ...{
            _MenuItem(
              onPressed: () => Navigator.restorablePushNamed(
                context,
                CompanyListPage.routeName,
              ),
              label: 'EMPRESAS',
            ),
            _MenuItem(
              onPressed: () => Navigator.restorablePushNamed(
                context,
                RoleListPage.routeName,
              ),
              label: 'CARGOS',
            ),
            _MenuItem(
              onPressed: () {},
              label: 'SALÁRIOS',
            ),
          },
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 24,
          horizontal: 24,
        ),
        child: body,
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    Key? key,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(
            horizontal: 16,
          ),
        ),
      ),
      child: Text(label),
    );
  }
}
