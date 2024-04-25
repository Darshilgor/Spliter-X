import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spliter_x/Services/Conts.dart';
import 'package:spliter_x/Services/Functions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          top: 10,
        ),
        child: StreamBuilder<GetRoomListMode>(
          stream: getRoomListStream(
              FirebaseAuth.instance.currentUser!.phoneNumber.toString()),
          builder: (context, AsyncSnapshot<GetRoomListMode> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: bgSecondry1, // Background color
                  valueColor: AlwaysStoppedAnimation<Color>(
                    bgSecondry2, // Color at the center of the gradient
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.roomIdList!.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                          context, '/roomList/transactioGroupList',
                          arguments: {
                            'roomId': snapshot.data!.roomIdList![index],
                          });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(
                          6,
                        ),
                      ),
                      child: ListTile(
                        title: Text(
                            snapshot.data!.roomNameList![index].toString()),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.add,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              snapshot.data!.roomMemberLength![index]
                                  .toString(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
