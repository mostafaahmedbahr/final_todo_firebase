import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_todo_firebase/auth/login/login.dart';
import 'package:final_todo_firebase/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../components/alret.dart';
class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  signUp()
  async {
    var formData = formKey.currentState;
    if(formData!.validate())
    {
      formData.save();
      try {
        showLoading(context);
        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.toString(),
          password: passwordController.toString(),
        );
        return credential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Navigator.pop(context);
          AwesomeDialog(context: context,
          title: "Error",
          body: const Text("password is too weak"),
          ).show();
        } else if (e.code == 'email-already-in-use') {
          Navigator.pop(context);
          AwesomeDialog(context: context,
            title: "Error",
            body: const Text("email is already use"),
          ).show();
        }
      } catch (e) {
        print(e);
      }
    }
    else
    {
     print( "not valid");
    }
  }
  String? emailController;
  String? passwordController;
  String? nameController;
  final  formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("SignUp",
                    style:   TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40,),
                  TextFormField(
                    onSaved: (val)
                    {
                      nameController = val ;
                    },
                    validator: (val)
                    {
                      if(val!.length<2)
                      {
                        return "name can not be less than 2 ";
                      }
                      if(val.length>100)
                      {
                        return "name can not be more than 100 ";
                      }
                      return null;
                    },
                    onFieldSubmitted: (value){
                      print(value);
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      border:   OutlineInputBorder(),
                      labelText: "Name",
                      prefixIcon:  Icon(Icons.person),


                    ),
                  ),
                  const SizedBox(height: 20,),
                  TextFormField(
                    onSaved: (val)
                    {
                      emailController = val ;
                    },
                    validator: (val)
                    {
                      if(val!.length<2)
                      {
                        return "email can not be less than 2 ";
                      }
                      if(val.length>100)
                      {
                        return "email can not be more than 100 ";
                      }
                      return null;
                    },

                    onFieldSubmitted: (value){
                      print(value);
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      border:   OutlineInputBorder(),
                      labelText: "E_Mail Address",
                      prefixIcon:  Icon(Icons.email),


                    ),
                  ),
                  const SizedBox(height: 20,),
                  TextFormField(
                    onSaved: (val)
                    {
                      passwordController = val ;
                    },
                    validator: (val)
                    {
                      if(val!.length<6)
                      {
                        return "password can not be less than 6 ";
                      }
                      if(val.length>100)
                      {
                        return "password can not be more than 100 ";
                      }
                      return null;
                    },

                    obscureText: true,
                    onFieldSubmitted: (value){
                      print(value);
                    },
                    keyboardType: TextInputType.visiblePassword,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "PassWord",
                      prefixIcon:Icon(Icons.lock),
                      suffixIcon: Icon(Icons.remove_red_eye),


                    ),
                  ),
                  const SizedBox(height: 20,),
                  Container(
                    width: double.infinity,
                    color: Colors.blue,
                    child: MaterialButton(
                      onPressed: ()async
                      {
                       UserCredential response =  await signUp();
                     if(response != null)
                     {
                       await FirebaseFirestore.instance.collection("users").add(
                           {
                             "name":nameController,
                             "email":emailController,
                           });
                       Navigator.push(context,MaterialPageRoute(builder: (context)
                       {
                         return HomePage();
                       }));
                     }
                     else
                     {
                       print("faild");
                     }
                      },
                      child: const Text("Sign Up",
                        style:   TextStyle(fontSize: 20,color: Colors.white),),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?",),
                      TextButton(
                        onPressed: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginScreen(),
                          ));
                        },
                        child: const Text("Login"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
