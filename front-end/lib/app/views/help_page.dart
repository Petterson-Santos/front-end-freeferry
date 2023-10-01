import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teste/app/routes/app_routes.dart';
import 'package:teste/provider/users.dart';
import 'package:url_launcher/link.dart';
import 'home_page.dart';

class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final websiteUri = Uri.parse('https://www.sie.sc.gov.br/ferryboat');
    final Users users = Provider.of(context);
    final user_id = ModalRoute.of(context)?.settings.arguments as String;

    return Scaffold(
      endDrawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: mainColor),
              currentAccountPicture: SizedBox(
                child: Avatar(),
              ),
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
                Navigator.of(context).pushReplacementNamed(
                  AppRoutes.PASS_REQUEST,
                  arguments: user_id,
                );
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
                Navigator.pop(context);
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
        title: const Text('Ajuda'),
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(left: 10, top: 40, bottom: 40, right: 10),
        child: Container(
          height: 250,
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xff162FB5), width: 2),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    'Precisando de ajuda?',
                    style: TextStyle(
                        fontSize: 30,
                        color: Color(0xff162FB5),
                        fontWeight: FontWeight.w900),
                    textAlign: TextAlign.center,
                  ),
                  Container(height: 10),
                  Text(
                    'Fale conosco',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Container(height: 15),
                  Text('Telefone Sede Passe Livre: (47) 3398-5999',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Container(height: 10),
                  Text(
                    'Horário de Atendimento: das 11:00h às 17:00h',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                  ),
                  Container(height: 30),
                  Link(
                      uri: websiteUri,
                      target: LinkTarget.defaultTarget,
                      builder: (context, openLink) => ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(mainColor),
                                minimumSize: MaterialStateProperty.all(
                                    const Size(150, 40))),
                            onPressed: openLink,
                            child: Text(
                              'Saiba Mais',
                              style: TextStyle(fontSize: 30),
                            ),
                          ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
