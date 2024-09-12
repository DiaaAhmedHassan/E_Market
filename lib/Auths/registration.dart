import 'package:e_market/Auths/input_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Registration extends StatefulWidget {
  Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  bool isPasswordHidden = true;
  bool isConfirmationHidden = true;

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController =
      TextEditingController();

  GlobalKey<FormState> registerFormKey = GlobalKey();

  showAndHidePassword() {
    setState(() {
      isPasswordHidden = !isPasswordHidden;
    });
  }

  signUpNewUser() async {
    print('===============function called============');
    print("Email: ${emailController.text}");
    print("Password: ${passwordController.text}");
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      print("register success");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  showAndHideConfirmation() {
    setState(() {
      isConfirmationHidden = !isConfirmationHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("E market registration"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Form(
            key: registerFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                            margin: const EdgeInsets.only(top: 20),
                            width: 135,
                            height: 135,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue[200]),
                            alignment: Alignment.center,
                            child: Image.asset("images/avatar.png")),
                      ),
                      MaterialButton(
                        onPressed: () {},
                        textColor: Colors.black,
                        child: const Text("Upload"),
                      )
                    ],
                  ),
                ),
                const Text(
                  "User name",
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(
                  height: 10,
                ),
                UserInputField(
                  inputType: TextInputType.name,
                  onSave: (val) {
                    usernameController.text = val!;
                  },
                  validation: (val) {
                    if (val!.isEmpty) {
                      return "This field is required";
                    }
                  },
                  controller: usernameController,
                  secureText: false,
                  hint: "eg: Mohammed",
                  prefix: const Icon(Icons.person),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Email",
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(
                  height: 10,
                ),
                UserInputField(
                  validation: (val) {
                    if (val!.isEmpty) {
                      return "This field is required";
                    }
                    if (!RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$')
                        .hasMatch(val)) {
                      return 'Please enter a valid email';
                    }
                  },
                  onSave: (val) {
                    emailController.text = val!;
                  },
                  controller: emailController,
                  secureText: false,
                  hint: "eg: mohamed@gmail.com",
                  prefix: const Icon(Icons.email),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Phone number",
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(
                  height: 10,
                ),
                UserInputField(
                  inputType: TextInputType.phone,
                  validation: (val) {
                    if(val!.isEmpty){
                      return "This field is required";
                    }
                    if (val.length != 11) {
                      return "Please enter a valid phone number";
                    }
                  },
                  onSave: (val) {
                    phoneNumberController.text = val!;
                  },
                  controller: phoneNumberController,
                  secureText: false,
                  hint: "0124*******",
                  prefix: const Icon(Icons.email),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Password",
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(
                  height: 10,
                ),
                UserInputField(
                  onSave: (val) {
                    passwordController.text = val!;
                  },
                  validation: (val) {
                    if(val!.isEmpty){
                      return "This field is required";
                    }
                    if (val.length < 6) {
                      return "Password can't be less than 6 characters at least";
                    }
                  },
                  controller: passwordController,
                  secureText: isPasswordHidden,
                  hint: "pa####d",
                  prefix: const Icon(Icons.lock_outline),
                  suffix: IconButton(
                      onPressed: () {
                        showAndHidePassword();
                      },
                      icon: Icon(isPasswordHidden
                          ? Icons.visibility
                          : Icons.visibility_off)),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "confirm Password",
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(
                  height: 10,
                ),
                UserInputField(
                  onSave: (val) {
                    passwordConfirmationController.text = val!;
                  },
                  validation: (val) {
                    if (val != passwordController.text) {
                      return "Password confirmation field";
                    }
                  },
                  controller: passwordConfirmationController,
                  secureText: isConfirmationHidden,
                  hint: "pa####d",
                  prefix: const Icon(Icons.lock),
                  suffix: IconButton(
                      onPressed: () {
                        showAndHideConfirmation();
                      },
                      icon: Icon(isConfirmationHidden
                          ? Icons.visibility
                          : Icons.visibility_off)),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                    width: double.infinity,
                    child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: () {
                          print(passwordController.text);
                            registerFormKey.currentState!.save();
                          if (registerFormKey.currentState!.validate()) {
                            
                            signUpNewUser();
                          }
                        },
                        color: Colors.blue,
                        textColor: Colors.white,
                        child: const Text(
                          "Register",
                          style: TextStyle(fontSize: 24),
                        ))),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? "),
                      InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                'login_page', (Route<dynamic> route) => false);
                          },
                          child: const Text(
                            "Login here",
                            style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
