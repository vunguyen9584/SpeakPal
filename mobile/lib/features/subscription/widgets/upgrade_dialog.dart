import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/subscription_provider.dart';
import '../services/purchase_service.dart';
import 'package:mobile/core/error/error_handler.dart';

/// Dialog to prompt users to upgrade to premium
class UpgradeDialog extends ConsumerStatefulWidget {
  const UpgradeDialog({super.key});

  @override
  ConsumerState<UpgradeDialog> createState() => _UpgradeDialogState();
}

class _UpgradeDialogState extends ConsumerState<UpgradeDialog> {
  bool _isPurchasing = false;

  @override
  Widget build(BuildContext context) {
    final plansAsync = ref.watch(plansProvider);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.workspace_premium,
                size: 48,
                color: Colors.amber.shade700,
              ),
            ),
            const SizedBox(height: 16),

            // Title
            const Text(
              'プレミアムにアップグレード',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Description
            const Text(
              'すべてのコンテンツにアクセスして、学習を加速しましょう！',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Plans
            plansAsync.when(
              data: (plans) {
                final premiumPlans = plans.where((p) => !p.isFree).toList();
                return Column(
                  children: premiumPlans.map((plan) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildPlanCard(context, plan),
                    );
                  }).toList(),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => const Text('プランの読み込みに失敗しました'),
            ),

            const SizedBox(height: 16),

            // Loading indicator
            if (_isPurchasing)
              const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 12),
                    Text('処理中...'),
                  ],
                ),
              ),

            // Actions
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: _isPurchasing ? null : () => Navigator.pop(context),
                    child: const Text('後で'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(BuildContext context, PlanInfo plan) {
    return Card(
      elevation: plan.isPopular ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: plan.isPopular
            ? BorderSide(color: Colors.amber.shade700, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: _isPurchasing ? null : () => _handlePurchase(plan),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plan.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          plan.price,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (plan.isPopular)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade700,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        '人気',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              ...plan.features.take(3).map((feature) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 16,
                        color: Colors.green.shade600,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          feature,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handlePurchase(PlanInfo plan) async {
    setState(() => _isPurchasing = true);

    final purchaseService = ref.read(purchaseServiceProvider);
    final result = await purchaseService.purchasePlan(plan.id);

    if (!mounted) return;
    setState(() => _isPurchasing = false);

    result.fold(
      (error) {
        // Handle error - convert to AppError and show message
        final appError = ErrorHandler.handle(error);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(appError.message),
            backgroundColor: Colors.red,
          ),
        );
      },
      (purchase) {
        // Success - refresh subscription status
        ref.invalidate(subscriptionProvider);

        // Close dialog
        Navigator.pop(context);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${plan.name}にアップグレードしました！'),
            backgroundColor: Colors.green,
          ),
        );
      },
    );
  }
}

