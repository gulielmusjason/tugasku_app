import 'package:flutter/material.dart';
import 'package:tugasku_app/mainapp.dart';
import 'package:tugasku_app/signuppage.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _passwordVisible = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void changeTheme(ThemeMode themeMode) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _buildLoginForm(),
            _buildSignUpLink(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 250,
      width: MediaQuery.of(context).size.width,
      child: ClipPath(
        clipper: CustomShape(),
        child: Container(
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        Text(
          "LOGIN",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 20),
        _buildTextField(
          controller: _emailController,
          hintText: "Email",
          prefixIcon: Icons.email,
        ),
        _buildTextField(
          controller: _passwordController,
          hintText: "Kata Sandi",
          prefixIcon: Icons.lock,
          isPassword: true,
        ),
        const SizedBox(height: 20),
        _buildLoginButton(),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? _passwordVisible : false,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(prefixIcon),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(_passwordVisible
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 40,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MainApp(),
              ),
            );
          },
          child: const Text('LOGIN'),
        ),
      ),
    );
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Tidak Punya Akun?"),
        const SizedBox(width: 5),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignUpPage(),
                ),
              );
            },
            child: const Text(
              "Daftar",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.brown),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double height = size.height;
    var path = Path();
    path.moveTo(0.0, height / 2);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height / 2);
    path.lineTo(size.width, 0.0);
    path.lineTo(0.0, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
