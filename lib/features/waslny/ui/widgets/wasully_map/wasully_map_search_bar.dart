import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/extensions.dart';

import '../../../../../core/Utilits/colors.dart';
import '../../../../../core_new/router/router.dart';
import '../../../../Widgets/edit_text.dart';
import '../../../logic/wasully_map_cubit/wasully_map_cubit.dart';
import '../../../logic/wasully_map_cubit/wasully_map_states.dart';

class WasullyMapSearchBar extends StatelessWidget {
  const WasullyMapSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WasullyMapCubit, WasullyMapStates>(
      builder: (context, state) {
        WasullyMapCubit cubit = context.read();
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 8.0,
                right: 8.0,
                left: 8.0,
              ),
              child: Form(
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          12,
                        ),
                      ),
                      height: context.height * .07,
                      width: context.width * .14,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_rounded,
                          size: 20.0,
                        ),
                        color: weevoPrimaryOrangeColor,
                        onPressed: () {
                          MagicRouter.pop();
                        },
                      ),
                    ),
                    SizedBox(
                      width: context.width * 0.01,
                    ),
                    Expanded(
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: EditText(
                          readOnly: false,
                          controller: cubit.searchController,
                          suffix: IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              cubit.searchController.clear();
                              cubit.searchFocusNode.unfocus();
                              cubit.clearPlaces();
                            },
                          ),
                          filled: true,
                          labelText: 'الموقع',
                          onTap: () {
                            if (cubit.places.isNotEmpty) {
                              cubit.changeSearchContainerVisibility(true);
                            }
                          },
                          fillColor: Colors.white,
                          focusNode: cubit.searchFocusNode,
                          prefix: state is WasullyMapSearchLoadingState
                              ? Container(
                                  padding: const EdgeInsets.all(12.0),
                                  height: context.height * 0.02,
                                  width: context.width * 0.02,
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : const Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                ),
                          isPassword: false,
                          isPhoneNumber: false,
                          shouldDisappear: false,
                          upperTitle: false,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            cubit.isSearchContainerVisible
                ? Container(
                    color: Colors.white.withOpacity(0.8),
                    height: context.height * 0.3,
                    child: ListView.builder(
                      itemBuilder: (context, i) => ListTile(
                        onTap: () {
                          cubit.updateLocation(
                            controller: cubit.mapController!,
                            lat: cubit.places[i].lat!,
                            long: cubit.places[i].lang!,
                            state: WaslyMapState.fromSearch,
                          );
                          cubit.searchController.clear();
                          cubit.searchFocusNode.unfocus();
                          cubit.changeSearchContainerVisibility(false);
                        },
                        title: Text(
                          cubit.places[i].name!,
                          style: const TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          cubit.places[i].formattedAddress!,
                          style: const TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey,
                          ),
                        ),
                        leading: const Icon(
                          Icons.location_on_rounded,
                          color: Colors.black,
                        ),
                      ),
                      itemCount: cubit.places.length,
                    ),
                  )
                : Container()
          ],
        );
      },
    );
  }
}
