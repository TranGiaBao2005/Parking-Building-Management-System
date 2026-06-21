import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/mock_data_service.dart';
import '../../core/models/models.dart';
import '../../shared/utils/responsive.dart';

class PricingScreen extends StatefulWidget {
  const PricingScreen({super.key});

  @override
  State<PricingScreen> createState() => _PricingScreenState();
}

class _PricingScreenState extends State<PricingScreen> {
  String? _editingId;

  @override
  Widget build(BuildContext context) {
    final svc = context.watch<MockDataService>();
    final fmt = NumberFormat('#,###', 'vi_VN');
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: isMobile ? Alignment.center : Alignment.centerLeft,
              child: Text(
                'Chính sách giá',
                textAlign: isMobile ? TextAlign.center : TextAlign.left,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontSize: isMobile ? 22 : null,
                    ),
              ),
            ).animate().fadeIn(),
            const SizedBox(height: 8),
            const Text('Quản lý bảng giá và quy định tính phí gửi xe.',
                    style: TextStyle(color: AppColors.textSecondary))
                .animate()
                .fadeIn(delay: 100.ms),
            const SizedBox(height: 32),

            // Pricing cards
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 20,
              runSpacing: 20,
              children: svc.pricingPolicies.asMap().entries.map((e) {
                final policy = e.value;
                return SizedBox(
                  width: isMobile ? MediaQuery.sizeOf(context).width - 32 : 300,
                  child: _editingId == policy.id
                      ? _PricingEditCard(
                          policy: policy,
                          fmt: fmt,
                          onSave: (r, o, m) {
                            svc.updatePricing(policy.id, r, o, m);
                            setState(() => _editingId = null);
                          },
                          onCancel: () => setState(() => _editingId = null),
                        )
                      : _PricingDisplayCard(
                          policy: policy,
                          fmt: fmt,
                          onEdit: () => setState(() => _editingId = policy.id),
                        ),
                )
                    .animate()
                    .fadeIn(delay: Duration(milliseconds: 100 + e.key * 100));
              }).toList(),
            ),

            const SizedBox(height: 40),

            // How pricing works
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.info_outline,
                          color: AppColors.primaryLight, size: 18),
                      const SizedBox(width: 8),
                      Text('Cách tính phí',
                          style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const _RuleRow(
                      icon: Icons.timer,
                      text:
                          'Phí theo giờ: Tính theo từng giờ (làm tròn lên). Ví dụ: gửi 1.5 giờ → tính 2 giờ.'),
                  const SizedBox(height: 10),
                  const _RuleRow(
                      icon: Icons.nightlight_round,
                      text:
                          'Phí qua đêm: Áp dụng khi xe gửi qua 22:00 đến 06:00 hôm sau.'),
                  const SizedBox(height: 10),
                  const _RuleRow(
                      icon: Icons.calendar_month,
                      text:
                          'Phí tháng: Đăng ký theo tháng, không giới hạn lượt ra vào trong tháng.'),
                ],
              ),
            ).animate().fadeIn(delay: 400.ms),
          ],
        ),
      ),
    );
  }
}

class _PricingDisplayCard extends StatelessWidget {
  final PricingPolicy policy;
  final NumberFormat fmt;
  final VoidCallback onEdit;
  const _PricingDisplayCard(
      {required this.policy, required this.fmt, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final colors = {
      VehicleType.motorbike: AppColors.accent,
      VehicleType.car: AppColors.primary,
      VehicleType.truck: AppColors.reserved,
    };
    final color = colors[policy.vehicleType]!;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(policy.vehicleType.icon,
                      style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 10),
                  Text(
                    policy.vehicleType.label,
                    style: TextStyle(
                      color: color,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined,
                    color: AppColors.textSecondary, size: 18),
                onPressed: onEdit,
                tooltip: 'Chỉnh sửa',
              ),
            ],
          ),
          if (policy.description != null) ...[
            const SizedBox(height: 6),
            Text(policy.description!,
                style:
                    const TextStyle(color: AppColors.textMuted, fontSize: 12)),
          ],
          const Divider(color: AppColors.border, height: 24),
          _PriceRow(
              label: 'Giá/giờ',
              value: '${fmt.format(policy.ratePerHour)}đ',
              color: color),
          const SizedBox(height: 10),
          if (policy.overnightRate != null)
            _PriceRow(
                label: 'Phí qua đêm',
                value: '${fmt.format(policy.overnightRate!)}đ',
                color: AppColors.textPrimary),
          if (policy.overnightRate != null) const SizedBox(height: 10),
          if (policy.monthlyRate != null)
            _PriceRow(
                label: 'Phí tháng',
                value: '${fmt.format(policy.monthlyRate!)}đ',
                color: AppColors.textPrimary),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _PriceRow(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style:
                const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        Text(value,
            style: TextStyle(
                color: color, fontSize: 15, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _PricingEditCard extends StatefulWidget {
  final PricingPolicy policy;
  final NumberFormat fmt;
  final Function(double, double?, double?) onSave;
  final VoidCallback onCancel;
  const _PricingEditCard({
    required this.policy,
    required this.fmt,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<_PricingEditCard> createState() => _PricingEditCardState();
}

class _PricingEditCardState extends State<_PricingEditCard> {
  late final TextEditingController _rate;
  late final TextEditingController _overnight;
  late final TextEditingController _monthly;

  @override
  void initState() {
    super.initState();
    _rate = TextEditingController(
        text: widget.policy.ratePerHour.toStringAsFixed(0));
    _overnight = TextEditingController(
        text: widget.policy.overnightRate?.toStringAsFixed(0) ?? '');
    _monthly = TextEditingController(
        text: widget.policy.monthlyRate?.toStringAsFixed(0) ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.4), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(widget.policy.vehicleType.icon,
                  style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text('Chỉnh sửa: ${widget.policy.vehicleType.label}',
                  style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _rate,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: const InputDecoration(
                labelText: 'Giá/giờ (VND)', isDense: true),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _overnight,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: const InputDecoration(
                labelText: 'Phí qua đêm (VND)', isDense: true),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _monthly,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: const InputDecoration(
                labelText: 'Phí tháng (VND)', isDense: true),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onCancel,
                  child: const Text('Hủy'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    final rate = double.tryParse(_rate.text) ??
                        widget.policy.ratePerHour;
                    final overnight = double.tryParse(_overnight.text);
                    final monthly = double.tryParse(_monthly.text);
                    widget.onSave(rate, overnight, monthly);
                  },
                  child: const Text('Lưu'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RuleRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _RuleRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primaryLight, size: 16),
        const SizedBox(width: 10),
        Expanded(
          child: Text(text,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 13)),
        ),
      ],
    );
  }
}
