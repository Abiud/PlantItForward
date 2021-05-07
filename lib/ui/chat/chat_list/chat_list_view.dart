import 'package:flutter/material.dart';
import 'package:plant_it_forward/ui/chat/chat_list/chat_list_view_model.dart';
import 'package:stacked/stacked.dart';

class ChatListView extends StatelessWidget {
  const ChatListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChatListViewModel>.reactive(
      builder: (context, model, child) => Scaffold(),
      viewModelBuilder: () => ChatListViewModel(),
    );
  }
}
