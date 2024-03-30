import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tipot/Login/index.dart';



class HomeScreen extends StatefulWidget {
   HomeScreen({super.key,

  });



  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  SignupControllers signupcontroller = Get.put(SignupControllers());
  bool isSignupScreen = false;
  Future messageDialog() =>showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Branch Name"),
        content: TextField(


        ),
        actions: [
          TextButton(
            child: Text("Add"),
            onPressed: ()=>Get.find<BranchControllers>().addBranchName(),)


        ],

      ));


  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>(); // Initialize _formKey here
  }


  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    print("gh");
    return Scaffold(
      backgroundColor: Color(0xFFF2FEFB),
      body: Stack(children: [
        Positioned(
          left: 0, // Adjust the left position as needed
          top: 0,
          right: 0,
          child: Container(
            height: 300,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("image/bg.jpg"),
                fit: BoxFit.fill,
              )
            ),
            child: Container(
              padding: EdgeInsets.only(top: 90, left: 20),
              color: Color(0xFF03E4C4).withOpacity(.85),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(text: TextSpan(
                    text: "Welcome to",
                    style: TextStyle(
                      fontSize: 25,
                      letterSpacing: 2,
                      color: Colors.blue[100],

                    ),
                    children: [
                      TextSpan(
                        text:"Tipot",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    ]

                  ),),
                  SizedBox(height: 5,),
                  Text("SignUp to Continue",
                  style: TextStyle(
                    fontSize: 25,
                    letterSpacing: 2,
                    color: Colors.blue[100],

                  )),
                ],
              ),
            ),
          ),// Adjust the top position as needed

        ),
        //Container for login and signup
        Positioned(
          top: 200,
            child: Container(
              padding: EdgeInsets.all(20),
          height: 380,
            width: MediaQuery.of(context).size.width-40,
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: 5,
              ),
            ],

          ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isSignupScreen = false;
                          });
                        },
                        child: Column(
                          children: [
                            Text("Login", style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold,
                              color: !isSignupScreen ? Color(0xFF068975): Color(0xFFc2dfda),
                        
                            ),),
                            if(!isSignupScreen)
                            Container(
                              margin: EdgeInsets.only(top:3),
                              height: 2,
                                width: 55,
                              color: Colors.orange,
                            )
                          ],
                        ),
                      ),

                      GestureDetector(
                        onTap: (

                            ) {
                          setState(() {
                            isSignupScreen = true;
                          });
                        },

                        child: Column(
                          children: [
                            Text("SignUp", style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold,
                              color: isSignupScreen? Color(0xFF068975):Color(0xFFc2dfda),

                            ),),
                            if(isSignupScreen)
                            Container(
                              margin: EdgeInsets.only(top:3),
                              height: 2,
                              width: 55,
                              color: Colors.orange,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10

                  ),
                  if(isSignupScreen)
                  SignUpPage(),
                  if(!isSignupScreen)
                    LoginPage(),

                ],

              ),
        )),
        if(isSignupScreen)
        Positioned(
          top: 535,
            right: 0,
            left: 0,
            child: Center(


              child: InkWell(
                onTap: () =>
                    Get.find<SignupControllers>().registerWithEmail(),
                child: Container(
                  height: 90,
                  width: 90,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),

                  ),
                  child: Container(

                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue, Colors.green],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.3),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0,1),
                      )
                      ],


                      ),

                    child: Icon(Icons.arrow_forward, color: Colors.white,),
                    ),

                  ),
              ),
            ),


        ),
        if (!isSignupScreen)
          Positioned(
            top: 535,
            right: 0,
            left: 0,
            child: Form(
              key: _formKey,
              child: Center(
                child: InkWell(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      Get.find<LoginControllers>().loginwithEmail();
                    }
                  },
                  child: Container(
                    height: 90,
                    width: 90,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue, Colors.green],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.3),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          )
                        ],
                      ),
                      child: Icon(Icons.arrow_forward, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),








      ]),
    );
























    // return Scaffold(
    //   backgroundColor: Colors.amber,
    //   body: Center(
    //     child: Column(children: [
    //       SizedBox(
    //         height: 270,
    //       ),
    //       Container(
    //         height: 50,
    //         width: 200,
    //         child: Center(
    //           child: InkWell(
    //             onTap: () => Navigator.of(context).push(
    //                 MaterialPageRoute(builder: (context) => SignUpPage())),
    //             child: Text(
    //               "Sign Up",
    //               style: TextStyle(color: Colors.black),
    //             ),
    //           ),
    //         ),
    //         decoration: BoxDecoration(
    //             color: Color.fromARGB(255, 232, 219, 182),
    //             borderRadius: BorderRadius.circular(20)),
    //       ),
    //       SizedBox(
    //         height: 20,
    //       ),
    //       Container(
    //         height: 50,
    //         width: 200,
    //         child: Center(
    //           child: InkWell(
    //             onTap: () => Navigator.of(context)
    //                 .push(MaterialPageRoute(builder: (context) => LoginPage())),
    //             child: Text(
    //               "Login",
    //               style: TextStyle(color: Colors.black),
    //             ),
    //           ),
    //         ),
    //         decoration: BoxDecoration(
    //             color: Color.fromARGB(255, 232, 219, 182),
    //             borderRadius: BorderRadius.circular(20)),
    //       ),
    //     ]),
    //   ),
    // );
  }
}
