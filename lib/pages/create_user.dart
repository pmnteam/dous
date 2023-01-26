import 'dart:ui';
//
import 'package:flutter/material.dart';
//
import 'package:provider/provider.dart';
//
import 'package:dous/services/user_service.dart';
import 'package:dous/utils/images_urls.dart';
import 'package:dous/models/user.dart';

class CreateUserPage extends StatefulWidget {
  const CreateUserPage({super.key});

  @override
  State<CreateUserPage> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            imgUrl,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          iconTheme: const IconThemeData(size: 25),
          leading: BackButton(
            color: Theme.of(context).colorScheme.surface,
          ),
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 16, top: 15),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaY: 22, sigmaX: 22),
                  child: SizedBox(
                    width: size.width * 0.9,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: size.width * 0.15,
                            bottom: size.width * 0.1,
                          ),
                          child: const Text(
                            'Create User',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(255, 253, 228, 1),
                            ),
                          ),
                        ),
                        CreateUserTextField(
                          icon: Icons.account_circle_outlined,
                          hintText: 'Username',
                          controller: usernameController,
                          isPassword: false,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CreateUserTextField(
                          icon: Icons.email_outlined,
                          hintText: 'Email',
                          controller: emailController,
                          isPassword: false,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CreateUserTextField(
                          icon: Icons.lock_outline,
                          hintText: 'Password',
                          controller: passwordController,
                          isPassword: true,
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.black.withOpacity(0.15),
                            shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () async {
                            User user = User(
                                userName: usernameController.value.text,
                                userEmail: emailController.value.text,
                                userPassword: passwordController.value.text);

                            var result = await Provider.of<UserService>(context,
                                    listen: false)
                                .createUser(user);

                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(result)));
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text(
                            'Create User',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CreateUserTextField extends StatelessWidget {
  const CreateUserTextField({
    super.key,
    required this.hintText,
    required this.icon,
    required this.isPassword,
    required this.controller,
  });

  final IconData icon;
  final String hintText;
  final bool isPassword;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15, left: 15),
      child: TextField(
        controller: controller,
        style: const TextStyle(
          color: Color.fromRGBO(255, 253, 228, 1),
        ),
        obscureText: isPassword,
        keyboardType:
            !isPassword ? TextInputType.emailAddress : TextInputType.text,
        cursorColor: Theme.of(context).colorScheme.surface,
        decoration: InputDecoration(
          fillColor: Colors.black.withOpacity(0.15),
          filled: true,
          prefixIcon: Icon(
            icon,
            color: const Color.fromRGBO(255, 253, 228, 1),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          hintMaxLines: 1,
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}
