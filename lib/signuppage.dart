import 'package:flutter/material.dart';
import 'package:tugasku_app/signinpage.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
      ),
      body: Stack(
        children: [
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: ClipPath(
                      clipper: CustomShapeSignUp(),
                      child: Container(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Buat Akun Kamu",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 5, bottom: 5, right: 20, left: 20),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Nama",
                        prefixIcon: Icon(Icons.person,
                            color: Theme.of(context).iconTheme.color),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 5, bottom: 5, right: 20, left: 20),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Email",
                        prefixIcon: Icon(Icons.email,
                            color: Theme.of(context).iconTheme.color),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 5, bottom: 5, right: 20, left: 20),
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Kata Sandi",
                        prefixIcon: Icon(Icons.lock,
                            color: Theme.of(context).iconTheme.color),
                      ),
                      onChanged: (text) {},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 5, bottom: 5, right: 20, left: 20),
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Konfirmasi Kata Sandi",
                        prefixIcon: Icon(Icons.lock,
                            color: Theme.of(context).iconTheme.color),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 50,
                      bottom: 20,
                      left: 20,
                      right: 20,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignInPage(),
                            ),
                          );
                        },
                        child: const Text('DAFTAR'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomShapeSignUp extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double height = size.height;

    var path = Path();

    path.moveTo(0.0, height);
    path.quadraticBezierTo(
        size.width / 2, size.height / 5, size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.lineTo(0.0, 0.0);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
