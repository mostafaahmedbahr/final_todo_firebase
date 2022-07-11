import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:final_todo_firebase/components/alret.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../home_page.dart';
import '../sign_up/sign_up.dart';

 class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}



class _LoginScreenState extends State<LoginScreen> {
   signIn()
   async {
     var formData = formKey.currentState;
     if(formData!.validate())
     {
       formData.save();
       try {
         showLoading(context);
         UserCredential credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
             email: emailController,
             password: passwordController,
         );
         return credential;
       } on FirebaseAuthException catch (e) {
         if (e.code == 'user-not-found') {
           Navigator.pop(context);
           AwesomeDialog(context: context,
             title: "Error",
             body: const Text("email is not found"),
           ).show();
         } else if (e.code == 'wrong-password') {
           Navigator.pop(context);
           AwesomeDialog(context: context,
             title: "Error",
             body: const Text("password is too weak"),
           ).show();
         }
       }
     }
     else
     {
       print("not valid");
     }
   }
  var emailController ;
  var passwordController ;
  final  formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Login",
                    style:   TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40,),
                  TextFormField(
                    onSaved: (val)
                    {
                      emailController = val;
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
                      passwordController = val;
                    },
                    validator: (val)
                    {
                      if(val!.length<2)
                      {
                        return "password can not be less than 2 ";
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
                      onPressed: () async {
                        var user =  await signIn();
                        if(user != null)
                        {
                          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)
                          {
                            return const HomePage();
                          }));
                        }
                        else
                        {
                          print("faild");
                        }
                      },
                      child: const Text("LoGin",
                        style:   TextStyle(fontSize: 20,color: Colors.white),),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don\' have an account?",),
                      TextButton(
                        onPressed: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const SignUp(),
                          ));
                        },
                        child: const Text("Register"),
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