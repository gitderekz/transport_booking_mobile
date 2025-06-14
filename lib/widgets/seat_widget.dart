//
// import 'package:flutter/material.dart';
// enum SeatStatus { available, selected, booked }
//
// class SeatWidget extends StatelessWidget {
//   final String seatNumber;
//   final SeatStatus status;
//   final VoidCallback? onTap;
//
//   const SeatWidget({
//     super.key,
//     required this.seatNumber,
//     required this.status,
//     this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     Color getColor() {
//       switch (status) {
//         case SeatStatus.available:
//           return Colors.green;
//         case SeatStatus.selected:
//           return Theme.of(context).colorScheme.primary;
//         case SeatStatus.booked:
//           return Colors.grey;
//       }
//     }
//
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 48,
//         height: 48,
//         margin: const EdgeInsets.symmetric(horizontal: 4),
//         decoration: BoxDecoration(
//           color: getColor(),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Center(
//           child: Text(
//             seatNumber,
//             style: TextStyle(
//               color: status == SeatStatus.booked ? Colors.white : Colors.black,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';

enum SeatStatus { available, selected, booked }

class SeatWidget extends StatelessWidget {
  final String seatNumber;
  final SeatStatus status;
  final VoidCallback? onTap;

  const SeatWidget({
    super.key,
    required this.seatNumber,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case SeatStatus.available:
        color = Colors.green;
        break;
      case SeatStatus.selected:
        color = Colors.blue;
        break;
      case SeatStatus.booked:
        color = Colors.red;
        break;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: status == SeatStatus.selected ? Colors.white : Colors.transparent,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            seatNumber,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}