import 'package:aura/core/helpers/functions/show_snake_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aura/features/summary/presentation/manger/summary_cubit/summary_cubit.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:page_transition/page_transition.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:path_provider/path_provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/utils/assets.dart';
import '../../../../summary/presentation/views/summarize_view.dart';
import '../../../data/models/doc_model.dart';
import '../../../data/models/recent_doc_model.dart';

class RecentItem extends StatefulWidget {
  final Data doc;
  final RecentDocModel? docCache;
  const RecentItem({super.key, required this.doc, required this.docCache});

  @override
  State<RecentItem> createState() => _RecentItemState();
}

class _RecentItemState extends State<RecentItem> {
  bool isFinished = false;
  bool isProcessing = false; // Track if this specific item is being processed
  String? currentProcessingUrl; // Track which URL is being processed

  // Helper to download file from URL to temp directory
  Future<File> downloadFile(String url, String filename) async {
    final response = await http.get(Uri.parse(url));
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  @override
  void dispose() {
    // Clean up state when widget is disposed
    isProcessing = false;
    currentProcessingUrl = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SwipeActionCell(
      backgroundColor: Colors.transparent,
      key: ValueKey(widget.doc.document),
      trailingActions: [
        SwipeAction(
          title: "view".tr(),
          color: Theme.of(context).colorScheme.primary,
          icon: const Icon(IconlyLight.show, color: Colors.white),
          onTap: (handler) async {
            try {
              final result = await OpenFile.open(
                  widget.docCache?.path ?? widget.doc.document);
              if (result.type != ResultType.done) {
                String errorMessage = 'failed_to_open_file'.tr();

                // Provide more specific error messages based on the result type
                switch (result.type) {
                  case ResultType.noAppToOpen:
                    errorMessage = 'no_app_to_open_file'.tr();
                    break;
                  case ResultType.permissionDenied:
                    errorMessage = 'permission_denied'.tr();
                    break;
                  case ResultType.fileNotFound:
                    errorMessage = 'file_not_found'.tr();
                    break;
                  case ResultType.error:
                    errorMessage = 'error_opening_file'.tr();
                    break;
                  default:
                    errorMessage = 'failed_to_open_file'.tr();
                }

                showSnackBar(
                  context,
                  errorMessage,
                  Colors.red,
                );
              }
            } catch (e) {
              // Handle any unexpected exceptions
              showSnackBar(
                context,
                'unexpected_error_opening_file'.tr(),
                Colors.red,
              );
            }
            handler(false);
          },
        ),
      ],
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: const Border.fromBorderSide(
            BorderSide(color: Colors.grey),
          ),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 40.w,
                height: 40.h,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: Theme.of(context).colorScheme.surface,
                ),
                child: Icon(
                  IconlyLight.document,
                  color: Theme.of(context).iconTheme.color,
                  size: 28.sp,
                ),
              ),
              title: Text(
                widget.docCache?.name ?? 'Unkown Document',
                style: GoogleFonts.sora(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              subtitle: Text(
                widget.docCache != null
                    ? '${'uploaded_on'.tr()}${widget.docCache?.uploadDate.day}/${widget.docCache?.uploadDate.month}/${widget.docCache?.uploadDate.year}'
                    : '${'uploaded_on'.tr()}Unknown',
                style: GoogleFonts.mali(
                  fontSize: 13.sp,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 8),
            BlocListener<SummaryCubit, SummaryState>(
              listener: (context, state) {
                // Only respond if this specific document is being processed
                if (isProcessing &&
                    currentProcessingUrl == widget.doc.document &&
                    mounted) {
                  if (state is SummarySuccess) {
                    // Check if this summary belongs to the current document
                    if (state.documentId == currentProcessingUrl && mounted) {
                      Navigator.of(context).push(
                        PageTransition(
                          type: PageTransitionType.fade,
                          child: SummarizeView(
                              summary: state.summary,
                              docName: widget.docCache?.name ??
                                  widget.doc.documentName,
                              uploadDate: widget.docCache != null
                                  ? '${widget.docCache?.uploadDate.day}/${widget.docCache?.uploadDate.month}/${widget.docCache?.uploadDate.year}'
                                  : 'Unknown'),
                        ),
                      );
                      setState(() {
                        isProcessing = false;
                        isFinished = false;
                        currentProcessingUrl = null;
                      });
                    }
                  } else if (state is SummaryFailure) {
                    // Check if this failure belongs to the current document
                    if (state.documentId == currentProcessingUrl && mounted) {
                      showSnackBar(context, state.error, Colors.red);
                      setState(() {
                        isProcessing = false;
                        isFinished = false;
                        currentProcessingUrl = null;
                      });
                    }
                  }
                }
              },
              child: isProcessing
                  ? Container(
                      width: 32.w,
                      height: 32.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      child: Center(
                        child: LoadingAnimationWidget.inkDrop(
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 24.w,
                        ),
                      ),
                    )
                  : SwipeButton.expand(
                      activeTrackColor: Theme.of(context).colorScheme.primary,
                      activeThumbColor: Theme.of(context).colorScheme.onPrimary,
                      thumb: Image.asset(Assets.assetsRobot2),
                      child: Center(
                        child: Text(
                          'swipe_to_summarize'.tr(),
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontFamily: GoogleFonts.sora().fontFamily,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onSwipe: () async {
                        if (!isProcessing) {
                          final cubit = context.read<SummaryCubit>();
                          final url = widget.doc.document;
                          final filename = url.split('/').last;

                          // Set processing state first to prevent multiple swipes
                          setState(() {
                            isProcessing = true;
                            currentProcessingUrl = url;
                          });

                          try {
                            final file = await downloadFile(url, filename);
                            // Double check that we're still processing the same document
                            if (currentProcessingUrl == url && mounted) {
                              cubit.summarizeDoc(file, documentId: url);
                            } else {
                              // Document changed, reset state
                              setState(() {
                                isProcessing = false;
                                currentProcessingUrl = null;
                              });
                            }
                          } catch (e) {
                            showSnackBar(context,
                                'failed_to_download_file'.tr(), Colors.red);
                            setState(() {
                              isProcessing = false;
                              currentProcessingUrl = null;
                            });
                          }
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
