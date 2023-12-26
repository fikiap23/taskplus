import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubjectCard extends StatelessWidget {
  SubjectCard({Key? key, required this.subjectName, required this.teacher})
      : super(key: key);
  late String subjectName;
  late String teacher;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              height: 70,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 123, 0, 245),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: const Icon(Icons.assignment, color: Colors.white),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      this.subjectName,
                      style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      this.teacher,
                      style: GoogleFonts.montserrat(
                        color: Colors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
                Expanded(child: Container()),
                Icon(
                  Icons.more_vert_outlined,
                  color: Colors.grey,
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
