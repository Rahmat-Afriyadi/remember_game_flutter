import 'package:flutter/material.dart';
import 'package:remember_game/ui/registrasi_page.dart';
import 'package:remember_game/ui/profile_page.dart';
import 'package:remember_game/bloc/login_bloc.dart';
import 'package:remember_game/helpers/user_info.dart';
import 'package:remember_game/widgets/warning_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool loadingLogin = false;

  Widget page = const CircularProgressIndicator();

  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   title: const Text('Login',style: TextStyle(fontSize: 30, color:Colors.white)),
      // ),
      backgroundColor: Color.fromARGB(255, 195, 181, 253),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Login',style: TextStyle(fontSize: 50, color:Colors.purple)),
                const SizedBox(height:25),
                _emailTextField(),
                const SizedBox(height:10),
                _passwordTextField(),
                const SizedBox(height: 15),
                _loginRegis(),
                const SizedBox(
                  height: 30,
                ),
                loadingLogin ? const CircularProgressIndicator() : const Text("")
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Membuat Textbox email
  Widget _emailTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: "Email",        
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
        return null;
      },
    );
  }

  //Membuat Textbox password
  Widget _passwordTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: "Password",
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
        if (value!.isEmpty) {
          return "Password harus diisi";
        }
        return null;
      },
    );
  }

  Widget _loginRegis() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            child: const Text("Login", ),
            onPressed: () {
              var validate = _formKey.currentState!.validate();
              if (validate) {
                if (!_isLoading) _submit();
              }
            }),
        const SizedBox(width: 5),
        ElevatedButton(
          child: const Text("Registrasi"),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const RegistrasiPage()));
          },
        )
      ],
    );
  }

  //Membuat Tombol Login
  Widget _buttonLogin() {
    return ElevatedButton(
        child: const Text("Login"),
        onPressed: () {
          var validate = _formKey.currentState!.validate();
          if (validate) {
            if (!_isLoading) _submit();
          }
        });
  }

  void _submit() {
    setState(() {
      loadingLogin = true;
    });
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    LoginBloc.login(
            email: _emailTextboxController.text,
            password: _passwordTextboxController.text)
        .then((value) async {
      await UserInfo().setToken(value.token.toString());
      await UserInfo().setUserID(int.parse(value.userID.toString()));
      setState(() {
        loadingLogin = false;
      });
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const ProfilePage(
                  // nama: value.nama,
                  // score: value.score,
                  )));
    }, onError: (error) {
      setState(() {
        loadingLogin = false;
      });
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => const WarningDialog(
                description:
                    "Login gagal, Email tidak ditemukan atau  password salah",
              ));
    });
    setState(() {
      _isLoading = false;
    });
  }

  // Membuat menu untuk membuka halaman registrasi
  Widget _menuRegistrasi() {
    return ElevatedButton(
      child: const Text("Registrasi"),
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const RegistrasiPage()));
      },
    );
  }
}
