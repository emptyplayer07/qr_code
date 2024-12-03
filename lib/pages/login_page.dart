import 'package:flutter/material.dart';

import '../bloc/bloc.dart';
import '../routes/router.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final TextEditingController emailC =
      TextEditingController(text: "admin@gmail.com");
  final TextEditingController passC = TextEditingController(text: "admin123");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Login Page"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50),
          child: ListView(
            padding: EdgeInsets.all(20),
            children: [
              TextField(
                controller: emailC,
                decoration: InputDecoration(
                  label: Text("Email"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: passC,
                obscureText: true,
                decoration: InputDecoration(
                  label: Text("Password"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  context
                      .read<AuthBloc>()
                      .add(AuthEventLogin(emailC.text, passC.text));
                },
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.blue),
                child: BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthStateLogin) {
                      context.goNamed(Routes.home);
                    }
                    if (state is AuthStateError) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(state.message),
                        duration: Duration(seconds: 3),
                      ));
                    }
                  },
                  builder: (context, state) {
                    if (state is AuthStateLoading) {
                      return Text(
                        "Loading...",
                        style: TextStyle(color: Colors.white),
                      );
                    }
                    return Text(
                      "Login",
                      style: TextStyle(color: Colors.white),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
