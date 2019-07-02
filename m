Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79FA65C927
	for <lists+ceph-devel@lfdr.de>; Tue,  2 Jul 2019 08:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725852AbfGBGPE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 2 Jul 2019 02:15:04 -0400
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:22667 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbfGBGPE (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 2 Jul 2019 02:15:04 -0400
Received: from yds-pc.domain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowAAX1rY19hpdQe_6AA--.2591S2;
        Tue, 02 Jul 2019 14:14:13 +0800 (CST)
Subject: Re: [PATCH 19/20] rbd: support for object-map and fast-diff
To:     dillaman@redhat.com, Ilya Dryomov <idryomov@gmail.com>
References: <20190625144111.11270-1-idryomov@gmail.com>
 <20190625144111.11270-20-idryomov@gmail.com>
 <CA+aFP1BYABF13KgHxqnHOptrXBBeNU-ZL5D9=bapc1YwtmNkUw@mail.gmail.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
Message-ID: <5D1AF635.7050705@easystack.cn>
Date:   Tue, 2 Jul 2019 14:14:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.0
MIME-Version: 1.0
In-Reply-To: <CA+aFP1BYABF13KgHxqnHOptrXBBeNU-ZL5D9=bapc1YwtmNkUw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: u+CowAAX1rY19hpdQe_6AA--.2591S2
X-Coremail-Antispam: 1Uf129KBjvAXoW3Cry8Kw4kAry8uF45ZF1fZwb_yoW8XrW5Ko
        Wftr4xJw4fGr1UA3ykJ3s2qFy5A3y8Ga42yrZ5WanrCF47Ka42kw13Ca13Xa9xuFySkF1x
        KFyxXF1FvF48Gw15n29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
        AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjTRPl1PUUUUU
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbicB-lellZurEGHQAAsg
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Jason,

On 07/02/2019 12:09 AM, Jason Dillaman wrote:
> On Tue, Jun 25, 2019 at 10:42 AM Ilya Dryomov <idryomov@gmail.com> wrote:
>> Speed up reads, discards and zeroouts through RBD_OBJ_FLAG_MAY_EXIST
>> and RBD_OBJ_FLAG_NOOP_FOR_NONEXISTENT based on object map.
>>
>> Invalid object maps are not trusted, but still updated.  Note that we
>> never iterate, resize or invalidate object maps.  If object-map feature
>> is enabled but object map fails to load, we just fail the requester
>> (either "rbd map" or I/O, by way of post-acquire action).
... ...
>> +}
>> +
>> +static int rbd_object_map_open(struct rbd_device *rbd_dev)
>> +{
>> +       int ret;
>> +
>> +       ret = rbd_object_map_lock(rbd_dev);
> Only lock/unlock if rbd_dev->spec.snap_id == CEPH_NOSNAP?

Hmm, IIUC, rbd_object_map_open() is called in post exclusive-lock 
acquired, when
rbd_dev->spec.snap_id != CEPH_NOSNAP, we don't need to acquire 
exclusive-lock I think.

But maybe we can add an assert in this function to make it clear.
>
>> +       if (ret)
>> +               return ret;
>> +
>> +       ret = rbd_object_map_load(rbd_dev);
>> +       if (ret) {
>> +               rbd_object_map_unlock(rbd_dev);
>> +               return ret;
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static void rbd_object_map_close(struct rbd_device *rbd_dev)
>> +{
>> +       rbd_object_map_free(rbd_dev);
>> +       rbd_object_map_unlock(rbd_dev);
>> +}
>> +
>> +/*
>> + * This function needs snap_id (or more precisely just something to
>> + * distinguish between HEAD and snapshot object maps), new_state and
>> + * current_state that were passed to rbd_object_map_update().
>> + *
>> + * To avoid allocating and stashing a context we piggyback on the OSD
>> + * request.  A HEAD update has two ops (assert_locked).  For new_state
>> + * and current_state we decode our own object_map_update op, encoded in
>> + * rbd_cls_object_map_update().
> Decoding the OSD request seems a little awkward. Since you would only
> update the in-memory state for the HEAD revision, could you just stash
> these fields in the "rbd_object_request" struct? Then in
> "rbd_object_map_update", set the callback to either a
> "rbd_object_map_snapshot_callback" callback or
> "rbd_object_map_head_callback".

Good idea, even we don't need two callback, because the
rbd_object_map_update_finish() will not update snapshot:

+    /*
+     * Nothing to do for a snapshot object map.
+     */
+    if (osd_req->r_num_ops == 1)
+        return 0;
>> + */
>> +static int rbd_object_map_update_finish(struct rbd_obj_request *obj_req,
>> +                                       struct ceph_osd_request *osd_req)
>> +{
>> +       struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
>> +       struct ceph_osd_data *osd_data;
>> +       u64 objno;
>> +       u8 state, new_state, current_state;
>> +       bool has_current_state;
>> +       void *p;
... ...
>>
>> +/*
>> + * Return:
>> + *   0 - object map update sent
>> + *   1 - object map update isn't needed
>> + *  <0 - error
>> + */
>> +static int rbd_obj_write_post_object_map(struct rbd_obj_request *obj_req)
>> +{
>> +       struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
>> +       u8 current_state = OBJECT_PENDING;
>> +
>> +       if (!(rbd_dev->header.features & RBD_FEATURE_OBJECT_MAP))
>> +               return 1;
>> +
>> +       if (!(obj_req->flags & RBD_OBJ_FLAG_DELETION))
>> +               return 1;
>> +
>> +       return rbd_object_map_update(obj_req, CEPH_NOSNAP, OBJECT_NONEXISTENT,
>> +                                    &current_state);
>> +}
>> +
>>   static bool rbd_obj_advance_write(struct rbd_obj_request *obj_req, int *result)
>>   {
>>          struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
>> @@ -2805,6 +3419,24 @@ static bool rbd_obj_advance_write(struct rbd_obj_request *obj_req, int *result)
>>          case RBD_OBJ_WRITE_START:
>>                  rbd_assert(!*result);
>>
>> +               if (rbd_obj_write_is_noop(obj_req))
>> +                       return true;
> Does this properly handle the case where it has a parent overlap? If
> the child object doesn't exist, we would still want to perform the
> copyup (if required), correct?

Good point. I found the zeroout case is handled, but discard not.

zeroout will check  (!obj_req->num_img_extents) before setting NOOP 
flag. but discard check it after setting.
Thanx
Yang
>
>> +               ret = rbd_obj_write_pre_object_map(obj_req);
>> +               if (ret < 0) {
>> +                       *result = ret;
>> +                       return true;
>> +               }
>> +               obj_req->write_state = RBD_OBJ_WRITE_PRE_OBJECT_MAP;
>> +               if (ret > 0)
>> +                       goto again;
>> +               return false;
>> +       case RBD_OBJ_WRITE_PRE_OBJECT_MAP:
>> +               if (*result) {
>> +                       rbd_warn(rbd_dev, "pre object map update failed: %d",
>> +                                *result);
>> +                       return true;
>> +               }
>>                  ret = rbd_obj_write_object(obj_req);
>>                  if (ret) {
>>                          *result = ret;
>> @@ -2837,8 +3469,23 @@ static bool rbd_obj_advance_write(struct rbd_obj_request *obj_req, int *result)
>>                          return false;
>>                  /* fall through */
>>          case RBD_OBJ_WRITE_COPYUP:
>> -               if (*result)
>> +               if (*result) {
>>                          rbd_warn(rbd_dev, "copyup failed: %d", *result);
>> +                       return true;
>> +               }
>> +               ret = rbd_obj_write_post_object_map(obj_req);
>> +               if (ret < 0) {
>> +                       *result = ret;
>> +                       return true;
>> +               }
>> +               obj_req->write_state = RBD_OBJ_WRITE_POST_OBJECT_MAP;
>> +               if (ret > 0)
>> +                       goto again;
>> +               return false;
>> +       case RBD_OBJ_WRITE_POST_OBJECT_MAP:
>> +               if (*result)
>> +                       rbd_warn(rbd_dev, "post object map update failed: %d",
>> +                                *result);
>>                  return true;
>>          default:
>>                  BUG();
>> @@ -2892,7 +3539,8 @@ static bool need_exclusive_lock(struct rbd_img_request *img_req)
>>                  return false;
>>
>>          rbd_assert(!test_bit(IMG_REQ_CHILD, &img_req->flags));
>> -       if (rbd_dev->opts->lock_on_read)
>> +       if (rbd_dev->opts->lock_on_read ||
>> +           (rbd_dev->header.features & RBD_FEATURE_OBJECT_MAP))
>>                  return true;
>>
>>          return rbd_img_is_write(img_req);
>> @@ -3427,7 +4075,7 @@ static int rbd_try_lock(struct rbd_device *rbd_dev)
>>                  if (ret)
>>                          goto out; /* request lock or error */
>>
>> -               rbd_warn(rbd_dev, "%s%llu seems dead, breaking lock",
>> +               rbd_warn(rbd_dev, "breaking header lock owned by %s%llu",
>>                           ENTITY_NAME(lockers[0].id.name));
>>
>>                  ret = ceph_monc_blacklist_add(&client->monc,
>> @@ -3454,6 +4102,19 @@ static int rbd_try_lock(struct rbd_device *rbd_dev)
>>          return ret;
>>   }
>>
>> +static int rbd_post_acquire_action(struct rbd_device *rbd_dev)
>> +{
>> +       int ret;
>> +
>> +       if (rbd_dev->header.features & RBD_FEATURE_OBJECT_MAP) {
>> +               ret = rbd_object_map_open(rbd_dev);
>> +               if (ret)
>> +                       return ret;
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>>   /*
>>    * Return:
>>    *   0 - lock acquired
>> @@ -3497,6 +4158,17 @@ static int rbd_try_acquire_lock(struct rbd_device *rbd_dev)
>>          rbd_assert(rbd_dev->lock_state == RBD_LOCK_STATE_LOCKED);
>>          rbd_assert(list_empty(&rbd_dev->running_list));
>>
>> +       ret = rbd_post_acquire_action(rbd_dev);
>> +       if (ret) {
>> +               rbd_warn(rbd_dev, "post-acquire action failed: %d", ret);
>> +               /*
>> +                * Can't stay in RBD_LOCK_STATE_LOCKED because
>> +                * rbd_lock_add_request() would let the request through,
>> +                * assuming that e.g. object map is locked and loaded.
>> +                */
>> +               rbd_unlock(rbd_dev);
>> +       }
>> +
>>   out:
>>          wake_requests(rbd_dev, ret);
>>          up_write(&rbd_dev->lock_rwsem);
>> @@ -3570,10 +4242,17 @@ static bool rbd_quiesce_lock(struct rbd_device *rbd_dev)
>>          return true;
>>   }
>>
>> +static void rbd_pre_release_action(struct rbd_device *rbd_dev)
>> +{
>> +       if (rbd_dev->header.features & RBD_FEATURE_OBJECT_MAP)
>> +               rbd_object_map_close(rbd_dev);
>> +}
>> +
>>   static void __rbd_release_lock(struct rbd_device *rbd_dev)
>>   {
>>          rbd_assert(list_empty(&rbd_dev->running_list));
>>
>> +       rbd_pre_release_action(rbd_dev);
>>          rbd_unlock(rbd_dev);
>>   }
>>
>> @@ -4860,6 +5539,8 @@ static struct rbd_device *__rbd_dev_create(struct rbd_client *rbdc,
>>          init_completion(&rbd_dev->acquire_wait);
>>          init_completion(&rbd_dev->releasing_wait);
>>
>> +       spin_lock_init(&rbd_dev->object_map_lock);
>> +
>>          rbd_dev->dev.bus = &rbd_bus_type;
>>          rbd_dev->dev.type = &rbd_device_type;
>>          rbd_dev->dev.parent = &rbd_root_dev;
>> @@ -5041,6 +5722,32 @@ static int rbd_dev_v2_features(struct rbd_device *rbd_dev)
>>                                                  &rbd_dev->header.features);
>>   }
>>
>> +/*
>> + * These are generic image flags, but since they are used only for
>> + * object map, store them in rbd_dev->object_map_flags.
>> + *
>> + * For the same reason, this function is called only on object map
>> + * (re)load and not on header refresh.
>> + */
>> +static int rbd_dev_v2_get_flags(struct rbd_device *rbd_dev)
>> +{
>> +       __le64 snapid = cpu_to_le64(rbd_dev->spec->snap_id);
>> +       __le64 flags;
>> +       int ret;
>> +
>> +       ret = rbd_obj_method_sync(rbd_dev, &rbd_dev->header_oid,
>> +                                 &rbd_dev->header_oloc, "get_flags",
>> +                                 &snapid, sizeof(snapid),
>> +                                 &flags, sizeof(flags));
>> +       if (ret < 0)
>> +               return ret;
>> +       if (ret < sizeof(flags))
>> +               return -EBADMSG;
>> +
>> +       rbd_dev->object_map_flags = le64_to_cpu(flags);
>> +       return 0;
>> +}
>> +
>>   struct parent_image_info {
>>          u64             pool_id;
>>          const char      *pool_ns;
>> @@ -6014,6 +6721,7 @@ static void rbd_dev_unprobe(struct rbd_device *rbd_dev)
>>          struct rbd_image_header *header;
>>
>>          rbd_dev_parent_put(rbd_dev);
>> +       rbd_object_map_free(rbd_dev);
>>          rbd_dev_mapping_clear(rbd_dev);
>>
>>          /* Free dynamic fields from the header, then zero it out */
>> @@ -6263,6 +6971,13 @@ static int rbd_dev_image_probe(struct rbd_device *rbd_dev, int depth)
>>          if (ret)
>>                  goto err_out_probe;
>>
>> +       if (rbd_dev->spec->snap_id != CEPH_NOSNAP &&
>> +           (rbd_dev->header.features & RBD_FEATURE_OBJECT_MAP)) {
>> +               ret = rbd_object_map_load(rbd_dev);
>> +               if (ret)
>> +                       goto err_out_probe;
>> +       }
>> +
>>          if (rbd_dev->header.features & RBD_FEATURE_LAYERING) {
>>                  ret = rbd_dev_v2_parent_info(rbd_dev);
>>                  if (ret)
>> diff --git a/drivers/block/rbd_types.h b/drivers/block/rbd_types.h
>> index 62ff50d3e7a6..ac98ab6ccd3b 100644
>> --- a/drivers/block/rbd_types.h
>> +++ b/drivers/block/rbd_types.h
>> @@ -18,6 +18,7 @@
>>   /* For format version 2, rbd image 'foo' consists of objects
>>    *   rbd_id.foo                - id of image
>>    *   rbd_header.<id>   - image metadata
>> + *   rbd_object_map.<id> - optional image object map
>>    *   rbd_data.<id>.0000000000000000
>>    *   rbd_data.<id>.0000000000000001
>>    *   ...               - data
>> @@ -25,6 +26,7 @@
>>    */
>>
>>   #define RBD_HEADER_PREFIX      "rbd_header."
>> +#define RBD_OBJECT_MAP_PREFIX  "rbd_object_map."
>>   #define RBD_ID_PREFIX          "rbd_id."
>>   #define RBD_V2_DATA_FORMAT     "%s.%016llx"
>>
>> @@ -39,6 +41,14 @@ enum rbd_notify_op {
>>          RBD_NOTIFY_OP_HEADER_UPDATE      = 3,
>>   };
>>
>> +#define OBJECT_NONEXISTENT     0
>> +#define OBJECT_EXISTS          1
>> +#define OBJECT_PENDING         2
>> +#define OBJECT_EXISTS_CLEAN    3
>> +
>> +#define RBD_FLAG_OBJECT_MAP_INVALID    (1ULL << 0)
>> +#define RBD_FLAG_FAST_DIFF_INVALID     (1ULL << 1)
>> +
>>   /*
>>    * For format version 1, rbd image 'foo' consists of objects
>>    *   foo.rbd           - image metadata
>> diff --git a/include/linux/ceph/cls_lock_client.h b/include/linux/ceph/cls_lock_client.h
>> index bea6c77d2093..17bc7584d1fe 100644
>> --- a/include/linux/ceph/cls_lock_client.h
>> +++ b/include/linux/ceph/cls_lock_client.h
>> @@ -52,4 +52,7 @@ int ceph_cls_lock_info(struct ceph_osd_client *osdc,
>>                         char *lock_name, u8 *type, char **tag,
>>                         struct ceph_locker **lockers, u32 *num_lockers);
>>
>> +int ceph_cls_assert_locked(struct ceph_osd_request *req, int which,
>> +                          char *lock_name, u8 type, char *cookie, char *tag);
>> +
>>   #endif
>> diff --git a/include/linux/ceph/striper.h b/include/linux/ceph/striper.h
>> index cbd0d24b7148..3486636c0e6e 100644
>> --- a/include/linux/ceph/striper.h
>> +++ b/include/linux/ceph/striper.h
>> @@ -66,4 +66,6 @@ int ceph_extent_to_file(struct ceph_file_layout *l,
>>                          struct ceph_file_extent **file_extents,
>>                          u32 *num_file_extents);
>>
>> +u64 ceph_get_num_objects(struct ceph_file_layout *l, u64 size);
>> +
>>   #endif
>> diff --git a/net/ceph/cls_lock_client.c b/net/ceph/cls_lock_client.c
>> index 56bbfe01e3ac..99cce6f3ec48 100644
>> --- a/net/ceph/cls_lock_client.c
>> +++ b/net/ceph/cls_lock_client.c
>> @@ -6,6 +6,7 @@
>>
>>   #include <linux/ceph/cls_lock_client.h>
>>   #include <linux/ceph/decode.h>
>> +#include <linux/ceph/libceph.h>
>>
>>   /**
>>    * ceph_cls_lock - grab rados lock for object
>> @@ -375,3 +376,47 @@ int ceph_cls_lock_info(struct ceph_osd_client *osdc,
>>          return ret;
>>   }
>>   EXPORT_SYMBOL(ceph_cls_lock_info);
>> +
>> +int ceph_cls_assert_locked(struct ceph_osd_request *req, int which,
>> +                          char *lock_name, u8 type, char *cookie, char *tag)
>> +{
>> +       int assert_op_buf_size;
>> +       int name_len = strlen(lock_name);
>> +       int cookie_len = strlen(cookie);
>> +       int tag_len = strlen(tag);
>> +       struct page **pages;
>> +       void *p, *end;
>> +       int ret;
>> +
>> +       assert_op_buf_size = name_len + sizeof(__le32) +
>> +                            cookie_len + sizeof(__le32) +
>> +                            tag_len + sizeof(__le32) +
>> +                            sizeof(u8) + CEPH_ENCODING_START_BLK_LEN;
>> +       if (assert_op_buf_size > PAGE_SIZE)
>> +               return -E2BIG;
>> +
>> +       ret = osd_req_op_cls_init(req, which, "lock", "assert_locked");
>> +       if (ret)
>> +               return ret;
>> +
>> +       pages = ceph_alloc_page_vector(1, GFP_NOIO);
>> +       if (IS_ERR(pages))
>> +               return PTR_ERR(pages);
>> +
>> +       p = page_address(pages[0]);
>> +       end = p + assert_op_buf_size;
>> +
>> +       /* encode cls_lock_assert_op struct */
>> +       ceph_start_encoding(&p, 1, 1,
>> +                           assert_op_buf_size - CEPH_ENCODING_START_BLK_LEN);
>> +       ceph_encode_string(&p, end, lock_name, name_len);
>> +       ceph_encode_8(&p, type);
>> +       ceph_encode_string(&p, end, cookie, cookie_len);
>> +       ceph_encode_string(&p, end, tag, tag_len);
>> +       WARN_ON(p != end);
>> +
>> +       osd_req_op_cls_request_data_pages(req, which, pages, assert_op_buf_size,
>> +                                         0, false, true);
>> +       return 0;
>> +}
>> +EXPORT_SYMBOL(ceph_cls_assert_locked);
>> diff --git a/net/ceph/striper.c b/net/ceph/striper.c
>> index c36462dc86b7..3b3fa75d1189 100644
>> --- a/net/ceph/striper.c
>> +++ b/net/ceph/striper.c
>> @@ -259,3 +259,20 @@ int ceph_extent_to_file(struct ceph_file_layout *l,
>>          return 0;
>>   }
>>   EXPORT_SYMBOL(ceph_extent_to_file);
>> +
>> +u64 ceph_get_num_objects(struct ceph_file_layout *l, u64 size)
>> +{
>> +       u64 period = (u64)l->stripe_count * l->object_size;
>> +       u64 num_periods = DIV64_U64_ROUND_UP(size, period);
>> +       u64 remainder_bytes;
>> +       u64 remainder_objs = 0;
>> +
>> +       div64_u64_rem(size, period, &remainder_bytes);
>> +       if (remainder_bytes > 0 &&
>> +           remainder_bytes < (u64)l->stripe_count * l->stripe_unit)
>> +               remainder_objs = l->stripe_count -
>> +                           DIV_ROUND_UP_ULL(remainder_bytes, l->stripe_unit);
>> +
>> +       return num_periods * l->stripe_count - remainder_objs;
>> +}
>> +EXPORT_SYMBOL(ceph_get_num_objects);
>> --
>> 2.19.2
>>
> Nit: might have been nice to break this one commit into several smaller commits.
>


