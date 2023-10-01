import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teste/app/routes/app_routes.dart';
import 'package:teste/provider/users.dart';
import 'home_page.dart';

const mainColor = Color(0xff162FB5);

class PassRequestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Users users = Provider.of(context);
    final user_id = ModalRoute.of(context)?.settings.arguments as String;

    return Scaffold(
      endDrawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: mainColor),
              currentAccountPicture: SizedBox(child: Avatar()),
              accountName: Text(users.byId(user_id)!.name),
              accountEmail: Text(users.byId(user_id)!.email),
            ),
            ListTile(
              titleAlignment: ListTileTitleAlignment.center,
              leading: Icon(Icons.home),
              title: Text('Inicio'),
              subtitle: Text('Tela de Início'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed(
                  AppRoutes.HOME,
                  arguments: user_id,
                );
              },
            ),
            ListTile(
              titleAlignment: ListTileTitleAlignment.center,
              leading: Icon(Icons.qr_code_2_rounded),
              title: Text('Solicitar Passes'),
              subtitle: Text('Solicite Seus Passes'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              titleAlignment: ListTileTitleAlignment.center,
              leading: Icon(Icons.manage_accounts),
              title: Text('Perfil'),
              subtitle: Text('Informações do Perfil'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed(
                  AppRoutes.PROFILE,
                  arguments: user_id,
                );
              },
            ),
            ListTile(
              titleAlignment: ListTileTitleAlignment.center,
              leading: Icon(Icons.help),
              title: Text('Ajuda'),
              subtitle: Text('Saiba Mais'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed(
                  AppRoutes.HELP,
                  arguments: user_id,
                );
              },
            ),
            ListTile(
              titleAlignment: ListTileTitleAlignment.center,
              leading: Icon(Icons.exit_to_app),
              title: Text('Sair'),
              subtitle: Text('Finalizar Sessão'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed(AppRoutes.LOGIN);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: mainColor,
        automaticallyImplyLeading: false,
        title: const Text('Solicitar Passe'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: SizedBox(
          child: Column(
            children: [
              Expanded(child: Container(color: Colors.red)),
              Expanded(child: Container(color: Colors.green)),
              Expanded(child: Container(color: Colors.amber)),
            ],
          ),
        ),
      ),
    );
  }
}
