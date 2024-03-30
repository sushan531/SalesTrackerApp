import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tipot/home/screens/add_user.dart';
import 'package:tipot/index.dart';


class AddBranch extends StatefulWidget {
  const AddBranch({Key? key}) : super(key: key);

  @override
  State<AddBranch> createState() => _AddBranchState();
}

class _AddBranchState extends State<AddBranch> {
  late BranchControllers branchController;

  @override
  void initState() {
    super.initState();
    branchController = Get.put(BranchControllers());
    branchController.getAllBranchNames();
     // Fetch branch names when widget is initialized
  }

//DialogBox for adding branch
  Future openDialog() => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Branch Name"),
      content: TextField(
        controller: Get.find<BranchControllers>().branchcontroller,
      ),
      actions: [
        TextButton(
          child: Text("Add Branch"),
          onPressed: () {
            Get.find<BranchControllers>().addBranchName();
            Navigator.push(context, MaterialPageRoute(builder: (context)=> AddBranch()));

          }
        )
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      
      appBar: AppBar(
        backgroundColor: Color(0xFF03E4C4).withOpacity(.85),
        title: Text(
          "Add Branch",
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
        actions: [
          GestureDetector(
            onTap:()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> AddUser())),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text("Next")
            ),
          )
        ]
      ),
      drawer: const NavDrawer(),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [

            Expanded(
              child:Obx(
                    () {
                  if (branchController.branchNames.isEmpty) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView.builder(
        
                      itemCount: branchController.branchNames.length,


                      itemBuilder: (context, index) {
                        return Card(
                          color: Color(0xFFF2FEFB),
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 10),
        
                          child: ListTile(
                            leading: Icon(Icons.pin_drop_outlined),
                            title:Text(branchController.branchNames[index],style:TextStyle(fontSize:20)),
                          ),
        
                        );
                      },
                    );
                  }
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                openDialog();
        
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Add Branch ",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Icon(Icons.add, color: Colors.white),
                ],
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF03E4C4).withOpacity(.85),
                elevation: 10,
                shadowColor: Color(0xFF03E4C4).withOpacity(.85),
              ),
            ),
            SizedBox(height: 20), // Add some space between the button and the bottom edge
          ],
        ),
      ),
    );
  }
}
