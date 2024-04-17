import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../models/bill.dart';
import '../pages.dart';

class BillCard extends StatelessWidget {
  final int index;
  final KiaanAyurvedaBill bill;
  final void Function() getBills;

  const BillCard({
    Key? key,
    required this.index,
    required this.bill,
    required this.getBills,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: ColorConstants.shadow,
              offset: Offset(0, 1),
              blurRadius: 3,
            )
          ],
          border: Border.all(
            color: Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: _buildLeftRow()),
            IconButton(
                icon: const Icon(Icons.print),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    Pages.previewBill,
                    arguments: {'bill': bill},
                  );
                }),
          ],
        ),
      ),
      onTap: () => _onTap(context),
    );
  }

  Widget _buildLeftRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildIndexBox(),
        const SizedBox(width: 16),
        Expanded(child: _buildDesc()),
      ],
    );
  }

  Widget _buildIndexBox() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: ColorConstants.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          '${index + 1}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildDesc() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Invoice No: ${bill.invoiceNo} - ${bill.invoiceDate}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Amount: ${bill.total}',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          bill.to,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _onTap(BuildContext context) {
    Navigator.of(context).pushNamed(
      Pages.editBill,
      arguments: {'bill': bill},
    ).then((value) {
      getBills();
    });
  }
}
