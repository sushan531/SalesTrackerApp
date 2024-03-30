import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tipot/Login/controllers/user_controllers.dart';
import 'package:tipot/index.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final BranchControllers _branchController = Get.put(BranchControllers());
  List<String> _selectedBranches = [];
  SalesAddUserControllers _addUserControllers = Get.put(SalesAddUserControllers());
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();


// Dialogbox for adding user
@override
Future openAddUserDialog() => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Add User"),
      content: Column(
        children: [
          CustomtextField(textController: _addUserControllers.emailcontroller,
              textfieldtype: TextFieldType.isEmail,
              icon: Icons.email_outlined),
          CustomtextField(textController: _addUserControllers.passwordcontroller,
              textfieldtype: TextFieldType.ispassword,
              icon: Icons.password_outlined),
          Obx(() => _branchController.branchNames.isEmpty
              ? const CircularProgressIndicator()
              : _buildDropDownMultiSelect(context)),

          Card(
            child: Text("Role"),
          ),
      ]
    ),
      actions: [
        TextButton(
            child: Text("Add User"),
            onPressed: () {
              Get.find<BranchControllers>().addBranchName();
              Navigator.push(context, MaterialPageRoute(builder: (context)=> AddUser()));

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
            "Add User",
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
                  if (_branchController.branchNames.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView.builder(

                      itemCount: _branchController.branchNames.length,


                      itemBuilder: (context, index) {
                        return Card(
                          color: Color(0xFFF2FEFB),
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 10),

                          child: ListTile(
                            leading: Icon(Icons.pin_drop_outlined),
                            title:Text(_branchController.branchNames[index],style:TextStyle(fontSize:20)),
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
                openAddUserDialog();


              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Add User ",
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
//Widget for dropdown multi selection of branches
  @override
  Widget _buildDropDownMultiSelect(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Select Branches"),
        DropdownButtonFormField<String>(
          isDense: true,
          items: _branchController.branchNames.map((branchName) {
            return DropdownMenuItem(
              value: branchName  , // Provide a default value if branchName is null
              child: Text(branchName), // Provide a default value if branchName is null
            );
          }).toList(),
          onChanged: (selectedBranch) {
            setState(() {
              if (_selectedBranches.contains(selectedBranch)) {
                _selectedBranches.remove(selectedBranch);
              } else {
                _selectedBranches.add(selectedBranch!);
                Wrap(
                  children: _selectedBranches.map((branch) {
                    return Chip(
                      label: Text(branch),
                      onDeleted: () {
                        setState(() {
                          _selectedBranches.remove(branch);
                        });
                      },
                    );
                  }).toList(),
                );
              }
            });
            setState(() {

            });
          },
          value: _selectedBranches.isNotEmpty ? _selectedBranches.first : null,  // Update value dynamically
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Select branches',
          ),
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down),

        ),



      ],
    );
  }
}
