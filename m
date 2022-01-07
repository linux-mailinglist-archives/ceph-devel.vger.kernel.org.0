Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B602E487488
	for <lists+ceph-devel@lfdr.de>; Fri,  7 Jan 2022 10:13:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346380AbiAGJN2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 7 Jan 2022 04:13:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:31434 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237011AbiAGJN2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 7 Jan 2022 04:13:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641546807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fQll7dQRB6yYSXsehb52NPiMrkaZRPypZaszVyGRWhs=;
        b=KtUzOs2ffkzjdNebn7XMcfH3mqmYSMCG8ZqyQ18Ut7KzepNabl3vLeCHQtVrY58KrA0nsV
        08ZmzE4DwZueplb460Qj0k2hgJnYYNMxknD7uKeJQin2VJd//pU6hkuZHiM5qyC4f2x7Vg
        tqKmRxJvrUuHKatHYBn+V8FeUd+Th+I=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-77-lgcXwbGSNZW2c0jXpQn6ug-1; Fri, 07 Jan 2022 04:13:23 -0500
X-MC-Unique: lgcXwbGSNZW2c0jXpQn6ug-1
Received: by mail-ed1-f72.google.com with SMTP id g11-20020a056402090b00b003f8fd1ac475so4189783edz.1
        for <ceph-devel@vger.kernel.org>; Fri, 07 Jan 2022 01:13:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fQll7dQRB6yYSXsehb52NPiMrkaZRPypZaszVyGRWhs=;
        b=QzucjgXSjj3li8Yda926EbXH14tqX3O4gCUFubJagV+/s25+oJk2HBjm08dUdrCDFO
         VPXjh4ljFHG/skkJc/weQ/o/1l9wZ0h387D4seM5zMwVVEGKXOfqRDwb/WrFJK7mma7a
         kCezNZxV86nIbkRcAUJSj6ho3t5SgfxiF6O9PaWMJ3Ih0V80Yp2u7mN/S+vxG5g3F+73
         in0sRnCutEVjpCb0agldYtf7tbhJb1RQUlKtnSFTu/UAY4agYqr8kZJzU41GCsDx8Wlm
         HXbjM7cX9bQJehLZOfrQ9TccGIucnAy+5d1oolnFi/3/0B+pKwETY23y65y4Zlp5Ql9+
         xomg==
X-Gm-Message-State: AOAM533/CVl7grr66NThVhksXZy2thWEC4m15C0j5Xv8o/KuhdZcued9
        jj6QQrawJPolJNwZwHV4MtZDWWEQIBoA+uOouKRsj3SneM8UBw4ZAqz39UF/bLv2EPE8pthhBsP
        Ueu0OnepSkDKE1CUX3vrzDMWb8jizj27zbJgyCg==
X-Received: by 2002:a17:906:c14f:: with SMTP id dp15mr52532719ejc.267.1641546802441;
        Fri, 07 Jan 2022 01:13:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJygPtoXkanXoQMQReHivWZUqbs5tWvz7c7o4PxuoEwGmcW4BNCiqjz8J5Tn0GqCKXllL3cfF46LCIVUgkHTnfw=
X-Received: by 2002:a17:906:c14f:: with SMTP id dp15mr52532699ejc.267.1641546802128;
 Fri, 07 Jan 2022 01:13:22 -0800 (PST)
MIME-Version: 1.0
References: <20220105132645.72282-1-jlayton@kernel.org>
In-Reply-To: <20220105132645.72282-1-jlayton@kernel.org>
From:   Venky Shankar <vshankar@redhat.com>
Date:   Fri, 7 Jan 2022 14:42:45 +0530
Message-ID: <CACPzV1=k5N3x+f2uR+nXy2rYKQobR0UHijW6523UzbNhdGZrKQ@mail.gmail.com>
Subject: Re: [RFC PATCH] ceph: add new "nopagecache" option
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        majianpeng <majianpeng@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Jan 5, 2022 at 6:57 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> CephFS is a bit unlike most other filesystems in that it only
> conditionally does buffered I/O based on the caps that it gets from the
> MDS. In most cases, unless there is contended access for an inode the
> MDS does give Fbc caps to the client, so the unbuffered codepaths are
> only infrequently traveled and are difficult to test.
>
> At one time, the "-o sync" mount option would give you this behavior,
> but that was removed in commit 7ab9b3807097 ("ceph: Don't use
> ceph-sync-mode for synchronous-fs.").
>
> Add a new mount option to tell the client to ignore Fbc caps when doing
> I/O, and to use the synchronous codepaths exclusively, even on
> non-O_DIRECT file descriptors. We already have an ioctl that forces this
> behavior on a per-inode basis, so we can just always set the CEPH_F_SYNC
> flag on such mounts.
>
> Additionally, this patch also changes the client to not request Fbc when
> doing direct I/O. We aren't using the cache with O_DIRECT so we don't
> have any need for those caps.

This looks good.

Reviewed-by: Venky Shankar <vshankar@redhat.com>

>
> Cc: majianpeng <majianpeng@gmail.com>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/file.c  | 24 +++++++++++++++---------
>  fs/ceph/super.c | 11 +++++++++++
>  fs/ceph/super.h |  1 +
>  3 files changed, 27 insertions(+), 9 deletions(-)
>
> I've been working with this patch in order to test the synchronous
> codepaths for content encryption. I think though that this might make
> sense to take into mainline, as it could be helpful for troubleshooting,
> and ensuring that these codepaths are regularly tested.
>
> Either way, I think the cap handling changes probably make sense on
> their own. I can split that out if we don't want to take the mount
> option in as well.
>
> Thoughts?
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index c138e8126286..7de5db51c3d0 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -204,6 +204,8 @@ static int ceph_init_file_info(struct inode *inode, struct file *file,
>                                         int fmode, bool isdir)
>  {
>         struct ceph_inode_info *ci = ceph_inode(inode);
> +       struct ceph_mount_options *opt =
> +               ceph_inode_to_client(&ci->vfs_inode)->mount_options;
>         struct ceph_file_info *fi;
>
>         dout("%s %p %p 0%o (%s)\n", __func__, inode, file,
> @@ -225,6 +227,9 @@ static int ceph_init_file_info(struct inode *inode, struct file *file,
>                 if (!fi)
>                         return -ENOMEM;
>
> +               if (opt->flags & CEPH_MOUNT_OPT_NOPAGECACHE)
> +                       fi->flags |= CEPH_F_SYNC;
> +
>                 file->private_data = fi;
>         }
>
> @@ -1536,7 +1541,7 @@ static ssize_t ceph_read_iter(struct kiocb *iocb, struct iov_iter *to)
>         struct ceph_inode_info *ci = ceph_inode(inode);
>         bool direct_lock = iocb->ki_flags & IOCB_DIRECT;
>         ssize_t ret;
> -       int want, got = 0;
> +       int want = 0, got = 0;
>         int retry_op = 0, read = 0;
>
>  again:
> @@ -1551,13 +1556,14 @@ static ssize_t ceph_read_iter(struct kiocb *iocb, struct iov_iter *to)
>         else
>                 ceph_start_io_read(inode);
>
> +       if (!(fi->flags & CEPH_F_SYNC) && !direct_lock)
> +               want |= CEPH_CAP_FILE_CACHE;
>         if (fi->fmode & CEPH_FILE_MODE_LAZY)
> -               want = CEPH_CAP_FILE_CACHE | CEPH_CAP_FILE_LAZYIO;
> -       else
> -               want = CEPH_CAP_FILE_CACHE;
> +               want |= CEPH_CAP_FILE_LAZYIO;
> +
>         ret = ceph_get_caps(filp, CEPH_CAP_FILE_RD, want, -1, &got);
>         if (ret < 0) {
> -               if (iocb->ki_flags & IOCB_DIRECT)
> +               if (direct_lock)
>                         ceph_end_io_direct(inode);
>                 else
>                         ceph_end_io_read(inode);
> @@ -1691,7 +1697,7 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
>         struct ceph_osd_client *osdc = &fsc->client->osdc;
>         struct ceph_cap_flush *prealloc_cf;
>         ssize_t count, written = 0;
> -       int err, want, got;
> +       int err, want = 0, got;
>         bool direct_lock = false;
>         u32 map_flags;
>         u64 pool_flags;
> @@ -1766,10 +1772,10 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
>
>         dout("aio_write %p %llx.%llx %llu~%zd getting caps. i_size %llu\n",
>              inode, ceph_vinop(inode), pos, count, i_size_read(inode));
> +       if (!(fi->flags & CEPH_F_SYNC) && !direct_lock)
> +               want |= CEPH_CAP_FILE_BUFFER;
>         if (fi->fmode & CEPH_FILE_MODE_LAZY)
> -               want = CEPH_CAP_FILE_BUFFER | CEPH_CAP_FILE_LAZYIO;
> -       else
> -               want = CEPH_CAP_FILE_BUFFER;
> +               want |= CEPH_CAP_FILE_LAZYIO;
>         got = 0;
>         err = ceph_get_caps(file, CEPH_CAP_FILE_WR, want, pos + count, &got);
>         if (err < 0)
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index 8d6daea351f6..d7e604a56fd9 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -160,6 +160,7 @@ enum {
>         Opt_quotadf,
>         Opt_copyfrom,
>         Opt_wsync,
> +       Opt_pagecache,
>  };
>
>  enum ceph_recover_session_mode {
> @@ -201,6 +202,7 @@ static const struct fs_parameter_spec ceph_mount_parameters[] = {
>         fsparam_string  ("mon_addr",                    Opt_mon_addr),
>         fsparam_u32     ("wsize",                       Opt_wsize),
>         fsparam_flag_no ("wsync",                       Opt_wsync),
> +       fsparam_flag_no ("pagecache",                   Opt_pagecache),
>         {}
>  };
>
> @@ -567,6 +569,12 @@ static int ceph_parse_mount_param(struct fs_context *fc,
>                 else
>                         fsopt->flags |= CEPH_MOUNT_OPT_ASYNC_DIROPS;
>                 break;
> +       case Opt_pagecache:
> +               if (result.negated)
> +                       fsopt->flags |= CEPH_MOUNT_OPT_NOPAGECACHE;
> +               else
> +                       fsopt->flags &= ~CEPH_MOUNT_OPT_NOPAGECACHE;
> +               break;
>         default:
>                 BUG();
>         }
> @@ -702,6 +710,9 @@ static int ceph_show_options(struct seq_file *m, struct dentry *root)
>         if (!(fsopt->flags & CEPH_MOUNT_OPT_ASYNC_DIROPS))
>                 seq_puts(m, ",wsync");
>
> +       if (fsopt->flags & CEPH_MOUNT_OPT_NOPAGECACHE)
> +               seq_puts(m, ",nopagecache");
> +
>         if (fsopt->wsize != CEPH_MAX_WRITE_SIZE)
>                 seq_printf(m, ",wsize=%u", fsopt->wsize);
>         if (fsopt->rsize != CEPH_MAX_READ_SIZE)
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index f9b1bbf26c1b..5c6d9384b7be 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -46,6 +46,7 @@
>  #define CEPH_MOUNT_OPT_NOQUOTADF       (1<<13) /* no root dir quota in statfs */
>  #define CEPH_MOUNT_OPT_NOCOPYFROM      (1<<14) /* don't use RADOS 'copy-from' op */
>  #define CEPH_MOUNT_OPT_ASYNC_DIROPS    (1<<15) /* allow async directory ops */
> +#define CEPH_MOUNT_OPT_NOPAGECACHE     (1<<16) /* bypass pagecache altogether */
>
>  #define CEPH_MOUNT_OPT_DEFAULT                 \
>         (CEPH_MOUNT_OPT_DCACHE |                \
> --
> 2.33.1
>


-- 
Cheers,
Venky

