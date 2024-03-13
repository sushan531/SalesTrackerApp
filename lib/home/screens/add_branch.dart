import 'package:flutter/material.dart';
import 'package:tipot/Login/screens/sign_up_page.dart';
import 'package:tipot/Login/utils/app_enum.dart';
import 'package:tipot/Login/widgets/custom_textfield_widget.dart';

class AddBranch extends StatefulWidget {
  const AddBranch({super.key});

  @override
  State<AddBranch> createState() => _AddBranchState();
}

class _AddBranchState extends State<AddBranch> {
  TextEditingController organizationidcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromARGB(255, 232, 219, 182),
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(
          "Register Here",
          style:
              TextStyle(fontSize: 30, color: Color.fromARGB(255, 65, 64, 60)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            CustomtextField(
              textController: organizationidcontroller,
              textfieldtype: TextFieldType.isorganizationid,
              icon: Icons.confirmation_num_sharp,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 50,
              width: 200,
              child: Center(
                child: InkWell(
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SignUpPage())),
                  child: Text(
                    "Add",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              decoration: BoxDecoration(
                  color: Colors.amber, borderRadius: BorderRadius.circular(20)),
            ),
          ],
        ),
      ),
    );
  }
}
