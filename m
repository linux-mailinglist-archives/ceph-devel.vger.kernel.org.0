Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07459359532
	for <lists+ceph-devel@lfdr.de>; Fri,  9 Apr 2021 08:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233251AbhDIGNo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 9 Apr 2021 02:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbhDIGNo (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 9 Apr 2021 02:13:44 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C8B3C061760;
        Thu,  8 Apr 2021 23:13:31 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id c15so3850583ilj.1;
        Thu, 08 Apr 2021 23:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OpQXQR3cFzxNIlWyIbGhD0hln9Ms5I3EBXzLQJUJizY=;
        b=pBJ8x9jDScO0Yl05YfsfRxalTaA3Sdn2UNH6QCiGk3jwBFf5hwnCwuDM+ZCQyk4zxY
         SibEsTDh+iX0A45QzIT4+y56bES0V1DvH8/AQ7vqhxH6elhGxXJeRqt8aPZVqJGez0AW
         F2dhRIgK3RrJrlZxEzBye1CcjifhHJ7EP1wSNPfa/YygTFPwzU1jiYg1zF5dAE+zZb/l
         lKJ/LMmzh/FMOEs0w04eLTydPOvpQKqrUxM3iIpVpFj8hB9hQ0i7vgm2gCQzrVKc7ZQK
         SOJ/a0brGHp71NRW10ekUzdEuov+TQBcFEy74fRwgCJkEFsI98lebBJQXCEzB53ythUO
         7bfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OpQXQR3cFzxNIlWyIbGhD0hln9Ms5I3EBXzLQJUJizY=;
        b=ilN4MgpzDgJLmpPkyrEpd0day2ReXDG2/EjCWlkMDweqIhBq15Sgk5XhKGTwBk2x4Y
         lO9YeUmoKgEnmxpm78Jj677Jomuk42mcnNt3hhZUtFXqEJulZVgDrXUyqYFzX9me3NTj
         at32FI17Z/ZlCegAyFctLUiqFbdE9yITfkBgkixa7tejnb8+zkTwEOeCc0awPbao8VKf
         chtE1wsNuUYWLJCmHY/uP2OUxzbKbk6YFPEy6kNoYObGQeRQs/G83dV0MqsAvbxi/74A
         OBg38XVfb0lJh1A4INf0f6AEsGAqX5foHRvFcrVVSZ9ZoR7vC+u9P81RlVRHm51icA7h
         S1Jw==
X-Gm-Message-State: AOAM532L4MwWA2urUgxB7GEeOwhxQDVTrkps0p5A3QLb0cFR64IBxH30
        0CLCthdvWXZ/rEI+/mfRgbvK1wvfFvH24lBbDjk=
X-Google-Smtp-Source: ABdhPJyEK8+Byql7A0tBuqHHoWl83Ii9PjLd5iW6AtCqucuzEWWTvFOgOvC2/40sWN3AyPMLsDiliuUVR0XwAC+zuEw=
X-Received: by 2002:a05:6e02:b4a:: with SMTP id f10mr9870349ilu.278.1617948810954;
 Thu, 08 Apr 2021 23:13:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200828012844.18937-1-gmayyyha@gmail.com>
In-Reply-To: <20200828012844.18937-1-gmayyyha@gmail.com>
From:   Yanhu Cao <gmayyyha@gmail.com>
Date:   Fri, 9 Apr 2021 14:13:20 +0800
Message-ID: <CAB9OAC0A_=fMGBNMOufMG1n81x4Mn20W1GqPPYGuRuC2MJLWHA@mail.gmail.com>
Subject: Re: [v2] ceph: support getting ceph.dir.rsnaps vxattr
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

ping @jeff @Ilya

On Fri, Aug 28, 2020 at 9:29 AM Yanhu Cao <gmayyyha@gmail.com> wrote:
>
> It's easy to know how many snapshots have been created.
>
> Link: https://tracker.ceph.com/issues/47168
> Signed-off-by: Yanhu Cao <gmayyyha@gmail.com>
> ---
>  fs/ceph/inode.c      | 1 +
>  fs/ceph/mds_client.c | 9 ++++++++-
>  fs/ceph/mds_client.h | 1 +
>  fs/ceph/super.h      | 2 +-
>  fs/ceph/xattr.c      | 7 +++++++
>  5 files changed, 18 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 357c937699d5..650cad4b3ecb 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -891,6 +891,7 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
>                         ci->i_rfiles = le64_to_cpu(info->rfiles);
>                         ci->i_rsubdirs = le64_to_cpu(info->rsubdirs);
>                         ci->i_dir_pin = iinfo->dir_pin;
> +                       ci->i_rsnaps = iinfo->rsnaps;
>                         ceph_decode_timespec64(&ci->i_rctime, &info->rctime);
>                 }
>         }
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 4a26862d7667..3466845c0179 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -176,6 +176,13 @@ static int parse_reply_info_in(void **p, void *end,
>                         memset(&info->snap_btime, 0, sizeof(info->snap_btime));
>                 }
>
> +               /* snapshot count, remains zero for v<=3 */
> +               if (struct_v >= 4) {
> +                       ceph_decode_64_safe(p, end, info->rsnaps, bad);
> +               } else {
> +                       info->rsnaps = 0;
> +               }
> +
>                 *p = end;
>         } else {
>                 if (features & CEPH_FEATURE_MDS_INLINE_DATA) {
> @@ -214,7 +221,7 @@ static int parse_reply_info_in(void **p, void *end,
>                 }
>
>                 info->dir_pin = -ENODATA;
> -               /* info->snap_btime remains zero */
> +               /* info->snap_btime and info->rsnaps remain zero */
>         }
>         return 0;
>  bad:
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index bc9e95937d7c..76f2ed1a7cbf 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -88,6 +88,7 @@ struct ceph_mds_reply_info_in {
>         s32 dir_pin;
>         struct ceph_timespec btime;
>         struct ceph_timespec snap_btime;
> +       u64 rsnaps;
>         u64 change_attr;
>  };
>
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 4c3c964b1c54..eb108b69da71 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -332,7 +332,7 @@ struct ceph_inode_info {
>
>         /* for dirs */
>         struct timespec64 i_rctime;
> -       u64 i_rbytes, i_rfiles, i_rsubdirs;
> +       u64 i_rbytes, i_rfiles, i_rsubdirs, i_rsnaps;
>         u64 i_files, i_subdirs;
>
>         /* quotas */
> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> index 3a733ac33d9b..c7d8ecc3d04b 100644
> --- a/fs/ceph/xattr.c
> +++ b/fs/ceph/xattr.c
> @@ -231,6 +231,12 @@ static ssize_t ceph_vxattrcb_dir_rsubdirs(struct ceph_inode_info *ci, char *val,
>         return ceph_fmt_xattr(val, size, "%lld", ci->i_rsubdirs);
>  }
>
> +static ssize_t ceph_vxattrcb_dir_rsnaps(struct ceph_inode_info *ci, char *val,
> +                                         size_t size)
> +{
> +       return ceph_fmt_xattr(val, size, "%lld", ci->i_rsnaps);
> +}
> +
>  static ssize_t ceph_vxattrcb_dir_rbytes(struct ceph_inode_info *ci, char *val,
>                                         size_t size)
>  {
> @@ -352,6 +358,7 @@ static struct ceph_vxattr ceph_dir_vxattrs[] = {
>         XATTR_RSTAT_FIELD(dir, rentries),
>         XATTR_RSTAT_FIELD(dir, rfiles),
>         XATTR_RSTAT_FIELD(dir, rsubdirs),
> +       XATTR_RSTAT_FIELD(dir, rsnaps),
>         XATTR_RSTAT_FIELD(dir, rbytes),
>         XATTR_RSTAT_FIELD(dir, rctime),
>         {
> --
> 2.24.3 (Apple Git-128)
>
