Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51B295E4A0
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Jul 2019 14:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbfGCM4g (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 3 Jul 2019 08:56:36 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:33115 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbfGCM4g (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 3 Jul 2019 08:56:36 -0400
Received: by mail-io1-f65.google.com with SMTP id u13so137573iop.0
        for <ceph-devel@vger.kernel.org>; Wed, 03 Jul 2019 05:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x3vJM3TtzkdsDYIfujCLKoyZnNdw6Dvi8A5C/L+K340=;
        b=OJabus11lg9hjndAh0vkxNOiZFyIhj7B9mVq+MB0ByD9wGxkldMhwgbwmJK/4hLObd
         ZxW9+4kZgcOoQlCWaPQcvUMa06AX7suv2DvnaEfDDoVfbobmtCWdhfmMURP+JyUJlTFC
         Lj0jFzODrequ37GCLZyfQKn4jMhvJgxrxS129pPqYD+CO0zJ3VXzGj3GN3U/GBU3FYTC
         SLxPJz3s61Ptj1AuKndjtVYGMBcKsg64ZyLRdY1girIXgeyFoWTRU0/fXdqyXPkrVw8d
         zvfxAM7/SirTBAdKa9PkpR2Z75P2V+n9/X4tuJo46QWXTaMpEvBEc9+6BPuqgWGHMes4
         fv0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x3vJM3TtzkdsDYIfujCLKoyZnNdw6Dvi8A5C/L+K340=;
        b=ZrdqSjmdBjTwhTNXM09NWAmlSrScFUPzeyH67yoo4MhnaDp+879nAFa1DkElV5eYNH
         NfIJyM2AZMICvHn4jF1fTVEBomv52gLSnlEbtVr0zl1ACuz2ddC0YvpqLZgk/nEfp4Mu
         +k6TN2jHsfRQQWFZtnIQ8E8dRF5VlU2mbWHLqSiP38YAs4hqLA4rJjhtlyqv6jdiqGYL
         WjG24I/1Hwenbq07k0sE1fsv2uhoXdlrovAoEQO9RWPSPWqb8suESj8f9hxsyvpmv/Kb
         KMrVeMKmV4EsKRip+dGVXWYLL/kCZL4Rp8sS2iZAh4VaCQ2OsgOCRvcHxiz/hH4h0cKZ
         vC3w==
X-Gm-Message-State: APjAAAX3Dg8pAsZwIMawgjCL9WfVjTUCNzJwmhmeeSQ0ZFA+TZTNYULY
        hjrDJc5gGOBWoiAMe4gxiXTSJ+6tICnCGTeObMQ=
X-Google-Smtp-Source: APXvYqy1PMO3YJYI54ozatzo2KDoQKZVVfB5HFxKKTdrwnpcrx7AsNDoS9JETcofkTUPt2RgkjK9eiiZ9Oq57XK/beY=
X-Received: by 2002:a5d:9550:: with SMTP id a16mr17956956ios.106.1562158594704;
 Wed, 03 Jul 2019 05:56:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190625144111.11270-1-idryomov@gmail.com> <20190625144111.11270-20-idryomov@gmail.com>
 <CA+aFP1BYABF13KgHxqnHOptrXBBeNU-ZL5D9=bapc1YwtmNkUw@mail.gmail.com>
In-Reply-To: <CA+aFP1BYABF13KgHxqnHOptrXBBeNU-ZL5D9=bapc1YwtmNkUw@mail.gmail.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 3 Jul 2019 14:59:14 +0200
Message-ID: <CAOi1vP8XB=vEWie4+T83mEtfQ-9e+QdE_60PEA6QRY9G-T+d=w@mail.gmail.com>
Subject: Re: [PATCH 19/20] rbd: support for object-map and fast-diff
To:     Jason Dillaman <dillaman@redhat.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jul 1, 2019 at 6:09 PM Jason Dillaman <jdillama@redhat.com> wrote:
>
> On Tue, Jun 25, 2019 at 10:42 AM Ilya Dryomov <idryomov@gmail.com> wrote:
> >
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
> >  drivers/block/rbd.c                  | 721 ++++++++++++++++++++++++++-
> >  drivers/block/rbd_types.h            |  10 +
> >  include/linux/ceph/cls_lock_client.h |   3 +
> >  include/linux/ceph/striper.h         |   2 +
> >  net/ceph/cls_lock_client.c           |  45 ++
> >  net/ceph/striper.c                   |  17 +
> >  6 files changed, 795 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> > index 671041b67957..756595f5fbc9 100644
> > --- a/drivers/block/rbd.c
> > +++ b/drivers/block/rbd.c
> > @@ -115,6 +115,8 @@ static int atomic_dec_return_safe(atomic_t *v)
> >  #define RBD_FEATURE_LAYERING           (1ULL<<0)
> >  #define RBD_FEATURE_STRIPINGV2         (1ULL<<1)
> >  #define RBD_FEATURE_EXCLUSIVE_LOCK     (1ULL<<2)
> > +#define RBD_FEATURE_OBJECT_MAP         (1ULL<<3)
> > +#define RBD_FEATURE_FAST_DIFF          (1ULL<<4)
> >  #define RBD_FEATURE_DEEP_FLATTEN       (1ULL<<5)
> >  #define RBD_FEATURE_DATA_POOL          (1ULL<<7)
> >  #define RBD_FEATURE_OPERATIONS         (1ULL<<8)
> > @@ -122,6 +124,8 @@ static int atomic_dec_return_safe(atomic_t *v)
> >  #define RBD_FEATURES_ALL       (RBD_FEATURE_LAYERING |         \
> >                                  RBD_FEATURE_STRIPINGV2 |       \
> >                                  RBD_FEATURE_EXCLUSIVE_LOCK |   \
> > +                                RBD_FEATURE_OBJECT_MAP |       \
> > +                                RBD_FEATURE_FAST_DIFF |        \
> >                                  RBD_FEATURE_DEEP_FLATTEN |     \
> >                                  RBD_FEATURE_DATA_POOL |        \
> >                                  RBD_FEATURE_OPERATIONS)
> > @@ -227,6 +231,8 @@ enum obj_operation_type {
> >  #define RBD_OBJ_FLAG_DELETION                  (1U << 0)
> >  #define RBD_OBJ_FLAG_COPYUP_ENABLED            (1U << 1)
> >  #define RBD_OBJ_FLAG_COPYUP_ZEROS              (1U << 2)
> > +#define RBD_OBJ_FLAG_MAY_EXIST                 (1U << 3)
> > +#define RBD_OBJ_FLAG_NOOP_FOR_NONEXISTENT      (1U << 4)
> >
> >  enum rbd_obj_read_state {
> >         RBD_OBJ_READ_START = 1,
> > @@ -261,14 +267,18 @@ enum rbd_obj_read_state {
> >   */
> >  enum rbd_obj_write_state {
> >         RBD_OBJ_WRITE_START = 1,
> > +       RBD_OBJ_WRITE_PRE_OBJECT_MAP,
> >         RBD_OBJ_WRITE_OBJECT,
> >         __RBD_OBJ_WRITE_COPYUP,
> >         RBD_OBJ_WRITE_COPYUP,
> > +       RBD_OBJ_WRITE_POST_OBJECT_MAP,
> >  };
> >
> >  enum rbd_obj_copyup_state {
> >         RBD_OBJ_COPYUP_START = 1,
> >         RBD_OBJ_COPYUP_READ_PARENT,
> > +       __RBD_OBJ_COPYUP_OBJECT_MAPS,
> > +       RBD_OBJ_COPYUP_OBJECT_MAPS,
> >         __RBD_OBJ_COPYUP_WRITE_OBJECT,
> >         RBD_OBJ_COPYUP_WRITE_OBJECT,
> >  };
> > @@ -419,6 +429,11 @@ struct rbd_device {
> >         int                     acquire_err;
> >         struct completion       releasing_wait;
> >
> > +       spinlock_t              object_map_lock;
> > +       u8                      *object_map;
> > +       u64                     object_map_size;        /* in objects */
> > +       u64                     object_map_flags;
> > +
> >         struct workqueue_struct *task_wq;
> >
> >         struct rbd_spec         *parent_spec;
> > @@ -620,6 +635,7 @@ static int _rbd_dev_v2_snap_size(struct rbd_device *rbd_dev, u64 snap_id,
> >                                 u8 *order, u64 *snap_size);
> >  static int _rbd_dev_v2_snap_features(struct rbd_device *rbd_dev, u64 snap_id,
> >                 u64 *snap_features);
> > +static int rbd_dev_v2_get_flags(struct rbd_device *rbd_dev);
> >
> >  static void rbd_obj_handle_request(struct rbd_obj_request *obj_req, int result);
> >  static void rbd_img_handle_request(struct rbd_img_request *img_req, int result);
> > @@ -1768,6 +1784,467 @@ static void rbd_img_request_destroy(struct kref *kref)
> >         kmem_cache_free(rbd_img_request_cache, img_request);
> >  }
> >
> > +#define BITS_PER_OBJ   2
> > +#define OBJS_PER_BYTE  (BITS_PER_BYTE / BITS_PER_OBJ)
> > +#define OBJ_MASK       ((1 << BITS_PER_OBJ) - 1)
> > +
> > +static void __rbd_object_map_index(struct rbd_device *rbd_dev, u64 objno,
> > +                                  u64 *index, u8 *shift)
> > +{
> > +       u32 off;
> > +
> > +       rbd_assert(objno < rbd_dev->object_map_size);
> > +       *index = div_u64_rem(objno, OBJS_PER_BYTE, &off);
> > +       *shift = (OBJS_PER_BYTE - off - 1) * BITS_PER_OBJ;
> > +}
> > +
> > +static u8 __rbd_object_map_get(struct rbd_device *rbd_dev, u64 objno)
> > +{
> > +       u64 index;
> > +       u8 shift;
> > +
> > +       lockdep_assert_held(&rbd_dev->object_map_lock);
> > +       __rbd_object_map_index(rbd_dev, objno, &index, &shift);
> > +       return (rbd_dev->object_map[index] >> shift) & OBJ_MASK;
> > +}
> > +
> > +static void __rbd_object_map_set(struct rbd_device *rbd_dev, u64 objno, u8 val)
> > +{
> > +       u64 index;
> > +       u8 shift;
> > +       u8 *p;
> > +
> > +       lockdep_assert_held(&rbd_dev->object_map_lock);
> > +       rbd_assert(!(val & ~OBJ_MASK));
> > +
> > +       __rbd_object_map_index(rbd_dev, objno, &index, &shift);
> > +       p = &rbd_dev->object_map[index];
> > +       *p = (*p & ~(OBJ_MASK << shift)) | (val << shift);
> > +}
> > +
> > +static u8 rbd_object_map_get(struct rbd_device *rbd_dev, u64 objno)
> > +{
> > +       u8 state;
> > +
> > +       spin_lock(&rbd_dev->object_map_lock);
> > +       state = __rbd_object_map_get(rbd_dev, objno);
> > +       spin_unlock(&rbd_dev->object_map_lock);
> > +       return state;
> > +}
> > +
> > +static bool use_object_map(struct rbd_device *rbd_dev)
> > +{
> > +       return ((rbd_dev->header.features & RBD_FEATURE_OBJECT_MAP) &&
> > +               !(rbd_dev->object_map_flags & RBD_FLAG_OBJECT_MAP_INVALID));
> > +}
> > +
> > +static bool rbd_object_map_may_exist(struct rbd_device *rbd_dev, u64 objno)
> > +{
> > +       u8 state;
> > +
> > +       /* fall back to default logic if object map is disabled or invalid */
> > +       if (!use_object_map(rbd_dev))
> > +               return true;
> > +
> > +       state = rbd_object_map_get(rbd_dev, objno);
> > +       return state != OBJECT_NONEXISTENT;
> > +}
> > +
> > +static void rbd_object_map_name(struct rbd_device *rbd_dev, u64 snap_id,
> > +                               struct ceph_object_id *oid)
> > +{
> > +       if (snap_id == CEPH_NOSNAP)
> > +               ceph_oid_printf(oid, "%s%s", RBD_OBJECT_MAP_PREFIX,
> > +                               rbd_dev->spec->image_id);
> > +       else
> > +               ceph_oid_printf(oid, "%s%s.%016llx", RBD_OBJECT_MAP_PREFIX,
> > +                               rbd_dev->spec->image_id, snap_id);
> > +}
> > +
> > +static int rbd_object_map_lock(struct rbd_device *rbd_dev)
> > +{
> > +       struct ceph_osd_client *osdc = &rbd_dev->rbd_client->client->osdc;
> > +       CEPH_DEFINE_OID_ONSTACK(oid);
> > +       u8 lock_type;
> > +       char *lock_tag;
> > +       struct ceph_locker *lockers;
> > +       u32 num_lockers;
> > +       bool broke_lock = false;
> > +       int ret;
> > +
> > +       rbd_object_map_name(rbd_dev, CEPH_NOSNAP, &oid);
> > +
> > +again:
> > +       ret = ceph_cls_lock(osdc, &oid, &rbd_dev->header_oloc, RBD_LOCK_NAME,
> > +                           CEPH_CLS_LOCK_EXCLUSIVE, "", "", "", 0);
> > +       if (ret != -EBUSY || broke_lock) {
> > +               if (ret == -EEXIST)
> > +                       ret = 0; /* already locked by myself */
> > +               if (ret)
> > +                       rbd_warn(rbd_dev, "failed to lock object map: %d", ret);
> > +               return ret;
> > +
> > +       }
> > +
> > +       ret = ceph_cls_lock_info(osdc, &oid, &rbd_dev->header_oloc,
> > +                                RBD_LOCK_NAME, &lock_type, &lock_tag,
> > +                                &lockers, &num_lockers);
> > +       if (ret) {
> > +               if (ret == -ENOENT)
> > +                       goto again;
> > +
> > +               rbd_warn(rbd_dev, "failed to get object map lockers: %d", ret);
> > +               return ret;
> > +       }
> > +
> > +       kfree(lock_tag);
> > +       if (num_lockers == 0)
> > +               goto again;
> > +
> > +       rbd_warn(rbd_dev, "breaking object map lock owned by %s%llu",
> > +                ENTITY_NAME(lockers[0].id.name));
> > +
> > +       ret = ceph_cls_break_lock(osdc, &oid, &rbd_dev->header_oloc,
> > +                                 RBD_LOCK_NAME, lockers[0].id.cookie,
> > +                                 &lockers[0].id.name);
> > +       ceph_free_lockers(lockers, num_lockers);
> > +       if (ret) {
> > +               if (ret == -ENOENT)
> > +                       goto again;
> > +
> > +               rbd_warn(rbd_dev, "failed to break object map lock: %d", ret);
> > +               return ret;
> > +       }
> > +
> > +       broke_lock = true;
> > +       goto again;
> > +}
> > +
> > +static void rbd_object_map_unlock(struct rbd_device *rbd_dev)
> > +{
> > +       struct ceph_osd_client *osdc = &rbd_dev->rbd_client->client->osdc;
> > +       CEPH_DEFINE_OID_ONSTACK(oid);
> > +       int ret;
> > +
> > +       rbd_object_map_name(rbd_dev, CEPH_NOSNAP, &oid);
> > +
> > +       ret = ceph_cls_unlock(osdc, &oid, &rbd_dev->header_oloc, RBD_LOCK_NAME,
> > +                             "");
> > +       if (ret && ret != -ENOENT)
> > +               rbd_warn(rbd_dev, "failed to unlock object map: %d", ret);
> > +}
> > +
> > +static int decode_object_map_header(void **p, void *end, u64 *object_map_size)
> > +{
> > +       u8 struct_v;
> > +       u32 struct_len;
> > +       u32 header_len;
> > +       void *header_end;
> > +       int ret;
> > +
> > +       ceph_decode_32_safe(p, end, header_len, e_inval);
> > +       header_end = *p + header_len;
> > +
> > +       ret = ceph_start_decoding(p, end, 1, "BitVector header", &struct_v,
> > +                                 &struct_len);
> > +       if (ret)
> > +               return ret;
> > +
> > +       ceph_decode_64_safe(p, end, *object_map_size, e_inval);
> > +
> > +       *p = header_end;
> > +       return 0;
> > +
> > +e_inval:
> > +       return -EINVAL;
> > +}
> > +
> > +static int __rbd_object_map_load(struct rbd_device *rbd_dev)
> > +{
> > +       struct ceph_osd_client *osdc = &rbd_dev->rbd_client->client->osdc;
> > +       CEPH_DEFINE_OID_ONSTACK(oid);
> > +       struct page **pages;
> > +       void *p, *end;
> > +       size_t reply_len;
> > +       u64 num_objects;
> > +       u64 object_map_bytes;
> > +       u64 object_map_size;
> > +       int num_pages;
> > +       int ret;
> > +
> > +       rbd_assert(!rbd_dev->object_map && !rbd_dev->object_map_size);
> > +
> > +       num_objects = ceph_get_num_objects(&rbd_dev->layout,
> > +                                          rbd_dev->mapping.size);
> > +       object_map_bytes = DIV_ROUND_UP_ULL(num_objects * BITS_PER_OBJ,
> > +                                           BITS_PER_BYTE);
> > +       num_pages = calc_pages_for(0, object_map_bytes) + 1;
> > +       pages = ceph_alloc_page_vector(num_pages, GFP_KERNEL);
> > +       if (IS_ERR(pages))
> > +               return PTR_ERR(pages);
> > +
> > +       reply_len = num_pages * PAGE_SIZE;
> > +       rbd_object_map_name(rbd_dev, rbd_dev->spec->snap_id, &oid);
> > +       ret = ceph_osdc_call(osdc, &oid, &rbd_dev->header_oloc,
> > +                            "rbd", "object_map_load", CEPH_OSD_FLAG_READ,
> > +                            NULL, 0, pages, &reply_len);
> > +       if (ret)
> > +               goto out;
> > +
> > +       p = page_address(pages[0]);
> > +       end = p + min(reply_len, (size_t)PAGE_SIZE);
> > +       ret = decode_object_map_header(&p, end, &object_map_size);
> > +       if (ret)
> > +               goto out;
> > +
> > +       if (object_map_size != num_objects) {
> > +               rbd_warn(rbd_dev, "object map size mismatch: %llu vs %llu",
> > +                        object_map_size, num_objects);
> > +               ret = -EINVAL;
> > +               goto out;
> > +       }
> > +
> > +       if (offset_in_page(p) + object_map_bytes > reply_len) {
> > +               ret = -EINVAL;
> > +               goto out;
> > +       }
> > +
> > +       rbd_dev->object_map = kvmalloc(object_map_bytes, GFP_KERNEL);
> > +       if (!rbd_dev->object_map) {
> > +               ret = -ENOMEM;
> > +               goto out;
> > +       }
> > +
> > +       rbd_dev->object_map_size = object_map_size;
> > +       ceph_copy_from_page_vector(pages, rbd_dev->object_map,
> > +                                  offset_in_page(p), object_map_bytes);
> > +
> > +out:
> > +       ceph_release_page_vector(pages, num_pages);
> > +       return ret;
> > +}
> > +
> > +static void rbd_object_map_free(struct rbd_device *rbd_dev)
> > +{
> > +       kvfree(rbd_dev->object_map);
> > +       rbd_dev->object_map = NULL;
> > +       rbd_dev->object_map_size = 0;
> > +}
> > +
> > +static int rbd_object_map_load(struct rbd_device *rbd_dev)
> > +{
> > +       int ret;
> > +
> > +       ret = __rbd_object_map_load(rbd_dev);
> > +       if (ret)
> > +               return ret;
> > +
> > +       ret = rbd_dev_v2_get_flags(rbd_dev);
> > +       if (ret) {
> > +               rbd_object_map_free(rbd_dev);
> > +               return ret;
> > +       }
> > +
> > +       if (rbd_dev->object_map_flags & RBD_FLAG_OBJECT_MAP_INVALID)
> > +               rbd_warn(rbd_dev, "object map is invalid");
> > +
> > +       return 0;
> > +}
> > +
> > +static int rbd_object_map_open(struct rbd_device *rbd_dev)
> > +{
> > +       int ret;
> > +
> > +       ret = rbd_object_map_lock(rbd_dev);
>
> Only lock/unlock if rbd_dev->spec.snap_id == CEPH_NOSNAP?

This is called for only for HEAD.  For snapshots, rbd_object_map_load()
is called directly.

>
> > +       if (ret)
> > +               return ret;
> > +
> > +       ret = rbd_object_map_load(rbd_dev);
> > +       if (ret) {
> > +               rbd_object_map_unlock(rbd_dev);
> > +               return ret;
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> > +static void rbd_object_map_close(struct rbd_device *rbd_dev)
> > +{
> > +       rbd_object_map_free(rbd_dev);
> > +       rbd_object_map_unlock(rbd_dev);
> > +}
> > +
> > +/*
> > + * This function needs snap_id (or more precisely just something to
> > + * distinguish between HEAD and snapshot object maps), new_state and
> > + * current_state that were passed to rbd_object_map_update().
> > + *
> > + * To avoid allocating and stashing a context we piggyback on the OSD
> > + * request.  A HEAD update has two ops (assert_locked).  For new_state
> > + * and current_state we decode our own object_map_update op, encoded in
> > + * rbd_cls_object_map_update().
>
> Decoding the OSD request seems a little awkward. Since you would only
> update the in-memory state for the HEAD revision, could you just stash
> these fields in the "rbd_object_request" struct? Then in
> "rbd_object_map_update", set the callback to either a
> "rbd_object_map_snapshot_callback" callback or
> "rbd_object_map_head_callback".

We do something similar is libceph, where we re-encode MOSDOp from one
version to another on the fly.  Given that rbd_object_map_update_finish()
decodes something that has been encoded by its sister function, I'm not
worried.  We could stash snap_id, new_state and current_state in obj_req,
but that would grow it, including when object-map feature is disabled.

>
> > + */
> > +static int rbd_object_map_update_finish(struct rbd_obj_request *obj_req,
> > +                                       struct ceph_osd_request *osd_req)
> > +{
> > +       struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
> > +       struct ceph_osd_data *osd_data;
> > +       u64 objno;
> > +       u8 state, new_state, current_state;
> > +       bool has_current_state;
> > +       void *p;
> > +
> > +       if (osd_req->r_result)
> > +               return osd_req->r_result;
> > +
> > +       /*
> > +        * Nothing to do for a snapshot object map.
> > +        */
> > +       if (osd_req->r_num_ops == 1)
> > +               return 0;
> > +
> > +       /*
> > +        * Update in-memory HEAD object map.
> > +        */
> > +       rbd_assert(osd_req->r_num_ops == 2);
> > +       osd_data = osd_req_op_data(osd_req, 1, cls, request_data);
> > +       rbd_assert(osd_data->type == CEPH_OSD_DATA_TYPE_PAGES);
> > +
> > +       p = page_address(osd_data->pages[0]);
> > +       objno = ceph_decode_64(&p);
> > +       rbd_assert(objno == obj_req->ex.oe_objno);
> > +       rbd_assert(ceph_decode_64(&p) == objno + 1);
> > +       new_state = ceph_decode_8(&p);
> > +       has_current_state = ceph_decode_8(&p);
> > +       if (has_current_state)
> > +               current_state = ceph_decode_8(&p);
> > +
> > +       spin_lock(&rbd_dev->object_map_lock);
> > +       state = __rbd_object_map_get(rbd_dev, objno);
> > +       if (!has_current_state || current_state == state ||
> > +           (current_state == OBJECT_EXISTS && state == OBJECT_EXISTS_CLEAN))
> > +               __rbd_object_map_set(rbd_dev, objno, new_state);
> > +       spin_unlock(&rbd_dev->object_map_lock);
> > +
> > +       return 0;
> > +}
> > +
> > +static void rbd_object_map_callback(struct ceph_osd_request *osd_req)
> > +{
> > +       struct rbd_obj_request *obj_req = osd_req->r_priv;
> > +       int result;
> > +
> > +       dout("%s osd_req %p result %d for obj_req %p\n", __func__, osd_req,
> > +            osd_req->r_result, obj_req);
> > +
> > +       result = rbd_object_map_update_finish(obj_req, osd_req);
> > +       rbd_obj_handle_request(obj_req, result);
> > +}
> > +
> > +static bool update_needed(struct rbd_device *rbd_dev, u64 objno, u8 new_state)
> > +{
> > +       u8 state = rbd_object_map_get(rbd_dev, objno);
> > +
> > +       if (state == new_state ||
> > +           (new_state == OBJECT_PENDING && state == OBJECT_NONEXISTENT) ||
> > +           (new_state == OBJECT_NONEXISTENT && state != OBJECT_PENDING))
> > +               return false;
> > +
> > +       return true;
> > +}
> > +
> > +static int rbd_cls_object_map_update(struct ceph_osd_request *req,
> > +                                    int which, u64 objno, u8 new_state,
> > +                                    const u8 *current_state)
> > +{
> > +       struct page **pages;
> > +       void *p, *start;
> > +       int ret;
> > +
> > +       ret = osd_req_op_cls_init(req, which, "rbd", "object_map_update");
> > +       if (ret)
> > +               return ret;
> > +
> > +       pages = ceph_alloc_page_vector(1, GFP_NOIO);
> > +       if (IS_ERR(pages))
> > +               return PTR_ERR(pages);
> > +
> > +       p = start = page_address(pages[0]);
> > +       ceph_encode_64(&p, objno);
> > +       ceph_encode_64(&p, objno + 1);
> > +       ceph_encode_8(&p, new_state);
> > +       if (current_state) {
> > +               ceph_encode_8(&p, 1);
> > +               ceph_encode_8(&p, *current_state);
> > +       } else {
> > +               ceph_encode_8(&p, 0);
> > +       }
> > +
> > +       osd_req_op_cls_request_data_pages(req, which, pages, p - start, 0,
> > +                                         false, true);
> > +       return 0;
> > +}
> > +
> > +/*
> > + * Return:
> > + *   0 - object map update sent
> > + *   1 - object map update isn't needed
> > + *  <0 - error
> > + */
> > +static int rbd_object_map_update(struct rbd_obj_request *obj_req, u64 snap_id,
> > +                                u8 new_state, const u8 *current_state)
> > +{
> > +       struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
> > +       struct ceph_osd_client *osdc = &rbd_dev->rbd_client->client->osdc;
> > +       struct ceph_osd_request *req;
> > +       int num_ops = 1;
> > +       int which = 0;
> > +       int ret;
> > +
> > +       if (snap_id == CEPH_NOSNAP) {
> > +               if (!update_needed(rbd_dev, obj_req->ex.oe_objno, new_state))
> > +                       return 1;
> > +
> > +               num_ops++; /* assert_locked */
> > +       }
> > +
> > +       req = ceph_osdc_alloc_request(osdc, NULL, num_ops, false, GFP_NOIO);
> > +       if (!req)
> > +               return -ENOMEM;
> > +
> > +       list_add_tail(&req->r_unsafe_item, &obj_req->osd_reqs);
> > +       req->r_callback = rbd_object_map_callback;
> > +       req->r_priv = obj_req;
> > +
> > +       rbd_object_map_name(rbd_dev, snap_id, &req->r_base_oid);
> > +       ceph_oloc_copy(&req->r_base_oloc, &rbd_dev->header_oloc);
> > +       req->r_flags = CEPH_OSD_FLAG_WRITE;
> > +       ktime_get_real_ts64(&req->r_mtime);
> > +
> > +       if (snap_id == CEPH_NOSNAP) {
> > +               /*
> > +                * Protect against possible race conditions during lock
> > +                * ownership transitions.
> > +                */
> > +               ret = ceph_cls_assert_locked(req, which++, RBD_LOCK_NAME,
> > +                                            CEPH_CLS_LOCK_EXCLUSIVE, "", "");
> > +               if (ret)
> > +                       return ret;
> > +       }
> > +
> > +       ret = rbd_cls_object_map_update(req, which, obj_req->ex.oe_objno,
> > +                                       new_state, current_state);
> > +       if (ret)
> > +               return ret;
> > +
> > +       ret = ceph_osdc_alloc_messages(req, GFP_NOIO);
> > +       if (ret)
> > +               return ret;
> > +
> > +       ceph_osdc_start_request(osdc, req, false);
> > +       return 0;
> > +}
> > +
> >  static void prune_extents(struct ceph_file_extent *img_extents,
> >                           u32 *num_img_extents, u64 overlap)
> >  {
> > @@ -1975,6 +2452,7 @@ static int rbd_obj_init_discard(struct rbd_obj_request *obj_req)
> >         if (ret)
> >                 return ret;
> >
> > +       obj_req->flags |= RBD_OBJ_FLAG_NOOP_FOR_NONEXISTENT;
> >         if (rbd_obj_is_entire(obj_req) && !obj_req->num_img_extents)
> >                 obj_req->flags |= RBD_OBJ_FLAG_DELETION;
> >
> > @@ -2022,6 +2500,7 @@ static int rbd_obj_init_zeroout(struct rbd_obj_request *obj_req)
> >         if (rbd_obj_copyup_enabled(obj_req))
> >                 obj_req->flags |= RBD_OBJ_FLAG_COPYUP_ENABLED;
> >         if (!obj_req->num_img_extents) {
> > +               obj_req->flags |= RBD_OBJ_FLAG_NOOP_FOR_NONEXISTENT;
> >                 if (rbd_obj_is_entire(obj_req))
> >                         obj_req->flags |= RBD_OBJ_FLAG_DELETION;
> >         }
> > @@ -2407,6 +2886,20 @@ static void rbd_img_schedule(struct rbd_img_request *img_req, int result)
> >         queue_work(rbd_wq, &img_req->work);
> >  }
> >
> > +static bool rbd_obj_may_exist(struct rbd_obj_request *obj_req)
> > +{
> > +       struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
> > +
> > +       if (rbd_object_map_may_exist(rbd_dev, obj_req->ex.oe_objno)) {
> > +               obj_req->flags |= RBD_OBJ_FLAG_MAY_EXIST;
> > +               return true;
> > +       }
> > +
> > +       dout("%s %p objno %llu assuming dne\n", __func__, obj_req,
> > +            obj_req->ex.oe_objno);
> > +       return false;
> > +}
> > +
> >  static int rbd_obj_read_object(struct rbd_obj_request *obj_req)
> >  {
> >         struct ceph_osd_request *osd_req;
> > @@ -2482,10 +2975,17 @@ static bool rbd_obj_advance_read(struct rbd_obj_request *obj_req, int *result)
> >         struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
> >         int ret;
> >
> > +again:
> >         switch (obj_req->read_state) {
> >         case RBD_OBJ_READ_START:
> >                 rbd_assert(!*result);
> >
> > +               if (!rbd_obj_may_exist(obj_req)) {
> > +                       *result = -ENOENT;
> > +                       obj_req->read_state = RBD_OBJ_READ_OBJECT;
> > +                       goto again;
> > +               }
> > +
> >                 ret = rbd_obj_read_object(obj_req);
> >                 if (ret) {
> >                         *result = ret;
> > @@ -2536,6 +3036,44 @@ static bool rbd_obj_advance_read(struct rbd_obj_request *obj_req, int *result)
> >         }
> >  }
> >
> > +static bool rbd_obj_write_is_noop(struct rbd_obj_request *obj_req)
> > +{
> > +       struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
> > +
> > +       if (rbd_object_map_may_exist(rbd_dev, obj_req->ex.oe_objno))
> > +               obj_req->flags |= RBD_OBJ_FLAG_MAY_EXIST;
> > +
> > +       if (!(obj_req->flags & RBD_OBJ_FLAG_MAY_EXIST) &&
> > +           (obj_req->flags & RBD_OBJ_FLAG_NOOP_FOR_NONEXISTENT)) {
> > +               dout("%s %p noop for nonexistent\n", __func__, obj_req);
> > +               return true;
> > +       }
> > +
> > +       return false;
> > +}
> > +
> > +/*
> > + * Return:
> > + *   0 - object map update sent
> > + *   1 - object map update isn't needed
> > + *  <0 - error
> > + */
> > +static int rbd_obj_write_pre_object_map(struct rbd_obj_request *obj_req)
> > +{
> > +       struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
> > +       u8 new_state;
> > +
> > +       if (!(rbd_dev->header.features & RBD_FEATURE_OBJECT_MAP))
> > +               return 1;
> > +
> > +       if (obj_req->flags & RBD_OBJ_FLAG_DELETION)
> > +               new_state = OBJECT_PENDING;
> > +       else
> > +               new_state = OBJECT_EXISTS;
> > +
> > +       return rbd_object_map_update(obj_req, CEPH_NOSNAP, new_state, NULL);
> > +}
> > +
> >  static int rbd_obj_write_object(struct rbd_obj_request *obj_req)
> >  {
> >         struct ceph_osd_request *osd_req;
> > @@ -2706,6 +3244,41 @@ static int rbd_obj_copyup_read_parent(struct rbd_obj_request *obj_req)
> >         return rbd_obj_read_from_parent(obj_req);
> >  }
> >
> > +static void rbd_obj_copyup_object_maps(struct rbd_obj_request *obj_req)
> > +{
> > +       struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
> > +       struct ceph_snap_context *snapc = obj_req->img_request->snapc;
> > +       u8 new_state;
> > +       u32 i;
> > +       int ret;
> > +
> > +       rbd_assert(!obj_req->pending.result && !obj_req->pending.num_pending);
> > +
> > +       if (!(rbd_dev->header.features & RBD_FEATURE_OBJECT_MAP))
> > +               return;
> > +
> > +       if (obj_req->flags & RBD_OBJ_FLAG_COPYUP_ZEROS)
> > +               return;
> > +
> > +       for (i = 0; i < snapc->num_snaps; i++) {
> > +               if ((rbd_dev->header.features & RBD_FEATURE_FAST_DIFF) &&
> > +                   i + 1 < snapc->num_snaps)
> > +                       new_state = OBJECT_EXISTS_CLEAN;
> > +               else
> > +                       new_state = OBJECT_EXISTS;
> > +
> > +               ret = rbd_object_map_update(obj_req, snapc->snaps[i],
> > +                                           new_state, NULL);
> > +               if (ret < 0) {
> > +                       obj_req->pending.result = ret;
> > +                       return;
> > +               }
> > +
> > +               rbd_assert(!ret);
> > +               obj_req->pending.num_pending++;
> > +       }
> > +}
> > +
> >  static void rbd_obj_copyup_write_object(struct rbd_obj_request *obj_req)
> >  {
> >         u32 bytes = rbd_obj_img_extents_bytes(obj_req);
> > @@ -2749,6 +3322,7 @@ static void rbd_obj_copyup_write_object(struct rbd_obj_request *obj_req)
> >
> >  static bool rbd_obj_advance_copyup(struct rbd_obj_request *obj_req, int *result)
> >  {
> > +       struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
> >         int ret;
> >
> >  again:
> > @@ -2776,6 +3350,25 @@ static bool rbd_obj_advance_copyup(struct rbd_obj_request *obj_req, int *result)
> >                         obj_req->flags |= RBD_OBJ_FLAG_COPYUP_ZEROS;
> >                 }
> >
> > +               rbd_obj_copyup_object_maps(obj_req);
> > +               if (!obj_req->pending.num_pending) {
> > +                       *result = obj_req->pending.result;
> > +                       obj_req->copyup_state = RBD_OBJ_COPYUP_OBJECT_MAPS;
> > +                       goto again;
> > +               }
> > +               obj_req->copyup_state = __RBD_OBJ_COPYUP_OBJECT_MAPS;
> > +               return false;
> > +       case __RBD_OBJ_COPYUP_OBJECT_MAPS:
> > +               if (!pending_result_dec(&obj_req->pending, result))
> > +                       return false;
> > +               /* fall through */
> > +       case RBD_OBJ_COPYUP_OBJECT_MAPS:
> > +               if (*result) {
> > +                       rbd_warn(rbd_dev, "snap object map update failed: %d",
> > +                                *result);
> > +                       return true;
> > +               }
> > +
> >                 rbd_obj_copyup_write_object(obj_req);
> >                 if (!obj_req->pending.num_pending) {
> >                         *result = obj_req->pending.result;
> > @@ -2795,6 +3388,27 @@ static bool rbd_obj_advance_copyup(struct rbd_obj_request *obj_req, int *result)
> >         }
> >  }
> >
> > +/*
> > + * Return:
> > + *   0 - object map update sent
> > + *   1 - object map update isn't needed
> > + *  <0 - error
> > + */
> > +static int rbd_obj_write_post_object_map(struct rbd_obj_request *obj_req)
> > +{
> > +       struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
> > +       u8 current_state = OBJECT_PENDING;
> > +
> > +       if (!(rbd_dev->header.features & RBD_FEATURE_OBJECT_MAP))
> > +               return 1;
> > +
> > +       if (!(obj_req->flags & RBD_OBJ_FLAG_DELETION))
> > +               return 1;
> > +
> > +       return rbd_object_map_update(obj_req, CEPH_NOSNAP, OBJECT_NONEXISTENT,
> > +                                    &current_state);
> > +}
> > +
> >  static bool rbd_obj_advance_write(struct rbd_obj_request *obj_req, int *result)
> >  {
> >         struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
> > @@ -2805,6 +3419,24 @@ static bool rbd_obj_advance_write(struct rbd_obj_request *obj_req, int *result)
> >         case RBD_OBJ_WRITE_START:
> >                 rbd_assert(!*result);
> >
> > +               if (rbd_obj_write_is_noop(obj_req))
> > +                       return true;
>
> Does this properly handle the case where it has a parent overlap? If
> the child object doesn't exist, we would still want to perform the
> copyup (if required), correct?

It should.  rbd_obj_write_is_noop() returns true only if
RBD_OBJ_FLAG_NOOP_FOR_NONEXISTENT is set.  For discard it's set
unconditionally because we never perform the copyup.  For zeroout
it's set only if there is no parent overlap (and therefore no need
to perform the copyup).  See rbd_obj_init_{discard,zeroout}().

>
> > +               ret = rbd_obj_write_pre_object_map(obj_req);
> > +               if (ret < 0) {
> > +                       *result = ret;
> > +                       return true;
> > +               }
> > +               obj_req->write_state = RBD_OBJ_WRITE_PRE_OBJECT_MAP;
> > +               if (ret > 0)
> > +                       goto again;
> > +               return false;
> > +       case RBD_OBJ_WRITE_PRE_OBJECT_MAP:
> > +               if (*result) {
> > +                       rbd_warn(rbd_dev, "pre object map update failed: %d",
> > +                                *result);
> > +                       return true;
> > +               }
> >                 ret = rbd_obj_write_object(obj_req);
> >                 if (ret) {
> >                         *result = ret;
> > @@ -2837,8 +3469,23 @@ static bool rbd_obj_advance_write(struct rbd_obj_request *obj_req, int *result)
> >                         return false;
> >                 /* fall through */
> >         case RBD_OBJ_WRITE_COPYUP:
> > -               if (*result)
> > +               if (*result) {
> >                         rbd_warn(rbd_dev, "copyup failed: %d", *result);
> > +                       return true;
> > +               }
> > +               ret = rbd_obj_write_post_object_map(obj_req);
> > +               if (ret < 0) {
> > +                       *result = ret;
> > +                       return true;
> > +               }
> > +               obj_req->write_state = RBD_OBJ_WRITE_POST_OBJECT_MAP;
> > +               if (ret > 0)
> > +                       goto again;
> > +               return false;
> > +       case RBD_OBJ_WRITE_POST_OBJECT_MAP:
> > +               if (*result)
> > +                       rbd_warn(rbd_dev, "post object map update failed: %d",
> > +                                *result);
> >                 return true;
> >         default:
> >                 BUG();
> > @@ -2892,7 +3539,8 @@ static bool need_exclusive_lock(struct rbd_img_request *img_req)
> >                 return false;
> >
> >         rbd_assert(!test_bit(IMG_REQ_CHILD, &img_req->flags));
> > -       if (rbd_dev->opts->lock_on_read)
> > +       if (rbd_dev->opts->lock_on_read ||
> > +           (rbd_dev->header.features & RBD_FEATURE_OBJECT_MAP))
> >                 return true;
> >
> >         return rbd_img_is_write(img_req);
> > @@ -3427,7 +4075,7 @@ static int rbd_try_lock(struct rbd_device *rbd_dev)
> >                 if (ret)
> >                         goto out; /* request lock or error */
> >
> > -               rbd_warn(rbd_dev, "%s%llu seems dead, breaking lock",
> > +               rbd_warn(rbd_dev, "breaking header lock owned by %s%llu",
> >                          ENTITY_NAME(lockers[0].id.name));
> >
> >                 ret = ceph_monc_blacklist_add(&client->monc,
> > @@ -3454,6 +4102,19 @@ static int rbd_try_lock(struct rbd_device *rbd_dev)
> >         return ret;
> >  }
> >
> > +static int rbd_post_acquire_action(struct rbd_device *rbd_dev)
> > +{
> > +       int ret;
> > +
> > +       if (rbd_dev->header.features & RBD_FEATURE_OBJECT_MAP) {
> > +               ret = rbd_object_map_open(rbd_dev);
> > +               if (ret)
> > +                       return ret;
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> >  /*
> >   * Return:
> >   *   0 - lock acquired
> > @@ -3497,6 +4158,17 @@ static int rbd_try_acquire_lock(struct rbd_device *rbd_dev)
> >         rbd_assert(rbd_dev->lock_state == RBD_LOCK_STATE_LOCKED);
> >         rbd_assert(list_empty(&rbd_dev->running_list));
> >
> > +       ret = rbd_post_acquire_action(rbd_dev);
> > +       if (ret) {
> > +               rbd_warn(rbd_dev, "post-acquire action failed: %d", ret);
> > +               /*
> > +                * Can't stay in RBD_LOCK_STATE_LOCKED because
> > +                * rbd_lock_add_request() would let the request through,
> > +                * assuming that e.g. object map is locked and loaded.
> > +                */
> > +               rbd_unlock(rbd_dev);
> > +       }
> > +
> >  out:
> >         wake_requests(rbd_dev, ret);
> >         up_write(&rbd_dev->lock_rwsem);
> > @@ -3570,10 +4242,17 @@ static bool rbd_quiesce_lock(struct rbd_device *rbd_dev)
> >         return true;
> >  }
> >
> > +static void rbd_pre_release_action(struct rbd_device *rbd_dev)
> > +{
> > +       if (rbd_dev->header.features & RBD_FEATURE_OBJECT_MAP)
> > +               rbd_object_map_close(rbd_dev);
> > +}
> > +
> >  static void __rbd_release_lock(struct rbd_device *rbd_dev)
> >  {
> >         rbd_assert(list_empty(&rbd_dev->running_list));
> >
> > +       rbd_pre_release_action(rbd_dev);
> >         rbd_unlock(rbd_dev);
> >  }
> >
> > @@ -4860,6 +5539,8 @@ static struct rbd_device *__rbd_dev_create(struct rbd_client *rbdc,
> >         init_completion(&rbd_dev->acquire_wait);
> >         init_completion(&rbd_dev->releasing_wait);
> >
> > +       spin_lock_init(&rbd_dev->object_map_lock);
> > +
> >         rbd_dev->dev.bus = &rbd_bus_type;
> >         rbd_dev->dev.type = &rbd_device_type;
> >         rbd_dev->dev.parent = &rbd_root_dev;
> > @@ -5041,6 +5722,32 @@ static int rbd_dev_v2_features(struct rbd_device *rbd_dev)
> >                                                 &rbd_dev->header.features);
> >  }
> >
> > +/*
> > + * These are generic image flags, but since they are used only for
> > + * object map, store them in rbd_dev->object_map_flags.
> > + *
> > + * For the same reason, this function is called only on object map
> > + * (re)load and not on header refresh.
> > + */
> > +static int rbd_dev_v2_get_flags(struct rbd_device *rbd_dev)
> > +{
> > +       __le64 snapid = cpu_to_le64(rbd_dev->spec->snap_id);
> > +       __le64 flags;
> > +       int ret;
> > +
> > +       ret = rbd_obj_method_sync(rbd_dev, &rbd_dev->header_oid,
> > +                                 &rbd_dev->header_oloc, "get_flags",
> > +                                 &snapid, sizeof(snapid),
> > +                                 &flags, sizeof(flags));
> > +       if (ret < 0)
> > +               return ret;
> > +       if (ret < sizeof(flags))
> > +               return -EBADMSG;
> > +
> > +       rbd_dev->object_map_flags = le64_to_cpu(flags);
> > +       return 0;
> > +}
> > +
> >  struct parent_image_info {
> >         u64             pool_id;
> >         const char      *pool_ns;
> > @@ -6014,6 +6721,7 @@ static void rbd_dev_unprobe(struct rbd_device *rbd_dev)
> >         struct rbd_image_header *header;
> >
> >         rbd_dev_parent_put(rbd_dev);
> > +       rbd_object_map_free(rbd_dev);
> >         rbd_dev_mapping_clear(rbd_dev);
> >
> >         /* Free dynamic fields from the header, then zero it out */
> > @@ -6263,6 +6971,13 @@ static int rbd_dev_image_probe(struct rbd_device *rbd_dev, int depth)
> >         if (ret)
> >                 goto err_out_probe;
> >
> > +       if (rbd_dev->spec->snap_id != CEPH_NOSNAP &&
> > +           (rbd_dev->header.features & RBD_FEATURE_OBJECT_MAP)) {
> > +               ret = rbd_object_map_load(rbd_dev);
> > +               if (ret)
> > +                       goto err_out_probe;
> > +       }
> > +
> >         if (rbd_dev->header.features & RBD_FEATURE_LAYERING) {
> >                 ret = rbd_dev_v2_parent_info(rbd_dev);
> >                 if (ret)
> > diff --git a/drivers/block/rbd_types.h b/drivers/block/rbd_types.h
> > index 62ff50d3e7a6..ac98ab6ccd3b 100644
> > --- a/drivers/block/rbd_types.h
> > +++ b/drivers/block/rbd_types.h
> > @@ -18,6 +18,7 @@
> >  /* For format version 2, rbd image 'foo' consists of objects
> >   *   rbd_id.foo                - id of image
> >   *   rbd_header.<id>   - image metadata
> > + *   rbd_object_map.<id> - optional image object map
> >   *   rbd_data.<id>.0000000000000000
> >   *   rbd_data.<id>.0000000000000001
> >   *   ...               - data
> > @@ -25,6 +26,7 @@
> >   */
> >
> >  #define RBD_HEADER_PREFIX      "rbd_header."
> > +#define RBD_OBJECT_MAP_PREFIX  "rbd_object_map."
> >  #define RBD_ID_PREFIX          "rbd_id."
> >  #define RBD_V2_DATA_FORMAT     "%s.%016llx"
> >
> > @@ -39,6 +41,14 @@ enum rbd_notify_op {
> >         RBD_NOTIFY_OP_HEADER_UPDATE      = 3,
> >  };
> >
> > +#define OBJECT_NONEXISTENT     0
> > +#define OBJECT_EXISTS          1
> > +#define OBJECT_PENDING         2
> > +#define OBJECT_EXISTS_CLEAN    3
> > +
> > +#define RBD_FLAG_OBJECT_MAP_INVALID    (1ULL << 0)
> > +#define RBD_FLAG_FAST_DIFF_INVALID     (1ULL << 1)
> > +
> >  /*
> >   * For format version 1, rbd image 'foo' consists of objects
> >   *   foo.rbd           - image metadata
> > diff --git a/include/linux/ceph/cls_lock_client.h b/include/linux/ceph/cls_lock_client.h
> > index bea6c77d2093..17bc7584d1fe 100644
> > --- a/include/linux/ceph/cls_lock_client.h
> > +++ b/include/linux/ceph/cls_lock_client.h
> > @@ -52,4 +52,7 @@ int ceph_cls_lock_info(struct ceph_osd_client *osdc,
> >                        char *lock_name, u8 *type, char **tag,
> >                        struct ceph_locker **lockers, u32 *num_lockers);
> >
> > +int ceph_cls_assert_locked(struct ceph_osd_request *req, int which,
> > +                          char *lock_name, u8 type, char *cookie, char *tag);
> > +
> >  #endif
> > diff --git a/include/linux/ceph/striper.h b/include/linux/ceph/striper.h
> > index cbd0d24b7148..3486636c0e6e 100644
> > --- a/include/linux/ceph/striper.h
> > +++ b/include/linux/ceph/striper.h
> > @@ -66,4 +66,6 @@ int ceph_extent_to_file(struct ceph_file_layout *l,
> >                         struct ceph_file_extent **file_extents,
> >                         u32 *num_file_extents);
> >
> > +u64 ceph_get_num_objects(struct ceph_file_layout *l, u64 size);
> > +
> >  #endif
> > diff --git a/net/ceph/cls_lock_client.c b/net/ceph/cls_lock_client.c
> > index 56bbfe01e3ac..99cce6f3ec48 100644
> > --- a/net/ceph/cls_lock_client.c
> > +++ b/net/ceph/cls_lock_client.c
> > @@ -6,6 +6,7 @@
> >
> >  #include <linux/ceph/cls_lock_client.h>
> >  #include <linux/ceph/decode.h>
> > +#include <linux/ceph/libceph.h>
> >
> >  /**
> >   * ceph_cls_lock - grab rados lock for object
> > @@ -375,3 +376,47 @@ int ceph_cls_lock_info(struct ceph_osd_client *osdc,
> >         return ret;
> >  }
> >  EXPORT_SYMBOL(ceph_cls_lock_info);
> > +
> > +int ceph_cls_assert_locked(struct ceph_osd_request *req, int which,
> > +                          char *lock_name, u8 type, char *cookie, char *tag)
> > +{
> > +       int assert_op_buf_size;
> > +       int name_len = strlen(lock_name);
> > +       int cookie_len = strlen(cookie);
> > +       int tag_len = strlen(tag);
> > +       struct page **pages;
> > +       void *p, *end;
> > +       int ret;
> > +
> > +       assert_op_buf_size = name_len + sizeof(__le32) +
> > +                            cookie_len + sizeof(__le32) +
> > +                            tag_len + sizeof(__le32) +
> > +                            sizeof(u8) + CEPH_ENCODING_START_BLK_LEN;
> > +       if (assert_op_buf_size > PAGE_SIZE)
> > +               return -E2BIG;
> > +
> > +       ret = osd_req_op_cls_init(req, which, "lock", "assert_locked");
> > +       if (ret)
> > +               return ret;
> > +
> > +       pages = ceph_alloc_page_vector(1, GFP_NOIO);
> > +       if (IS_ERR(pages))
> > +               return PTR_ERR(pages);
> > +
> > +       p = page_address(pages[0]);
> > +       end = p + assert_op_buf_size;
> > +
> > +       /* encode cls_lock_assert_op struct */
> > +       ceph_start_encoding(&p, 1, 1,
> > +                           assert_op_buf_size - CEPH_ENCODING_START_BLK_LEN);
> > +       ceph_encode_string(&p, end, lock_name, name_len);
> > +       ceph_encode_8(&p, type);
> > +       ceph_encode_string(&p, end, cookie, cookie_len);
> > +       ceph_encode_string(&p, end, tag, tag_len);
> > +       WARN_ON(p != end);
> > +
> > +       osd_req_op_cls_request_data_pages(req, which, pages, assert_op_buf_size,
> > +                                         0, false, true);
> > +       return 0;
> > +}
> > +EXPORT_SYMBOL(ceph_cls_assert_locked);
> > diff --git a/net/ceph/striper.c b/net/ceph/striper.c
> > index c36462dc86b7..3b3fa75d1189 100644
> > --- a/net/ceph/striper.c
> > +++ b/net/ceph/striper.c
> > @@ -259,3 +259,20 @@ int ceph_extent_to_file(struct ceph_file_layout *l,
> >         return 0;
> >  }
> >  EXPORT_SYMBOL(ceph_extent_to_file);
> > +
> > +u64 ceph_get_num_objects(struct ceph_file_layout *l, u64 size)
> > +{
> > +       u64 period = (u64)l->stripe_count * l->object_size;
> > +       u64 num_periods = DIV64_U64_ROUND_UP(size, period);
> > +       u64 remainder_bytes;
> > +       u64 remainder_objs = 0;
> > +
> > +       div64_u64_rem(size, period, &remainder_bytes);
> > +       if (remainder_bytes > 0 &&
> > +           remainder_bytes < (u64)l->stripe_count * l->stripe_unit)
> > +               remainder_objs = l->stripe_count -
> > +                           DIV_ROUND_UP_ULL(remainder_bytes, l->stripe_unit);
> > +
> > +       return num_periods * l->stripe_count - remainder_objs;
> > +}
> > +EXPORT_SYMBOL(ceph_get_num_objects);
> > --
> > 2.19.2
> >
>
> Nit: might have been nice to break this one commit into several smaller commits.

It's all new static functions that don't make sense on their own with
just a couple of existing lines changed.  I didn't see a sensible set
of smaller commits to break this into (unused function warnings, etc).

Thanks,

                Ilya
