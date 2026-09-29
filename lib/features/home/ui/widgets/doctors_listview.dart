import 'package:docdoc/core/helpers/spacing.dart';
import 'package:docdoc/features/home/ui/widgets/doctor_listview_container.dart';
import 'package:flutter/material.dart';

class DoctorsListview extends StatelessWidget {
  const DoctorsListview({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        itemBuilder: (context, index) {
          return DoctorListviewContainer();
        },
        separatorBuilder: (BuildContext context, int index) {
          return verticalSpace(16);
        },
        itemCount: 5,
      ),
    );
  }
}
