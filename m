Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4B4F833F0
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Aug 2019 16:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732127AbfHFO1j (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 6 Aug 2019 10:27:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:39062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729535AbfHFO1j (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 6 Aug 2019 10:27:39 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BB3C20880;
        Tue,  6 Aug 2019 14:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565101656;
        bh=T3NG7sxSNpC5dkxzsuIX2DTTQnIIa1jhFFZDpumS3OQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=qs+mHuHWCy1/8q22Ir376zFe5j3FH8IlGQPQz288hx7kWQOIoHeEHipPE1a+FXbPY
         pMeCdBwRhPDcvUFczfdknXYPcRDcB82X3C2/we0jh8q40QTtDhg0uZEq5UqttWg3fd
         gWEVny4vJwuxy7Swp+o8orXWi1P7Glm+3s30HyA0=
Message-ID: <d25f63c2a8d9613dcbbc319d8f2e130884b78874.camel@kernel.org>
Subject: Re: [PATCH] ceph: add buffered/direct exclusionary locking for
 reads and writes
From:   Jeff Layton <jlayton@kernel.org>
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, Sage Weil <sage@redhat.com>,
        Christoph Hellwig <hch@lst.de>
Date:   Tue, 06 Aug 2019 10:27:34 -0400
In-Reply-To: <CAAM7YA=y8f+kv17y09Vh2mLmvQe7vMefYaNZLEYdtdbvZ19hPA@mail.gmail.com>
References: <20190805200501.17905-1-jlayton@kernel.org>
         <CAAM7YA=y8f+kv17y09Vh2mLmvQe7vMefYaNZLEYdtdbvZ19hPA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2019-08-06 at 11:21 +0800, Yan, Zheng wrote:
> On Tue, Aug 6, 2019 at 4:05 AM Jeff Layton <jlayton@kernel.org> wrote:
> > xfstest generic/451 intermittently fails. The test does O_DIRECT writes
> > to a file, and then reads back the result using buffered I/O, while
> > running a separate set of tasks that are also doing buffered reads.
> > 
> > The client will invalidate the cache prior to a direct write, but it's
> > easy for one of the other readers' replies to race in and reinstantiate
> > the invalidated range with stale data.
> > 
> > To fix this, we must to serialize direct I/O writes and buffered reads.
> > We could just sprinkle in some shared locks on the i_rwsem for reads,
> > and increase the exclusive footprint on the write side, but that would
> > cause O_DIRECT writes to end up serialized vs. other direct requests.
> > 
> > Instead, borrow the scheme used by nfs.ko. Buffered writes take the
> > i_rwsem exclusively, but buffered reads and all O_DIRECT requests
> > take a shared lock, allowing them to run in parallel.
> > 
> > To fix the bug though, we need buffered reads and O_DIRECT I/O to not
> > run in parallel. A flag on the ceph_inode_info is used to indicate
> > whether it's in direct or buffered I/O mode. When a conflicting request
> > is submitted, it will block until the inode can flip to the necessary
> > mode.
> > 
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/ceph/Makefile |   2 +-
> >  fs/ceph/file.c   |  28 ++++++--
> >  fs/ceph/io.c     | 163 +++++++++++++++++++++++++++++++++++++++++++++++
> >  fs/ceph/io.h     |  12 ++++
> >  fs/ceph/super.h  |   2 +-
> >  5 files changed, 198 insertions(+), 9 deletions(-)
> >  create mode 100644 fs/ceph/io.c
> >  create mode 100644 fs/ceph/io.h
> > 
> > diff --git a/fs/ceph/Makefile b/fs/ceph/Makefile
> > index a699e320393f..c1da294418d1 100644
> > --- a/fs/ceph/Makefile
> > +++ b/fs/ceph/Makefile
> > @@ -6,7 +6,7 @@
> >  obj-$(CONFIG_CEPH_FS) += ceph.o
> > 
> >  ceph-y := super.o inode.o dir.o file.o locks.o addr.o ioctl.o \
> > -       export.o caps.o snap.o xattr.o quota.o \
> > +       export.o caps.o snap.o xattr.o quota.o io.o \
> >         mds_client.o mdsmap.o strings.o ceph_frag.o \
> >         debugfs.o
> > 
> > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > index 5182e1a49d6f..d7d264e05303 100644
> > --- a/fs/ceph/file.c
> > +++ b/fs/ceph/file.c
> > @@ -15,6 +15,7 @@
> >  #include "super.h"
> >  #include "mds_client.h"
> >  #include "cache.h"
> > +#include "io.h"
> > 
> >  static __le32 ceph_flags_sys2wire(u32 flags)
> >  {
> > @@ -1284,12 +1285,16 @@ static ssize_t ceph_read_iter(struct kiocb *iocb, struct iov_iter *to)
> > 
> >                 if (ci->i_inline_version == CEPH_INLINE_NONE) {
> >                         if (!retry_op && (iocb->ki_flags & IOCB_DIRECT)) {
> > +                               ceph_start_io_direct(inode);
> >                                 ret = ceph_direct_read_write(iocb, to,
> >                                                              NULL, NULL);
> > +                               ceph_end_io_direct(inode);
> >                                 if (ret >= 0 && ret < len)
> >                                         retry_op = CHECK_EOF;
> >                         } else {
> > +                               ceph_start_io_read(inode);
> >                                 ret = ceph_sync_read(iocb, to, &retry_op);
> > +                               ceph_end_io_read(inode);
> >                         }
> >                 } else {
> >                         retry_op = READ_INLINE;
> > @@ -1300,7 +1305,9 @@ static ssize_t ceph_read_iter(struct kiocb *iocb, struct iov_iter *to)
> >                      inode, ceph_vinop(inode), iocb->ki_pos, (unsigned)len,
> >                      ceph_cap_string(got));
> >                 ceph_add_rw_context(fi, &rw_ctx);
> > +               ceph_start_io_read(inode);
> >                 ret = generic_file_read_iter(iocb, to);
> > +               ceph_end_io_read(inode);
> >                 ceph_del_rw_context(fi, &rw_ctx);
> >         }
> >         dout("aio_read %p %llx.%llx dropping cap refs on %s = %d\n",
> > @@ -1409,7 +1416,10 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
> >                 return -ENOMEM;
> > 
> >  retry_snap:
> > -       inode_lock(inode);
> > +       if (iocb->ki_flags & IOCB_DIRECT)
> > +               ceph_start_io_direct(inode);
> > +       else
> > +               ceph_start_io_write(inode);
> > 
> >         /* We can write back this queue in page reclaim */
> >         current->backing_dev_info = inode_to_bdi(inode);
> > @@ -1480,7 +1490,6 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
> >             (ci->i_ceph_flags & CEPH_I_ERROR_WRITE)) {
> >                 struct ceph_snap_context *snapc;
> >                 struct iov_iter data;
> > -               inode_unlock(inode);
> > 
> >                 spin_lock(&ci->i_ceph_lock);
> >                 if (__ceph_have_pending_cap_snap(ci)) {
> > @@ -1497,11 +1506,14 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
> > 
> >                 /* we might need to revert back to that point */
> >                 data = *from;
> > -               if (iocb->ki_flags & IOCB_DIRECT)
> > +               if (iocb->ki_flags & IOCB_DIRECT) {
> >                         written = ceph_direct_read_write(iocb, &data, snapc,
> >                                                          &prealloc_cf);
> > -               else
> > +                       ceph_end_io_direct(inode);
> > +               } else {
> >                         written = ceph_sync_write(iocb, &data, pos, snapc);
> > +                       ceph_end_io_write(inode);
> > +               }
> >                 if (written > 0)
> >                         iov_iter_advance(from, written);
> >                 ceph_put_snap_context(snapc);
> > @@ -1516,7 +1528,7 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
> >                 written = generic_perform_write(file, from, pos);
> >                 if (likely(written >= 0))
> >                         iocb->ki_pos = pos + written;
> > -               inode_unlock(inode);
> > +               ceph_end_io_write(inode);
> >         }
> > 
> >         if (written >= 0) {
> > @@ -1551,9 +1563,11 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
> >         }
> > 
> >         goto out_unlocked;
> > -
> >  out:
> > -       inode_unlock(inode);
> > +       if (iocb->ki_flags & IOCB_DIRECT)
> > +               ceph_end_io_direct(inode);
> > +       else
> > +               ceph_end_io_write(inode);
> >  out_unlocked:
> >         ceph_free_cap_flush(prealloc_cf);
> >         current->backing_dev_info = NULL;
> > diff --git a/fs/ceph/io.c b/fs/ceph/io.c
> > new file mode 100644
> > index 000000000000..8367cbcc81e8
> > --- /dev/null
> > +++ b/fs/ceph/io.c
> > @@ -0,0 +1,163 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (c) 2016 Trond Myklebust
> > + * Copyright (c) 2019 Jeff Layton
> > + *
> > + * I/O and data path helper functionality.
> > + *
> > + * Heavily borrowed from equivalent code in fs/nfs/io.c
> > + */
> > +
> > +#include <linux/ceph/ceph_debug.h>
> > +
> > +#include <linux/types.h>
> > +#include <linux/kernel.h>
> > +#include <linux/rwsem.h>
> > +#include <linux/fs.h>
> > +
> > +#include "super.h"
> > +#include "io.h"
> > +
> > +/* Call with exclusively locked inode->i_rwsem */
> > +static void ceph_block_o_direct(struct ceph_inode_info *ci, struct inode *inode)
> > +{
> > +       lockdep_assert_held_write(&inode->i_rwsem);
> > +
> > +       if (READ_ONCE(ci->i_ceph_flags) & CEPH_I_ODIRECT) {
> > +               spin_lock(&ci->i_ceph_lock);
> > +               ci->i_ceph_flags &= ~CEPH_I_ODIRECT;
> > +               spin_unlock(&ci->i_ceph_lock);
> > +               inode_dio_wait(inode);
> > +       }
> > +}
> > +
> > +/**
> > + * ceph_start_io_read - declare the file is being used for buffered reads
> > + * @inode: file inode
> > + *
> > + * Declare that a buffered read operation is about to start, and ensure
> > + * that we block all direct I/O.
> > + * On exit, the function ensures that the CEPH_I_ODIRECT flag is unset,
> > + * and holds a shared lock on inode->i_rwsem to ensure that the flag
> > + * cannot be changed.
> > + * In practice, this means that buffered read operations are allowed to
> > + * execute in parallel, thanks to the shared lock, whereas direct I/O
> > + * operations need to wait to grab an exclusive lock in order to set
> > + * CEPH_I_ODIRECT.
> > + * Note that buffered writes and truncates both take a write lock on
> > + * inode->i_rwsem, meaning that those are serialised w.r.t. the reads.
> > + */
> > +void
> > +ceph_start_io_read(struct inode *inode)
> > +{
> > +       struct ceph_inode_info *ci = ceph_inode(inode);
> > +
> > +       /* Be an optimist! */
> > +       down_read(&inode->i_rwsem);
> > +       if (!(READ_ONCE(ci->i_ceph_flags) & CEPH_I_ODIRECT))
> > +               return;
> > +       up_read(&inode->i_rwsem);
> > +       /* Slow path.... */
> > +       down_write(&inode->i_rwsem);
> > +       ceph_block_o_direct(ci, inode);
> > +       downgrade_write(&inode->i_rwsem);
> > +}
> > +
> > +/**
> > + * ceph_end_io_read - declare that the buffered read operation is done
> > + * @inode: file inode
> > + *
> > + * Declare that a buffered read operation is done, and release the shared
> > + * lock on inode->i_rwsem.
> > + */
> > +void
> > +ceph_end_io_read(struct inode *inode)
> > +{
> > +       up_read(&inode->i_rwsem);
> > +}
> > +
> > +/**
> > + * ceph_start_io_write - declare the file is being used for buffered writes
> > + * @inode: file inode
> > + *
> > + * Declare that a buffered read operation is about to start, and ensure
> > + * that we block all direct I/O.
> > + */
> > +void
> > +ceph_start_io_write(struct inode *inode)
> > +{
> > +       down_write(&inode->i_rwsem);
> > +       ceph_block_o_direct(ceph_inode(inode), inode);
> > +}
> > +
> > +/**
> > + * ceph_end_io_write - declare that the buffered write operation is done
> > + * @inode: file inode
> > + *
> > + * Declare that a buffered write operation is done, and release the
> > + * lock on inode->i_rwsem.
> > + */
> > +void
> > +ceph_end_io_write(struct inode *inode)
> > +{
> > +       up_write(&inode->i_rwsem);
> > +}
> > +
> > +/* Call with exclusively locked inode->i_rwsem */
> > +static void ceph_block_buffered(struct ceph_inode_info *ci, struct inode *inode)
> > +{
> > +       lockdep_assert_held_write(&inode->i_rwsem);
> > +
> > +       if (!(READ_ONCE(ci->i_ceph_flags) & CEPH_I_ODIRECT)) {
> > +               spin_lock(&ci->i_ceph_lock);
> > +               ci->i_ceph_flags |= CEPH_I_ODIRECT;
> > +               spin_unlock(&ci->i_ceph_lock);
> > +               /* FIXME: unmap_mapping_range? */
> > +               filemap_write_and_wait(inode->i_mapping);
> > +       }
> > +}
> > +
> > +/**
> > + * ceph_end_io_direct - declare the file is being used for direct i/o
> > + * @inode: file inode
> > + *
> > + * Declare that a direct I/O operation is about to start, and ensure
> > + * that we block all buffered I/O.
> > + * On exit, the function ensures that the CEPH_I_ODIRECT flag is set,
> > + * and holds a shared lock on inode->i_rwsem to ensure that the flag
> > + * cannot be changed.
> > + * In practice, this means that direct I/O operations are allowed to
> > + * execute in parallel, thanks to the shared lock, whereas buffered I/O
> > + * operations need to wait to grab an exclusive lock in order to clear
> > + * CEPH_I_ODIRECT.
> > + * Note that buffered writes and truncates both take a write lock on
> > + * inode->i_rwsem, meaning that those are serialised w.r.t. O_DIRECT.
> > + */
> > +void
> > +ceph_start_io_direct(struct inode *inode)
> > +{
> > +       struct ceph_inode_info *ci = ceph_inode(inode);
> > +
> > +       /* Be an optimist! */
> > +       down_read(&inode->i_rwsem);
> > +       if (READ_ONCE(ci->i_ceph_flags) & CEPH_I_ODIRECT)
> > +               return;
> > +       up_read(&inode->i_rwsem);
> > +       /* Slow path.... */
> > +       down_write(&inode->i_rwsem);
> > +       ceph_block_buffered(ci, inode);
> > +       downgrade_write(&inode->i_rwsem);
> > +}
> > +
> > +/**
> > + * ceph_end_io_direct - declare that the direct i/o operation is done
> > + * @inode: file inode
> > + *
> > + * Declare that a direct I/O operation is done, and release the shared
> > + * lock on inode->i_rwsem.
> > + */
> > +void
> > +ceph_end_io_direct(struct inode *inode)
> > +{
> > +       up_read(&inode->i_rwsem);
> > +}
> > diff --git a/fs/ceph/io.h b/fs/ceph/io.h
> > new file mode 100644
> > index 000000000000..fa594cd77348
> > --- /dev/null
> > +++ b/fs/ceph/io.h
> > @@ -0,0 +1,12 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#ifndef _FS_CEPH_IO_H
> > +#define _FS_CEPH_IO_H
> > +
> > +void ceph_start_io_read(struct inode *inode);
> > +void ceph_end_io_read(struct inode *inode);
> > +void ceph_start_io_write(struct inode *inode);
> > +void ceph_end_io_write(struct inode *inode);
> > +void ceph_start_io_direct(struct inode *inode);
> > +void ceph_end_io_direct(struct inode *inode);
> > +
> > +#endif /* FS_CEPH_IO_H */
> > diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> > index 03e4828c7635..46a64293a3f7 100644
> > --- a/fs/ceph/super.h
> > +++ b/fs/ceph/super.h
> > @@ -516,7 +516,7 @@ static inline struct inode *ceph_find_inode(struct super_block *sb,
> >  #define CEPH_I_FLUSH_SNAPS     (1 << 9) /* need flush snapss */
> >  #define CEPH_I_ERROR_WRITE     (1 << 10) /* have seen write errors */
> >  #define CEPH_I_ERROR_FILELOCK  (1 << 11) /* have seen file lock errors */
> > -
> > +#define CEPH_I_ODIRECT         (1 << 12) /* active direct I/O in progress */
> > 
> >  /*
> >   * Masks of ceph inode work.
> > --
> > 2.21.0
> > 
> Reviewd-by

Thanks, Zheng.

I cleaned up the comments and changelog, and added another delta to
remove the filemap_write_and_wait_range() call at the top of
ceph_direct_read_write() since it's no longer needed.

I've pushed the result to ceph-client/testing. Let me know if you hear
of any regressions with this (performance regressions in particular).
-- 
Jeff Layton <jlayton@kernel.org>

