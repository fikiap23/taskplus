import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskplus/controllers/home_controller.dart';
import 'package:taskplus/screens/Home/create_subject_dialog.dart';
import 'package:taskplus/screens/Home/subject_card.dart';
import 'package:taskplus/common/widgets/drawer_menu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController _homeController = HomeController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadSubjectData();
  }

  Future<void> _loadUserData() async {
    await _homeController; // Gantilah dengan metode yang sesuai
    setState(() {}); // Memicu pembaharuan UI setelah data dimuat
  }

  Future<void> _loadSubjectData() async {
    await _homeController.loadSubjectData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("TaskPlus")),
      drawer: DrawerMenu(),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _homeController.scrollController,
          child: Container(
            color: Color.fromRGBO(242, 244, 255, 1),
            padding: const EdgeInsets.all(0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Hello,",
                              style: GoogleFonts.montserrat(
                                color: Colors.black,
                                fontSize: 25,
                              ),
                            ),
                            TextSpan(
                              text: "${_homeController.userData['name'] ?? ''}",
                              style: GoogleFonts.montserrat(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                      ),
                      Text(
                        "Have a nice day!",
                        style: GoogleFonts.montserrat(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Progress",
                            style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return CreateSubjectDialog();
                                },
                              );
                            },
                            child: Text("Create Subject"),
                          ),
                        ],
                      ),
                      // Display loading indicator if subject data is still loading
                      _homeController.subjectData == null
                          ? Center(child: CircularProgressIndicator())
                          : Column(
                              // Loop through subject cards without using ListView.builder
                              children: [
                                for (int index = 0;
                                    index <
                                        (_homeController.subjectData?.length ??
                                            0);
                                    index++)
                                  SubjectCard(
                                    subjectName: _homeController
                                            .subjectData![index]['name'] ??
                                        'SubjectName',
                                    teacher: _homeController.subjectData![index]
                                            ['dosen'] ??
                                        '',
                                    subjectId: _homeController
                                            .subjectData![index]['_id'] ??
                                        '',
                                  ),
                              ],
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
