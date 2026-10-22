import 'package:docdoc/core/auth/auth_storage.dart';
import 'package:docdoc/core/di/dependency_injection.dart';
import 'package:docdoc/core/helpers/extensions.dart';
import 'package:docdoc/core/helpers/responsive.dart';
import 'package:docdoc/core/helpers/spacing.dart';
import 'package:docdoc/core/routing/routes.dart';
import 'package:docdoc/core/theme/app_colors.dart';
import 'package:docdoc/core/widgets/empty_state.dart';
import 'package:docdoc/features/home/logic/home_cubit.dart';
import 'package:docdoc/features/home/ui/all_doctors_screen.dart';
import 'package:docdoc/features/home/ui/widgets/doctor_card.dart';
import 'package:docdoc/features/home/ui/widgets/home_banner.dart';
import 'package:docdoc/features/home/ui/widgets/home_screen_app_bar.dart';
import 'package:docdoc/features/home/ui/widgets/search_field.dart';
import 'package:docdoc/features/home/ui/widgets/see_all_row.dart';
import 'package:docdoc/features/home/ui/widgets/specialty_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class HomeScreenBody extends StatefulWidget {
  const HomeScreenBody({super.key, required this.onOpenAppointments});

  final VoidCallback onOpenAppointments;

  @override
  State<HomeScreenBody> createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = getIt<AuthStorage>().currentUser;
    final firstName = user?.name.trim().split(' ').first ?? 'there';

    return SafeArea(
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final preview = state.doctors.take(4).toList();

          return ResponsiveCenter(
            maxWidth: AppBreakpoints.wideContent,
            child: RefreshIndicator(
              color: AppColors.mainBlue,
              onRefresh: () async => context.read<HomeCubit>().load(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                children: [
                  HomeScreenAppBar(
                    userName: firstName,
                    onNotificationTap: widget.onOpenAppointments,
                  ),
                  verticalSpace(20),
                  HomeBanner(
                    onFindDoctor: () {
                      _searchFocusNode.requestFocus();
                    },
                  ),
                  verticalSpace(24),
                  SearchField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    onChanged: (value) =>
                        context.read<HomeCubit>().search(value),
                    onClear: () {
                      _searchController.clear();
                      context.read<HomeCubit>().search('');
                    },
                  ),
                  verticalSpace(24),
                  const SeeAllRow(title: 'Specialties', showAction: false),
                  verticalSpace(12),
                  SpecialtyListView(
                    specialties: state.specialties,
                    selectedSpecialty: state.selectedSpecialty,
                    onSelected: (specialty) {
                      context.read<HomeCubit>().selectSpecialty(specialty);
                    },
                  ),
                  verticalSpace(24),
                  SeeAllRow(
                    title: state.selectedSpecialty == 'All'
                        ? 'Top Doctors'
                        : state.selectedSpecialty,
                    actionLabel: 'See All',
                    onAction: () {
                      context.pushNamed(
                        Routes.allDoctors,
                        arguments: AllDoctorsArguments(
                          specialty: state.selectedSpecialty == 'All'
                              ? null
                              : state.selectedSpecialty,
                          query: state.query,
                        ),
                      );
                    },
                  ),
                  verticalSpace(12),
                  if (state.isLoading)
                    const Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (preview.isEmpty)
                    EmptyState(
                      icon: Icons.search_off,
                      title: 'No doctors found',
                      message:
                          'Try a different name, specialty or clear your filters.',
                      actionLabel: 'Clear filters',
                      onAction: () {
                        _searchController.clear();
                        context.read<HomeCubit>().clearFilters();
                      },
                    )
                  else
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final columns = context.responsiveColumns(
                          availableWidth: constraints.maxWidth,
                        );
                        final cardWidth =
                            (constraints.maxWidth - 12 * (columns - 1)) /
                                columns;
                        return Wrap(
                          spacing: 12,
                          runSpacing: 12.h,
                          children: [
                            for (final doctor in preview)
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
                  verticalSpace(16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
