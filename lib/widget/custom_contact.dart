// import 'package:adaptive_theme/adaptive_theme.dart';
// import 'package:flutter/material.dart';
// import 'package:renconsport_flutter/modal/user.dart';
// import 'package:renconsport_flutter/services/user_service.dart';

// class CustomContact extends StatelessWidget {
//   const CustomContact({super.key, required this.id, required this.isNew});

//   final String id;
//   final bool isNew;

//   @override
//   Widget build(BuildContext context) {
//     User user = getUser();
//     return ListTile(
//       title: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Row(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(right: 15),
//               child: Container(
//                 width: 60,
//                 height: 60,
//                 decoration: const BoxDecoration(
//                   shape: BoxShape.circle,
//                   image: DecorationImage(
//                       image: NetworkImage(
//                           'https://googleflutter.com/sample_image.jpg'),
//                       fit: BoxFit.fill),
//                 ),
//               ),
//             ),
//             Text(
//               user.username,
//               style: isNew
//                   ? TextStyle(
//                       color: isNew ? Colors.white : const Color(0xFF000000),
//                       fontSize: 20)
//                   : AdaptiveTheme.of(context).theme.textTheme.bodyMedium,
//             ),
//           ],
//         ),
//       ),
//       tileColor: isNew
//           ? const Color(0xFF004989)
//           : AdaptiveTheme.of(context).theme.canvasColor,
//     );
//   }

//   User getUser() {
//     var res;
//     UserService.fetchUserFuture("/api/users/$id", UserService.getCurrentToken())
//         .then((value) {
//       res = value;
//     });
//     return res;
//   }
// }

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:renconsport_flutter/modal/user.dart';
import 'package:renconsport_flutter/services/user_service.dart';

class CustomContact extends StatelessWidget {
  const CustomContact({super.key, required this.id, required this.isNew});

  final String id;
  final bool isNew;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: getUser(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text("Chargement..."));
        }
        return ListTile(
          title: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                            'https://googleflutter.com/sample_image.jpg'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Text(
                  snapshot.data!.username,
                  style: isNew
                      ? TextStyle(
                          color: isNew ? Colors.white : const Color(0xFF000000),
                          fontSize: 20)
                      : AdaptiveTheme.of(context).theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          tileColor: isNew
              ? const Color(0xFF004989)
              : AdaptiveTheme.of(context).theme.canvasColor,
        );
      },
    );
  }

  Future<User> getUser() async {
    User? res;
    await UserService.fetchUserFuture(
            "/api/users/$id", UserService.getCurrentToken())
        .then((value) {
      res = value;
    });
    return res!;
  }
}
