import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:learn_bloc/core/custom/colors.dart';
import 'package:learn_bloc/core/extensions/string_extensions.dart';
import 'package:learn_bloc/models/user_followers.dart';
import 'package:learn_bloc/models/user_model.dart';
import 'package:learn_bloc/products/user_info/cubits/cubit/user_following_cubit.dart';
import 'package:learn_bloc/products/user_info/cubits/user_followers_cubit/user_followers_cubit_cubit.dart';
import 'package:learn_bloc/products/user_info/cubits/user_info_cubit/user_info_cubit.dart';
import 'package:learn_bloc/products/user_repo/cubit/user_repo_cubit.dart';
import 'package:learn_bloc/products/user_repo/view/user_repo_view.dart';
import 'package:learn_bloc/widgets/custom_column/custom_column.dart';
import 'package:learn_bloc/widgets/error_state_widget/error_state_widget.dart';
import 'package:learn_bloc/widgets/loading_state_widget/loading_state_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UserInfoView extends StatelessWidget {
  const UserInfoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserInfoCubit(),
        ),
        BlocProvider(
          create: (context) => UserFollowersCubit(
            context.read<UserInfoCubit>().getUserName(),
          ),
        ),
        BlocProvider(
          create: (context) => UserFollowingCubit(
            context.read<UserInfoCubit>().getUserName(),
          ),
        ),
      ],
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

class _UserInfoArea extends StatelessWidget {
  final UserModel user;

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
          _UserEmail(user: user),
          _UserBlog(user: user),
          _UserTwitter(user: user),
          _UserCreatedAt(user: user),
          _UserUpdatedAt(user: user),
          const SizedBox(
            height: 10,
          ),
          _UserRepoAndGistCount(user: user),
          _UserShowReposButton(user: user),
          const _UserShowFollowingArea(),
          const _UserShowFollowersArea(),
        ],
      ),
    );
  }
}

class _UserShowFollowersArea extends StatelessWidget {
  const _UserShowFollowersArea();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserFollowersCubit, UserFollowersState>(
      builder: (context, state) {
        if (state is UserFollowersLoading) {
          return const LoadingState(
            height: 0.01,
          );
        } else if (state is UserFollowersError) {
          return ErrorState(message: state.message);
        } else if (state is UserFollowersLoaded) {
          return _UserFollowersArea(
            followers: state.userFollowers,
          );
        }
        return Container();
      },
    );
  }
}

class _UserShowFollowingArea extends StatelessWidget {
  const _UserShowFollowingArea();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserFollowingCubit, UserFollowingState>(
      builder: (context, state) {
        if (state is UserFollowingLoading) {
          return const LoadingState(
            height: 0.01,
          );
        } else if (state is UserFollowingError) {
          return ErrorState(message: state.message);
        } else if (state is UserFollowingLoaded) {
          return _UserFollowingArea(
            following: state.userFollowers,
          );
        }
        return Container();
      },
    );
  }
}

class _UserFollowingArea extends StatelessWidget {
  final List<UserFollowModel> following;
  const _UserFollowingArea({
    required this.following,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Following",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              "(${following.length})",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(5),
              bottomLeft: Radius.circular(5),
              bottomRight: Radius.circular(10),
            ),
            color: CustomColors.primaryColor,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(10),
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                for (var user in following)
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.read<UserInfoCubit>().getUserData(user: user.login);
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(5),
                                  bottomLeft: Radius.circular(5),
                                  bottomRight: Radius.circular(10),
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(user.avatarUrl),
                                ),
                              ),
                            ),
                            Text(
                              user.login.truncateWithEllipsis(4),
                              style: const TextStyle(
                                fontSize: 15,
                                color: CustomColors.onPrimaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
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

class _UserFollowersArea extends StatelessWidget {
  final List<UserFollowModel> followers;
  const _UserFollowersArea({
    required this.followers,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Followers",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              "(${followers.length})",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 450, // Bu değeri ihtiyacınıza göre ayarlayabilirsiniz
          child: ListView.builder(
            itemCount: followers.length,
            itemBuilder: (context, index) {
              var follower = followers[index];
              return Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.only(
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                      color: CustomColors.primaryColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 55,
                          height: 55,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5),
                            ),
                            image: DecorationImage(
                              image: NetworkImage(
                                follower.avatarUrl,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      follower.login,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        color: CustomColors.onPrimaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      follower.id.toString(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: CustomColors.onPrimaryColor.withOpacity(0.5),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          iconSize: 25,
                          onPressed: () async {
                            context.read<UserInfoCubit>().getUserData(user: follower.login);
                            context.read<UserFollowersCubit>().getUserFollowers(user: follower.login);
                          },
                          icon: const FaIcon(
                            FontAwesomeIcons.magnifyingGlass,
                            color: CustomColors.onPrimaryColor,
                          ),
                        ),
                        IconButton(
                          iconSize: 30,
                          onPressed: () async {
                            try {
                              final Uri url = Uri.parse(
                                follower.htmlUrl,
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
                          icon: const FaIcon(
                            FontAwesomeIcons.github,
                            color: CustomColors.onPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (index == followers.length - 1)
                    const SizedBox(
                      height: 250,
                    ),
                ],
              );
            },
          ),
        ),
      ],
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

class _UserCreatedAt extends StatelessWidget {
  final UserModel user;
  const _UserCreatedAt({
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return _RowIconTextWidget(
      icon: FontAwesomeIcons.calendarDays,
      text: "Joined at ${user.createdAt.day}/${user.createdAt.month}/${user.createdAt.year}\t${user.createdAt.hour}:${user.createdAt.minute}:${user.createdAt.second}",
    );
  }
}

class _UserUpdatedAt extends StatelessWidget {
  final UserModel user;
  const _UserUpdatedAt({
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return _RowIconTextWidget(
      icon: FontAwesomeIcons.calendarCheck,
      text: "Updated at ${user.updatedAt.day}/${user.updatedAt.month}/${user.updatedAt.year}\t${user.updatedAt.hour}:${user.updatedAt.minute}:${user.updatedAt.second}",
    );
  }
}

class _UserEmail extends StatelessWidget {
  final UserModel user;
  const _UserEmail({
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return user.email.isEmpty
        ? const SizedBox()
        : GestureDetector(
            onTap: () async {
              try {
                final Uri emailLaunchUri = Uri(scheme: 'mailto', path: user.email);
                launchUrlString(emailLaunchUri.toString());
              } on Exception {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Something went wrong"),
                  ),
                );
              }
            },
            child: _RowIconTextWidget(
              icon: FontAwesomeIcons.envelope,
              text: user.email,
            ),
          );
  }
}

class _UserRepoAndGistCount extends StatelessWidget {
  final UserModel user;
  const _UserRepoAndGistCount({
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}

class _UserProfilePictureAndInfo extends StatelessWidget {
  final UserModel user;
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
            child: SingleChildScrollView(
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
                          maxLines: 5,
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
        ),
      ],
    );
  }
}

class _UserLocation extends StatelessWidget {
  final UserModel user;
  const _UserLocation({
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return user.location.isNotEmpty
        ? _RowIconTextWidget(
            icon: FontAwesomeIcons.locationDot,
            text: user.location,
          )
        : const SizedBox();
  }
}

class _UserFollowers extends StatelessWidget {
  final UserModel user;
  const _UserFollowers({
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return _RowIconTextWidget(
      icon: FontAwesomeIcons.userGroup,
      text: "${user.followers} Followers · ${user.following} Following",
    );
  }
}

class _UserTwitter extends StatelessWidget {
  final UserModel user;
  const _UserTwitter({
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return user.twitterUsername.isEmpty
        ? const SizedBox()
        : _RowIconTextWidget(
            icon: FontAwesomeIcons.twitter,
            text: user.twitterUsername,
          );
  }
}

class _UserBlog extends StatelessWidget {
  final UserModel user;
  const _UserBlog({
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return user.blog.isEmpty
        ? const SizedBox()
        : _RowIconTextWidget(
            icon: FontAwesomeIcons.link,
            text: user.blog,
          );
  }
}

class _RowIconTextWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  const _RowIconTextWidget({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 20,
          child: FaIcon(
            icon,
            size: 16,
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Expanded(
          child: Text(
            text,
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

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          icon: const FaIcon(
            FontAwesomeIcons.github,
            color: Colors.white,
          ),
          label: const Text(
            "Show All Repos",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
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
        ),
      ],
    );
  }
}
