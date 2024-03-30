import 'package:flutter/material.dart';
import 'package:tipot/home/screens/add_user.dart';
import 'package:tipot/index.dart';
class NavDrawer extends StatefulWidget {
  const NavDrawer({super.key});

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(

            accountName: const Text('User'),
            accountEmail:const Text('Email', style: TextStyle(fontSize: 12, ),),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset('image/user.png'),),
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF03E4C4).withOpacity(.85),

              // if want to add image

              // image: const DecorationImage(image: AssetImage('image/bg.jpg'), fit: BoxFit.fill,),
            ),


          ),
          ListTile(
            leading: Icon(Icons.home_outlined, color: Color(0xFF03E4C4).withOpacity(.85),),
            title:  Text("Home", style: TextStyle(color: Color(0xFF03E4C4).withOpacity(.85), ),),
            onTap: () =>
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddBranch()))
          ),

           ListTile(
            leading: Icon(Icons.location_pin, ),
             title:  Text("Add Branch", ),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddBranch()))

          ),
          ListTile(
            leading: Icon(Icons.person),
            title:  Text("Add User",  ),
            onTap: () =>  Navigator.push(context, MaterialPageRoute(builder: (context) => AddUser()))
          ),




        ],
      ),

    );

  }
}

