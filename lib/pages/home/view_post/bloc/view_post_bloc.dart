import 'package:dbestblog/pages/home/view_post/bloc/view_post_events.dart';
import 'package:dbestblog/pages/home/view_post/bloc/view_post_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewPostBloc extends Bloc<ViewPostEvents, ViewPostStates> {
  ViewPostBloc() : super(const ViewPostStates());
}
