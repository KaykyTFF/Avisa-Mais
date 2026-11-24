import 'package:flutter/material.dart';

import '../../../core/di/app_dependencies.dart';
import '../../../core/theme/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/app_bottom_nav_bar.dart';
import '../../../widgets/app_header_bar.dart';
import '../widgets/profile/profile_modals.dart';
import '../widgets/profile/profile_stats_card.dart';

class ProfileScreen extends StatefulWidget {
  final String initialName;
  final String initialEmail;
  final bool isEmbedded;
  final VoidCallback? onBackToHome;

  const ProfileScreen({
    super.key,
    this.initialName = 'João Silva',
    this.initialEmail = 'Silva234@gmail.com',
    this.isEmbedded = false,
    this.onBackToHome,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _issueViewModel = AppDependencies.instance.issueViewModel;
  final _authViewModel = AppDependencies.instance.authViewModel;

  late String _userName;
  late String _userEmail;

  @override
  void initState() {
    super.initState();
    _userName = _authViewModel.currentUser?.name ?? widget.initialName;
    _userEmail = _authViewModel.currentUser?.email ?? widget.initialEmail;
  }

  void _editName() {
    showEditProfileNameDialog(
      context: context,
      currentName: _userName,
      onSave: (updatedName) {
        setState(() => _userName = updatedName);
        _authViewModel.updateProfile(name: _userName);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          widget.isEmbedded ? Colors.transparent : AppColors.backgroundGray,
      appBar: widget.isEmbedded ? null : const AppHeaderBar(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(child: Container(color: AppColors.backgroundGray)),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 60),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.10),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(22, 16, 22, 28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                tooltip: 'Voltar',
                                icon: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: AppColors.textDark,
                                  size: 22,
                                ),
                                splashRadius: 20,
                                onPressed: () {
                                  if (widget.isEmbedded &&
                                      widget.onBackToHome != null) {
                                    widget.onBackToHome!();
                                  } else {
                                    Navigator.of(context).pop();
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 54),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Text(
                                    _userName,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.textDark,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                InkWell(
                                  onTap: _editName,
                                  borderRadius: BorderRadius.circular(16),
                                  child: const Padding(
                                    padding: EdgeInsets.all(4),
                                    child: Icon(
                                      Icons.edit_rounded,
                                      size: 18,
                                      color: AppColors.primaryYellowDark,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              _userEmail,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textLight,
                              ),
                            ),
                            const SizedBox(height: 22),
                            ListenableBuilder(
                              listenable: _issueViewModel,
                              builder: (context, _) => ProfileStatsCard(
                                registeredCount: _issueViewModel.totalCount,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      child: ProfileAvatar(
                        onTap: () => showChangeProfilePhotoModal(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (!widget.isEmbedded)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AppBottomNavBar(
                currentTab: AppNavTab.profile,
                onHomeTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.home,
                  (route) => false,
                  arguments: _userName,
                ),
                onHistoryTap: () =>
                    Navigator.of(context).pushNamed(AppRoutes.history),
                onPlusTap: () =>
                    Navigator.of(context).pushNamed(AppRoutes.createIssue),
                onProfileTap: () {},
                onSettingsTap: () =>
                    Navigator.of(context).pushNamed(AppRoutes.settings),
              ),
            ),
        ],
      ),
    );
  }
}
