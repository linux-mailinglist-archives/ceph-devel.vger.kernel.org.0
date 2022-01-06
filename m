Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3FF486641
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Jan 2022 15:44:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240226AbiAFOoa (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 6 Jan 2022 09:44:30 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55718 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239677AbiAFOoa (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 6 Jan 2022 09:44:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3632BB82047
        for <ceph-devel@vger.kernel.org>; Thu,  6 Jan 2022 14:44:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73183C36AE3;
        Thu,  6 Jan 2022 14:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641480267;
        bh=kf4wqQJQ8Rl73xyWQm9pJk7gQRVPpHyMGdXRXrs+m8c=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DoNO5IyJKfm1qsYI2m9bh9hO01Jovm4XObfx9LFurjV0B26SByEUhjgXOdsd8UTiQ
         3B2vNj3FDrz7/fMBHC5Ba0rtbuLTZMXX0RHYNOHnGuLz7bPjnQyywA6eJ6ezYrCL/u
         16Gn6Yp5eUAy6iwS0mZbNr7406gN3ubF89IzdUChFHimSOpP+ETsLxbKQ3MP5Tt4ZP
         GctCPZ54Ae0zHW0tEdwuE36pvkd9NWRKEzTpMd9KH/CHIffe+Mn2UOuQhUUWM5oOH1
         idWlmPXfJhGt2MeW/RZvcYBeyVu5wb1fEkpmkbuCUiml3v+6uzLpeadLHW796B/DwQ
         4GRXu8UzJ+rxw==
Message-ID: <ffb73ca62cae9324be6dd55f0a2acdecd0394025.camel@kernel.org>
Subject: Re: [RFC PATCH] ceph: add new "nopagecache" option
From:   Jeff Layton <jlayton@kernel.org>
To:     Gregory Farnum <gfarnum@redhat.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        majianpeng <majianpeng@gmail.com>
Date:   Thu, 06 Jan 2022 09:44:26 -0500
In-Reply-To: <CAJ4mKGax=oA_4nAD_Jw-7jMvOq9xz6o2rgJTewHpR1sTM0-Evw@mail.gmail.com>
References: <20220105132645.72282-1-jlayton@kernel.org>
         <CAJ4mKGbNhHO8H_JkCBHP_hqOEK4=Zx7aqGE3Yr5K4CwxxBF1dA@mail.gmail.com>
         <f7aeed3cc7ace416915441e4251f078298fe5242.camel@kernel.org>
         <CAJ4mKGax=oA_4nAD_Jw-7jMvOq9xz6o2rgJTewHpR1sTM0-Evw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.2 (3.42.2-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2022-01-06 at 06:13 -0800, Gregory Farnum wrote:
> On Thu, Jan 6, 2022 at 5:54 AM Jeff Layton <jlayton@kernel.org> wrote:
> > 
> > No, I've only used this for local testing so far. Perhaps you can
> > handhold me through adding such a patch to teuthology for it?
> 
> Well, we mount with the "kclient" task:
> https://github.com/ceph/ceph/blob/master/qa/tasks/kclient.py
> 
> And it looks like that already supports passing arbitrary mount
> options: https://github.com/ceph/ceph/blob/master/qa/tasks/kclient.py#L51
> 
> So I think that wherever we use the kclient, we look at if that
> subsuite/test is appropriate to test without the page cache. If it is,
> split up the kclient yaml fragment to specify both with and without
> the new mount option.
> 
> Right now it looks like the tree is organized so we just include
> https://github.com/ceph/ceph/tree/master/qa/cephfs/mount anywhere we
> use CephFS mounts, and that will generate tests against both ceph-fuse
> and the kclient. So we could update that by replacing the single
> "kclient/mount.yaml" file with a folder "kclient_mount" that contains
> the existing mount.yaml, and a no_page_cache_mount.yaml that looks
> like
> 
> tasks:
> - kclient:
>   - mntopts: ["nopagecache"]
> 

Do I also need one of the magic %, +, or $ files in this directory?

Also, what will be effect of doing this? Will the new mount option be
used randomly, or will I need to specify a test run that includes this
file?


> > 
> > Note that this _really_ slows down I/O, especially if you're doing a lot
> > of small reads or writes, so it may not be appropriate for throughput-
> > heavy testing.
> > 
> > On Thu, 2022-01-06 at 05:41 -0800, Gregory Farnum wrote:
> > > This seems fine to me. Do you have a teuthology fragment to exercise this?
> > > 
> > > Acked-by: Greg Farnum <gfarnum@redhat.com>
> > > 
> > > On Wed, Jan 5, 2022 at 5:27 AM Jeff Layton <jlayton@kernel.org> wrote:
> > > > 
> > > > CephFS is a bit unlike most other filesystems in that it only
> > > > conditionally does buffered I/O based on the caps that it gets from the
> > > > MDS. In most cases, unless there is contended access for an inode the
> > > > MDS does give Fbc caps to the client, so the unbuffered codepaths are
> > > > only infrequently traveled and are difficult to test.
> > > > 
> > > > At one time, the "-o sync" mount option would give you this behavior,
> > > > but that was removed in commit 7ab9b3807097 ("ceph: Don't use
> > > > ceph-sync-mode for synchronous-fs.").
> > > > 
> > > > Add a new mount option to tell the client to ignore Fbc caps when doing
> > > > I/O, and to use the synchronous codepaths exclusively, even on
> > > > non-O_DIRECT file descriptors. We already have an ioctl that forces this
> > > > behavior on a per-inode basis, so we can just always set the CEPH_F_SYNC
> > > > flag on such mounts.
> > > > 
> > > > Additionally, this patch also changes the client to not request Fbc when
> > > > doing direct I/O. We aren't using the cache with O_DIRECT so we don't
> > > > have any need for those caps.
> > > > 
> > > > Cc: majianpeng <majianpeng@gmail.com>
> > > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > > ---
> > > >  fs/ceph/file.c  | 24 +++++++++++++++---------
> > > >  fs/ceph/super.c | 11 +++++++++++
> > > >  fs/ceph/super.h |  1 +
> > > >  3 files changed, 27 insertions(+), 9 deletions(-)
> > > > 
> > > > I've been working with this patch in order to test the synchronous
> > > > codepaths for content encryption. I think though that this might make
> > > > sense to take into mainline, as it could be helpful for troubleshooting,
> > > > and ensuring that these codepaths are regularly tested.
> > > > 
> > > > Either way, I think the cap handling changes probably make sense on
> > > > their own. I can split that out if we don't want to take the mount
> > > > option in as well.
> > > > 
> > > > Thoughts?
> > > > 
> > > > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > > > index c138e8126286..7de5db51c3d0 100644
> > > > --- a/fs/ceph/file.c
> > > > +++ b/fs/ceph/file.c
> > > > @@ -204,6 +204,8 @@ static int ceph_init_file_info(struct inode *inode, struct file *file,
> > > >                                         int fmode, bool isdir)
> > > >  {
> > > >         struct ceph_inode_info *ci = ceph_inode(inode);
> > > > +       struct ceph_mount_options *opt =
> > > > +               ceph_inode_to_client(&ci->vfs_inode)->mount_options;
> > > >         struct ceph_file_info *fi;
> > > > 
> > > >         dout("%s %p %p 0%o (%s)\n", __func__, inode, file,
> > > > @@ -225,6 +227,9 @@ static int ceph_init_file_info(struct inode *inode, struct file *file,
> > > >                 if (!fi)
> > > >                         return -ENOMEM;
> > > > 
> > > > +               if (opt->flags & CEPH_MOUNT_OPT_NOPAGECACHE)
> > > > +                       fi->flags |= CEPH_F_SYNC;
> > > > +
> > > >                 file->private_data = fi;
> > > >         }
> > > > 
> > > > @@ -1536,7 +1541,7 @@ static ssize_t ceph_read_iter(struct kiocb *iocb, struct iov_iter *to)
> > > >         struct ceph_inode_info *ci = ceph_inode(inode);
> > > >         bool direct_lock = iocb->ki_flags & IOCB_DIRECT;
> > > >         ssize_t ret;
> > > > -       int want, got = 0;
> > > > +       int want = 0, got = 0;
> > > >         int retry_op = 0, read = 0;
> > > > 
> > > >  again:
> > > > @@ -1551,13 +1556,14 @@ static ssize_t ceph_read_iter(struct kiocb *iocb, struct iov_iter *to)
> > > >         else
> > > >                 ceph_start_io_read(inode);
> > > > 
> > > > +       if (!(fi->flags & CEPH_F_SYNC) && !direct_lock)
> > > > +               want |= CEPH_CAP_FILE_CACHE;
> > > >         if (fi->fmode & CEPH_FILE_MODE_LAZY)
> > > > -               want = CEPH_CAP_FILE_CACHE | CEPH_CAP_FILE_LAZYIO;
> > > > -       else
> > > > -               want = CEPH_CAP_FILE_CACHE;
> > > > +               want |= CEPH_CAP_FILE_LAZYIO;
> > > > +
> > > >         ret = ceph_get_caps(filp, CEPH_CAP_FILE_RD, want, -1, &got);
> > > >         if (ret < 0) {
> > > > -               if (iocb->ki_flags & IOCB_DIRECT)
> > > > +               if (direct_lock)
> > > >                         ceph_end_io_direct(inode);
> > > >                 else
> > > >                         ceph_end_io_read(inode);
> > > > @@ -1691,7 +1697,7 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
> > > >         struct ceph_osd_client *osdc = &fsc->client->osdc;
> > > >         struct ceph_cap_flush *prealloc_cf;
> > > >         ssize_t count, written = 0;
> > > > -       int err, want, got;
> > > > +       int err, want = 0, got;
> > > >         bool direct_lock = false;
> > > >         u32 map_flags;
> > > >         u64 pool_flags;
> > > > @@ -1766,10 +1772,10 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
> > > > 
> > > >         dout("aio_write %p %llx.%llx %llu~%zd getting caps. i_size %llu\n",
> > > >              inode, ceph_vinop(inode), pos, count, i_size_read(inode));
> > > > +       if (!(fi->flags & CEPH_F_SYNC) && !direct_lock)
> > > > +               want |= CEPH_CAP_FILE_BUFFER;
> > > >         if (fi->fmode & CEPH_FILE_MODE_LAZY)
> > > > -               want = CEPH_CAP_FILE_BUFFER | CEPH_CAP_FILE_LAZYIO;
> > > > -       else
> > > > -               want = CEPH_CAP_FILE_BUFFER;
> > > > +               want |= CEPH_CAP_FILE_LAZYIO;
> > > >         got = 0;
> > > >         err = ceph_get_caps(file, CEPH_CAP_FILE_WR, want, pos + count, &got);
> > > >         if (err < 0)
> > > > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > > > index 8d6daea351f6..d7e604a56fd9 100644
> > > > --- a/fs/ceph/super.c
> > > > +++ b/fs/ceph/super.c
> > > > @@ -160,6 +160,7 @@ enum {
> > > >         Opt_quotadf,
> > > >         Opt_copyfrom,
> > > >         Opt_wsync,
> > > > +       Opt_pagecache,
> > > >  };
> > > > 
> > > >  enum ceph_recover_session_mode {
> > > > @@ -201,6 +202,7 @@ static const struct fs_parameter_spec ceph_mount_parameters[] = {
> > > >         fsparam_string  ("mon_addr",                    Opt_mon_addr),
> > > >         fsparam_u32     ("wsize",                       Opt_wsize),
> > > >         fsparam_flag_no ("wsync",                       Opt_wsync),
> > > > +       fsparam_flag_no ("pagecache",                   Opt_pagecache),
> > > >         {}
> > > >  };
> > > > 
> > > > @@ -567,6 +569,12 @@ static int ceph_parse_mount_param(struct fs_context *fc,
> > > >                 else
> > > >                         fsopt->flags |= CEPH_MOUNT_OPT_ASYNC_DIROPS;
> > > >                 break;
> > > > +       case Opt_pagecache:
> > > > +               if (result.negated)
> > > > +                       fsopt->flags |= CEPH_MOUNT_OPT_NOPAGECACHE;
> > > > +               else
> > > > +                       fsopt->flags &= ~CEPH_MOUNT_OPT_NOPAGECACHE;
> > > > +               break;
> > > >         default:
> > > >                 BUG();
> > > >         }
> > > > @@ -702,6 +710,9 @@ static int ceph_show_options(struct seq_file *m, struct dentry *root)
> > > >         if (!(fsopt->flags & CEPH_MOUNT_OPT_ASYNC_DIROPS))
> > > >                 seq_puts(m, ",wsync");
> > > > 
> > > > +       if (fsopt->flags & CEPH_MOUNT_OPT_NOPAGECACHE)
> > > > +               seq_puts(m, ",nopagecache");
> > > > +
> > > >         if (fsopt->wsize != CEPH_MAX_WRITE_SIZE)
> > > >                 seq_printf(m, ",wsize=%u", fsopt->wsize);
> > > >         if (fsopt->rsize != CEPH_MAX_READ_SIZE)
> > > > diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> > > > index f9b1bbf26c1b..5c6d9384b7be 100644
> > > > --- a/fs/ceph/super.h
> > > > +++ b/fs/ceph/super.h
> > > > @@ -46,6 +46,7 @@
> > > >  #define CEPH_MOUNT_OPT_NOQUOTADF       (1<<13) /* no root dir quota in statfs */
> > > >  #define CEPH_MOUNT_OPT_NOCOPYFROM      (1<<14) /* don't use RADOS 'copy-from' op */
> > > >  #define CEPH_MOUNT_OPT_ASYNC_DIROPS    (1<<15) /* allow async directory ops */
> > > > +#define CEPH_MOUNT_OPT_NOPAGECACHE     (1<<16) /* bypass pagecache altogether */
> > > > 
> > > >  #define CEPH_MOUNT_OPT_DEFAULT                 \
> > > >         (CEPH_MOUNT_OPT_DCACHE |                \
> > > > --
> > > > 2.33.1
> > > > 
> > > 
> > 
> > --
> > Jeff Layton <jlayton@kernel.org>
> > 
> 

-- 
Jeff Layton <jlayton@kernel.org>
