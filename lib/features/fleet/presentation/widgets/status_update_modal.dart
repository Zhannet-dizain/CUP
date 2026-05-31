import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/vehicle.dart';
import '../../domain/entities/vehicle_status.dart';
import '../../domain/entities/status_reason.dart';
import '../providers/vehicle_provider.dart';

class StatusUpdateModal extends ConsumerStatefulWidget {
  final Vehicle vehicle;

  const StatusUpdateModal({super.key, required this.vehicle});

  @override
  ConsumerState<StatusUpdateModal> createState() => _StatusUpdateModalState();
}

class _StatusUpdateModalState extends ConsumerState<StatusUpdateModal> {
  VehicleStatus? selectedStatus;
  StatusReason? selectedReason;
  final TextEditingController commentController = TextEditingController();

  bool get requiresReason {
    if (selectedStatus == null) return false;
    return selectedStatus == VehicleStatus.underRepair ||
        selectedStatus == VehicleStatus.accident ||
        selectedStatus == VehicleStatus.idleNoDriver ||
        selectedStatus == VehicleStatus.waitingRepair ||
        selectedStatus == VehicleStatus.waitingParts;
  }

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.vehicle.status;
    selectedReason = widget.vehicle.reason;
    commentController.text = widget.vehicle.comment ?? '';
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Update Status: ${widget.vehicle.licensePlate}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
              ],
            ),
            const Divider(),
            const SizedBox(height: 10),
            const Text('Select New Status', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: VehicleStatus.values.map((status) {
                final isSelected = selectedStatus == status;
                return ChoiceChip(
                  label: Text(status.label),
                  selected: isSelected,
                  selectedColor: status.color.withOpacity(0.3),
                  onSelected: (val) {
                    setState(() {
                      selectedStatus = status;
                      if (!requiresReason) {
                        selectedReason = null;
                      }
                    });
                  },
                );
              }).toList(),
            ),
            if (requiresReason) ...[
              const SizedBox(height: 20),
              const Text('Reason', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              DropdownButtonFormField<StatusReason>(
                value: selectedReason,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                items: StatusReason.values.map((r) => DropdownMenuItem(value: r, child: Text(r.label))).toList(),
                onChanged: (val) => setState(() => selectedReason = val),
              ),
              const SizedBox(height: 20),
              const Text('Comment (Optional)', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              TextField(
                controller: commentController,
                decoration: InputDecoration(
                  hintText: 'Enter details...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                maxLines: 2,
              ),
            ],
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  ref.read(vehicleListProvider.notifier).updateVehicleStatus(
                    vehicleId: widget.vehicle.id,
                    newStatus: selectedStatus!,
                    reason: selectedReason,
                    comment: commentController.text.isNotEmpty ? commentController.text : null,
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Status updated successfully')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Save Update', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
