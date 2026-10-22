import 'package:docdoc/core/di/dependency_injection.dart';
import 'package:docdoc/core/helpers/extensions.dart';
import 'package:docdoc/core/helpers/responsive.dart';
import 'package:docdoc/core/routing/routes.dart';
import 'package:docdoc/core/widgets/empty_state.dart';
import 'package:docdoc/features/home/data/repo/doctor_repository.dart';
import 'package:docdoc/features/home/ui/widgets/doctor_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class AllDoctorsArguments {
  const AllDoctorsArguments({this.specialty, this.query = ''});

  final String? specialty;
  final String query;
}

class AllDoctorsScreen extends StatelessWidget {
  const AllDoctorsScreen({super.key, required this.arguments});

  final AllDoctorsArguments arguments;

  @override
  Widget build(BuildContext context) {
    final doctors = getIt<DoctorRepository>().search(
      specialty: arguments.specialty,
      query: arguments.query,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(arguments.specialty ?? 'All Doctors'),
      ),
      body: doctors.isEmpty
          ? EmptyState(
              icon: Icons.search_off,
              title: 'No doctors found',
              message: 'Try another specialty or search term.',
              actionLabel: 'Back',
              onAction: () => context.pop(),
            )
          : ResponsiveCenter(
              maxWidth: AppBreakpoints.wideContent,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 16.h,
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final columns = context.responsiveColumns(
                      availableWidth: constraints.maxWidth,
                    );
                    final cardWidth =
                        (constraints.maxWidth - 12 * (columns - 1)) / columns;
                    return Wrap(
                      spacing: 12,
                      runSpacing: 12.h,
                      children: [
                        for (final doctor in doctors)
                          SizedBox(
                            width: cardWidth,
                            child: DoctorCard(
                              doctor: doctor,
                              onTap: () => context.pushNamed(
                                Routes.doctorDetails,
                                arguments: doctor,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
    );
  }
}
