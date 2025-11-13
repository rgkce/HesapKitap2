import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hesapkitap/core/theme/app_colors.dart';
import 'package:hesapkitap/core/theme/app_styles.dart';
import 'package:hesapkitap/features/navigation/approver_navbar.dart';

class ApproverHomePage extends StatelessWidget {
  const ApproverHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final List<Map<String, String>> pendingRequests = [
      {"title": "Talep #101", "status": "Bekliyor"},
      {"title": "Talep #102", "status": "Bekliyor"},
      {"title": "Talep #103", "status": "Bekliyor"},
    ];

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors:
                  isDark
                      ? [AppColors.grey800, AppColors.primary.withOpacity(0.8)]
                      : [
                        AppColors.primary.withOpacity(0.8),
                        AppColors.accent.withOpacity(0.8),
                      ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: size.height),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Yönetici Ana Sayfa",
                            style: AppStyles.heading1.copyWith(
                              color: AppColors.textLight,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/approver_profile');
                            },
                            icon: Icon(
                              Icons.settings,
                              color: AppColors.textLight,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // 🔹 Özet Kartlar
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _buildStatCard(
                            "Toplam Talepler",
                            "27",
                            Icons.list_alt,
                            AppColors.primary,
                          ),
                          _buildStatCard(
                            "Bekleyen Onaylar",
                            "5",
                            Icons.pending_actions,
                            AppColors.warning,
                          ),
                          _buildStatCard(
                            "Onaylananlar",
                            "20",
                            Icons.check_circle,
                            AppColors.success,
                          ),
                          _buildStatCard(
                            "Reddedilenler",
                            "2",
                            Icons.cancel,
                            AppColors.error,
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      // // 🔹 Hızlı İşlemler
                      // Text(
                      //   "Hızlı İşlemler",
                      //   style: AppStyles.heading2.copyWith(color: Colors.white),
                      // ),
                      // const SizedBox(height: 10),

                      // SizedBox(
                      //   height: 110,
                      //   child: ListView(
                      //     scrollDirection: Axis.horizontal,
                      //     children: [
                      //       _buildQuickAction(
                      //         icon: Icons.list_alt,
                      //         label: "Talepler",
                      //         color: AppColors.primary,
                      //       ),
                      //       _buildQuickAction(
                      //         icon: Icons.add_task,
                      //         label: "Yeni Talep",
                      //         color: AppColors.success,
                      //       ),
                      //       _buildQuickAction(
                      //         icon: Icons.bar_chart,
                      //         label: "Raporlar",
                      //         color: AppColors.warning,
                      //       ),
                      //       _buildQuickAction(
                      //         icon: Icons.people,
                      //         label: "Kullanıcılar",
                      //         color: AppColors.accent,
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      // const SizedBox(height: 30),

                      // 🔹 Onay Dağılım Pie Chart
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.grey100.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 12,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Onay - Red Dağılımı",
                              style: AppStyles.heading3.copyWith(
                                color: AppColors.grey800,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: 200,
                              child: PieChart(
                                PieChartData(
                                  borderData: FlBorderData(show: false),
                                  centerSpaceRadius: 50,
                                  sectionsSpace: 4,
                                  sections: [
                                    PieChartSectionData(
                                      value: 20,
                                      title: "20%",
                                      radius: 70,
                                      color: AppColors.warning,
                                      titleStyle: AppStyles.bodyText.copyWith(
                                        color: AppColors.textLight,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    PieChartSectionData(
                                      value: 74,
                                      title: "74%",
                                      radius: 70,
                                      color: AppColors.success,
                                      titleStyle: AppStyles.bodyText.copyWith(
                                        color: AppColors.textLight,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    PieChartSectionData(
                                      value: 6,
                                      title: "6%",
                                      radius: 70,
                                      color: AppColors.error,
                                      titleStyle: AppStyles.bodyText.copyWith(
                                        color: AppColors.textLight,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // 🔹 Bekleyen Talepler
                      Text(
                        "Bekleyen Talepler",
                        style: AppStyles.heading2.copyWith(
                          color: AppColors.grey100,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 160,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: pendingRequests.length,
                          itemBuilder: (context, index) {
                            final req = pendingRequests[index];
                            return Container(
                              width: 150,
                              margin: const EdgeInsets.only(right: 16),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.grey100.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    req["title"]!,
                                    style: AppStyles.heading3,
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 6,
                                      horizontal: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _statusColor(
                                        req["status"]!,
                                      ).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      req["status"]!,
                                      style: AppStyles.bodyText.copyWith(
                                        color: _statusColor(req["status"]!),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: const ApproverNavBar(currentIndex: 0),
      ),
    );
  }

  // Güncellenmiş _buildStatCard
  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color iconColor,
  ) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.grey100.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: AppStyles.heading3.copyWith(color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppStyles.heading2.copyWith(
              color: iconColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildQuickAction({
  //   required IconData icon,
  //   required String label,
  //   required Color color,
  // }) {
  //   return Container(
  //     width: 90,
  //     margin: const EdgeInsets.only(right: 16),
  //     padding: const EdgeInsets.all(12),
  //     decoration: BoxDecoration(
  //       color: AppColors.grey100.withOpacity(0.9),
  //       borderRadius: BorderRadius.circular(20),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black12,
  //           blurRadius: 8,
  //           offset: const Offset(0, 4),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         CircleAvatar(
  //           radius: 24,
  //           backgroundColor: color.withOpacity(0.2),
  //           child: Icon(icon, color: color, size: 28),
  //         ),
  //         const SizedBox(height: 8),
  //         Text(
  //           label,
  //           textAlign: TextAlign.center,
  //           style: AppStyles.bodyText.copyWith(
  //             color: Colors.black87,
  //             fontWeight: FontWeight.bold,
  //             fontSize: 12,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildRequestCard(String title, String status) {
  //   Color statusColor =
  //       status == "Bekliyor"
  //           ? AppColors.warning
  //           : status == "Onaylandı"
  //           ? AppColors.success
  //           : AppColors.error;

  //   return Container(
  //     width: 140,
  //     margin: const EdgeInsets.only(right: 12),
  //     padding: const EdgeInsets.all(12),
  //     decoration: BoxDecoration(
  //       color: AppColors.grey100.withOpacity(0.9),
  //       borderRadius: BorderRadius.circular(16),
  //     ),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Text(title, style: AppStyles.heading3),
  //         const SizedBox(height: 8),
  //         Container(
  //           padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
  //           decoration: BoxDecoration(
  //             color: statusColor.withOpacity(0.2),
  //             borderRadius: BorderRadius.circular(12),
  //           ),
  //           child: Text(
  //             status,
  //             style: AppStyles.bodyText.copyWith(
  //               color: statusColor,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Duruma göre renk döndüren fonksiyon
  Color _statusColor(String status) {
    switch (status) {
      case "Bekliyor":
        return AppColors.warning;
      case "Onaylandı":
        return AppColors.success;
      case "Reddedildi":
        return AppColors.error;
      default:
        return AppColors.grey400;
    }
  }
}
