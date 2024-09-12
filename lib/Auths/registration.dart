import 'package:e_market/Auths/input_fields.dart';
import 'package:flutter/material.dart';

class Registration extends StatefulWidget {
  Registration({super.key});



  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {

    bool isPasswordHidden = true;
  bool isConfirmationHidden = true;

  showAndHidePassword(){
    setState(() {
      isPasswordHidden = !isPasswordHidden;
    });
  }

  showAndHideConfirmation(){
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
                        decoration:  BoxDecoration(
                            shape: BoxShape.circle, color: Colors.blue[200]),
                        alignment: Alignment.center,
                        child: Image.asset("images/avatar.png")
                      ),
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
                secureText: isPasswordHidden,
                hint: "pa####d",
                prefix: const Icon(Icons.lock_outline),
                suffix:
                    IconButton(onPressed: () {
                        showAndHidePassword();
                      
                    }, icon:  Icon(isPasswordHidden?Icons.visibility: Icons.visibility_off)),
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
                secureText:isConfirmationHidden,
                hint: "pa####d",
                prefix: const Icon(Icons.lock),
                suffix:
                    IconButton(onPressed: () {
                        showAndHideConfirmation();
                      
                    }, icon:  Icon(isConfirmationHidden?Icons.visibility: Icons.visibility_off)),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                  
                  width: double.infinity,
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      onPressed: () {},
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: const Text(
                        "Register",
                        style: TextStyle(fontSize: 24),
                      ))),
                      const SizedBox(height: 20,),
                      Container(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          const Text("Already have an account? "),
                          InkWell(
                            onTap: (){
                              Navigator.of(context).pushNamedAndRemoveUntil('login_page', (Route<dynamic> route) => false);
                            },
                            child: const Text("Login here", style:TextStyle(color: Colors.blue, decoration: TextDecoration.underline ,decorationColor: Colors.blue, fontWeight: FontWeight.bold),)
                            )
                        ],),
                      )
            ],
          ),
        ),
      ),
    );
  }
}
