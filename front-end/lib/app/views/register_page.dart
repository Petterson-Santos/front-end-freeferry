import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teste/app/models/user.dart';
import 'package:teste/app/routes/app_routes.dart';
import 'package:teste/provider/users.dart';
import 'login_page.dart';

class RegisterPage extends StatelessWidget {
  final _form = GlobalKey<FormState>();
  final Map<String, String> _formData = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
          child: Column(
            children: [
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
                flex: 4,
                child: Form(
                  key: _form,
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          labelText: 'Nome',
                        ),
                        validator: (value) {
                          if (!value.toString().isValidName()) {
                            return 'Nome inválido.';
                          }

                          return null;
                        },
                        onSaved: (value) {
                          _formData['name'] = value!;
                        },
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'E-mail',
                        ),
                        validator: (value) {
                          if (!value.toString().isValidEmail()) {
                            return 'E-mail inválido.';
                          }

                          if (Provider.of<Users>(context, listen: false)
                                  .getUserByEmail(value!) !=
                              null) {
                            return 'E-mail já cadastrado.';
                          }

                          return null;
                        },
                        onSaved: (value) {
                          _formData['email'] = value!;
                        },
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Senha',
                        ),
                        validator: (value) {
                          if (!value.toString().isValidPassword()) {
                            return 'Senha inválida.';
                          }

                          return null;
                        },
                        onChanged: (value) {
                          _formData['password'] = value;
                        },
                        onSaved: (value) {
                          _formData['password'] = value!;
                        },
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Confirme sua Senha',
                        ),
                        validator: (value) {
                          if (_formData['password'] !=
                              _formData['confirmedPassword']) {
                            return 'As senhas não são iguais.';
                          }

                          return null;
                        },
                        onChanged: (value) {
                          _formData['confirmedPassword'] = value;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Url do seu Avatar',
                        ),
                        validator: (value) {
                          if (!value.toString().isValidUrl()) {
                            return 'A url é inválida.';
                          }

                          return null;
                        },
                        onSaved: (value) {
                          _formData['avatarUrl'] = value!;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0))),
                            minimumSize:
                                MaterialStateProperty.all(const Size(200, 50)),
                            backgroundColor:
                                MaterialStateProperty.all(mainColor)),
                        child: const Text(
                          'REGISTRAR',
                          style: TextStyle(fontSize: 30),
                        ),
                        onPressed: () {
                          print(_formData['confirmedPassword']);
                          print(_formData['password']);
                          final isValid = _form.currentState!.validate();

                          if (isValid) {
                            _form.currentState!.save();
                            final id = Random().nextDouble().toString();
                            Provider.of<Users>(context, listen: false).put(
                              User(
                                id: id,
                                name: _formData['name'].toString(),
                                email: _formData['email'].toString(),
                                password: _formData['password'].toString(),
                                passes: 0,
                                avatarUrl: _formData['avatarUrl'].toString(),
                              ),
                            );

                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text(
                                          'Usuário Cadastrado com Sucesso!'),
                                      content: Text(
                                          'Pressione o botão para retornar a tela de Login,'),
                                      actions: [
                                        TextButton.icon(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pushReplacementNamed(
                                                      AppRoutes.LOGIN);
                                            },
                                            icon: Icon(Icons.arrow_back),
                                            label: Text('Voltar'))
                                      ],
                                    ));
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Já possui uma conta? ',
                      style: TextStyle(fontSize: 15, color: Colors.black54),
                    ),
                    InkWell(
                      child: Text(
                        'Conecte-se',
                        style: TextStyle(fontSize: 15, color: mainColor),
                      ),
                      onTap: () {
                        Navigator.of(context)
                            .pushReplacementNamed(AppRoutes.LOGIN);
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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

//validator of url
extension UrlValidator on String {
  bool isValidUrl() {
    return RegExp(
      r'^(https?://)?' // Match http:// or https:// (optional)
      r'([a-zA-Z0-9.-]+)?' // Match the domain (optional)
      r'(\.[a-zA-Z]{2,})?' // Match the top-level domain (optional)
      r'(/[\w.-]*)*' // Match optional path (e.g., /path/to/page)
      r'(\?[a-zA-Z0-9_=-]*)*' // Match optional query parameters (e.g., ?param=value)
      r'(#\w*)*$', // Match optional fragment identifier (e.g., #section)
    ).hasMatch(this);
  }
}

//validator of name
extension NameValidator on String {
  bool isValidName() {
    return RegExp(r'^[A-Za-zÀ-ÖØ-öø-ÿ\s\-]{3,}$').hasMatch(this);
  }
}
