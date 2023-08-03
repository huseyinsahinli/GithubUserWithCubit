import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:learn_bloc/core/custom/colors.dart';
import 'package:learn_bloc/models/user_model.dart';
import 'package:learn_bloc/products/user_info/cubit/user_info_cubit.dart';
import 'package:learn_bloc/products/user_repo/cubit/user_repo_cubit.dart';
import 'package:learn_bloc/products/user_repo/view/user_repo_view.dart';
import 'package:learn_bloc/products/widgets/custom_column/custom_column.dart';
import 'package:learn_bloc/products/widgets/error_state_widget/error_state_widget.dart';
import 'package:learn_bloc/products/widgets/loading_state_widget/loading_state_widget.dart';

class UserInfoView extends StatelessWidget {
  const UserInfoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserInfoCubit(),
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
          leading: BlocBuilder<UserInfoCubit, UserInfoState>(
            builder: (context, state) {
              return IconButton(
                onPressed: () => context.read<UserInfoCubit>().clearUserData(),
                icon: FaIcon(
                  state is UserError
                      ? FontAwesomeIcons.xmark
                      : state is UserInitial
                          ? null
                          : FontAwesomeIcons.arrowLeft,
                  color: CustomColors.onPrimaryColor,
                ),
              );
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
    return BlocBuilder<UserInfoCubit, UserInfoState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return const LoadingState();
        } else if (state is UserError) {
          return ErrorState(message: state.message);
        } else if (state is UserLoaded) {
          return _UserInfoArea(user: state.user);
        }

        return const _GetUserDataArea();
      },
    );
  }
}

class _GetUserDataArea extends StatelessWidget {
  const _GetUserDataArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Image.network(
              "https://cdn-icons-png.flaticon.com/512/25/25231.png",
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
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
            controller: context.read<UserInfoCubit>().userNameController,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              backgroundColor: CustomColors.primaryColor,
            ),
            onPressed: () {
              if (context.read<UserInfoCubit>().userNameController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please enter username"),
                  ),
                );
                return;
              }
              context.read<UserInfoCubit>().getUserData();
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
      child: CustomColumn(
        spaceHeight: 5,
        children: [
          _UserProfilePictureAndInfo(user: user),
          _UserLocation(user: user),
          _UserFollowers(user: user),
          _UserBlog(user: user),
          _UserTwitter(user: user),
          _UserShowReposButton(user: user)
        ],
      ),
    );
  }
}

class _UserProfilePictureAndInfo extends StatelessWidget {
  final User user;
  const _UserProfilePictureAndInfo({
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            image: user.avatarUrl.isNotEmpty
                ? DecorationImage(
                    image: NetworkImage(user.avatarUrl),
                    fit: BoxFit.cover,
                  )
                : null,
            color: user.avatarUrl.isEmpty ? CustomColors.primaryColor : null,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(10),
            ),
          ),
          child: user.avatarUrl.isEmpty
              ? const Icon(
                  FontAwesomeIcons.user,
                  color: CustomColors.onPrimaryColor,
                  size: 50,
                )
              : null,
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
    );
  }
}

class _UserLocation extends StatelessWidget {
  final User user;
  const _UserLocation({
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return user.location.isNotEmpty
        ? Row(
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
          )
        : const SizedBox();
  }
}

class _UserFollowers extends StatelessWidget {
  final User user;
  const _UserFollowers({
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}

class _UserTwitter extends StatelessWidget {
  final User user;
  const _UserTwitter({
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return user.twitterUsername.isEmpty
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
          );
  }
}

class _UserBlog extends StatelessWidget {
  final User user;
  const _UserBlog({
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return user.blog.isEmpty
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
          );
  }
}

class _UserShowReposButton extends StatelessWidget {
  const _UserShowReposButton({
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            backgroundColor: CustomColors.primaryColor,
          ),
          onPressed: () {
            //TODO: I don't know if this is the best way to do this
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => UserRepoCubit(user.login),
                  child: const UserRepoView(),
                ),
              ),
            );
          },
          child: const Text(
            "Show Repos",
          ),
        ),
      ],
    );
  }
}
