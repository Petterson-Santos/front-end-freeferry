import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teste/app/models/user.dart';
import 'package:teste/app/routes/app_routes.dart';
import 'package:teste/provider/users.dart';
import 'home_page.dart';

class ProfilePage extends StatelessWidget {
  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Users users = Provider.of(context);
    final user_id = ModalRoute.of(context)?.settings.arguments as String;
    User? user = users.byId(user_id);
    String newEmail = users.byId(user_id)!.email;
    String newPassword = users.byId(user_id)!.password;

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
                Navigator.pop(context);
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
        title: const Text('Perfil'),
      ),
      body: SizedBox(
          width: double.infinity,
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Avatar(),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        users.byId(user_id)!.name,
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Form(
                      key: _form,
                      child: Column(
                        children: [
                          TextFormField(
                            initialValue: newEmail,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(labelText: 'E-mail'),
                            validator: (value) {
                              if (!value.toString().isValidEmail()) {
                                return 'E-mail inválido.';
                              }

                              if (users.getUserByEmail(value!) != null) {
                                return 'E-mail já cadastrado.';
                              }

                              return null;
                            },
                            onSaved: (value) => newEmail = value.toString(),
                          ),
                          TextFormField(
                            initialValue: newPassword,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(labelText: 'Senha'),
                            validator: (value) {
                              if (!value.toString().isValidPassword()) {
                                return 'Senha inválida.\nPelo menos 3 caracteres. Somente letras e números.';
                              }

                              return null;
                            },
                            onSaved: (value) => newPassword = value.toString(),
                          ),
                        ],
                      )),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                          style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all(
                                  const Size(270, 50))),
                          onPressed: () {
                            final isValid = _form.currentState!.validate();

                            if (isValid) {
                              _form.currentState!.save();
                              Provider.of<Users>(context, listen: false).put(
                                User(
                                  id: users.byId(user_id)!.id,
                                  name: users.byId(user_id)!.name,
                                  email: newEmail,
                                  password: newPassword,
                                  passes: users.byId(user_id)!.passes,
                                  avatarUrl: users.byId(user_id)!.avatarUrl,
                                ),
                              );
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text('Usário Alterado'),
                                        content: Text(
                                            'Os dados do usuário foram alterados!'),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Voltar'))
                                        ],
                                      ));
                            }
                          },
                          child: Text(
                            'Salvar Alterações',
                            style: TextStyle(fontSize: 30),
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all(
                                  const Size(270, 50)),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red)),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text('Excluir Usuário'),
                                      content: Text('Tem certeza?'),
                                      actions: [
                                        TextButton(
                                          child: Text('Não'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: Text('Sim'),
                                          onPressed: () {
                                            Provider.of<Users>(context,
                                                    listen: false)
                                                .remove(user!);
                                            Navigator.of(context)
                                                .pushReplacementNamed(
                                                    AppRoutes.LOGIN);
                                          },
                                        ),
                                      ],
                                    ));
                          },
                          child: Text(
                            'Excluir Usuário',
                            style: TextStyle(fontSize: 30),
                          ))
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

//validator of email
extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

//only letters and numbers on passwords
extension PasswordValidator on String {
  bool isValidPassword() {
    return RegExp(r'^[A-Za-z0-9]{3,}$').hasMatch(this);
  }
}
