import 'package:flutter/material.dart';
//
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
//
import 'package:dous/utils/images_urls.dart';
import 'package:dous/routes/routes.dart';
import 'package:dous/services/dous_service.dart';
import 'package:dous/services/user_service.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController emailTextController = TextEditingController();
  late TextEditingController passowrdTextController = TextEditingController();

  @override
  void dispose() {
    emailTextController.dispose();
    passowrdTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(
            imgUrl,
          ),
        ),
      ),
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        behavior: HitTestBehavior.opaque,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.surface,
                  fontSize: 22,
                ),
              ),
              LoginTextField(
                label: 'Username',
                icon: Icons.email,
                controller: emailTextController,
                textInputType: TextInputType.emailAddress,
              ),
              LoginTextField(
                label: 'Password',
                controller: passowrdTextController,
                icon: Icons.lock_outline,
                textInputType: TextInputType.text,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.surface.withOpacity(0.85),
                    minimumSize: const Size.fromHeight(40),
                    shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    var result =
                        await Provider.of<UserService>(context, listen: false)
                            .checkIfUserExists(emailTextController.text);
                    // Use mounted to make sure widget is still active
                    if (mounted) {
                      if (result == 'UserExists') {
                        Provider.of<DousService>(context, listen: false)
                            .getDousTasks(emailTextController.text);
                        Navigator.of(context).pushNamed(RouteHandler.doUs);
                      } else {
                        Fluttertoast.showToast(
                          msg: 'User Does Not exist',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 2,
                          backgroundColor: Theme.of(context).cardColor,
                          textColor: Colors.red,
                          fontSize: 16.0,
                        );
                      }
                    }
                  },
                  child: Text(
                    'Login',
                    style: GoogleFonts.roboto(
                      color: const Color.fromRGBO(255, 253, 228, 1),
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: TextButton(
            child: Text(
              'register',
              style: TextStyle(
                color: Theme.of(context).colorScheme.surface,
                fontSize: 16,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(RouteHandler.createUser);
            },
          ),
        ),
      ),
    );
  }
}

class LoginTextField extends StatelessWidget {
  const LoginTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.textInputType,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType textInputType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: TextField(
        controller: controller,
        keyboardType: textInputType,
        obscureText: textInputType != TextInputType.emailAddress ? true : false,
        style: const TextStyle(
          color: Color.fromRGBO(255, 253, 228, 1),
        ),
        cursorColor: Theme.of(context).colorScheme.surface,
        decoration: InputDecoration(
          // fillColor: Color.fromRGBO(105, 105, 105, 0.6),
          fillColor: Colors.black.withOpacity(.2),
          filled: true,
          hintText: label,
          hintStyle: const TextStyle(
            fontSize: 14,
            color: Color.fromRGBO(255, 253, 228, 0.85),
          ),
          prefixIcon: Icon(
            icon,
            color: Theme.of(context).colorScheme.surface,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.surface,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
