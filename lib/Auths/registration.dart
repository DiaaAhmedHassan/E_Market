import 'package:e_market/Auths/input_fields.dart';
import 'package:flutter/material.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("E market registeration"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(10),
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
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.blue),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.person_add_alt_1,
                          size: 100,
                          color: Colors.grey[200],
                        ),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {},
                      child: const Text("Upload"),
                      textColor: Colors.black,
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
              const UserInputField(
                hint: "eg: Mohammed",
                prefix: Icon(Icons.person),
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
              const UserInputField(
                hint: "eg: mohamed@gmail.com",
                prefix: Icon(Icons.email),
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
              const UserInputField(
                hint: "0124*******",
                prefix: Icon(Icons.email),
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
                hint: "pa####d",
                prefix: Icon(Icons.lock_outline),
                suffix:
                    IconButton(onPressed: () {}, icon: Icon(Icons.visibility)),
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
                hint: "pa####d",
                prefix: Icon(Icons.lock),
                suffix:
                    IconButton(onPressed: () {}, icon: Icon(Icons.visibility)),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                  
                  width: double.infinity,
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      onPressed: () {},
                      child: Text(
                        "Register",
                        style: TextStyle(fontSize: 24),
                      ),
                      color: Colors.blue,
                      textColor: Colors.white)),
                      SizedBox(height: 20,),
                      Container(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          Text("Already have an account? "),
                          InkWell(
                            onTap: (){
                              Navigator.of(context).pushNamedAndRemoveUntil('login_page', (Route<dynamic> route) => false);
                            },
                            child: Text("Login here", style:TextStyle(color: Colors.blue, decoration: TextDecoration.underline ,decorationColor: Colors.blue),))
                        ],),
                      )
            ],
          ),
        ),
      ),
    );
  }
}
