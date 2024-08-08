import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../cubit/message_cubit.dart';
import '../model/message_model.dart';
import '../model/user_model.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

@RoutePage()
class MessagePage extends StatefulWidget {
  final UserModel friend;

  const MessagePage({super.key, required this.friend});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> with WidgetsBindingObserver {
  late final ScrollController scrollController;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final users = firestore.collection("User").doc(auth.currentUser!.uid);
    if (state == AppLifecycleState.resumed) {
      users.update({
        "isActive": true,
      });
    } else {
      users.update({
        "isActive": false,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).viewInsets.bottom > 0) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    }

    return BlocProvider(
      create: (context) =>
          MessageCubit(friend: widget.friend, controller: scrollController),
      child: BlocBuilder<MessageCubit, MessageState>(
        builder: (context, state) {
          final List<GlobalKey> keys = List.generate(
              state.messagesList.length, (index) => GlobalObjectKey(index));

          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () async {
                  await context.read<MessageCubit>().close();
                  if (context.mounted) {
                    context.router.maybePop();
                  }
                },
                icon: const Icon(
                  Icons.arrow_back,
                ),
              ),
              systemOverlayStyle: SystemUiOverlayStyle(
                systemNavigationBarColor: Colors.blue.shade600,
              ),
              toolbarHeight: 80.h,
              title: Text("Message ${widget.friend.name}"),
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Color(0xff3461FD),
                      Color(0xAA3461FD),
                      Color(0x003461FD),
                    ],
                  ),
                ),
              ),
              actions: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(90.r),
                  child: Container(
                    width: 20.w,
                    height: 20.h,
                    decoration: BoxDecoration(
                      color: state.isFriendActive! ? Colors.green : Colors.red,
                    ),
                  ),
                ),
                SizedBox(width: 20.w),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 24.w),
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: state.messagesList.length,
                      itemBuilder: (context, index) {
                        return MessageCard(
                          globalKey: keys[index],
                          message: state.messagesList[index],
                        );
                      },
                    ),
                  ),
                ),
                SendMessageTextfield(
                  friend: widget.friend,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class SendMessageTextfield extends StatefulWidget {
  const SendMessageTextfield({
    super.key,
    required this.friend,
  });

  final UserModel friend;

  @override
  State<SendMessageTextfield> createState() => _SendMessageTextfieldState();
}

class _SendMessageTextfieldState extends State<SendMessageTextfield> {
  late final TextEditingController textEditingController;

  @override
  void initState() {
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(color: Colors.blue.shade600),
      child: Row(
        children: [
          SizedBox(width: 24.w),
          Expanded(
            child: TextField(
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.white,
              controller: textEditingController,
              decoration: InputDecoration(
                fillColor: Colors.blue.shade800,
                filled: true,
                hintText: "Send a message",
                hintStyle: const TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(45.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 24.w),
          IconButton(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                Colors.green.shade600,
              ),
            ),
            onPressed: () async {
              if (textEditingController.text.isNotEmpty) {
                context.read<MessageCubit>().sendMessageToFriend(
                    textEditingController.text.trim(), widget.friend);
                textEditingController.clear();
              }
            },
            icon: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 24.w),
        ],
      ),
    );
  }
}

class MessageCard extends StatelessWidget {
  final MessageModel message;
  final GlobalKey globalKey;

  const MessageCard({
    super.key,
    required this.globalKey,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.friendUserUid == _auth.currentUser!.uid
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.h),
        child: InkWell(
          splashColor: message.friendUserUid == _auth.currentUser!.uid
              ? Colors.green.shade800
              : Colors.blue.shade800,
          borderRadius: BorderRadius.circular(45.r),
          key: globalKey,
          onLongPress: () async {
            final cubit = context.read<MessageCubit>();
            final RenderBox renderBox =
                globalKey.currentContext!.findRenderObject() as RenderBox;

            final Offset offset = renderBox.localToGlobal(Offset.zero);
            final Size size = renderBox.size;
            await showMenu(
              context: context,
              position: RelativeRect.fromLTRB(
                offset.dx, // Sol kenar
                offset.dy + size.height, // Alt kenar
                offset.dx, // Sağ kenar
                offset.dy, // Üst kenar
              ),
              items: [
                PopupMenuItem(
                  onTap: () => cubit.removeFromEverybody(message),
                  child: const Text("Remove from everybody"),
                ),
                PopupMenuItem(
                  onTap: () => cubit.removeFromMe(message),
                  child: const Text("Remove from me"),
                ),
              ],
            );
          },
          child: Ink(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: message.friendUserUid != _auth.currentUser!.uid
                  ? Colors.blue.shade100
                  : Colors.green.shade100,
              borderRadius: BorderRadius.circular(45.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message.text),
                SizedBox(height: 3.h),
                Text(message.time.toString()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
