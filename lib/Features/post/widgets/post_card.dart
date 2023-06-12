import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoapp/constants/assets_constant.dart';
import 'package:todoapp/Features/auth/controller/auth_controller.dart';
import 'package:todoapp/Features/post/widgets/carousel_image.dart';
import 'package:todoapp/Features/post/widgets/hashtag_text.dart';
import 'package:todoapp/Features/post/widgets/post_icon_button.dart';
import 'package:todoapp/common/common.dart';
import 'package:todoapp/core/enums/post_type.dart';
import 'package:todoapp/models/post_model.dart';
import 'package:todoapp/theme/pallet.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostCard extends ConsumerWidget {
  final Post post;
  const PostCard({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userDetailsProvider(post.uid)).when(
          data: (user) {
            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(user.profilePic),
                        radius: 25,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Reshare
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 5),
                                child: Text(
                                  user.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 19,
                                  ),
                                ),
                              ),
                              Text(
                                '@${user.name} . ${timeago.format(
                                  post.postedAt,
                                  locale: 'en_short',
                                )}',
                                style: const TextStyle(
                                  color: Pallete.greyColor,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),

                          //repliedto
                          HashtagText(text: post.text),
                          if (post.postType == PostType.image)
                            CarouselImage(imageLinks: post.imageLinks),
                          if (post.link.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            AnyLinkPreview(
                                displayDirection:
                                    UIDirection.uiDirectionHorizontal,
                                link: 'https://${post.link}'),
                          ],
                          Container(
                            margin: const EdgeInsets.only(
                              top: 10,
                              right: 20,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                PostIconButton(
                                  pathName: AssetsConstants.viewicon,
                                  text: (post.commentIds.length +
                                          post.reshareCount +
                                          post.likes.length)
                                      .toString(),
                                  onTap: () {},
                                ),
                                PostIconButton(
                                  pathName: AssetsConstants.commenticon,
                                  text: post.commentIds.length.toString(),
                                  onTap: () {},
                                ),
                                PostIconButton(
                                  pathName: AssetsConstants.likeoutlinedicon,
                                  text: post.likes.length.toString(),
                                  onTap: () {},
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.share_outlined,
                                    size: 25,
                                    color: Pallete.greyColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 1),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(color: Pallete.greyColor),
              ],
            );
          },
          error: (error, stackTrace) => ErrorText(
            error: error.toString(),
          ),
          loading: () => const Loader(),
        );
  }
}
