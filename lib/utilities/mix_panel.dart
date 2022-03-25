// import 'package:mixpanel_flutter/mixpanel_flutter.dart';
// import 'package:spaces/data/user.dart';

// class AnalyticInterface {
//   final Mixpanel mixpanel;

//   AnalyticInterface({required this.mixpanel});

//   Future<void> initUser(User currentUser) async {
//     if (currentUser.uid != "" && currentUser.uid != await mixpanel.getDistinctId()) {
//       mixpanel.identify(currentUser.uid);
//       mixpanel.alias(currentUser.userId, currentUser.uid);
//     }
//   }

//   void updateInitialData() {
//     mixpanel.getPeople().set("Last Login", DateTime.now().toString());
//     mixpanel.getPeople().increment("Total App Visits", 1);
//     mixpanel.track("App Visit");
//   }

//   // Events

//   void trackCreatedSpace(String chatId) {
//     mixpanel.track("Created Space", properties: {
//       "chatId": chatId,
//     });
//   }

//   void trackOpenedChat(String chatId) {
//     mixpanel.track("Opened Chat", properties: { 
//       "chatId": chatId,
//     });
//   }

//   void trackReplied(String chatId, bool isMine) {
//     mixpanel.track("Replied", properties: {
//       "chatId": chatId,
//       "Mine": isMine
//     });
//   }

//   void flushAll() {
//     mixpanel.flush();
//   }

// }
