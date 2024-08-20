import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_demo/utils/custom/custom_appbar.dart';
import 'package:firebase_demo/utils/custom/custom_text_field.dart';
import 'package:firebase_demo/utils/extension/datetime_extension.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../cubit/message_cubit.dart';
import '../../model/message_model.dart';
import '../../../auth/models/user_model.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

@RoutePage()
class MessagePage extends StatefulWidget {
  final UserModel friend;

  const MessagePage({super.key, required this.friend});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  late final ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
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
            appBar: CustomAppbar(
              leadingOnPressed: () async {
                await context.read<MessageCubit>().close();
                if (context.mounted) {
                  context.router.maybePop();
                }
              },
              centerTitle: false,
              systemOverlayStyle: SystemUiOverlayStyle(
                systemNavigationBarColor: Theme.of(context).colorScheme.primary,
              ),
              title: "Message ${widget.friend.name}",
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
                        return _MessageCard(
                          globalKey: keys[index],
                          message: state.messagesList[index],
                        );
                      },
                    ),
                  ),
                ),
                _SendMessageTextfield(
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

class _MessageCard extends StatelessWidget {
  final MessageModel message;
  final GlobalKey globalKey;

  const _MessageCard({
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
              items: message.friendUserUid == _auth.currentUser!.uid
                  ? [
                      PopupMenuItem(
                        onTap: () => cubit.removeFromEverybody(message),
                        child: Text(
                          "Remove from everybody",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      PopupMenuItem(
                        onTap: () => cubit.removeFromMe(message),
                        child: Text(
                          "Remove from me",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ]
                  : [
                      PopupMenuItem(
                        onTap: () => cubit.removeFromMe(message),
                        child: Text(
                          "Remove from me",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
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
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Column(
              crossAxisAlignment:
                  message.friendUserUid == _auth.currentUser!.uid
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
              children: [
                Text(
                  message.text,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: 3.h),
                Text(
                  message.time.mmed,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SendMessageTextfield extends StatefulWidget {
  const _SendMessageTextfield({required this.friend});

  final UserModel friend;

  @override
  State<_SendMessageTextfield> createState() => __SendMessageTextfieldState();
}

class __SendMessageTextfieldState extends State<_SendMessageTextfield> {
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
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
      child: Row(
        children: [
          SizedBox(width: 24.w),
          Expanded(
            child: CustomTextField(
              textController: textEditingController,
              hintText: "Send a message",
            ),
          ),
          SizedBox(width: 24.w),
          IconButton(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                Theme.of(context).colorScheme.secondary,
              ),
            ),
            onPressed: () async {
              if (textEditingController.text.isNotEmpty) {
                context.read<MessageCubit>().sendMessageToFriend(
                      textEditingController.text.trim(),
                      widget.friend,
                    );
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
