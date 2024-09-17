import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:e_market/Auths/input_fields.dart';
import 'package:e_market/user.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

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

  File? file;
  String? photoUrl;

  getImageFromCamera() async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? pickedImage =
        await imagePicker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      await _handelImageUpload(pickedImage);
    }

    setState(() {});
  }

  Future<void> _handelImageUpload(XFile pickedImage) async {
    file = File(pickedImage.path);
    if(file != null){
    var imageName = path.basename(pickedImage.path);

    var imageRef = FirebaseStorage.instance.ref(imageName);
    await imageRef.putFile(file!);
    photoUrl = await imageRef.getDownloadURL();
    }
  }

  getImageFromGallery() async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      _handelImageUpload(pickedImage);
    }

    setState(() {});
  }

  showAndHidePassword() {
    setState(() {
      isPasswordHidden = !isPasswordHidden;
    });
  }

  signUpNewUser() async {
    var user = MarketUser(
        imageUrl: photoUrl,
        email: emailController.text,
        password: passwordController.text,
        name: usernameController.text,
        phoneNumber: phoneNumberController.text);

    try {
      bool isSuccessRegister = await user.register();
      if (isSuccessRegister) {
        sendEmailVerification();
        setState(() {});
      } else {
        print("Registration failed");
      }
    } catch (e) {
      print("Registration failed");
    }
  }

  sendEmailVerification() async{
    final user = FirebaseAuth.instance.currentUser;

    user!.sendEmailVerification();
    print("verification sent");
  }


  showAndHideConfirmation() {
    setState(() {
      isConfirmationHidden = !isConfirmationHidden;
    });
  }
@override
  void initState() {
    super.initState();
    if(FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser!.emailVerified){
      print("email verified");
      Navigator.pushReplacementNamed(context, 'login_page');
    }
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
                          clipBehavior: Clip.hardEdge,
                          margin: const EdgeInsets.only(top: 20),
                          width: 135,
                          height: 135,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.blue[200]),
                          alignment: Alignment.center,
                          child: file == null
                              ? Image.asset("images/avatar.png")
                              : photoUrl != null? Image.network(
                                  photoUrl!,
                                  fit: BoxFit.fill,
                                  width: 135,
                                  height: 135,
                                ):Image.file(file!),
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (builder) {
                                return Container(
                                  height: 150.0,
                                  color: Colors.transparent, 
                                  child: Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                              topLeft:
                                                  Radius.circular(10.0),
                                              topRight:
                                                  Radius.circular(10.0))),
                                      child:  Center(
                                        child:
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                const Text("Upload a photo via", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                                                const SizedBox(height: 30,),                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                  Column(
                                                    children: [
                                                      IconButton(onPressed: (){
                                                        getImageFromGallery();
                                                      }, icon: const Icon(Icons.image, size: 40, color: Colors.blue,)),
                                                      const Text("Gallery",)
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      IconButton(onPressed: (){
                                                        getImageFromCamera();
                                                      }, icon: const Icon(Icons.camera_alt, size: 40, color: Colors.blue,)),
                                                      const Text("Capture a photo",)
                                                
                                                    ],
                                                  ),
                                                ],),
                                              ],
                                            ),
                                      )),
                                );
                              });
                        },
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
                    return null;
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
                    return null;
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
                    if (val!.isEmpty) {
                      return "This field is required";
                    }
                    if (val.length != 11) {
                      return "Please enter a valid phone number";
                    }
                    return null;
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
                    if (val!.isEmpty) {
                      return "This field is required";
                    }
                    if (val.length < 6) {
                      return "Password can't be less than 6 characters at least";
                    }
                    return null;
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
                    return null;
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
                            AwesomeDialog(context: context,
                            dialogType: DialogType.info,
                            title: "Check your email", 
                            body: Text("An email verification sent to the email ${emailController.text} please check your email before you login"),
                            btnOkText: "Ok",
                            btnOkOnPress: (){
                              Navigator.pushReplacementNamed(context, 'login_page');
                            }
                            ).show();

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
