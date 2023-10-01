// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teste/app/exceptions/NoRegisteredUsersException.dart';
import 'package:teste/app/exceptions/PasswordNotFoundException.dart';
import 'package:teste/app/exceptions/EmailNotFoundException.dart';
import 'package:teste/app/models/user.dart';
import 'package:teste/app/routes/app_routes.dart';
import 'package:teste/provider/users.dart';

const mainColor = Color(0xff162FB5);

class LoginPage extends StatelessWidget {
  final _form = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool invalidEmail = false;
  bool invalidPassword = false;
  late User? user;

  @override
  Widget build(BuildContext context) {
    final Users users = Provider.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(),
                    ),
                    Expanded(
                        child: Container(
                      alignment: Alignment.center,
                      child: const Text(
                        'Free Ferry',
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: mainColor),
                      ),
                    )),
                    Expanded(
                      flex: 2,
                      child: Form(
                        key: _form,
                        child: Column(
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                  labelText: 'E-mail',
                                  border: OutlineInputBorder()),
                              validator: (value) {
                                if (invalidEmail) {
                                  return 'E-mail não cadastrado.';
                                }

                                return null;
                              },
                              onChanged: (value) {
                                email = value;
                              },
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              obscureText: true,
                              decoration: const InputDecoration(
                                  labelText: 'Senha',
                                  border: OutlineInputBorder()),
                              validator: (value) {
                                if (invalidPassword) {
                                  return 'Senha inválida';
                                }

                                return null;
                              },
                              onChanged: (value) {
                                password = value;
                              },
                            ),
                            const SizedBox(height: 15),
                            ElevatedButton(
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0))),
                                    minimumSize: MaterialStateProperty.all(
                                        const Size(200, 50)),
                                    backgroundColor:
                                        MaterialStateProperty.all(mainColor)),
                                onPressed: () {
                                  print(users.count);
                                  try {
                                    users.isEmpty();
                                    if (users.isUserRegistered(
                                        email, password)) {
                                      user = users.getUserByEmail(email);
                                    }

                                    if (users.count > 0) {
                                      Navigator.of(context)
                                          .pushReplacementNamed(AppRoutes.HOME,
                                              arguments: user?.id);
                                    }
                                  } on NoRegisteredUsersException {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title: Text(
                                                  'Não há usuários cadastrados!'),
                                              content: Text(
                                                  'Favor cadastrar um usário ou reiniciar a aplicação.'),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text('Voltar'))
                                              ],
                                            ));
                                  } on EmailNotFoundException {
                                    invalidEmail = true;
                                    _form.currentState!.validate();
                                    print('Email Inválido');
                                  } on PasswordNotFoundException {
                                    invalidPassword = true;
                                    _form.currentState!.validate();
                                    print('Senha inválida');
                                  } catch (e) {
                                    print('Ocorreu um erro inesperado: $e');
                                  } finally {
                                    invalidEmail = false;
                                    invalidPassword = false;
                                  }
                                },
                                child: const Text(
                                  'ENTRAR',
                                  style: TextStyle(fontSize: 30),
                                )),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Não tem uma conta? ',
                            style:
                                TextStyle(fontSize: 15, color: Colors.black54),
                          ),
                          InkWell(
                            child: Text(
                              'Registre-se',
                              style: TextStyle(fontSize: 15, color: mainColor),
                            ),
                            onTap: () {
                              Navigator.of(context)
                                  .pushReplacementNamed(AppRoutes.REGISTER);
                            },
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 150,
                      child: Image.asset(
                        'assets/images/logo_governo.png',
                      ),
                    ),
                  ],
                ))),
      ),
    );
  }
}
