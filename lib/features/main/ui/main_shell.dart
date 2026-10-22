import 'package:docdoc/core/di/dependency_injection.dart';
import 'package:docdoc/core/helpers/responsive.dart';
import 'package:docdoc/features/appointments/logic/appointments_cubit.dart';
import 'package:docdoc/features/appointments/ui/appointments_screen.dart';
import 'package:docdoc/features/home/ui/home_screen.dart';
import 'package:docdoc/features/profile/ui/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _currentIndex;
  late final AppointmentsCubit _appointmentsCubit;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab.clamp(0, 2);
    _appointmentsCubit = getIt<AppointmentsCubit>()..load();
  }

  @override
  void dispose() {
    _appointmentsCubit.close();
    super.dispose();
  }

  void _selectTab(int index) {
    if (index == _currentIndex) return;
    setState(() => _currentIndex = index);
    if (index == 1) {
      _appointmentsCubit.load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final useRail = context.isExpandedWidth;

    return BlocProvider.value(
      value: _appointmentsCubit,
      child: Scaffold(
        body: useRail
            ? Row(
                children: [
                  SafeArea(
                    child: NavigationRail(
                      selectedIndex: _currentIndex,
                      onDestinationSelected: _selectTab,
                      labelType: NavigationRailLabelType.all,
                      destinations: const [
                        NavigationRailDestination(
                          icon: Icon(Icons.home_outlined),
                          selectedIcon: Icon(Icons.home),
                          label: Text('Home'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.calendar_month_outlined),
                          selectedIcon: Icon(Icons.calendar_month),
                          label: Text('Appointments'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.person_outline),
                          selectedIcon: Icon(Icons.person),
                          label: Text('Profile'),
                        ),
                      ],
                    ),
                  ),
                  const VerticalDivider(width: 1, thickness: 1),
                  Expanded(child: _pages),
                ],
              )
            : _pages,
        bottomNavigationBar: useRail
            ? null
            : NavigationBar(
                selectedIndex: _currentIndex,
                onDestinationSelected: _selectTab,
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.home_outlined),
                    selectedIcon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.calendar_month_outlined),
                    selectedIcon: Icon(Icons.calendar_month),
                    label: 'Appointments',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.person_outline),
                    selectedIcon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
              ),
      ),
    );
  }

  Widget get _pages => IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(onOpenAppointments: () => _selectTab(1)),
          AppointmentsScreen(onFindDoctor: () => _selectTab(0)),
          ProfileScreen(onOpenAppointments: () => _selectTab(1)),
        ],
      );
}
