import 'package:absensi_dede/absensi/models/absen/history_absen_response_model.dart';
import 'package:absensi_dede/absensi/services/maps_service.dart';
import 'package:absensi_dede/absensi/widgets/check_out_button.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:intl/intl.dart';

class SheetAttend extends StatelessWidget {
  final FLayout side;
  final Data history;
  const SheetAttend({required this.side, required this.history, super.key});

  @override
  Widget build(BuildContext context) {
    final typography = context.theme.typography;

    final latitude = double.parse(history.checkInLocation?.split(',')[0] ?? '');
    final longitude = double.parse(
      history.checkInLocation?.split(',')[1] ?? '',
    );

    final date = DateTime.parse(history.checkIn?.split(' ')[0] ?? "");
    final formattedDate = DateFormat('dd MMMM yyyy', 'id_ID').format(date);

    return Container(
      decoration: BoxDecoration(color: context.theme.colors.background),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsetsGeometry.only(top: 20, bottom: 10),
                  child: Column(
                    children: [
                      Text(formattedDate, style: typography.body.sm),
                      Row(
                        children: [
                          Expanded(child: Container()),
                          Text(
                            'Presensi ${history.status} jam ',
                            style: typography.body.lg,
                          ),
                          Text(
                            history.checkIn?.split(' ')[1] ?? '-',
                            style: typography.body.lg.copyWith(
                              fontWeight: .w700,
                            ),
                          ),
                          Expanded(child: Container()),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: FButton(
                  variant: .destructive,
                  onPress: () {},
                  size: .sm,
                  child: Icon(FLucideIcons.trash, size: 20),
                ),
              ),
            ],
          ),
          FDivider(style: .delta(padding: .value(.zero))),
          Expanded(
            child: ListView(
              padding: .only(left: 20, right: 20),
              children: [
                FAccordion(
                  children: [
                    FAccordionItem(
                      title: Text('Alamat Check In'),
                      child: Text(
                        history.checkInAddress ?? 'Tidak ada alamat tercatat',
                      ),
                    ),
                    FAccordionItem(
                      initiallyExpanded: true,
                      title: Text('Check Out'),
                      child: Text(
                        history.checkOutAddress ?? 'Anda Belum Checkout',
                      ),
                    ),
                    if (history.checkOutAddress != null) CheckOutButton(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
    ;
  }
}
