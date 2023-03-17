import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:manager/controllers/AuthController.dart';
import 'package:manager/utils/color.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;
  bool showPassword = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void signInWithPassword() async {
    setState(() {
      loading = true;
    });
    await ref.read(authControllerProvider.notifier).signInWithPassword(
      context,
      emailController.text, 
      passwordController.text
    );
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final heightSafeArea = MediaQuery.of(context).size.height -
      AppBar().preferredSize.height -
      MediaQuery.of(context).padding.top -
      MediaQuery.of(context).padding.bottom;
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: heightSafeArea,
            padding: const EdgeInsets.symmetric(horizontal: 20,),
            child: Column(
              children: [
                const SizedBox(height: 50,),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(child: Image.asset("assets/img/cat2.png", width: 300)),
                        // const SizedBox(height: 10),
                        const Text(
                          "Nhập tài khoản và mật khẩu của bạn",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "Cẩn thận, bất kỳ ai có tài khoản của bạn đều có thể truy cập vào ứng dụng",
                          style: TextStyle(
                            color: Colors.grey
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(CupertinoIcons.mail),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: passwordController,
                          obscureText: !showPassword,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: () => setState(() {showPassword = !showPassword;}),
                              icon: Icon(showPassword ? CupertinoIcons.lock_open : CupertinoIcons.lock)
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Or login with Social Network",
                          style: TextStyle(
                            color: Colors.grey
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 10,
                          children: [
                            InkWell(
                              // onTap: loginWithFacebook,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: blue,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                alignment: Alignment.center,
                                child: SvgPicture.asset(
                                  "assets/svg/bxl-facebook.svg",
                                  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                                )
                              ),
                            ),
                            InkWell(
                              // onTap: loginWithGoogle,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: yellow,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                alignment: Alignment.center,
                                child: SvgPicture.asset(
                                  "assets/svg/bxl-google.svg",
                                  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                                )
                              ),
                            ),
                            InkWell(
                              // onTap: loginWithGithub,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: primary,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                alignment: Alignment.center,
                                child: SvgPicture.asset(
                                  "assets/svg/bxl-github.svg",
                                  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                                )
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  child: ElevatedButton(
                    onPressed: loading ? null : signInWithPassword,
                    child: loading ? const CircularProgressIndicator() : const Text("Login"), 
                  )
                ),
                const SizedBox(height: 20,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


