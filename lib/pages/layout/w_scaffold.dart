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
    final List<_MenuItem> menu = [
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
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MediaQuery.of(context).size.width > 600
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 4,
                horizontal: MediaQuery.of(context).size.width > 600 ? 10 : 0,
              ),
              child: Image.asset(
                './assets/images/logo-menor.png',
                fit: BoxFit.contain,
                width: 80,
                filterQuality: FilterQuality.high,
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width > 600 ? 40 : 16),
            if (title != null && title!.isNotEmpty) ...{
              Container(
                width: 2,
                height: 32,
                color: Theme.of(context).dividerColor,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title!,
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width > 600
                        ? Theme.of(context).appBarTheme.titleTextStyle?.fontSize
                        : 18,
                  ),
                ),
              ),
            }
          ],
        ),
        centerTitle: MediaQuery.of(context).size.width > 600 ? false : true,
        leading: withMenu && MediaQuery.of(context).size.width <= 600
            ? null
            : const SizedBox(),
        leadingWidth:
            withMenu && MediaQuery.of(context).size.width <= 600 ? null : 0,
        actions: [
          if (withMenu && MediaQuery.of(context).size.width > 600) ...{
            ...menu,
          },
          const SizedBox(width: 16),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            if (withMenu && MediaQuery.of(context).size.width <= 600) ...{
              ...menu,
            },
          ],
        ),
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
    return MediaQuery.of(context).size.width > 600
        ? TextButton(
            onPressed: onPressed,
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
              ),
            ),
            child: Text(label),
          )
        : ListTile(
            onTap: onPressed,
            title: Text(label),
          );
  }
}
