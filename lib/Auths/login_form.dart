import 'package:e_market/Auths/input_fields.dart';
import 'package:flutter/material.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("E market"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10,),

              Center(
                child: Container(
                  width: 135,
                  height: 135,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(width: 1, color: Colors.blue),
                    color: Colors.blue[50]
                  ),
                  clipBehavior: Clip.hardEdge,
                  padding: const EdgeInsets.all(5),
                  alignment: Alignment.center,
                  child: Image.asset("images/E_comm_logo.png", fit: BoxFit.fill,),
                ),
              ),
              const SizedBox(height: 20,),
             
              const Text(
                "Email",
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const UserInputField(
                hint: "eg. example@domain.com",
                prefix: Icon(Icons.email),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Password",
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              UserInputField(
                hint: "pa#@#rd",
                prefix: const Icon(Icons.lock),
                suffix: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.visibility_outlined)),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                  alignment: Alignment.bottomRight,
                  child: MaterialButton(
                    onPressed: () {},
                    child: const Text("Forgot password ?"),
                  )),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                  width: double.infinity,
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    onPressed: () {},
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: const Text(
                      "Login",
                      style: TextStyle(fontSize: 24),
                    ),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Expanded(
                      child: Divider(
                    thickness: 1,
                  )),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      "Or login via",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const Expanded(
                      child: Divider(
                    thickness: 2,
                  ))
                ],
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton.icon(
                  onPressed: () {},
                  label: const Text("Google",
                      style: TextStyle(fontSize: 24, color: Colors.black)),
                  icon: Image.asset(
                    "images/google.png",
                    width: 30,
                    height: 30,
                  ),
                ),                
              ),

              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                alignment: Alignment.center,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Text("Don't have an account yet "),
                  Text("Register here", style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline, decorationColor: Colors.blue, fontWeight: FontWeight.bold), )
                ],),
              )
            ],
          ),
        ),
      ),
    );
  }
}
