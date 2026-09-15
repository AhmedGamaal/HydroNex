import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydronex_app/core/network/api_client.dart';
import 'package:hydronex_app/core/storage/token_storage.dart';
import 'package:hydronex_app/core/theme/app_theme.dart';
import 'package:hydronex_app/features/aibot/data/datasources/ai_bot_remote_data_source.dart';
import 'package:hydronex_app/features/aibot/data/repositories/ai_bot_repository_impl.dart';
// import 'package:hydronex_app/features/aibot/view/widgets/ai_bot_feature_card.dart';
import 'package:hydronex_app/features/aibot/view/widgets/ai_bot_header.dart';
import 'package:hydronex_app/features/aibot/view/widgets/ai_bot_input.dart';
import 'package:hydronex_app/features/aibot/view/widgets/ai_bot_loading.dart';
import 'package:hydronex_app/features/aibot/view/widgets/ai_bot_message_bubble.dart';
import 'package:hydronex_app/features/aibot/view_model/ai_bot_view_model.dart';
import 'package:hydronex_app/features/crops/cubit/crop/crop_cubit.dart';

class AiBotTab extends StatefulWidget {
  const AiBotTab({super.key});

  @override
  State<AiBotTab> createState() => _AiBotTabState();
}

class _AiBotTabState extends State<AiBotTab>
    with AutomaticKeepAliveClientMixin {
  late AiBotViewModel viewModel;

  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    final Dio dio = ApiClient.create(
      tokenStorage: const TokenStorage(),
    );

    final AiBotRemoteDataSource remoteDataSource =
        AiBotRemoteDataSource(dio: dio);

    final AiBotRepositoryImpl repository = AiBotRepositoryImpl(
      remoteDataSource: remoteDataSource,
    );

    viewModel = AiBotViewModel(
      repository: repository,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    viewModel.dispose();
    super.dispose();
  }

  Future<void> sendMessage() async {
    if (controller.text.trim().isEmpty) {
      return;
    }

    final String message = controller.text.trim();
    controller.clear();

    final cropCubit = context.read<CropCubit>();

    if (cropCubit.state.crops.isEmpty) {
      await cropCubit.getCrops();
    }

    if (cropCubit.state.crops.isEmpty) {
      return;
    }

    final int cropId = cropCubit.state.crops.first.id;

    await viewModel.sendMessage(
      cropId: cropId,
      message: message,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final TextTheme textTheme = TextTheme.of(context);

    return AnimatedBuilder(
      animation: viewModel,
      builder: (context, child) {
        final bool hasMessages = viewModel.messages.isNotEmpty;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (hasMessages) _buildChatHeader() else AiBotHeader(),
                const SizedBox(height: 20),
                Expanded(
                  child: hasMessages ? _buildMessages() : _buildIntro(),
                ),
                if (viewModel.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Something went wrong. Please try again.',
                      style: textTheme.titleSmall?.copyWith(
                        color: AppTheme.red,
                      ),
                    ),
                  ),
                AiBotInput(
                  controller: controller,
                  onSend: sendMessage,
                  isLoading: viewModel.isLoading,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildIntro() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // AiBotFeatureCard(
          //   text: 'Remembers what user said\nearlier in the conversation',
          // ),
          // const SizedBox(height: 12),
          // AiBotFeatureCard(
          //   text: 'Allows user to provide.\nfollow-up corrections With Ai',
          // ),
          // const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildMessages() {
    int itemCount = viewModel.messages.length;

    if (viewModel.isLoading) {
      itemCount++;
    }

    return ListView.separated(
      controller: scrollController,
      itemCount: itemCount,
      separatorBuilder: (context, index) {
        return const SizedBox(height: 12);
      },
      itemBuilder: (context, index) {
        if (index == viewModel.messages.length) {
          return AiBotLoading();
        }

        return AiBotMessageBubble(
          message: viewModel.messages[index],
        );
      },
    );
  }

  Widget _buildChatHeader() {
    return Row(
      children: [
        Image.asset(
          'assets/images/ai_bot.png',
          fit: BoxFit.contain,
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'HydroNex AI',
              style: TextTheme.of(context).titleMedium?.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.gery,
                  ),
            ),
            Text(
              '• Online',
              style: TextTheme.of(context).titleSmall?.copyWith(
                    color: AppTheme.liveGreen,
                  ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
