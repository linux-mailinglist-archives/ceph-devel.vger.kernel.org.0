Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 464A721136C
	for <lists+ceph-devel@lfdr.de>; Wed,  1 Jul 2020 21:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbgGATWc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 1 Jul 2020 15:22:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:36794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725771AbgGATWc (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 1 Jul 2020 15:22:32 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CE4D20760;
        Wed,  1 Jul 2020 19:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593631351;
        bh=QL5CFli14OMqjIwQb1oppxHzWfb4Fg3SZz0V/wqtvro=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fNXd+H9R1Nv6Y6XCN0Cj6PA3hCVoVChV8GXvReAQJi82/axTJzb8jm0j8RSGNTWNl
         c/WqZYiZkApwAugj1TVRFw1FB54oovANK0HNaLJUN+73ObDx3MXB9ArneNT9iYUtdJ
         Y6FCjYCtxUN+hJtpF3hfiJ0aR4VLg9K1YgbmnOIk=
Message-ID: <ca4f307a56bb893edcbaa867f923f29378a67d2a.camel@kernel.org>
Subject: Re: [PATCH 4/4] libceph/ceph: move ceph_osdc_new_request into
 ceph.ko
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Date:   Wed, 01 Jul 2020 15:22:30 -0400
In-Reply-To: <CAOi1vP9zV+BRLqFcO4jmVGN_WN=wPRZjBRCBzXM1EdTcstE2Tw@mail.gmail.com>
References: <20200701155446.41141-1-jlayton@kernel.org>
         <20200701155446.41141-5-jlayton@kernel.org>
         <CAOi1vP9zV+BRLqFcO4jmVGN_WN=wPRZjBRCBzXM1EdTcstE2Tw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2020-07-01 at 21:15 +0200, Ilya Dryomov wrote:
> On Wed, Jul 1, 2020 at 5:54 PM Jeff Layton <jlayton@kernel.org> wrote:
> > ceph_osdc_new_request is cephfs specific. Move it and calc_layout into
> > ceph.ko. Also, calc_layout can be void return.
> > 
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/ceph/Makefile                |   2 +-
> >  fs/ceph/addr.c                  |   1 +
> >  fs/ceph/file.c                  |   1 +
> >  fs/ceph/osdc.c                  | 113 +++++++++++++++++++++++++++++++
> >  fs/ceph/osdc.h                  |  16 +++++
> >  include/linux/ceph/osd_client.h |  10 ---
> >  net/ceph/osd_client.c           | 115 --------------------------------
> >  7 files changed, 132 insertions(+), 126 deletions(-)
> >  create mode 100644 fs/ceph/osdc.c
> >  create mode 100644 fs/ceph/osdc.h
> > 
> > diff --git a/fs/ceph/Makefile b/fs/ceph/Makefile
> > index 50c635dc7f71..f2ec52fa8d37 100644
> > --- a/fs/ceph/Makefile
> > +++ b/fs/ceph/Makefile
> > @@ -8,7 +8,7 @@ obj-$(CONFIG_CEPH_FS) += ceph.o
> >  ceph-y := super.o inode.o dir.o file.o locks.o addr.o ioctl.o \
> >         export.o caps.o snap.o xattr.o quota.o io.o \
> >         mds_client.o mdsmap.o strings.o ceph_frag.o \
> > -       debugfs.o util.o metric.o
> > +       debugfs.o util.o metric.o osdc.o
> > 
> >  ceph-$(CONFIG_CEPH_FSCACHE) += cache.o
> >  ceph-$(CONFIG_CEPH_FS_POSIX_ACL) += acl.o
> > diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> > index 01ad09733ac7..1a3cc1875a31 100644
> > --- a/fs/ceph/addr.c
> > +++ b/fs/ceph/addr.c
> > @@ -19,6 +19,7 @@
> >  #include "metric.h"
> >  #include <linux/ceph/osd_client.h>
> >  #include <linux/ceph/striper.h>
> > +#include "osdc.h"
> > 
> >  /*
> >   * Ceph address space ops.
> > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > index 160644ddaeed..b697a1f3c56e 100644
> > --- a/fs/ceph/file.c
> > +++ b/fs/ceph/file.c
> > @@ -18,6 +18,7 @@
> >  #include "cache.h"
> >  #include "io.h"
> >  #include "metric.h"
> > +#include "osdc.h"
> > 
> >  static __le32 ceph_flags_sys2wire(u32 flags)
> >  {
> > diff --git a/fs/ceph/osdc.c b/fs/ceph/osdc.c
> > new file mode 100644
> > index 000000000000..303e39fce3d4
> > --- /dev/null
> > +++ b/fs/ceph/osdc.c
> > @@ -0,0 +1,113 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +#include <linux/ceph/ceph_debug.h>
> > +#include <linux/ceph/libceph.h>
> > +#include <linux/ceph/osd_client.h>
> > +#include <linux/ceph/striper.h>
> > +#include "osdc.h"
> > +
> > +/*
> > + * calculate the mapping of a file extent onto an object, and fill out the
> > + * request accordingly.  shorten extent as necessary if it crosses an
> > + * object boundary.
> > + *
> > + * fill osd op in request message.
> > + */
> > +static void calc_layout(struct ceph_file_layout *layout, u64 off, u64 *plen,
> > +                       u64 *objnum, u64 *objoff, u64 *objlen)
> > +{
> > +       u64 orig_len = *plen;
> > +       u32 xlen;
> > +
> > +       /* object extent? */
> > +       ceph_calc_file_object_mapping(layout, off, orig_len, objnum,
> > +                                         objoff, &xlen);
> > +       *objlen = xlen;
> > +       if (*objlen < orig_len) {
> > +               *plen = *objlen;
> > +               dout(" skipping last %llu, final file extent %llu~%llu\n",
> > +                    orig_len - *plen, off, *plen);
> > +       }
> > +
> > +       dout("calc_layout objnum=%llx %llu~%llu\n", *objnum, *objoff, *objlen);
> > +}
> > +
> > +/*
> > + * build new request AND message, calculate layout, and adjust file
> > + * extent as needed.
> > + *
> > + * if the file was recently truncated, we include information about its
> > + * old and new size so that the object can be updated appropriately.  (we
> > + * avoid synchronously deleting truncated objects because it's slow.)
> > + */
> > +struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *osdc,
> > +                                              struct ceph_file_layout *layout,
> > +                                              struct ceph_vino vino,
> > +                                              u64 off, u64 *plen,
> > +                                              unsigned int which, int num_ops,
> > +                                              int opcode, int flags,
> > +                                              struct ceph_snap_context *snapc,
> > +                                              u32 truncate_seq,
> > +                                              u64 truncate_size,
> > +                                              bool use_mempool)
> > +{
> > +       struct ceph_osd_request *req;
> > +       u64 objnum = 0;
> > +       u64 objoff = 0;
> > +       u64 objlen = 0;
> > +       int r;
> > +
> > +       BUG_ON(opcode != CEPH_OSD_OP_READ && opcode != CEPH_OSD_OP_WRITE &&
> > +              opcode != CEPH_OSD_OP_ZERO && opcode != CEPH_OSD_OP_TRUNCATE &&
> > +              opcode != CEPH_OSD_OP_CREATE && opcode != CEPH_OSD_OP_DELETE);
> > +
> > +       req = ceph_osdc_alloc_request(osdc, snapc, num_ops, use_mempool,
> > +                                       GFP_NOFS);
> > +       if (!req)
> > +               return ERR_PTR(-ENOMEM);
> > +
> > +       /* calculate max write size */
> > +       calc_layout(layout, off, plen, &objnum, &objoff, &objlen);
> > +
> > +       if (opcode == CEPH_OSD_OP_CREATE || opcode == CEPH_OSD_OP_DELETE) {
> > +               osd_req_op_init(req, which, opcode, 0);
> > +       } else {
> > +               u32 object_size = layout->object_size;
> > +               u32 object_base = off - objoff;
> > +               if (!(truncate_seq == 1 && truncate_size == -1ULL)) {
> > +                       if (truncate_size <= object_base) {
> > +                               truncate_size = 0;
> > +                       } else {
> > +                               truncate_size -= object_base;
> > +                               if (truncate_size > object_size)
> > +                                       truncate_size = object_size;
> > +                       }
> > +               }
> > +               osd_req_op_extent_init(req, which, opcode, objoff, objlen,
> > +                                      truncate_size, truncate_seq);
> > +       }
> > +
> > +       req->r_base_oloc.pool = layout->pool_id;
> > +       req->r_base_oloc.pool_ns = ceph_try_get_string(layout->pool_ns);
> > +       req->r_flags = flags | osdc->client->options->read_from_replica;
> > +       ceph_oid_printf(&req->r_base_oid, "%llx.%08llx", vino.ino, objnum);
> > +
> > +       req->r_snapid = vino.snap;
> > +       if (flags & CEPH_OSD_FLAG_WRITE)
> > +               req->r_data_offset = off;
> > +
> > +       if (num_ops > 1)
> > +               /*
> > +                * This is a special case for ceph_writepages_start(), but it
> > +                * also covers ceph_uninline_data().  If more multi-op request
> > +                * use cases emerge, we will need a separate helper.
> > +                */
> > +               r = ceph_osdc_alloc_num_messages(req, GFP_NOFS, num_ops, 0);
> > +       else
> > +               r = ceph_osdc_alloc_messages(req, GFP_NOFS);
> > +       if (r) {
> > +               ceph_osdc_put_request(req);
> > +               return ERR_PTR(r);
> > +       }
> > +
> > +       return req;
> > +}
> > diff --git a/fs/ceph/osdc.h b/fs/ceph/osdc.h
> > new file mode 100644
> > index 000000000000..b03e5f9ef733
> > --- /dev/null
> > +++ b/fs/ceph/osdc.h
> > @@ -0,0 +1,16 @@
> > +#ifndef _FS_CEPH_OSDC_H
> > +#define _FS_CEPH_OSDC_H
> > +
> > +#include <linux/ceph/osd_client.h>
> > +
> > +struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *osdc,
> > +                                              struct ceph_file_layout *layout,
> > +                                              struct ceph_vino vino,
> > +                                              u64 off, u64 *plen,
> > +                                              unsigned int which, int num_ops,
> > +                                              int opcode, int flags,
> > +                                              struct ceph_snap_context *snapc,
> > +                                              u32 truncate_seq,
> > +                                              u64 truncate_size,
> > +                                              bool use_mempool);
> > +#endif /* _FS_CEPH_OSDC_H */
> > diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
> > index 71b7610c3a3c..f59eb192c472 100644
> > --- a/include/linux/ceph/osd_client.h
> > +++ b/include/linux/ceph/osd_client.h
> > @@ -486,16 +486,6 @@ int ceph_osdc_alloc_num_messages(struct ceph_osd_request *req, gfp_t gfp,
> >                                  int num_reply_data_items);
> >  int ceph_osdc_alloc_messages(struct ceph_osd_request *req, gfp_t gfp);
> > 
> > -extern struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *,
> > -                                     struct ceph_file_layout *layout,
> > -                                     struct ceph_vino vino,
> > -                                     u64 offset, u64 *len,
> > -                                     unsigned int which, int num_ops,
> > -                                     int opcode, int flags,
> > -                                     struct ceph_snap_context *snapc,
> > -                                     u32 truncate_seq, u64 truncate_size,
> > -                                     bool use_mempool);
> > -
> >  extern void ceph_osdc_get_request(struct ceph_osd_request *req);
> >  extern void ceph_osdc_put_request(struct ceph_osd_request *req);
> >  void ceph_osdc_init_request(struct ceph_osd_request *req,
> > diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> > index 7be78fa6e2c3..5e54971bb7b2 100644
> > --- a/net/ceph/osd_client.c
> > +++ b/net/ceph/osd_client.c
> > @@ -93,33 +93,6 @@ static inline void verify_osd_locked(struct ceph_osd *osd) { }
> >  static inline void verify_lreq_locked(struct ceph_osd_linger_request *lreq) { }
> >  #endif
> > 
> > -/*
> > - * calculate the mapping of a file extent onto an object, and fill out the
> > - * request accordingly.  shorten extent as necessary if it crosses an
> > - * object boundary.
> > - *
> > - * fill osd op in request message.
> > - */
> > -static int calc_layout(struct ceph_file_layout *layout, u64 off, u64 *plen,
> > -                       u64 *objnum, u64 *objoff, u64 *objlen)
> > -{
> > -       u64 orig_len = *plen;
> > -       u32 xlen;
> > -
> > -       /* object extent? */
> > -       ceph_calc_file_object_mapping(layout, off, orig_len, objnum,
> > -                                         objoff, &xlen);
> > -       *objlen = xlen;
> > -       if (*objlen < orig_len) {
> > -               *plen = *objlen;
> > -               dout(" skipping last %llu, final file extent %llu~%llu\n",
> > -                    orig_len - *plen, off, *plen);
> > -       }
> > -
> > -       dout("calc_layout objnum=%llx %llu~%llu\n", *objnum, *objoff, *objlen);
> > -       return 0;
> > -}
> > -
> >  static void ceph_osd_data_init(struct ceph_osd_data *osd_data)
> >  {
> >         memset(osd_data, 0, sizeof (*osd_data));
> > @@ -1056,94 +1029,6 @@ static u32 osd_req_encode_op(struct ceph_osd_op *dst,
> >         return src->indata_len;
> >  }
> > 
> > -/*
> > - * build new request AND message, calculate layout, and adjust file
> > - * extent as needed.
> > - *
> > - * if the file was recently truncated, we include information about its
> > - * old and new size so that the object can be updated appropriately.  (we
> > - * avoid synchronously deleting truncated objects because it's slow.)
> > - */
> > -struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *osdc,
> > -                                              struct ceph_file_layout *layout,
> > -                                              struct ceph_vino vino,
> > -                                              u64 off, u64 *plen,
> > -                                              unsigned int which, int num_ops,
> > -                                              int opcode, int flags,
> > -                                              struct ceph_snap_context *snapc,
> > -                                              u32 truncate_seq,
> > -                                              u64 truncate_size,
> > -                                              bool use_mempool)
> > -{
> > -       struct ceph_osd_request *req;
> > -       u64 objnum = 0;
> > -       u64 objoff = 0;
> > -       u64 objlen = 0;
> > -       int r;
> > -
> > -       BUG_ON(opcode != CEPH_OSD_OP_READ && opcode != CEPH_OSD_OP_WRITE &&
> > -              opcode != CEPH_OSD_OP_ZERO && opcode != CEPH_OSD_OP_TRUNCATE &&
> > -              opcode != CEPH_OSD_OP_CREATE && opcode != CEPH_OSD_OP_DELETE);
> > -
> > -       req = ceph_osdc_alloc_request(osdc, snapc, num_ops, use_mempool,
> > -                                       GFP_NOFS);
> > -       if (!req) {
> > -               r = -ENOMEM;
> > -               goto fail;
> > -       }
> > -
> > -       /* calculate max write size */
> > -       r = calc_layout(layout, off, plen, &objnum, &objoff, &objlen);
> > -       if (r)
> > -               goto fail;
> > -
> > -       if (opcode == CEPH_OSD_OP_CREATE || opcode == CEPH_OSD_OP_DELETE) {
> > -               osd_req_op_init(req, which, opcode, 0);
> > -       } else {
> > -               u32 object_size = layout->object_size;
> > -               u32 object_base = off - objoff;
> > -               if (!(truncate_seq == 1 && truncate_size == -1ULL)) {
> > -                       if (truncate_size <= object_base) {
> > -                               truncate_size = 0;
> > -                       } else {
> > -                               truncate_size -= object_base;
> > -                               if (truncate_size > object_size)
> > -                                       truncate_size = object_size;
> > -                       }
> > -               }
> > -               osd_req_op_extent_init(req, which, opcode, objoff, objlen,
> > -                                      truncate_size, truncate_seq);
> > -       }
> > -
> > -       req->r_base_oloc.pool = layout->pool_id;
> > -       req->r_base_oloc.pool_ns = ceph_try_get_string(layout->pool_ns);
> > -       ceph_oid_printf(&req->r_base_oid, "%llx.%08llx", vino.ino, objnum);
> > -       req->r_flags = flags | osdc->client->options->read_from_replica;
> > -
> > -       req->r_snapid = vino.snap;
> > -       if (flags & CEPH_OSD_FLAG_WRITE)
> > -               req->r_data_offset = off;
> > -
> > -       if (num_ops > 1)
> > -               /*
> > -                * This is a special case for ceph_writepages_start(), but it
> > -                * also covers ceph_uninline_data().  If more multi-op request
> > -                * use cases emerge, we will need a separate helper.
> > -                */
> > -               r = ceph_osdc_alloc_num_messages(req, GFP_NOFS, num_ops, 0);
> > -       else
> > -               r = ceph_osdc_alloc_messages(req, GFP_NOFS);
> > -       if (r)
> > -               goto fail;
> > -
> > -       return req;
> > -
> > -fail:
> > -       ceph_osdc_put_request(req);
> > -       return ERR_PTR(r);
> > -}
> > -EXPORT_SYMBOL(ceph_osdc_new_request);
> > -
> >  /*
> >   * We keep osd requests in an rbtree, sorted by ->r_tid.
> >   */
> 
> Do you have plans to refactor ceph_osdc_new_request() or change
> it significantly?
> 
> I don't think the fact that it is used only by fs/ceph justifies
> moving it to fs/ceph, particularly given that you had to export a
> rather sensitive OSD client helper in the process.  Also, you are
> creating a new file for it, which indicates that it doesn't fit
> into any of the existing files and reinforces my feeling that it
> probably doesn't belong in fs/ceph.
> 

Not today. I may need to refactor it a bit for the fscache work, but
that's still a ways out before it's ready. If you don't think this is
worth doing, we can just drop it for now.

-- 
Jeff Layton <jlayton@kernel.org>

