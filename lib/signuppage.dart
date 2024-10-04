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
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  _buildTitle(),
                  const SizedBox(height: 20),
                  _buildInputField("Nama", Icons.person),
                  _buildInputField("Email", Icons.email),
                  _buildInputField("Kata Sandi", Icons.lock, isPassword: true),
                  _buildInputField("Konfirmasi Kata Sandi", Icons.lock,
                      isPassword: true),
                  _buildSignUpButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: ClipPath(
        clipper: CustomShapeSignUp(),
        child: Container(
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      "Buat Akun Kamu",
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildInputField(String hintText, IconData icon,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: TextField(
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(icon, color: Theme.of(context).iconTheme.color),
        ),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 50, bottom: 20, left: 20, right: 20),
      child: SizedBox(
        width: double.infinity,
        height: 40,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignInPage()),
            );
          },
          child: const Text('DAFTAR'),
        ),
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
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
