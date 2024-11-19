import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:task_management/Screens/Home.dart';
import 'package:task_management/auth/Login.dart';
import 'package:task_management/provider/Circular_Indicator.dart';
import 'package:task_management/provider/visivble_passoward.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  void registerUser() {
    final authProvider = Provider.of<Circular_provider>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      authProvider.setLoading(true);
      if (_password.text == _confirmPassword.text &&
          _email.text.endsWith('@gmail.com')) {
        auth
            .createUserWithEmailAndPassword(
          email: _email.text,
          password: _password.text,
        )
            .then(
          (value) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              elevation: 0,
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              content: AwesomeSnackbarContent(
                title: 'Registered successfully',
                message: 'Welcome to Task management app!',
                contentType: ContentType.success,
              ),
            ));
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Home()),
            );
          },
        ).onError(
          (error, stackTrace) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(error.toString()),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ));
          },
        ).whenComplete(() {
          authProvider.setLoading(false);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Password does not match or email is incorrect'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const Gap(31),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 91, 90, 90),
                      ),
                    ),
                  ),
                  const Gap(20),
                  _buildInputField(
                    label: 'Email',
                    controller: _email,
                    hintText: 'Enter Email',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const Gap(20),
                  Consumer<Visible_Passoward>(
                    builder: (context, value, child) {
                      return _buildInputField(
                        label: 'Password',
                        controller: _password,
                        hintText: 'Enter Password',
                        prefixIcon: Icons.lock_open,
                        obscureText: value.visibile_passoward_signup1,
                        suffixIcon: InkWell(
                          onTap: () {
                            value.setPassoward2();
                          },
                          child: Icon(value.Visible_Passoward_Signup
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined),
                        ),
                      );
                    },
                  ),
                  const Gap(20),
                  Consumer<Visible_Passoward>(
                    builder: (context, value, child) {
                      return _buildInputField(
                        label: 'Confirm Password',
                        controller: _confirmPassword,
                        hintText: 'Confirm Password',
                        prefixIcon: Icons.lock_open,
                        obscureText: value.visibile_passoward_signup2,
                        suffixIcon: InkWell(
                          onTap: () {
                            value.setPassoward3();
                          },
                          child: Icon(value.visibile_passoward_signup2
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined),
                        ),
                      );
                    },
                  ),
                  const Gap(40),
                  SizedBox(
                    width: double.infinity,
                    child: Consumer<Circular_provider>(
                      builder: (context, authProvider, child) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 91, 90, 90),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: registerUser,
                          child: authProvider.isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'Register',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                        );
                      },
                    ),
                  ),
                  const Gap(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account? ',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Login(),
                            ),
                          );
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 91, 90, 90),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 91, 90, 90),
          ),
        ),
        const Gap(8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(prefixIcon),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Colors.grey.shade200,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $label';
            }
            return null;
          },
        ),
      ],
    );
  }
}
