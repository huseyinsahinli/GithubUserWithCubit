import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:learn_bloc/core/custom/colors.dart';
import 'package:learn_bloc/products/user_repo/cubit/user_repo_cubit.dart';
import 'package:learn_bloc/products/widgets/error_state_widget/error_state_widget.dart';
import 'package:learn_bloc/products/widgets/loading_state_widget/loading_state_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class UserRepoView extends StatelessWidget {
  const UserRepoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.primaryColor,
        title: const Text(
          "User Reporitories",
          style: TextStyle(
            color: CustomColors.onPrimaryColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const FaIcon(
            FontAwesomeIcons.arrowLeft,
            color: CustomColors.onPrimaryColor,
          ),
        ),
      ),
      body: const SingleChildScrollView(
        child: _Body(),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserRepoCubit, UserRepoState>(
      builder: (context, state) {
        if (state is UserRepoLoading) {
          return const LoadingState();
        } else if (state is UserRepoError) {
          return ErrorState(message: state.message);
        } else if (state is UserRepoLoaded) {
          return Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              _RepoSearch(userRepoState: state),
              _UserRepoArea(userRepoState: state),
            ],
          );
        }
        return Container();
      },
    );
  }
}

class _RepoSearch extends StatelessWidget {
  final UserRepoLoaded userRepoState;
  const _RepoSearch({
    required this.userRepoState,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      child: TextFormField(
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        decoration: InputDecoration(
          isDense: true,
          constraints: const BoxConstraints(
            maxHeight: 50,
          ),
          hintText: "Search Repositories",
          prefixIcon: const Icon(
            Icons.search,
            size: 24,
            color: CustomColors.primaryColor,
          ),
          suffixIcon: context.read<UserRepoCubit>().searchController.text.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    context.read<UserRepoCubit>().searchController.clear();
                    context.read<UserRepoCubit>().searchRepo("");
                  },
                  child: const Icon(
                    FontAwesomeIcons.circleXmark,
                    size: 20,
                    color: CustomColors.primaryColor,
                  ),
                )
              : null,
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
            borderSide: BorderSide(
              width: 1,
              color: CustomColors.primaryColor,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
            borderSide: BorderSide(
              width: 1,
              color: CustomColors.primaryColor,
            ),
          ),
          labelText: "Search Repositories",
          labelStyle: const TextStyle(
            color: CustomColors.primaryColor,
          ),
        ),
        cursorColor: CustomColors.primaryColor,
        controller: context.read<UserRepoCubit>().searchController,
        onChanged: (value) {
          context.read<UserRepoCubit>().searchRepo(value);
        },
      ),
    );
  }
}

class _UserRepoArea extends StatelessWidget {
  final UserRepoLoaded userRepoState;
  const _UserRepoArea({
    required this.userRepoState,
  });

  @override
  Widget build(BuildContext context) {
    userRepoState.repos.sort((a, b) => b.stargazersCount?.compareTo(a.stargazersCount ?? 0) ?? 0);
    return SingleChildScrollView(
      child: Column(
        children: [
          if (userRepoState.repos.isNotEmpty)
            for (var repo in userRepoState.repos)
              GestureDetector(
                onTap: () async {
                  try {
                    final Uri url = Uri.parse(
                      repo.htmlUrl ?? "",
                    );
                    if (!await launchUrl(
                      url,
                      mode: LaunchMode.externalApplication,
                      webOnlyWindowName: "github",
                    )) {
                      throw "Can't open the link";
                    }
                  } on Exception {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Can't open the link"),
                      ),
                    );
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: CustomColors.primaryColor,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: repo.owner?.avatarUrl != null ? NetworkImage(repo.owner!.avatarUrl ?? "") : const NetworkImage(""),
                    ),
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            repo.name ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.star,
                              size: 15,
                              color: CustomColors.primaryColor,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              repo.stargazersCount.toString(),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(width: 7),
                            const FaIcon(
                              FontAwesomeIcons.codeBranch,
                              size: 15,
                              color: CustomColors.primaryColor,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              repo.forksCount.toString(),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          repo.description ?? "No Description",
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: CustomColors.primaryColor.withOpacity(0.8),
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Row(
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.eye,
                              size: 15,
                              color: CustomColors.primaryColor,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              repo.watchersCount.toString(),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(width: 7),
                            const FaIcon(
                              FontAwesomeIcons.code,
                              size: 15,
                              color: CustomColors.primaryColor,
                            ),
                            const SizedBox(width: 2),
                            Flexible(
                              child: Text(
                                repo.language ?? "No Language",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Row(
                          children: [
                            Flexible(
                              child: Text(
                                "View Repo In Github",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: CustomColors.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                            FaIcon(
                              FontAwesomeIcons.github,
                              size: 15,
                              color: CustomColors.primaryColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
          else
            const Center(
              child: Text(
                "No Repo Found",
                style: TextStyle(
                  color: CustomColors.primaryColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
