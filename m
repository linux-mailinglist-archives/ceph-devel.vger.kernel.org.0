Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6BF69C777
	for <lists+ceph-devel@lfdr.de>; Mon, 26 Aug 2019 04:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729366AbfHZCyz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 25 Aug 2019 22:54:55 -0400
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:20729 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729179AbfHZCyz (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 25 Aug 2019 22:54:55 -0400
Received: from yds-pc.domain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowABnhGTPSWNd+t18AQ--.19S2;
        Mon, 26 Aug 2019 10:54:07 +0800 (CST)
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: Re: [PATCH v3 13/15] rbd: append journal event in image request state
 machine
To:     Ilya Dryomov <idryomov@gmail.com>
References: <1564393377-28949-1-git-send-email-dongsheng.yang@easystack.cn>
 <1564393377-28949-14-git-send-email-dongsheng.yang@easystack.cn>
 <CAOi1vP9X2b0X4OE-ukAr6rKgneBuT1rg0g8P=CgOmnRAX4-oDg@mail.gmail.com>
Cc:     Jason Dillaman <jdillama@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Message-ID: <5D6349CF.4020609@easystack.cn>
Date:   Mon, 26 Aug 2019 10:54:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.0
MIME-Version: 1.0
In-Reply-To: <CAOi1vP9X2b0X4OE-ukAr6rKgneBuT1rg0g8P=CgOmnRAX4-oDg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: u+CowABnhGTPSWNd+t18AQ--.19S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3KrykXrWkZw1fGF1UXw1xAFb_yoWkCr4Upa
        y8XFs8CFWDur12yw1Fga1vqrWfX3y0kFW7WrWvkF9Ik3Z29rn3KFyUGrW5urW2qryxCrs7
        Cr4UZ3yxuw1UtrDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pRRT5PUUUUU=
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbiahodellZutzkEgAAsH
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org



On 08/19/2019 06:38 PM, Ilya Dryomov wrote:
> On Mon, Jul 29, 2019 at 11:43 AM Dongsheng Yang
> <dongsheng.yang@easystack.cn>  wrote:
>> Introduce RBD_IMG_APPEND_JOURNAL and __RBD_IMG_APPEND_JOURNAL in rbd_img_state.
>> When a image request after RBD_IMG_EXCLUSIVE_LOCK, it will go into __RBD_IMG_APPEND_JOURNAL
>> and then RBD_IMG_APPEND_JOURNAL. after that, it then would go into __RBD_IMG_OBJECT_REQUESTS.
>>
>> That means, we will append journal event before send the data object request for image request.
>>
>> Signed-off-by: Dongsheng Yang<dongsheng.yang@easystack.cn>
>> ---
>>   drivers/block/rbd.c | 250 +++++++++++++++++++++++++++++++++++++++++++++++++++-
>>   1 file changed, 249 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
>> index 86008f2..89bc7b3 100644
>> --- a/drivers/block/rbd.c
>> +++ b/drivers/block/rbd.c
>> @@ -121,6 +121,7 @@ static int atomic_dec_return_safe(atomic_t *v)
>>   #define RBD_FEATURE_OBJECT_MAP         (1ULL<<3)
>>   #define RBD_FEATURE_FAST_DIFF          (1ULL<<4)
>>   #define RBD_FEATURE_DEEP_FLATTEN       (1ULL<<5)
>> +#define RBD_FEATURE_JOURNALING          (1ULL<<6)
>>   #define RBD_FEATURE_DATA_POOL          (1ULL<<7)
>>   #define RBD_FEATURE_OPERATIONS         (1ULL<<8)
>>
>> @@ -327,6 +328,8 @@ enum img_req_flags {
>>   enum rbd_img_state {
>>          RBD_IMG_START = 1,
>>          RBD_IMG_EXCLUSIVE_LOCK,
>> +       __RBD_IMG_APPEND_JOURNAL,
>> +       RBD_IMG_APPEND_JOURNAL,
>>          __RBD_IMG_OBJECT_REQUESTS,
>>          RBD_IMG_OBJECT_REQUESTS,
>>   };
>> @@ -355,6 +358,7 @@ struct rbd_img_request {
>>          int                     work_result;
>>
>>          struct completion       completion;
>> +       uint64_t                journaler_commit_tid;
>>
>>          struct kref             kref;
>>   };
>> @@ -448,6 +452,8 @@ struct rbd_device {
>>          atomic_t                parent_ref;
>>          struct rbd_device       *parent;
>>
>> +       struct rbd_journal      *journal;
>> +
>>          /* Block layer tags. */
>>          struct blk_mq_tag_set   tag_set;
>>
>> @@ -3650,6 +3656,19 @@ static void rbd_img_object_requests(struct rbd_img_request *img_req)
>>          }
>>   }
>>
>> +static bool rbd_img_need_journal(struct rbd_img_request *img_req) {
>> +       struct rbd_device *rbd_dev = img_req->rbd_dev;
>> +
>> +       if (img_req->op_type == OBJ_OP_READ)
>> +               return false;
>> +
>> +       if (!(rbd_dev->header.features & RBD_FEATURE_JOURNALING))
>> +               return false;
>> +
>> +       return true;
>> +}
>> +
>> +static void rbd_img_journal_append(struct rbd_img_request *img_req);
>>   static bool rbd_img_advance(struct rbd_img_request *img_req, int *result)
>>   {
>>          struct rbd_device *rbd_dev = img_req->rbd_dev;
>> @@ -3676,6 +3695,27 @@ static bool rbd_img_advance(struct rbd_img_request *img_req, int *result)
>>                  rbd_assert(!need_exclusive_lock(img_req) ||
>>                             __rbd_is_lock_owner(rbd_dev));
>>
>> +               if (!rbd_img_need_journal(img_req)) {
>> +                       img_req->state = RBD_IMG_APPEND_JOURNAL;
>> +                       goto again;
>> +               }
>> +
>> +               rbd_img_journal_append(img_req);
>> +               if (!img_req->pending.num_pending) {
>> +                       *result = img_req->pending.result;
>> +                       img_req->state = RBD_IMG_OBJECT_REQUESTS;
>> +                       goto again;
>> +               }
>> +               img_req->state = __RBD_IMG_APPEND_JOURNAL;
>> +               return false;
>> +       case __RBD_IMG_APPEND_JOURNAL:
>> +               if (!pending_result_dec(&img_req->pending, result))
>> +                       return false;
>> +               /* fall through */
>> +       case RBD_IMG_APPEND_JOURNAL:
>> +               if (*result)
>> +                       return true;
>> +
>>                  rbd_img_object_requests(img_req);
>>                  if (!img_req->pending.num_pending) {
>>                          *result = img_req->pending.result;
>> @@ -3744,9 +3784,15 @@ static void rbd_img_handle_request(struct rbd_img_request *img_req, int result)
>>          } else {
>>                  struct request *rq = img_req->rq;
>>
>> +               if (!result && img_req->journaler_commit_tid) {
>> +                       ceph_journaler_client_committed(img_req->rbd_dev->journal->journaler,
>> +                                                       img_req->journaler_commit_tid);
>> +               }
>> +
>>                  complete_all(&img_req->completion);
>>                  rbd_img_request_put(img_req);
>> -               blk_mq_end_request(rq, errno_to_blk_status(result));
>> +               if (rq)
>> +                       blk_mq_end_request(rq, errno_to_blk_status(result));
>>          }
>>   }
>>
>> @@ -6927,6 +6973,208 @@ static int rbd_dev_header_name(struct rbd_device *rbd_dev)
>>          return ret;
>>   }
>>
>> +enum rbd_journal_event_type {
>> +  EVENT_TYPE_AIO_DISCARD           = 0,
>> +  EVENT_TYPE_AIO_WRITE             = 1,
>> +  EVENT_TYPE_AIO_FLUSH             = 2,
>> +  EVENT_TYPE_OP_FINISH             = 3,
>> +  EVENT_TYPE_SNAP_CREATE           = 4,
>> +  EVENT_TYPE_SNAP_REMOVE           = 5,
>> +  EVENT_TYPE_SNAP_RENAME           = 6,
>> +  EVENT_TYPE_SNAP_PROTECT          = 7,
>> +  EVENT_TYPE_SNAP_UNPROTECT        = 8,
>> +  EVENT_TYPE_SNAP_ROLLBACK         = 9,
>> +  EVENT_TYPE_RENAME                = 10,
>> +  EVENT_TYPE_RESIZE                = 11,
>> +  EVENT_TYPE_FLATTEN               = 12,
>> +  EVENT_TYPE_DEMOTE_PROMOTE        = 13,
>> +  EVENT_TYPE_SNAP_LIMIT            = 14,
>> +  EVENT_TYPE_UPDATE_FEATURES       = 15,
>> +  EVENT_TYPE_METADATA_SET          = 16,
>> +  EVENT_TYPE_METADATA_REMOVE       = 17,
>> +  EVENT_TYPE_AIO_WRITESAME         = 18,
>> +  EVENT_TYPE_AIO_COMPARE_AND_WRITE = 19,
>> +};
>> +
>> +
>> +// RBD_EVENT_FIXED_SIZE(10 = CEPH_ENCODING_START_BLK_LEN(6) + EVENT_TYPE(4))
>> +static const uint32_t RBD_EVENT_FIXED_SIZE = 10;
>> +
>> +static struct bio_vec *setup_write_bvecs(void *buf, u64 offset, u64 length)
>> +{
>> +       u32 i;
>> +       struct bio_vec *bvecs;
>> +       u32 bvec_count;
>> +
>> +       bvec_count = calc_pages_for(offset, length);
>> +       bvecs = kcalloc(bvec_count, sizeof(*bvecs), GFP_NOIO);
>> +       if (!bvecs)
>> +               goto err;
>> +
>> +       offset = offset % PAGE_SIZE;
>> +       for (i = 0; i < bvec_count; i++) {
>> +               unsigned int len = min(length, (u64)PAGE_SIZE - offset);
>> +
>> +               bvecs[i].bv_page = alloc_page(GFP_NOIO);
>> +               if (!bvecs[i].bv_page)
>> +                       goto free_bvecs;
>> +
>> +               bvecs[i].bv_offset = offset;
>> +               bvecs[i].bv_len = len;
>> +               memcpy(page_address(bvecs[i].bv_page) + bvecs[i].bv_offset, buf, bvecs[i].bv_len);
>> +               length -= len;
>> +               buf += len;
>> +               offset = 0;
>> +       }
>> +
>> +       rbd_assert(!length);
>> +
>> +       return bvecs;
>> +
>> +free_bvecs:
>> +err:
>> +       return NULL;
>> +}
>> +
>> +static void rbd_journal_callback(struct ceph_journaler_ctx *journaler_ctx)
>> +{
>> +       struct rbd_img_request *img_req = journaler_ctx->priv;
>> +       int result = journaler_ctx->result;
>> +
>> +       ceph_journaler_ctx_put(journaler_ctx);
>> +       rbd_img_handle_request(img_req, result);
>> +}
>> +
>> +static void img_journal_append_write_event(struct rbd_img_request *img_req)
>> +{
>> +       struct rbd_journal *journal = img_req->rbd_dev->journal;
>> +       struct ceph_journaler_ctx *journaler_ctx;
>> +       u64 offset = (u64)blk_rq_pos(img_req->rq) << SECTOR_SHIFT;
>> +       u64 length = blk_rq_bytes(img_req->rq);
>> +       struct bio *bio = img_req->rq->bio;
>> +       uint64_t prefix_len = RBD_EVENT_FIXED_SIZE + 20;
>> +       uint64_t max_append_size = ceph_journaler_get_max_append_size(journal->journaler) - prefix_len;
>> +       uint64_t append_size = min(max_append_size, length);
>> +       uint64_t bio_offset = 0;
>> +       void *p;
>> +       int ret;
>> +
>> +       rbd_assert(!img_req->pending.result && !img_req->pending.num_pending);
>> +
>> +       while (length > 0) {
>> +               journaler_ctx = ceph_journaler_ctx_alloc();
>> +               if (!journaler_ctx) {
>> +                       img_req->pending.result = -ENOMEM;
>> +                       return;
>> +               }
>> +
>> +               journaler_ctx->bio_iter.bio = bio;
>> +               journaler_ctx->bio_iter.iter = bio->bi_iter;
>> +
>> +               ceph_bio_iter_advance(&journaler_ctx->bio_iter, bio_offset);
>> +               append_size = min(max_append_size, length);
>> +               journaler_ctx->bio_len = append_size;
>> +               bio_offset += append_size;
>> +               length -= append_size;
>> +
>> +               // RBD_EVENT_FIXED_SIZE + offset(8) + length(8) + string_len(4) = 30
>> +               journaler_ctx->prefix_len = prefix_len;
>> +               journaler_ctx->prefix_offset = PAGE_SIZE - journaler_ctx->prefix_len;
>> +
>> +               p = page_address(journaler_ctx->prefix_page) + journaler_ctx->prefix_offset;
>> +
>> +               ceph_start_encoding(&p, 1, 1, journaler_ctx->prefix_len + journaler_ctx->bio_len - 6);
>> +
>> +               ceph_encode_32(&p, EVENT_TYPE_AIO_WRITE);
>> +
>> +               ceph_encode_64(&p, offset);
> Looks like this is encoding the same offset for all append chunks?
> This, coupled with always checksumming the entire bio, makes me think
> that this code path hasn't been tested.

Oh, yes. Because the rbd_mirror.sh test in ceph-qa is all about 4K 
writing, which will not go into next loop here.

I will add a case in qa/workunits/rbd/rbd_mirror.sh to cover this code path.
>> +               ceph_encode_64(&p, append_size);
>> +
>> +               // first part of ceph_encode_string();
>> +               ceph_encode_32(&p, journaler_ctx->bio_len);
>> +
>> +               journaler_ctx->priv = img_req;
>> +               journaler_ctx->callback = rbd_journal_callback;
>> +
>> +               ret = ceph_journaler_append(journal->journaler, journal->tag_tid,
>> +                                           journaler_ctx);
>> +               if (ret) {
>> +                       ceph_journaler_ctx_put(journaler_ctx);
>> +                       img_req->pending.result = ret;
>> +                       return;
>> +               }
>> +
>> +               rbd_assert(!ret);
> Bogus assert.

ok
>> +               img_req->pending.num_pending++;
>> +               img_req->journaler_commit_tid = journaler_ctx->commit_tid;
>> +       }
>> +}
>> +
>> +static void img_journal_append_discard_event(struct rbd_img_request *img_req)
>> +{
>> +       struct rbd_journal *journal = img_req->rbd_dev->journal;
>> +       struct ceph_journaler_ctx *journaler_ctx;
>> +       u64 offset = (u64)blk_rq_pos(img_req->rq) << SECTOR_SHIFT;
>> +       u64 length = blk_rq_bytes(img_req->rq);
>> +       struct bio *bio = img_req->rq->bio;
>> +       void *p;
>> +       int ret;
>> +
>> +       rbd_assert(!img_req->pending.result && !img_req->pending.num_pending);
> Move this assert to rbd_img_journal_append() to avoid duplicating it
> for write event and for discard event.

sounds good.
>> +
>> +       journaler_ctx = ceph_journaler_ctx_alloc();
>> +       if (!journaler_ctx) {
>> +               img_req->pending.result = -ENOMEM;
>> +               return;
>> +       }
>> +
>> +       journaler_ctx->bio_iter.bio = bio;
>> +       journaler_ctx->bio_iter.iter = bio->bi_iter;
>> +       journaler_ctx->bio_len = 0;
>> +
>> +       // RBD_EVENT_FIXED_SIZE + offset(8) + length(8) = 26
>> +       journaler_ctx->prefix_len = RBD_EVENT_FIXED_SIZE + 16;
>> +       journaler_ctx->prefix_offset = PAGE_SIZE - journaler_ctx->prefix_len;
>> +
>> +       p = page_address(journaler_ctx->prefix_page) + journaler_ctx->prefix_offset;
>> +
>> +       ceph_start_encoding(&p, 1, 1, journaler_ctx->prefix_len + journaler_ctx->bio_len - 6);
>> +
>> +       ceph_encode_32(&p, EVENT_TYPE_AIO_DISCARD);
>> +
>> +       ceph_encode_64(&p, offset);
>> +       ceph_encode_64(&p, length);
>> +
>> +       journaler_ctx->priv = img_req;
>> +       journaler_ctx->callback = rbd_journal_callback;
>> +
>> +       ret = ceph_journaler_append(journal->journaler, journal->tag_tid,
>> +                                   journaler_ctx);
>> +       if (ret) {
>> +               ceph_journaler_ctx_put(journaler_ctx);
>> +               img_req->pending.result = ret;
>> +               return;
>> +       }
>> +
>> +       rbd_assert(!ret);
> Bogus assert.

ok
>> +       img_req->pending.num_pending++;
>> +       img_req->journaler_commit_tid = journaler_ctx->commit_tid;
>> +}
>> +
>> +static void rbd_img_journal_append(struct rbd_img_request *img_req)
>> +{
>> +       switch (img_req->op_type) {
>> +       case OBJ_OP_WRITE:
>> +               img_journal_append_write_event(img_req);
>> +               break;
>> +       case OBJ_OP_DISCARD:
>> +               img_journal_append_discard_event(img_req);
>> +               break;
>> +       default:
>> +               img_req->pending.result = -ENOTSUPP;
> What about zeroouts?

As this work start before rbd supporting zeroout, so this code does not 
cover zeroout.

I will add zeroout in journaling in next version of this patchset.

Thanx
> Thanks,
>
>                  Ilya
>


