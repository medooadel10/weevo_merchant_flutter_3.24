import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core_new/di/dependency_injection.dart';
import '../../../../core_new/router/router.dart';
import '../../../wasully_details/data/models/wasully_model.dart';
import '../../logic/wasully_cubit/wasully_cubit.dart';
import '../widgets/wasully/wasully_body.dart';

class WasullyScreen extends StatelessWidget {
  final WasullyModel? wasullyModel;
  const WasullyScreen({
    super.key,
    this.wasullyModel,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          WasullyCubit(getIt(), getIt())..getInitData(wasullyModel, context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'وصلي',
          ),
          leading: GestureDetector(
            onTap: () {
              MagicRouter.pop();
            },
            child: const Icon(Icons.arrow_back_ios),
          ),
        ),
        body: const WasullyBody(),
      ),
    );
  }
}
