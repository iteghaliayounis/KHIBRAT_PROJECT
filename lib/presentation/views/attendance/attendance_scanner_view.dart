import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../controllers/attendance_controller.dart';
import '../../controllers/attendance_scanner_controller.dart';
import '../../widgets/attendance/attendance_success_overlay.dart';

class AttendanceScannerView extends StatefulWidget {
  const AttendanceScannerView({super.key});

  @override
  State<AttendanceScannerView> createState() => _AttendanceScannerViewState();
}

class _AttendanceScannerViewState extends State<AttendanceScannerView> {
  late final AttendanceScannerController controller;
  late final MobileScannerController scannerController;

  @override
  void initState() {
    super.initState();
    controller = Get.find<AttendanceScannerController>();
    scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
    );
  }

  @override
  void dispose() {
    scannerController.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (controller.isProcessing.value || controller.showSuccess.value) return;
    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;
    final raw = barcodes.first.rawValue;
    if (raw == null || raw.isEmpty) return;

    await scannerController.stop();
    await controller.onQrDetected(raw);
    if (!controller.showSuccess.value && mounted) {
      // Allow another scan after recoverable failure.
      await scannerController.start();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCheckIn = controller.mode == AttendanceScanMode.checkIn;
    final title = isCheckIn ? 'attendance_scan_check_in'.tr : 'attendance_scan_check_out'.tr;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        if (controller.showSuccess.value && controller.actionResult.value != null) {
          return AttendanceSuccessOverlay(
            result: controller.actionResult.value!,
            isCheckIn: isCheckIn,
            onDone: controller.onDone,
          );
        }

        return Stack(
          fit: StackFit.expand,
          children: [
            MobileScanner(
              controller: scannerController,
              onDetect: _onDetect,
            ),
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.close_rounded, color: Colors.white),
                        ),
                        Expanded(
                          child: Text(
                            title,
                            style: AppTextStyles.h2.copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 28),
                    height: 240,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.secondary, width: 2.5),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Text(
                      'attendance_scan_hint'.tr,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
                    ),
                  ),
                  const Spacer(),
                  if (controller.isProcessing.value || controller.statusMessage.value != null)
                    Container(
                      margin: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.4,
                              color: AppColors.secondary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              (controller.statusMessage.value ?? 'attendance_processing').tr,
                              style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
