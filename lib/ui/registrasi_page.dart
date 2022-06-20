import 'package:flutter/material.dart';
import 'package:remember_game/bloc/registrasi_bloc.dart';
import 'package:remember_game/widgets/success_dialog.dart';
import 'package:remember_game/widgets/warning_dialog.dart';
import 'package:remember_game/helpers/user_info.dart';

class RegistrasiPage extends StatefulWidget {
  const RegistrasiPage({Key? key}) : super(key: key);

  @override
  _RegistrasiPageState createState() => _RegistrasiPageState();
}

class _RegistrasiPageState extends State<RegistrasiPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _namaTextboxController = TextEditingController();
  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text("Registrasi"),
          backgroundColor: Colors.transparent,
          elevation: 0,
      ),
      backgroundColor: const Color.fromARGB(255, 196, 181, 253),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.center, 
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Register',style: TextStyle(fontSize: 50, color:Colors.purple)),
                    const SizedBox(height:25),
                    _namaTextField(),
                    const SizedBox(height:10),
                    _emailTextField(),
                    const SizedBox(height:10),
                    _passwordTextField(),
                    const SizedBox(height:10),
                    _passwordKonfirmasiTextField(),
                    const SizedBox(height:15),
                    _buttonRegistrasi(),
                    const SizedBox(
                        height: 30,
                      ),
                      _isLoading ? CircularProgressIndicator() : Text("")
              ]),
          ),
        ),
      ),
    );
  }

  Widget _namaTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Nama",
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(11.0)),
                          borderSide:
                              BorderSide(color: Colors.white, width: 2.0),                              
                        ),
                        border: OutlineInputBorder()
      ),
      keyboardType: TextInputType.text,
      controller: _namaTextboxController,
      validator: (value) {
        if (value!.length < 3) {
          return "Nama harus diisi minimal 3 karakter";
        }
        return null;
      },
    );
  }

  Widget _emailTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Email",
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(11.0)),
                          borderSide:
                              BorderSide(color: Colors.white, width: 2.0),                              
                        ),
                        border: OutlineInputBorder()
      ),
      keyboardType: TextInputType.emailAddress,
      controller: _emailTextboxController,
      validator: (value) {
        //validasi harus diisi
        if (value!.isEmpty) {
          return 'Email harus diisi';
        }
        //validasi email
        Pattern pattern =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regex = RegExp(pattern.toString());
        if (!regex.hasMatch(value)) {
          return "Email tidak valid";
        }
        return null;
      },
    );
  }

  Widget _passwordTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Password",
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(11.0)),
                          borderSide:
                              BorderSide(color: Colors.white, width: 2.0),                              
                        ),
                        border: OutlineInputBorder()
      ),
      keyboardType: TextInputType.text,
      obscureText: true,
      controller: _passwordTextboxController,
      validator: (value) {
        //jika karakter yang dimasukkan kurang dari 6 karakter
        if (value!.length < 6) {
          return "Password harus diisi minimal 6 karakter";
        }
        return null;
      },
    );
  }

  //membuat textbox Konfirmasi Password
  Widget _passwordKonfirmasiTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Konfirmasi Password",
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(11.0)),
                          borderSide:
                              BorderSide(color: Colors.white, width: 2.0),                              
                        ),
                        border: OutlineInputBorder()
      ),
      keyboardType: TextInputType.text,
      obscureText: true,
      validator: (value) {
        //jika inputan tidak sama dengan password
        if (value != _passwordTextboxController.text) {
          return "Konfirmasi Password tidak sama";
        }
        return null;
      },
    );
  }

  //Membuat Tombol Registrasi
  Widget _buttonRegistrasi() {
    return ElevatedButton(
        child: const Text("Registrasi"),
        onPressed: () {
          var validate = _formKey.currentState!.validate();
          if (validate) {
            if (!_isLoading) _submit();
          }
        });
  }

  void _submit() {
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    RegistrasiBloc.registrasi(
            nama: _namaTextboxController.text,
            email: _emailTextboxController.text,
            password: _passwordTextboxController.text
          )
        .then((value) async {

        await UserInfo().setToken(value.token.toString());
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => SuccessDialog(
                description: "Registrasi berhasil, silahkan login",
                okClick: () {
                  Navigator.pop(context);
                },
              ));
    }, onError: (error) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => const WarningDialog(
                description: "Registrasi gagal, silahkan coba lagi",
              ));
    });
    setState(() {
      _isLoading = false;
    });
  }
}
