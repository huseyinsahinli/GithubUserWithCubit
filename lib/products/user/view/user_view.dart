import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:learn_bloc/core/custom/colors.dart';
import 'package:learn_bloc/models/user_model.dart';
import 'package:learn_bloc/products/user/cubit/user_cubit.dart';

class UserView extends StatelessWidget {
  const UserView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserCubit(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColors.primaryColor,
          title: const Text(
            "Github Stalker",
            style: TextStyle(
              color: CustomColors.onPrimaryColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          leading: BlocBuilder<UserCubit, UserState>(
            builder: (context, state) {
              if (state is UserLoaded) {
                return IconButton(
                  onPressed: () => context.read<UserCubit>().clearUserData(),
                  icon: const FaIcon(
                    FontAwesomeIcons.arrowLeft,
                    color: CustomColors.onPrimaryColor,
                  ),
                );
              } else if (state is UserError) {
                return IconButton(
                  onPressed: () => context.read<UserCubit>().clearUserData(),
                  icon: const FaIcon(
                    FontAwesomeIcons.xmark,
                    color: CustomColors.onPrimaryColor,
                  ),
                );
              }
              return Container();
            },
          ),
        ),
        body: const SingleChildScrollView(
          child: _Body(),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is UserError) {
          return _ErrorState(state: state);
        } else if (state is UserLoaded) {
          return _UserInfoArea(user: state.user);
        } else if (state is UserLoading) {
          return const _LoadingState();
        }
        return const _GetDataArea();
      },
    );
  }
}

class _ErrorState extends StatelessWidget {
  final UserError state;

  const _ErrorState({required this.state});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        state.message,
        style: const TextStyle(
          color: CustomColors.primaryColor,
        ),
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
        ),
        const Center(
          child: CircularProgressIndicator(
            color: CustomColors.primaryColor,
          ),
        ),
      ],
    );
  }
}

class _GetDataArea extends StatelessWidget {
  const _GetDataArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              hintText: "Enter Github Username",
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                borderSide: BorderSide(
                  color: CustomColors.primaryColor,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                borderSide: BorderSide(
                  color: CustomColors.primaryColor,
                ),
              ),
              labelText: "Username",
              labelStyle: TextStyle(
                color: CustomColors.primaryColor,
              ),
            ),
            cursorColor: CustomColors.primaryColor,
            controller: context.read<UserCubit>().userNameController,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              backgroundColor: CustomColors.primaryColor,
            ),
            onPressed: () {
              context.read<UserCubit>().getUserData();
            },
            child: const Text(
              "Stalk",
              style: TextStyle(
                color: CustomColors.onPrimaryColor,
                fontSize: 17,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UserInfoArea extends StatelessWidget {
  final User user;

  const _UserInfoArea({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(user.avatarUrl),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(25),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                user.name,
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                user.login,
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                user.bio,
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const FaIcon(
                  FontAwesomeIcons.userGroup,
                  size: 16,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    "${user.followers} Followers · ${user.following} Following",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const FaIcon(
                  FontAwesomeIcons.locationDot,
                  size: 16,
                ),
                const SizedBox(width: 5),
                Text(
                  user.location,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            user.blog.isEmpty
                ? const SizedBox()
                : Row(
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.link,
                        size: 16,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          user.blog,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
            const SizedBox(height: 5),
            user.twitterUsername.isEmpty
                ? const SizedBox()
                : Row(
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.twitter,
                        size: 16,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          user.twitterUsername,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
            const SizedBox(height: 5),
            user.company.isNotEmpty
                ? Row(
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.building,
                        size: 16,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          user.company,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox(
                    height: 10,
                  ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      user.publicRepos.toString(),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Text(
                      "Repositories",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      user.publicGists.toString(),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Text(
                      "Gists",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ));
  }
}
