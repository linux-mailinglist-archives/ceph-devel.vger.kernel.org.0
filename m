Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6DDA2AD0D0
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Nov 2020 09:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728508AbgKJIFu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Nov 2020 03:05:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726690AbgKJIFu (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 10 Nov 2020 03:05:50 -0500
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17326C0613CF
        for <ceph-devel@vger.kernel.org>; Tue, 10 Nov 2020 00:05:50 -0800 (PST)
Received: by mail-il1-x144.google.com with SMTP id y17so11014365ilg.4
        for <ceph-devel@vger.kernel.org>; Tue, 10 Nov 2020 00:05:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+neLFolF+Mml9RRjqJpiP1IOJeUz9wwj3UJTsNMK7pE=;
        b=cEIW9dA5S9GcI0mo/vvr4oDEFibEHvwZK4VBg4Lyx3wQQwIavJHUe8TZdRjGGNFXNp
         BOTqMpc4HoC/VpmZkLwPXR4pHg4tvdlzw2GORexhSncitZjj7QxQvnhs0SpeybQb7l7+
         5JDa1zXDIqdOgFbkmFSWJyVdXhbMESSWcWmR20ddts1KVa5xDFZFNckzCquDcCOpRd72
         gD5xPN4zzqfd3BG9BdTNZh0IQkB/8VWdQgWdFXAlPQ+2JIAvipwlRW80uWSE5Ecj6784
         I7AsqVvkRt/HgC6bgax9QVyTT7skzg8TkAVbdVbK1YXxPxLazjT4OAjAc8Vd0670d+bg
         sgPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+neLFolF+Mml9RRjqJpiP1IOJeUz9wwj3UJTsNMK7pE=;
        b=jzErv5jdTIELwUYxDwCbG1tmq2dRUIXSPuO6XI5uuz7aa+CHpvHCGv2oA5nekinngV
         TxAe5O6921W5+iY6wLZ5UinVExtuhEBwFn+2BxvLJGudBGXxWypXmo92kqrikvtrXK30
         pfiANgPQQ+YX2fd9lL3IyT5Tvz/q4hLFktcICyj6gY4guaiCpZOWSFPAzFtc2cVWrdvO
         58U2sjdGq9fH1Sn3o87j70slvxRdgjxjwR88Q47hTYSwXZCjAnTS+Ek5XSuJqd5cYRft
         WIt47gpxSHU3YyPvqHZ7/oSGoBvnGYJmf0dIUjsj0hvF0e36M5ZB/ImdyHmw2uvJYl9O
         AKIw==
X-Gm-Message-State: AOAM533pRVy15KvBldYy+DYofxbZrCXd1Iqll5j61bBGrBqWNAWR9dJi
        36m02bPyg80QJa/3UttAUcvgQ7Tri58zSbH52G4=
X-Google-Smtp-Source: ABdhPJx2W4tuIdDX9F2Hs+T36CwCRh070BwQqC4Elt6dNCr+CFY3eEvKo+4/9mJ+jxHhY6is4oIaMHjP5DyfHhHctKM=
X-Received: by 2002:a92:ba56:: with SMTP id o83mr14121274ili.19.1604995549397;
 Tue, 10 Nov 2020 00:05:49 -0800 (PST)
MIME-Version: 1.0
References: <20201105023703.735882-1-xiubli@redhat.com> <20201105023703.735882-3-xiubli@redhat.com>
In-Reply-To: <20201105023703.735882-3-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 10 Nov 2020 09:05:49 +0100
Message-ID: <CAOi1vP_kVqsmktmWxoEKOD8JAnGrKM5R+cxToncMb8kgRftCYg@mail.gmail.com>
Subject: Re: [PATCH 2/2] ceph: add CEPH_IOC_GET_FS_CLIENT_IDS ioctl cmd support
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>, "Yan, Zheng" <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Nov 5, 2020 at 3:37 AM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> This ioctl will return the dedicated fs and client IDs back to
> userspace. With this we can easily know which mountpoint the file
> blongs to and also they can help locate the debugfs path quickly.

belongs

>
> URL: https://tracker.ceph.com/issues/48124
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/ioctl.c | 22 ++++++++++++++++++++++
>  fs/ceph/ioctl.h | 15 +++++++++++++++
>  2 files changed, 37 insertions(+)
>
> diff --git a/fs/ceph/ioctl.c b/fs/ceph/ioctl.c
> index 6e061bf62ad4..2498a1df132e 100644
> --- a/fs/ceph/ioctl.c
> +++ b/fs/ceph/ioctl.c
> @@ -268,6 +268,25 @@ static long ceph_ioctl_syncio(struct file *file)
>         return 0;
>  }
>
> +static long ceph_ioctl_get_client_id(struct file *file, void __user *arg)
> +{
> +       struct inode *inode = file_inode(file);
> +       struct ceph_fs_client *fsc = ceph_sb_to_client(inode->i_sb);
> +       struct fs_client_ids ids;
> +       char fsid[40];
> +
> +       snprintf(fsid, sizeof(fsid), "%pU", &fsc->client->fsid);
> +       memcpy(ids.fsid, fsid, sizeof(fsid));
> +
> +       ids.global_id = fsc->client->monc.auth->global_id;

Why is fsid returned in text and global_id in binary?  I get that the
initial use case is constructing "<fsid>.client<global_id>" string, but
it's probably better to stick to binary.

Use ceph_client_gid() for getting global_id.

> +
> +       /* send result back to user */
> +       if (copy_to_user(arg, &ids, sizeof(ids)))
> +               return -EFAULT;
> +
> +       return 0;
> +}
> +
>  long ceph_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  {
>         dout("ioctl file %p cmd %u arg %lu\n", file, cmd, arg);
> @@ -289,6 +308,9 @@ long ceph_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>
>         case CEPH_IOC_SYNCIO:
>                 return ceph_ioctl_syncio(file);
> +
> +       case CEPH_IOC_GET_FS_CLIENT_IDS:
> +               return ceph_ioctl_get_client_id(file, (void __user *)arg);
>         }
>
>         return -ENOTTY;
> diff --git a/fs/ceph/ioctl.h b/fs/ceph/ioctl.h
> index 51f7f1d39a94..59c7479e77b2 100644
> --- a/fs/ceph/ioctl.h
> +++ b/fs/ceph/ioctl.h
> @@ -98,4 +98,19 @@ struct ceph_ioctl_dataloc {
>   */
>  #define CEPH_IOC_SYNCIO _IO(CEPH_IOCTL_MAGIC, 5)
>
> +/*
> + * CEPH_IOC_GET_FS_CLIENT_IDS - get the fs and client ids
> + *
> + * This ioctl will return the dedicated fs and client IDs back to

The "fsid" you are capturing is really a cluster id, which may be home
to multiple CephFS filesystems.  Referring to it as a "dedicated fs ID"
is misleading.

Thanks,

                Ilya
