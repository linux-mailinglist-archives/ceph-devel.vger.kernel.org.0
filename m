Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3811392175
	for <lists+ceph-devel@lfdr.de>; Mon, 19 Aug 2019 12:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbfHSKfo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 19 Aug 2019 06:35:44 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:45748 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727351AbfHSKfm (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 19 Aug 2019 06:35:42 -0400
Received: by mail-qt1-f194.google.com with SMTP id k13so1271135qtm.12
        for <ceph-devel@vger.kernel.org>; Mon, 19 Aug 2019 03:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y8qMN26MjvaLEZni9owPQ9aZL4m1qrFPwYQGXicbmZg=;
        b=fbeRs2fNJRjqKpLlxUimlGyO4W6PGBNhewch3DUSnlDWsD+l89AUVFZ+jZyKfT/uQc
         aH+f7/E8m4G0k9RlwLgFJZtneQPc13MKCIHueNNGYhIGXZX6a3PPHZOIs1gav8mjTmdF
         I20Lu/4HdjZSpj87sNDy6JeyihHyNNJk2pKdDqHgwdNSjMRTkTtz27iMzq8ScNg2XS9i
         khFfEw7+QX8x40jrohmAhuIBLdNOHFqRmsb0IKnQBm0J3JGlqkVbLO6Kn9uxP9ee8P5j
         G2q7r/FiMAfsms5DbFdjXQB2xqq/OHy/mZaZH3hqAkbOF7B89gnvomN23oWpXPGPGBy6
         1scQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y8qMN26MjvaLEZni9owPQ9aZL4m1qrFPwYQGXicbmZg=;
        b=hBjnHHCOve1Oj+Uyl9Lz6iFtI+o1jGPHyf2InGsBguc4LTL1u1+F5tobqNquEqtkKk
         G4b0rw1sfyg93D91uTAg7kHKWXenrCltj1fCOATFE1ISQneIftSr+nnx/Zl3SpY7O0ve
         2kCKk1C1N6qlfpF4i7jRRtZvyLJB+VcJGndWxhP0OsZxU6qPI5L6/oAPkODDl9QD49yV
         0q9e0PSu/0YiYUJwEYUSbGNDlrA16PDZq3o4G4bimual1QOXXmKhtF3H2RD6Sk9avrJY
         S0okBCqKQ75DUpWo8dugiGYqw4E/Bkf6T6Q7j49xRhfUxOvvty1ZitZsk4ZhYBs8aIEH
         di8g==
X-Gm-Message-State: APjAAAWmDvTt5mQHSRMpfk8lzYOgaDpAx6dPwrsmqnZWtPVVjWeC8jP0
        NgxQSUlAloV5L4L6wg8VUzDzs0q5DAPO3+UiJXRfRkSN
X-Google-Smtp-Source: APXvYqxjKteTllYn4kO1VstrWLuOv+sv8UITH9aptuVoBc1pealQcj2p4vVt5L6bVJMUM+O0A+/Xq51s/oFuzTnWgL0=
X-Received: by 2002:a05:6638:3af:: with SMTP id z15mr17893008jap.39.1566210940142;
 Mon, 19 Aug 2019 03:35:40 -0700 (PDT)
MIME-Version: 1.0
References: <1564393377-28949-1-git-send-email-dongsheng.yang@easystack.cn> <1564393377-28949-14-git-send-email-dongsheng.yang@easystack.cn>
In-Reply-To: <1564393377-28949-14-git-send-email-dongsheng.yang@easystack.cn>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 19 Aug 2019 12:38:39 +0200
Message-ID: <CAOi1vP9X2b0X4OE-ukAr6rKgneBuT1rg0g8P=CgOmnRAX4-oDg@mail.gmail.com>
Subject: Re: [PATCH v3 13/15] rbd: append journal event in image request state machine
To:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Cc:     Jason Dillaman <jdillama@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jul 29, 2019 at 11:43 AM Dongsheng Yang
<dongsheng.yang@easystack.cn> wrote:
>
> Introduce RBD_IMG_APPEND_JOURNAL and __RBD_IMG_APPEND_JOURNAL in rbd_img_state.
> When a image request after RBD_IMG_EXCLUSIVE_LOCK, it will go into __RBD_IMG_APPEND_JOURNAL
> and then RBD_IMG_APPEND_JOURNAL. after that, it then would go into __RBD_IMG_OBJECT_REQUESTS.
>
> That means, we will append journal event before send the data object request for image request.
>
> Signed-off-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
> ---
>  drivers/block/rbd.c | 250 +++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 249 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 86008f2..89bc7b3 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -121,6 +121,7 @@ static int atomic_dec_return_safe(atomic_t *v)
>  #define RBD_FEATURE_OBJECT_MAP         (1ULL<<3)
>  #define RBD_FEATURE_FAST_DIFF          (1ULL<<4)
>  #define RBD_FEATURE_DEEP_FLATTEN       (1ULL<<5)
> +#define RBD_FEATURE_JOURNALING          (1ULL<<6)
>  #define RBD_FEATURE_DATA_POOL          (1ULL<<7)
>  #define RBD_FEATURE_OPERATIONS         (1ULL<<8)
>
> @@ -327,6 +328,8 @@ enum img_req_flags {
>  enum rbd_img_state {
>         RBD_IMG_START = 1,
>         RBD_IMG_EXCLUSIVE_LOCK,
> +       __RBD_IMG_APPEND_JOURNAL,
> +       RBD_IMG_APPEND_JOURNAL,
>         __RBD_IMG_OBJECT_REQUESTS,
>         RBD_IMG_OBJECT_REQUESTS,
>  };
> @@ -355,6 +358,7 @@ struct rbd_img_request {
>         int                     work_result;
>
>         struct completion       completion;
> +       uint64_t                journaler_commit_tid;
>
>         struct kref             kref;
>  };
> @@ -448,6 +452,8 @@ struct rbd_device {
>         atomic_t                parent_ref;
>         struct rbd_device       *parent;
>
> +       struct rbd_journal      *journal;
> +
>         /* Block layer tags. */
>         struct blk_mq_tag_set   tag_set;
>
> @@ -3650,6 +3656,19 @@ static void rbd_img_object_requests(struct rbd_img_request *img_req)
>         }
>  }
>
> +static bool rbd_img_need_journal(struct rbd_img_request *img_req) {
> +       struct rbd_device *rbd_dev = img_req->rbd_dev;
> +
> +       if (img_req->op_type == OBJ_OP_READ)
> +               return false;
> +
> +       if (!(rbd_dev->header.features & RBD_FEATURE_JOURNALING))
> +               return false;
> +
> +       return true;
> +}
> +
> +static void rbd_img_journal_append(struct rbd_img_request *img_req);
>  static bool rbd_img_advance(struct rbd_img_request *img_req, int *result)
>  {
>         struct rbd_device *rbd_dev = img_req->rbd_dev;
> @@ -3676,6 +3695,27 @@ static bool rbd_img_advance(struct rbd_img_request *img_req, int *result)
>                 rbd_assert(!need_exclusive_lock(img_req) ||
>                            __rbd_is_lock_owner(rbd_dev));
>
> +               if (!rbd_img_need_journal(img_req)) {
> +                       img_req->state = RBD_IMG_APPEND_JOURNAL;
> +                       goto again;
> +               }
> +
> +               rbd_img_journal_append(img_req);
> +               if (!img_req->pending.num_pending) {
> +                       *result = img_req->pending.result;
> +                       img_req->state = RBD_IMG_OBJECT_REQUESTS;
> +                       goto again;
> +               }
> +               img_req->state = __RBD_IMG_APPEND_JOURNAL;
> +               return false;
> +       case __RBD_IMG_APPEND_JOURNAL:
> +               if (!pending_result_dec(&img_req->pending, result))
> +                       return false;
> +               /* fall through */
> +       case RBD_IMG_APPEND_JOURNAL:
> +               if (*result)
> +                       return true;
> +
>                 rbd_img_object_requests(img_req);
>                 if (!img_req->pending.num_pending) {
>                         *result = img_req->pending.result;
> @@ -3744,9 +3784,15 @@ static void rbd_img_handle_request(struct rbd_img_request *img_req, int result)
>         } else {
>                 struct request *rq = img_req->rq;
>
> +               if (!result && img_req->journaler_commit_tid) {
> +                       ceph_journaler_client_committed(img_req->rbd_dev->journal->journaler,
> +                                                       img_req->journaler_commit_tid);
> +               }
> +
>                 complete_all(&img_req->completion);
>                 rbd_img_request_put(img_req);
> -               blk_mq_end_request(rq, errno_to_blk_status(result));
> +               if (rq)
> +                       blk_mq_end_request(rq, errno_to_blk_status(result));
>         }
>  }
>
> @@ -6927,6 +6973,208 @@ static int rbd_dev_header_name(struct rbd_device *rbd_dev)
>         return ret;
>  }
>
> +enum rbd_journal_event_type {
> +  EVENT_TYPE_AIO_DISCARD           = 0,
> +  EVENT_TYPE_AIO_WRITE             = 1,
> +  EVENT_TYPE_AIO_FLUSH             = 2,
> +  EVENT_TYPE_OP_FINISH             = 3,
> +  EVENT_TYPE_SNAP_CREATE           = 4,
> +  EVENT_TYPE_SNAP_REMOVE           = 5,
> +  EVENT_TYPE_SNAP_RENAME           = 6,
> +  EVENT_TYPE_SNAP_PROTECT          = 7,
> +  EVENT_TYPE_SNAP_UNPROTECT        = 8,
> +  EVENT_TYPE_SNAP_ROLLBACK         = 9,
> +  EVENT_TYPE_RENAME                = 10,
> +  EVENT_TYPE_RESIZE                = 11,
> +  EVENT_TYPE_FLATTEN               = 12,
> +  EVENT_TYPE_DEMOTE_PROMOTE        = 13,
> +  EVENT_TYPE_SNAP_LIMIT            = 14,
> +  EVENT_TYPE_UPDATE_FEATURES       = 15,
> +  EVENT_TYPE_METADATA_SET          = 16,
> +  EVENT_TYPE_METADATA_REMOVE       = 17,
> +  EVENT_TYPE_AIO_WRITESAME         = 18,
> +  EVENT_TYPE_AIO_COMPARE_AND_WRITE = 19,
> +};
> +
> +
> +// RBD_EVENT_FIXED_SIZE(10 = CEPH_ENCODING_START_BLK_LEN(6) + EVENT_TYPE(4))
> +static const uint32_t RBD_EVENT_FIXED_SIZE = 10;
> +
> +static struct bio_vec *setup_write_bvecs(void *buf, u64 offset, u64 length)
> +{
> +       u32 i;
> +       struct bio_vec *bvecs;
> +       u32 bvec_count;
> +
> +       bvec_count = calc_pages_for(offset, length);
> +       bvecs = kcalloc(bvec_count, sizeof(*bvecs), GFP_NOIO);
> +       if (!bvecs)
> +               goto err;
> +
> +       offset = offset % PAGE_SIZE;
> +       for (i = 0; i < bvec_count; i++) {
> +               unsigned int len = min(length, (u64)PAGE_SIZE - offset);
> +
> +               bvecs[i].bv_page = alloc_page(GFP_NOIO);
> +               if (!bvecs[i].bv_page)
> +                       goto free_bvecs;
> +
> +               bvecs[i].bv_offset = offset;
> +               bvecs[i].bv_len = len;
> +               memcpy(page_address(bvecs[i].bv_page) + bvecs[i].bv_offset, buf, bvecs[i].bv_len);
> +               length -= len;
> +               buf += len;
> +               offset = 0;
> +       }
> +
> +       rbd_assert(!length);
> +
> +       return bvecs;
> +
> +free_bvecs:
> +err:
> +       return NULL;
> +}
> +
> +static void rbd_journal_callback(struct ceph_journaler_ctx *journaler_ctx)
> +{
> +       struct rbd_img_request *img_req = journaler_ctx->priv;
> +       int result = journaler_ctx->result;
> +
> +       ceph_journaler_ctx_put(journaler_ctx);
> +       rbd_img_handle_request(img_req, result);
> +}
> +
> +static void img_journal_append_write_event(struct rbd_img_request *img_req)
> +{
> +       struct rbd_journal *journal = img_req->rbd_dev->journal;
> +       struct ceph_journaler_ctx *journaler_ctx;
> +       u64 offset = (u64)blk_rq_pos(img_req->rq) << SECTOR_SHIFT;
> +       u64 length = blk_rq_bytes(img_req->rq);
> +       struct bio *bio = img_req->rq->bio;
> +       uint64_t prefix_len = RBD_EVENT_FIXED_SIZE + 20;
> +       uint64_t max_append_size = ceph_journaler_get_max_append_size(journal->journaler) - prefix_len;
> +       uint64_t append_size = min(max_append_size, length);
> +       uint64_t bio_offset = 0;
> +       void *p;
> +       int ret;
> +
> +       rbd_assert(!img_req->pending.result && !img_req->pending.num_pending);
> +
> +       while (length > 0) {
> +               journaler_ctx = ceph_journaler_ctx_alloc();
> +               if (!journaler_ctx) {
> +                       img_req->pending.result = -ENOMEM;
> +                       return;
> +               }
> +
> +               journaler_ctx->bio_iter.bio = bio;
> +               journaler_ctx->bio_iter.iter = bio->bi_iter;
> +
> +               ceph_bio_iter_advance(&journaler_ctx->bio_iter, bio_offset);
> +               append_size = min(max_append_size, length);
> +               journaler_ctx->bio_len = append_size;
> +               bio_offset += append_size;
> +               length -= append_size;
> +
> +               // RBD_EVENT_FIXED_SIZE + offset(8) + length(8) + string_len(4) = 30
> +               journaler_ctx->prefix_len = prefix_len;
> +               journaler_ctx->prefix_offset = PAGE_SIZE - journaler_ctx->prefix_len;
> +
> +               p = page_address(journaler_ctx->prefix_page) + journaler_ctx->prefix_offset;
> +
> +               ceph_start_encoding(&p, 1, 1, journaler_ctx->prefix_len + journaler_ctx->bio_len - 6);
> +
> +               ceph_encode_32(&p, EVENT_TYPE_AIO_WRITE);
> +
> +               ceph_encode_64(&p, offset);

Looks like this is encoding the same offset for all append chunks?
This, coupled with always checksumming the entire bio, makes me think
that this code path hasn't been tested.

> +               ceph_encode_64(&p, append_size);
> +
> +               // first part of ceph_encode_string();
> +               ceph_encode_32(&p, journaler_ctx->bio_len);
> +
> +               journaler_ctx->priv = img_req;
> +               journaler_ctx->callback = rbd_journal_callback;
> +
> +               ret = ceph_journaler_append(journal->journaler, journal->tag_tid,
> +                                           journaler_ctx);
> +               if (ret) {
> +                       ceph_journaler_ctx_put(journaler_ctx);
> +                       img_req->pending.result = ret;
> +                       return;
> +               }
> +
> +               rbd_assert(!ret);

Bogus assert.

> +               img_req->pending.num_pending++;
> +               img_req->journaler_commit_tid = journaler_ctx->commit_tid;
> +       }
> +}
> +
> +static void img_journal_append_discard_event(struct rbd_img_request *img_req)
> +{
> +       struct rbd_journal *journal = img_req->rbd_dev->journal;
> +       struct ceph_journaler_ctx *journaler_ctx;
> +       u64 offset = (u64)blk_rq_pos(img_req->rq) << SECTOR_SHIFT;
> +       u64 length = blk_rq_bytes(img_req->rq);
> +       struct bio *bio = img_req->rq->bio;
> +       void *p;
> +       int ret;
> +
> +       rbd_assert(!img_req->pending.result && !img_req->pending.num_pending);

Move this assert to rbd_img_journal_append() to avoid duplicating it
for write event and for discard event.

> +
> +       journaler_ctx = ceph_journaler_ctx_alloc();
> +       if (!journaler_ctx) {
> +               img_req->pending.result = -ENOMEM;
> +               return;
> +       }
> +
> +       journaler_ctx->bio_iter.bio = bio;
> +       journaler_ctx->bio_iter.iter = bio->bi_iter;
> +       journaler_ctx->bio_len = 0;
> +
> +       // RBD_EVENT_FIXED_SIZE + offset(8) + length(8) = 26
> +       journaler_ctx->prefix_len = RBD_EVENT_FIXED_SIZE + 16;
> +       journaler_ctx->prefix_offset = PAGE_SIZE - journaler_ctx->prefix_len;
> +
> +       p = page_address(journaler_ctx->prefix_page) + journaler_ctx->prefix_offset;
> +
> +       ceph_start_encoding(&p, 1, 1, journaler_ctx->prefix_len + journaler_ctx->bio_len - 6);
> +
> +       ceph_encode_32(&p, EVENT_TYPE_AIO_DISCARD);
> +
> +       ceph_encode_64(&p, offset);
> +       ceph_encode_64(&p, length);
> +
> +       journaler_ctx->priv = img_req;
> +       journaler_ctx->callback = rbd_journal_callback;
> +
> +       ret = ceph_journaler_append(journal->journaler, journal->tag_tid,
> +                                   journaler_ctx);
> +       if (ret) {
> +               ceph_journaler_ctx_put(journaler_ctx);
> +               img_req->pending.result = ret;
> +               return;
> +       }
> +
> +       rbd_assert(!ret);

Bogus assert.

> +       img_req->pending.num_pending++;
> +       img_req->journaler_commit_tid = journaler_ctx->commit_tid;
> +}
> +
> +static void rbd_img_journal_append(struct rbd_img_request *img_req)
> +{
> +       switch (img_req->op_type) {
> +       case OBJ_OP_WRITE:
> +               img_journal_append_write_event(img_req);
> +               break;
> +       case OBJ_OP_DISCARD:
> +               img_journal_append_discard_event(img_req);
> +               break;
> +       default:
> +               img_req->pending.result = -ENOTSUPP;

What about zeroouts?

Thanks,

                Ilya
