import 'package:docdoc/core/auth/auth_exception.dart';
import 'package:docdoc/core/auth/auth_storage.dart';
import 'package:docdoc/core/auth/local_user.dart';
import 'package:docdoc/core/di/dependency_injection.dart';
import 'package:docdoc/core/helpers/extensions.dart';
import 'package:docdoc/core/helpers/responsive.dart';
import 'package:docdoc/core/helpers/snackbars.dart';
import 'package:docdoc/core/helpers/spacing.dart';
import 'package:docdoc/core/routing/routes.dart';
import 'package:docdoc/core/theme/app_colors.dart';
import 'package:docdoc/core/theme/styles.dart';
import 'package:docdoc/core/widgets/empty_state.dart';
import 'package:docdoc/features/appointments/logic/appointments_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.onOpenAppointments});

  final VoidCallback onOpenAppointments;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  LocalUser? _user;

  @override
  void initState() {
    super.initState();
    _user = getIt<AuthStorage>().currentUser;
  }

  @override
  Widget build(BuildContext context) {
    final user = _user;
    final upcomingCount =
        context.watch<AppointmentsCubit>().state.upcomingCount;

    if (user == null) {
      return Scaffold(
        body: EmptyState(
          icon: Icons.person_outline,
          title: 'You are signed out',
          message: 'Sign in to see your profile and appointments.',
          actionLabel: 'Sign in',
          onAction: () => context.pushNamedAndRemoveUntil(
            Routes.login,
            predicate: (_) => false,
          ),
        ),
      );
    }

    final initials =
        user.name.trim().split(' ').where((part) => part.isNotEmpty).toList();
    final avatarText = initials.isEmpty
        ? 'U'
        : initials.length == 1
            ? initials.first.substring(0, 1).toUpperCase()
            : (initials.first.substring(0, 1) + initials.last.substring(0, 1))
                .toUpperCase();

    return SafeArea(
      child: ResponsiveCenter(
        maxWidth: AppBreakpoints.content,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          children: [
            Text('Profile', style: AppTextStyles.font24Black700W),
            verticalSpace(20),
            Container(
              padding: EdgeInsets.all(18.r),
              decoration: BoxDecoration(
                color: AppColors.lightBlue,
                borderRadius: BorderRadius.circular(22.r),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 34.r,
                    backgroundColor: AppColors.mainBlue,
                    child: Text(
                      avatarText,
                      style: AppTextStyles.font18White500W.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  horizantalSpace(16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: AppTextStyles.font18DarkBlue700W,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        verticalSpace(4),
                        Text(
                          user.email,
                          style: AppTextStyles.font12Gray500W,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        verticalSpace(8),
                        Text(
                          upcomingCount == 1
                              ? '1 upcoming appointment'
                              : '$upcomingCount upcoming appointments',
                          style: AppTextStyles.font12MainBlue400W,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            verticalSpace(24),
            _MenuItem(
              icon: Icons.calendar_month_outlined,
              title: 'My appointments',
              subtitle: 'View, manage or cancel your visits',
              onTap: widget.onOpenAppointments,
            ),
            _MenuItem(
              icon: Icons.edit_outlined,
              title: 'Edit name',
              subtitle: 'Change the name shown in the app',
              onTap: () => _editName(context, user),
            ),
            _MenuItem(
              icon: Icons.info_outline,
              title: 'About DocDoc',
              subtitle: 'Version 1.0.0 • Offline demo',
              onTap: () => _showAbout(context),
            ),
            _MenuItem(
              icon: Icons.logout,
              title: 'Log out',
              subtitle: 'Sign out of this device',
              isDestructive: true,
              onTap: () => _confirmLogout(context),
            ),
            verticalSpace(16),
            Center(
              child: Text(
                'Your data stays on this device.',
                style: AppTextStyles.font11Gray400W,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editName(BuildContext context, LocalUser user) async {
    final controller = TextEditingController(text: user.name);
    final newName = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit name'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(hintText: 'Full name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.of(dialogContext).pop(controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    controller.dispose();

    if (newName == null || !context.mounted) return;

    try {
      final updatedUser = await getIt<AuthStorage>().updateName(newName);
      if (!mounted) return;
      setState(() => _user = updatedUser);
      if (!context.mounted) return;
      showAppSnackBar(context, 'Your name has been updated.');
    } on AuthException catch (error) {
      if (!context.mounted) return;
      showAppSnackBar(context, error.message, isError: true);
    }
  }

  void _showAbout(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('About DocDoc'),
        content: const Text(
          'DocDoc is a fully offline doctor appointment demo. '
          'Accounts, appointments and preferences are stored locally on this '
          'device using SharedPreferences.\n\n'
          'No data is sent to a server and no real medical advice is provided.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text(
          'You will need to sign in again to see your appointments.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Log out'),
          ),
        ],
      ),
    );

    if (shouldLogout != true) return;

    await getIt<AuthStorage>().logout();
    if (!context.mounted) return;
    context.pushNamedAndRemoveUntil(Routes.login, predicate: (_) => false);
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? const Color(0xFFB3261E) : AppColors.mainBlue;

    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.lightestGray),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(icon, color: color, size: 20.r),
                ),
                horizantalSpace(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.font14DarkBlue500W.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isDestructive
                              ? const Color(0xFFB3261E)
                              : AppColors.darkBlue,
                        ),
                      ),
                      verticalSpace(2),
                      Text(
                        subtitle,
                        style: AppTextStyles.font11Gray400W,
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: AppColors.lightGray,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
