// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import '../../../../models/src/user_model/user_model.dart';
// import '../../../../services/navigation/router.dart';
// import '../../../app_ui.dart';
//
// class CustomChatCard extends ConsumerStatefulWidget {
//   final UserModel? userModel;
//   final VoidCallback? onTap;
//
//   const CustomChatCard( {super.key,this.onTap, this.userModel});
//
//   @override
//   ConsumerState<CustomChatCard> createState() => _CustomChatCardState();
// }
//
// class _CustomChatCardState extends ConsumerState<CustomChatCard> {
//   bool _hasMarkedRead = false;
//   ProviderSubscription<AsyncValue>? _subscription;
//
//
//   /// ✅ Marks unread messages as read for the given receiver ID
//
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//
//     final receiverId = widget.userModel?.uid;
//     if (receiverId == null || receiverId.isEmpty) return;
//
//     // ✅ Listen to the provider and mark as read when data is ready
//     _subscription ??= ref.listenManual<AsyncValue>(
//       chatCardProvider(receiverId),
//           (previous, next) async {
//         if (next is AsyncData && !_hasMarkedRead) {
//           _hasMarkedRead = true;
//           await markMessagesAsRead(receiverId);
//         }
//       },
//     );
//   }
//
//   @override
//   void dispose() {
//     _subscription?.close();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     final theme = Theme.of(context);
//     final receiverId = widget.userModel?.uid;
//
//     if (receiverId == null || receiverId.isEmpty) {
//       return const SizedBox.shrink();
//     }
//
//     final chatStateAsync = ref.watch(chatCardProvider(receiverId));
//
//     return chatStateAsync.when(
//       loading: () => const Center(child: CircularProgressIndicator()),
//       error: (error, stack) => Text("Error: $error"),
//       data: (chat) {
//
//         String formattedTime = '';
//         if (chat.timestamp != null) {
//           final now = DateTime.now();
//           final isToday = chat.timestamp!.day == now.day &&
//               chat.timestamp!.month == now.month &&
//               chat.timestamp!.year == now.year;
//
//           formattedTime = isToday
//               ? "${chat.timestamp!.hour.toString().padLeft(2, '0')}:${chat.timestamp!.minute.toString().padLeft(2, '0')}" // 14:05
//               : "${chat.timestamp!.day}/${chat.timestamp!.month}/${chat.timestamp!.year}"; // 23/06/2025
//         }
//
//         return CustomWidgets.customAnimationWrapper(
//           curve: Curves.decelerate,
//           animationType: AnimationType.fade,
//           duration: Duration(milliseconds: 500),
//           child: GestureDetector(
//             onTap: widget.onTap,
//             child: CustomWidgets.customContainer(
//               borderRadius: BorderRadius.circular(10),
//               border: Border.all(color: theme.primaryColor),
//               path: AssetImages.imgBg,
//               w: MediaQuery.of(context).size.width,
//               color: theme.scaffoldBackgroundColor,
//               padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 10.r),
//               child: Row(
//                 children: [
//                   CustomWidgets.customContainer(
//                     h: 40.r,
//                     w: 40.r,
//                     color: theme.primaryColor,
//                     border: Border.all(color: theme.primaryColor),
//                     boxShape: BoxShape.circle,
//                     child: Icon(Icons.person, color: theme.scaffoldBackgroundColor),
//                   ).padRight(10.r),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       CustomWidgets.customText(
//                         data: widget.userModel?.displayName ?? 'Name',
//                         style: BaseStyle.s15w700
//                             .w(500)
//                             .c(theme.primaryColor)
//                             .family(FontFamily.poppins),
//                       ),
//                       CustomWidgets.customText(
//                         data: chat.lastMessage.isEmpty
//                             ? 'No messages yet'
//                             : chat.lastMessage,
//                         style: BaseStyle.s10w700
//                             .w(500)
//                             .c(theme.primaryColor)
//                             .family(FontFamily.poppins),
//                       ),
//                     ],
//                   ).padV(2.r).padH(5.r),
//                   const Spacer(),
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       CustomWidgets.customText(
//                         data: formattedTime, // Replace with dynamic timestamp
//                         style: BaseStyle.s14w500
//                             .line(1.0)
//                             .c(theme.primaryColor)
//                             .family(FontFamily.poppins),
//                       ).padBottom(5.r),
//                       if (chat.unreadCount > 0)
//                         CustomWidgets.customContainer(
//                           h: 20.r,
//                           w: 20.r,
//                           color: theme.primaryColor,
//                           alignment: Alignment.center,
//                           boxShape: BoxShape.circle,
//                           child: CustomWidgets.customText(
//                             textAlign: TextAlign.center,
//                             data: '${chat.unreadCount}',
//                             style: BaseStyle.s10w700.c(theme.scaffoldBackgroundColor),
//                           ),
//                         ),
//                     ],
//                   ).padV(2.r).padH(5.r),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
