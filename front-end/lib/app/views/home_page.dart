import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:teste/app/routes/app_routes.dart';
import 'package:teste/app_controller.dart';
import 'package:teste/provider/users.dart';

const mainColor = Color(0xff162FB5);

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Users users = Provider.of(context);
    final user_id = ModalRoute.of(context)?.settings.arguments as String;

    return Scaffold(
        resizeToAvoidBottomInset: false,
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
                leading: const Icon(Icons.home),
                title: const Text('Inicio'),
                subtitle: const Text('Tela de Início'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                leading: const Icon(Icons.qr_code_2_rounded),
                title: const Text('Solicitar Passes'),
                subtitle: const Text('Solicite Seus Passes'),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed(
                    AppRoutes.PASS_REQUEST,
                    arguments: user_id,
                  );
                },
              ),
              ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                leading: const Icon(Icons.manage_accounts),
                title: const Text('Perfil'),
                subtitle: const Text('Informações do Perfil'),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed(
                    AppRoutes.PROFILE,
                    arguments: user_id,
                  );
                },
              ),
              ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                leading: const Icon(Icons.help),
                title: const Text('Ajuda'),
                subtitle: const Text('Saiba Mais'),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed(
                    AppRoutes.HELP,
                    arguments: user_id,
                  );
                },
              ),
              ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                leading: const Icon(Icons.exit_to_app),
                title: const Text('Sair'),
                subtitle: const Text('Finalizar Sessão'),
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
          title: const Text('Início'),
        ),
        body: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                    child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          'Passes',
                          style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w900,
                              color: mainColor),
                        ))),
                Expanded(
                  flex: 4,
                  child: QrImageView(data: users.byId(user_id)!.email),
                  //qr code here
                ),
                Expanded(
                    child: Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'Quantidade de Passes Disponíveis',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
                Expanded(
                    child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    users.byId(user_id)!.passes.toString(),
                    style: const TextStyle(fontSize: 50),
                  ),
                )),
                Expanded(
                    child: Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton.icon(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(mainColor)),
                          onPressed: () {
                            Provider.of<Users>(context, listen: false)
                                .getPass(users.byId(user_id));
                          },
                          label: const Text('Solicitar Passe'),
                          icon: const Icon(Icons.add)),
                      ElevatedButton.icon(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(mainColor)),
                          onPressed: () {
                            Provider.of<Users>(context, listen: false)
                                .usePass(users.byId(user_id));
                          },
                          label: const Text('Utilizar Passe'),
                          icon: const Icon(Icons.remove))
                    ],
                  ),
                )),
              ],
            )));
  }
}

class CustomSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Switch(
        value: AppController.instance.isDarkTheme,
        onChanged: (value) {
          AppController.instance.changeTheme();
        });
  }
}

class Avatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user_id = ModalRoute.of(context)?.settings.arguments as String;
    final avatar = Provider.of<Users>(context).byId(user_id)!.avatarUrl.isEmpty
        ? const CircleAvatar(
            radius: 60,
            backgroundColor: Colors.blueAccent,
            child: Icon(
              Icons.person,
              size: 70,
            ),
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(
                Provider.of<Users>(context).byId(user_id)!.avatarUrl,
              ),
            ),
          );
    return avatar;
  }
}
