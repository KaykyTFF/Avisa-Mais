import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class ProfileAvatar extends StatelessWidget {
  final VoidCallback onTap;

  const ProfileAvatar({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 124,
            height: 124,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade300,
              border: Border.all(color: Colors.white, width: 5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ClipOval(
              child: Container(
                color: const Color(0xFF374151),
                child: const Center(
                  child: Icon(
                    Icons.person_rounded,
                    size: 76,
                    color: Color(0xFFE5E7EB),
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.primaryYellow.withValues(alpha: 0.92),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Center(
              child: Icon(
                Icons.edit_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileStatsCard extends StatelessWidget {
  final int registeredCount;

  const ProfileStatsCard({super.key, required this.registeredCount});

  @override
  Widget build(BuildContext context) {
    final approvedCount = registeredCount > 1 ? registeredCount - 1 : 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.primaryYellow,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryYellow.withValues(alpha: 0.35),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Column(
            children: [
              Text(
                'AVISOS DISPONÍVEIS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                ),
              ),
              SizedBox(height: 2),
              Text(
                '2/3',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppColors.primaryYellowDark.withValues(alpha: 0.7),
              width: 1.4,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      'Avisos registrados',
                      style: TextStyle(
                        color: AppColors.primaryYellowDark,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$registeredCount',
                      style: const TextStyle(
                        color: AppColors.primaryYellowDark,
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 46,
                width: 1,
                color: Colors.grey.shade300,
              ),
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      'Avisos aprovados',
                      style: TextStyle(
                        color: AppColors.primaryYellowDark,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$approvedCount',
                      style: const TextStyle(
                        color: AppColors.primaryYellowDark,
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
