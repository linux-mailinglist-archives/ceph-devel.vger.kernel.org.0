Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E389F5E23A
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Jul 2019 12:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726870AbfGCKl1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 3 Jul 2019 06:41:27 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:41530 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbfGCKl1 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 3 Jul 2019 06:41:27 -0400
Received: by mail-io1-f66.google.com with SMTP id w25so3596130ioc.8
        for <ceph-devel@vger.kernel.org>; Wed, 03 Jul 2019 03:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8at9jhm1o9QunDmjEukfoOs3pOGO6iSKADOgS5CekdU=;
        b=tSoZZmS1bnmrxBY7V8vvr3Qk3vAVmZlD55xV7+LtmgWfTjYYUmr0xsmLrV308t5nF3
         cZCKBhlePPONwM3H5iF3IOmFfKAM/vBwBRn6MINAfHg9bhglwKPvTCJb+6dh8oQatatN
         gGLBhDkKiaQN5SWciMXR9uyfiCZ2/D2vkYpqAFPhiWS+paF3hj05YUZCgEnDAVBDs0fr
         eNRqMi2tgneuakwFRuhpOMiJSj5sI7kg/fG7yDKcaMIs58HNrWbCPpK3t+9gZeVtrGql
         EjeHkAwTlbXrjPp739gq0TSRi+JlxO6krIPvIorEaKoIXa71BXDG09yI5ep4YNxwOMxD
         GOFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8at9jhm1o9QunDmjEukfoOs3pOGO6iSKADOgS5CekdU=;
        b=p8USUqGQtd0FLt5ik9cxZ9oWVdD60XajZ2QkHl5r+5ePjEX0hhzAHzOBKXcHI6j9OX
         joKmn7lQqIEoaiiy4F45YD5pxaIWPFd1W8JNNRuoeeQICtSI9dPTDNymBwHNdZ5/zumN
         7lWwOddQLZOgl3wGr9rGAyBFDuEUhr6ypOerE6Fpm8lrVP1o2sHXRTuNxYm4GHhfCQ/e
         o7X89V9rH/jpJY6tiPoF/EIYVkHqyZ0rAsgdPpfmihuqlj9V1nK7I0XQvtg+JQVOcgKy
         nj2DBpKVbfABGFsQ13d/IvujNoYiwro2gmkuEjmYtNNNr23wgngbEcM2MN7YJz7crn80
         fucw==
X-Gm-Message-State: APjAAAUuH3bDEKZkOabRwiNoGS00Oq3S1Rjvkp+omzh9VCXtiC1GiTeV
        LCD4jjyhHdn3W4p8KIkqNSClVQywgWTaAKFTav9UyHe+
X-Google-Smtp-Source: APXvYqywvEJM/pGvOE+HhGCQLrHOkrPjFCBokLmDoyECbf6t9nvnbrSF9LkkNxaN/OflLLw/RIdRmBzqeyU3bDaA9Cc=
X-Received: by 2002:a6b:ed02:: with SMTP id n2mr11232946iog.131.1562150486096;
 Wed, 03 Jul 2019 03:41:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190625144111.11270-1-idryomov@gmail.com> <20190625144111.11270-20-idryomov@gmail.com>
 <5D199B3A.8070501@easystack.cn>
In-Reply-To: <5D199B3A.8070501@easystack.cn>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 3 Jul 2019 12:44:06 +0200
Message-ID: <CAOi1vP_o9BMGvXxmkO6Wr5gzKib7G+ngd=MWfK115fTUTy-T2Q@mail.gmail.com>
Subject: Re: [PATCH 19/20] rbd: support for object-map and fast-diff
To:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jul 1, 2019 at 7:33 AM Dongsheng Yang
<dongsheng.yang@easystack.cn> wrote:
>
>
>
> On 06/25/2019 10:41 PM, Ilya Dryomov wrote:
> > Speed up reads, discards and zeroouts through RBD_OBJ_FLAG_MAY_EXIST
> > and RBD_OBJ_FLAG_NOOP_FOR_NONEXISTENT based on object map.
> >
> > Invalid object maps are not trusted, but still updated.  Note that we
> > never iterate, resize or invalidate object maps.  If object-map feature
> > is enabled but object map fails to load, we just fail the requester
> > (either "rbd map" or I/O, by way of post-acquire action).
> >
> > Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> > ---
> >   drivers/block/rbd.c                  | 721 ++++++++++++++++++++++++++-
> >   drivers/block/rbd_types.h            |  10 +
> >   include/linux/ceph/cls_lock_client.h |   3 +
> >   include/linux/ceph/striper.h         |   2 +
> >   net/ceph/cls_lock_client.c           |  45 ++
> >   net/ceph/striper.c                   |  17 +
> >   6 files changed, 795 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> > index 671041b67957..756595f5fbc9 100644
> > --- a/drivers/block/rbd.c
> > +++ b/drivers/block/rbd.c
> > @@ -115,6 +115,8 @@ static int atomic_dec_return_safe(atomic_t *v)
> >   #define RBD_FEATURE_LAYERING                (1ULL<<0)
> >   #define RBD_FEATURE_STRIPINGV2              (1ULL<<1)
> >   #define RBD_FEATURE_EXCLUSIVE_LOCK  (1ULL<<2)
> > +#define RBD_FEATURE_OBJECT_MAP               (1ULL<<3)
> > +#define RBD_FEATURE_FAST_DIFF                (1ULL<<4)
> >   #define RBD_FEATURE_DEEP_FLATTEN    (1ULL<<5)
> >   #define RBD_FEATURE_DATA_POOL               (1ULL<<7)
> >   #define RBD_FEATURE_OPERATIONS              (1ULL<<8)
> > @@ -122,6 +124,8 @@ static int atomic_dec_return_safe(atomic_t *v)
> >   #define RBD_FEATURES_ALL    (RBD_FEATURE_LAYERING |         \
> >                                RBD_FEATURE_STRIPINGV2 |       \
> >                                RBD_FEATURE_EXCLUSIVE_LOCK |   \
> > +                              RBD_FEATURE_OBJECT_MAP |       \
> > +                              RBD_FEATURE_FAST_DIFF |        \
> >                                RBD_FEATURE_DEEP_FLATTEN |     \
> >                                RBD_FEATURE_DATA_POOL |        \
> >                                RBD_FEATURE_OPERATIONS)
> > @@ -227,6 +231,8 @@ enum obj_operation_type {
> >   #define RBD_OBJ_FLAG_DELETION                       (1U << 0)
> >   #define RBD_OBJ_FLAG_COPYUP_ENABLED         (1U << 1)
> >   #define RBD_OBJ_FLAG_COPYUP_ZEROS           (1U << 2)
> > +#define RBD_OBJ_FLAG_MAY_EXIST                       (1U << 3)
> > +#define RBD_OBJ_FLAG_NOOP_FOR_NONEXISTENT    (1U << 4)
> >
> >   enum rbd_obj_read_state {
> >       RBD_OBJ_READ_START = 1,
> > @@ -261,14 +267,18 @@ enum rbd_obj_read_state {
> >    */
> >   enum rbd_obj_write_state {
> >       RBD_OBJ_WRITE_START = 1,
> > +     RBD_OBJ_WRITE_PRE_OBJECT_MAP,
> >       RBD_OBJ_WRITE_OBJECT,
> >       __RBD_OBJ_WRITE_COPYUP,
> >       RBD_OBJ_WRITE_COPYUP,
> > +     RBD_OBJ_WRITE_POST_OBJECT_MAP,
> >   };
> >
> >   enum rbd_obj_copyup_state {
> >       RBD_OBJ_COPYUP_START = 1,
> >       RBD_OBJ_COPYUP_READ_PARENT,
> > +     __RBD_OBJ_COPYUP_OBJECT_MAPS,
> > +     RBD_OBJ_COPYUP_OBJECT_MAPS,
> >       __RBD_OBJ_COPYUP_WRITE_OBJECT,
> >       RBD_OBJ_COPYUP_WRITE_OBJECT,
> >   };
> > @@ -419,6 +429,11 @@ struct rbd_device {
> >       int                     acquire_err;
> >       struct completion       releasing_wait;
> >
> > +     spinlock_t              object_map_lock;
> > +     u8                      *object_map;
> > +     u64                     object_map_size;        /* in objects */
> > +     u64                     object_map_flags;
> > +
> >       struct workqueue_struct *task_wq;
> >
> >       struct rbd_spec         *parent_spec;
> > @@ -620,6 +635,7 @@ static int _rbd_dev_v2_snap_size(struct rbd_device *rbd_dev, u64 snap_id,
> >                               u8 *order, u64 *snap_size);
> >   static int _rbd_dev_v2_snap_features(struct rbd_device *rbd_dev, u64 snap_id,
> >               u64 *snap_features);
> > +static int rbd_dev_v2_get_flags(struct rbd_device *rbd_dev);
> >
> >   static void rbd_obj_handle_request(struct rbd_obj_request *obj_req, int result);
> >   static void rbd_img_handle_request(struct rbd_img_request *img_req, int result);
> > @@ -1768,6 +1784,467 @@ static void rbd_img_request_destroy(struct kref *kref)
> >       kmem_cache_free(rbd_img_request_cache, img_request);
> >   }
> >
> > +#define BITS_PER_OBJ 2
> > +#define OBJS_PER_BYTE        (BITS_PER_BYTE / BITS_PER_OBJ)
> > +#define OBJ_MASK     ((1 << BITS_PER_OBJ) - 1)
> > +
> > +static void __rbd_object_map_index(struct rbd_device *rbd_dev, u64 objno,
> > +                                u64 *index, u8 *shift)
> > +{
> > +     u32 off;
> > +
> > +     rbd_assert(objno < rbd_dev->object_map_size);
> > +     *index = div_u64_rem(objno, OBJS_PER_BYTE, &off);
> > +     *shift = (OBJS_PER_BYTE - off - 1) * BITS_PER_OBJ;
> > +}
> > +
> > +static u8 __rbd_object_map_get(struct rbd_device *rbd_dev, u64 objno)
> > +{
> > +     u64 index;
> > +     u8 shift;
> > +
> > +     lockdep_assert_held(&rbd_dev->object_map_lock);
> > +     __rbd_object_map_index(rbd_dev, objno, &index, &shift);
> > +     return (rbd_dev->object_map[index] >> shift) & OBJ_MASK;
> > +}
> > +
> > +static void __rbd_object_map_set(struct rbd_device *rbd_dev, u64 objno, u8 val)
> > +{
> > +     u64 index;
> > +     u8 shift;
> > +     u8 *p;
> > +
> > +     lockdep_assert_held(&rbd_dev->object_map_lock);
> > +     rbd_assert(!(val & ~OBJ_MASK));
> > +
> > +     __rbd_object_map_index(rbd_dev, objno, &index, &shift);
> > +     p = &rbd_dev->object_map[index];
> > +     *p = (*p & ~(OBJ_MASK << shift)) | (val << shift);
> > +}
> > +
> > +static u8 rbd_object_map_get(struct rbd_device *rbd_dev, u64 objno)
> > +{
> > +     u8 state;
> > +
> > +     spin_lock(&rbd_dev->object_map_lock);
> > +     state = __rbd_object_map_get(rbd_dev, objno);
> > +     spin_unlock(&rbd_dev->object_map_lock);
> > +     return state;
> > +}
> > +
> > +static bool use_object_map(struct rbd_device *rbd_dev)
> > +{
> > +     return ((rbd_dev->header.features & RBD_FEATURE_OBJECT_MAP) &&
> > +             !(rbd_dev->object_map_flags & RBD_FLAG_OBJECT_MAP_INVALID));
> > +}
> > +
> > +static bool rbd_object_map_may_exist(struct rbd_device *rbd_dev, u64 objno)
> > +{
> > +     u8 state;
> > +
> > +     /* fall back to default logic if object map is disabled or invalid */
> > +     if (!use_object_map(rbd_dev))
> > +             return true;
> > +
> > +     state = rbd_object_map_get(rbd_dev, objno);
> > +     return state != OBJECT_NONEXISTENT;
> > +}
> > +
> > +static void rbd_object_map_name(struct rbd_device *rbd_dev, u64 snap_id,
> > +                             struct ceph_object_id *oid)
> > +{
> > +     if (snap_id == CEPH_NOSNAP)
> > +             ceph_oid_printf(oid, "%s%s", RBD_OBJECT_MAP_PREFIX,
> > +                             rbd_dev->spec->image_id);
> > +     else
> > +             ceph_oid_printf(oid, "%s%s.%016llx", RBD_OBJECT_MAP_PREFIX,
> > +                             rbd_dev->spec->image_id, snap_id);
> > +}
> > +
> > +static int rbd_object_map_lock(struct rbd_device *rbd_dev)
> > +{
> > +     struct ceph_osd_client *osdc = &rbd_dev->rbd_client->client->osdc;
> > +     CEPH_DEFINE_OID_ONSTACK(oid);
> > +     u8 lock_type;
> > +     char *lock_tag;
> > +     struct ceph_locker *lockers;
> > +     u32 num_lockers;
> > +     bool broke_lock = false;
> > +     int ret;
> > +
> > +     rbd_object_map_name(rbd_dev, CEPH_NOSNAP, &oid);
> > +
> > +again:
> > +     ret = ceph_cls_lock(osdc, &oid, &rbd_dev->header_oloc, RBD_LOCK_NAME,
> > +                         CEPH_CLS_LOCK_EXCLUSIVE, "", "", "", 0);
> > +     if (ret != -EBUSY || broke_lock) {
> > +             if (ret == -EEXIST)
> > +                     ret = 0; /* already locked by myself */
> > +             if (ret)
> > +                     rbd_warn(rbd_dev, "failed to lock object map: %d", ret);
> > +             return ret;
> > +
> > +     }
> blank line

Fixed.

> > +
> > +     ret = ceph_cls_lock_info(osdc, &oid, &rbd_dev->header_oloc,
> > +                              RBD_LOCK_NAME, &lock_type, &lock_tag,
> > +                              &lockers, &num_lockers);
> > +     if (ret) {
> > +             if (ret == -ENOENT)
> > +                     goto again;
> > +
> > +             rbd_warn(rbd_dev, "failed to get object map lockers: %d", ret);
> > +             return ret;
> > +     }
> > +
> > +     kfree(lock_tag);
> > +     if (num_lockers == 0)
> > +             goto again;
> > +
> > +     rbd_warn(rbd_dev, "breaking object map lock owned by %s%llu",
> > +              ENTITY_NAME(lockers[0].id.name));
> > +
> > +     ret = ceph_cls_break_lock(osdc, &oid, &rbd_dev->header_oloc,
> > +                               RBD_LOCK_NAME, lockers[0].id.cookie,
> > +                               &lockers[0].id.name);
> > +     ceph_free_lockers(lockers, num_lockers);
> > +     if (ret) {
> > +             if (ret == -ENOENT)
> > +                     goto again;
> > +
> > +             rbd_warn(rbd_dev, "failed to break object map lock: %d", ret);
> > +             return ret;
> > +     }
> > +
> > +     broke_lock = true;
> > +     goto again;
> > +}
> > +
> > +static void rbd_object_map_unlock(struct rbd_device *rbd_dev)
> > +{
> > +     struct ceph_osd_client *osdc = &rbd_dev->rbd_client->client->osdc;
> > +     CEPH_DEFINE_OID_ONSTACK(oid);
> > +     int ret;
> > +
> > +     rbd_object_map_name(rbd_dev, CEPH_NOSNAP, &oid);
> > +
> > +     ret = ceph_cls_unlock(osdc, &oid, &rbd_dev->header_oloc, RBD_LOCK_NAME,
> > +                           "");
> > +     if (ret && ret != -ENOENT)
> > +             rbd_warn(rbd_dev, "failed to unlock object map: %d", ret);
> > +}
> > +
> > +static int decode_object_map_header(void **p, void *end, u64 *object_map_size)
> > +{
> > +     u8 struct_v;
> > +     u32 struct_len;
> > +     u32 header_len;
> > +     void *header_end;
> > +     int ret;
> > +
> > +     ceph_decode_32_safe(p, end, header_len, e_inval);
> > +     header_end = *p + header_len;
> > +
> > +     ret = ceph_start_decoding(p, end, 1, "BitVector header", &struct_v,
> > +                               &struct_len);
> > +     if (ret)
> > +             return ret;
> > +
> > +     ceph_decode_64_safe(p, end, *object_map_size, e_inval);
> > +
> > +     *p = header_end;
> could this be different?

You mean *p and header_end?  They could be in the future, if new fields
are added to the header.  We want to skip them here.

> > +     return 0;
> > +
> > +e_inval:
> > +     return -EINVAL;
> > +}
> > +
> > +static int __rbd_object_map_load(struct rbd_device *rbd_dev)
> > +{
> > +     struct ceph_osd_client *osdc = &rbd_dev->rbd_client->client->osdc;
> > +     CEPH_DEFINE_OID_ONSTACK(oid);
> > +     struct page **pages;
> > +     void *p, *end;
> > +     size_t reply_len;
> > +     u64 num_objects;
> > +     u64 object_map_bytes;
> > +     u64 object_map_size;
> > +     int num_pages;
> > +     int ret;
> > +
> > +     rbd_assert(!rbd_dev->object_map && !rbd_dev->object_map_size);
> > +
> > +     num_objects = ceph_get_num_objects(&rbd_dev->layout,
> > +                                        rbd_dev->mapping.size);
> > +     object_map_bytes = DIV_ROUND_UP_ULL(num_objects * BITS_PER_OBJ,
> > +                                         BITS_PER_BYTE);
> > +     num_pages = calc_pages_for(0, object_map_bytes) + 1;
> > +     pages = ceph_alloc_page_vector(num_pages, GFP_KERNEL);
> > +     if (IS_ERR(pages))
> > +             return PTR_ERR(pages);
> > +
> > +     reply_len = num_pages * PAGE_SIZE;
> > +     rbd_object_map_name(rbd_dev, rbd_dev->spec->snap_id, &oid);
> > +     ret = ceph_osdc_call(osdc, &oid, &rbd_dev->header_oloc,
> > +                          "rbd", "object_map_load", CEPH_OSD_FLAG_READ,
> > +                          NULL, 0, pages, &reply_len);
> > +     if (ret)
> > +             goto out;
> > +
> > +     p = page_address(pages[0]);
> > +     end = p + min(reply_len, (size_t)PAGE_SIZE);
> > +     ret = decode_object_map_header(&p, end, &object_map_size);
> > +     if (ret)
> > +             goto out;
> > +
> > +     if (object_map_size != num_objects) {
> > +             rbd_warn(rbd_dev, "object map size mismatch: %llu vs %llu",
> > +                      object_map_size, num_objects);
> > +             ret = -EINVAL;
> > +             goto out;
> > +     }
> > +
> > +     if (offset_in_page(p) + object_map_bytes > reply_len) {
> > +             ret = -EINVAL;
> > +             goto out;
> > +     }
> > +
> > +     rbd_dev->object_map = kvmalloc(object_map_bytes, GFP_KERNEL);
> As there is a ceph_kvmalloc(), should we always use ceph_kvmalloc() in
> ceph module?

No.  On the contrary, using generic interfaces should be preferred.

> > +     if (!rbd_dev->object_map) {
> > +             ret = -ENOMEM;
> > +             goto out;
> > +     }
> > +
> > +     rbd_dev->object_map_size = object_map_size;
> > +     ceph_copy_from_page_vector(pages, rbd_dev->object_map,
> > +                                offset_in_page(p), object_map_bytes);
> > +
> > +out:
> > +     ceph_release_page_vector(pages, num_pages);
> > +     return ret;
> > +}
> > +
> > +static void rbd_object_map_free(struct rbd_device *rbd_dev)
> > +{
> > +     kvfree(rbd_dev->object_map);
> > +     rbd_dev->object_map = NULL;
> > +     rbd_dev->object_map_size = 0;
> > +}
> > +
> > +static int rbd_object_map_load(struct rbd_device *rbd_dev)
> > +{
> > +     int ret;
> > +
> > +     ret = __rbd_object_map_load(rbd_dev);
> > +     if (ret)
> > +             return ret;
> > +
> > +     ret = rbd_dev_v2_get_flags(rbd_dev);
> > +     if (ret) {
> > +             rbd_object_map_free(rbd_dev);
> > +             return ret;
> > +     }
> > +
> > +     if (rbd_dev->object_map_flags & RBD_FLAG_OBJECT_MAP_INVALID)
> > +             rbd_warn(rbd_dev, "object map is invalid");
> Okey, if the object_map is invalid, we warn and not use object_map in
> I/O path, right?

Not quite.  We don't trust it (i.e. RBD_OBJ_FLAG_MAY_EXIST gets set)
but we still update it.

> > +
> > +     return 0;
> > +}
> > +
> > +static int rbd_object_map_open(struct rbd_device *rbd_dev)
> > +{
> > +     int ret;
> > +
> > +     ret = rbd_object_map_lock(rbd_dev);
>
> hold the object_map lock in the whole rbd_device lifecycle? So if a rbd
> is mapped, we can't do object-map operation (such as check, rebuild)?

Object map lock is tied to exclusive lock on the header.  For rebuild,
"rbd object-map rebuild" would end up requesting exclusive lock and we
would release object map lock and exclusive lock after all in-flight
image requests complete.  check/rebuild is no different from resize or
any other maintenance operation (or even regular I/O if the same image
is mapped more than once and is being accessed through two or more
mappings concurrently).

Thanks,

                Ilya
