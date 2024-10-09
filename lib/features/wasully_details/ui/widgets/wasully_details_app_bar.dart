import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/Utilits/colors.dart';
import '../../../../core_new/router/router.dart';
import '../../logic/cubit/wasully_details_cubit.dart';
import '../../logic/cubit/wasully_details_state.dart';
import 'wasully_details_app_bar_title.dart';

class WasullyDetailsAppBar extends StatelessWidget {
  final int? id;
  const WasullyDetailsAppBar({super.key, this.id});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<WasullyDetailsCubit>();
    return BlocBuilder<WasullyDetailsCubit, WasullyDetailsState>(
      builder: (context, state) {
        return Container(
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                color: weevoPrimaryOrangeColor,
                onPressed: () {
                  MagicRouter.pop(data: cubit.wasullyModel);
                },
              ),
              Expanded(
                child: WasullyDetailsAppBarTitle(
                  id: id,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
