import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/mock_data_service.dart';
import '../../core/models/models.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  FeedbackCategory _category = FeedbackCategory.other;
  final _descCtrl = TextEditingController();
  final _plateCtrl = TextEditingController();
  bool _submitted = false;

  @override
  Widget build(BuildContext context) {
    final svc = context.watch<MockDataService>();
    final user = svc.currentUser;
    final dtFmt = DateFormat('dd/MM/yyyy HH:mm');

    final myFeedbacks = svc.feedbacks
        .where((f) => f.userId == user?.id)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Row(
        children: [
          // Form
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Gửi phản hồi', style: Theme.of(context).textTheme.displayMedium)
                      .animate().fadeIn(),
                  const SizedBox(height: 8),
                  const Text('Báo cáo vấn đề như mất thẻ, phí sai hoặc slot bị chiếm.',
                      style: TextStyle(color: AppColors.textSecondary))
                      .animate().fadeIn(delay: 100.ms),
                  const SizedBox(height: 32),

                  if (_submitted) ...[
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.available.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.available.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, color: AppColors.available, size: 28),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Phản hồi đã được gửi!',
                                    style: TextStyle(color: AppColors.available, fontWeight: FontWeight.w600)),
                                Text('Chúng tôi sẽ xử lý trong 24 giờ làm việc.',
                                    style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => setState(() => _submitted = false),
                      child: const Text('Gửi phản hồi khác'),
                    ),
                  ] else ...[
                    // Category
                    const Text('Loại vấn đề', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: FeedbackCategory.values.map((cat) {
                        final isSelected = _category == cat;
                        final icons = {
                          FeedbackCategory.lostTicket: Icons.confirmation_number_outlined,
                          FeedbackCategory.wrongFee: Icons.money_off,
                          FeedbackCategory.occupiedSlot: Icons.block,
                          FeedbackCategory.other: Icons.help_outline,
                        };
                        return GestureDetector(
                          onTap: () => setState(() => _category = cat),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.accent.withOpacity(0.15) : AppColors.surface,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected ? AppColors.accent : AppColors.border,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(icons[cat], color: isSelected ? AppColors.accent : AppColors.textSecondary, size: 16),
                                const SizedBox(width: 6),
                                Text(
                                  cat.label,
                                  style: TextStyle(
                                    color: isSelected ? AppColors.accent : AppColors.textSecondary,
                                    fontSize: 13,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ).animate().fadeIn(delay: 150.ms),
                    const SizedBox(height: 20),

                    // Plate (optional)
                    TextField(
                      controller: _plateCtrl,
                      textCapitalization: TextCapitalization.characters,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: const InputDecoration(
                        labelText: 'Biển số liên quan (tùy chọn)',
                        hintText: 'VD: 51A-12345',
                        prefixIcon: Icon(Icons.directions_car_outlined, color: AppColors.textSecondary),
                      ),
                    ).animate().fadeIn(delay: 200.ms),
                    const SizedBox(height: 16),

                    // Description
                    TextField(
                      controller: _descCtrl,
                      maxLines: 4,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: const InputDecoration(
                        labelText: 'Mô tả vấn đề *',
                        hintText: 'Mô tả chi tiết vấn đề bạn gặp phải...',
                        alignLabelWithHint: true,
                      ),
                    ).animate().fadeIn(delay: 250.ms),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (_descCtrl.text.trim().isEmpty) return;
                          svc.submitFeedback(
                            userId: user?.id ?? 'u004',
                            userFullName: user?.fullName ?? 'Khách',
                            category: _category,
                            description: _descCtrl.text.trim(),
                            licensePlate: _plateCtrl.text.trim().isNotEmpty
                                ? _plateCtrl.text.trim().toUpperCase()
                                : null,
                          );
                          _descCtrl.clear();
                          _plateCtrl.clear();
                          setState(() => _submitted = true);
                        },
                        icon: const Icon(Icons.send),
                        label: const Text('Gửi phản hồi', style: TextStyle(fontSize: 16)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ).animate().fadeIn(delay: 300.ms),
                  ],
                ],
              ),
            ),
          ),

          // My feedbacks
          Expanded(
            flex: 2,
            child: Container(
              decoration: const BoxDecoration(
                border: Border(left: BorderSide(color: AppColors.border)),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Phản hồi đã gửi', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 14),
                  Expanded(
                    child: myFeedbacks.isEmpty
                        ? const Center(
                            child: Text('Chưa có phản hồi nào.',
                                style: TextStyle(color: AppColors.textMuted)),
                          )
                        : ListView.separated(
                            itemCount: myFeedbacks.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 10),
                            itemBuilder: (context, i) {
                              final fb = myFeedbacks[i];
                              final isResolved = fb.status == FeedbackStatus.resolved;
                              return Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isResolved
                                        ? AppColors.available.withOpacity(0.3)
                                        : AppColors.border,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(fb.category.label,
                                            style: const TextStyle(
                                                color: AppColors.textPrimary,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13)),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: (isResolved ? AppColors.available : AppColors.reserved)
                                                .withOpacity(0.15),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            isResolved ? 'Đã xử lý' : 'Đang xử lý',
                                            style: TextStyle(
                                              color: isResolved ? AppColors.available : AppColors.reserved,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(fb.description,
                                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis),
                                    const SizedBox(height: 4),
                                    Text(dtFmt.format(fb.createdAt),
                                        style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
                                    if (isResolved && fb.resolution != null) ...[
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: AppColors.available.withOpacity(0.08),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          '✅ ${fb.resolution}',
                                          style: const TextStyle(color: AppColors.available, fontSize: 11),
                                        ),
                                      ),
                                    ],
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
        ],
      ),
    );
  }
}
