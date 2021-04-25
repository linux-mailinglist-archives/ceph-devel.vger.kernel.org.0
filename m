Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF72B36A414
	for <lists+ceph-devel@lfdr.de>; Sun, 25 Apr 2021 04:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbhDYCJa (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 24 Apr 2021 22:09:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbhDYCJ3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 24 Apr 2021 22:09:29 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C00D8C061574;
        Sat, 24 Apr 2021 19:08:48 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id l19so3263277ilk.13;
        Sat, 24 Apr 2021 19:08:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q5joxXb+m/AVdWJQOkqgevuyLLpgBYLxWdlDLAg7wMg=;
        b=do7M+ldMyEfGW+Q1uF7F/gfSPJxniLSiW77dXEOUwj5kwiawaMxIooITghT+PjQ2d5
         SXWu8arNGGhAJ1ph04Jc4pThLKLt35fzmaZ3vNSNkgOO6Ntwi/1VzV/+N2WOr9z+ppGk
         owM/40ZQKdeJiuqorYdmJos8CopPTuoBH9zBYbJYSrQUXOcoMDvIDNjVm0pH6qZregEc
         H1xQZusBMV1VVg4Y48fO1xrVb2UcVovjU6UlFhelz/bJRPLqax25JEUFV6UZgcIkRF+J
         OrmndMcw+ivnRMpLDSMfd/4cQHF7B5J6wGWQ/7tzcPfehK7GNE3LrJxVeaGaXy7xsOPb
         j07g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q5joxXb+m/AVdWJQOkqgevuyLLpgBYLxWdlDLAg7wMg=;
        b=b6eJ5etaqQuGas28+rxCVNtzrQrX9wr9yOu6ORTEuJtCznBRcOY4QBJ79IALPpd2cb
         Sd6KCzO5iKe3qzfcLuag56R6yJ55o26+1I1g2RCiqH1ZFaRbFGAaqyqo5PUT+O+prFrn
         0GmgDlnAsfTeGmnE/S3xCsPhYUhZVxPYkolGFyDOX8x1cHJUpHWh8sScqPtZVwUsI/OL
         MiQkHy5SyCeZNBD7QookLOsd8aLSOrtFdx371cegva9rB6AoL9vtC0tL36lDcIA+pYBz
         Y9BJYiA/U7QU9/eAIGaqflNigM+2z0WijZko4UbrBfhzpfEYts5wi1fPhRjoPQL6emDl
         ey7A==
X-Gm-Message-State: AOAM530Z8teOmQ+l7oGx6AF6CKlgi/Bl1x/fm+eLyTjle1+gcLzzPdWU
        Z22H4enl0i5Ju2vJCfo79l00buf2hw+D40d0G/MSgh0D
X-Google-Smtp-Source: ABdhPJz9QSmeGDdV6grzI6q+QQx+mUj7HFsUDlSO4lGcPT0WVuDz9SKuQ4yieDUEuDKmA7qmDeCruCXCjRJwtEgytIo=
X-Received: by 2002:a92:c525:: with SMTP id m5mr8077018ili.298.1619316528222;
 Sat, 24 Apr 2021 19:08:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200828012844.18937-1-gmayyyha@gmail.com> <e3830bc562d86e7d82542a3ee3d6ce66c901fda0.camel@kernel.org>
In-Reply-To: <e3830bc562d86e7d82542a3ee3d6ce66c901fda0.camel@kernel.org>
From:   Yanhu Cao <gmayyyha@gmail.com>
Date:   Sun, 25 Apr 2021 10:08:37 +0800
Message-ID: <CAB9OAC2fXT_wWm9tf1bKAsZfX0mO=-s8znqMMj+hkU8SCZsaVw@mail.gmail.com>
Subject: Re: [v2] ceph: support getting ceph.dir.rsnaps vxattr
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Apr 9, 2021 at 8:50 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Fri, 2020-08-28 at 09:28 +0800, Yanhu Cao wrote:
> > It's easy to know how many snapshots have been created.
> >
> > Link: https://tracker.ceph.com/issues/47168
> > Signed-off-by: Yanhu Cao <gmayyyha@gmail.com>
> > ---
> >  fs/ceph/inode.c      | 1 +
> >  fs/ceph/mds_client.c | 9 ++++++++-
> >  fs/ceph/mds_client.h | 1 +
> >  fs/ceph/super.h      | 2 +-
> >  fs/ceph/xattr.c      | 7 +++++++
> >  5 files changed, 18 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> > index 357c937699d5..650cad4b3ecb 100644
> > --- a/fs/ceph/inode.c
> > +++ b/fs/ceph/inode.c
> > @@ -891,6 +891,7 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
> >                       ci->i_rfiles = le64_to_cpu(info->rfiles);
> >                       ci->i_rsubdirs = le64_to_cpu(info->rsubdirs);
> >                       ci->i_dir_pin = iinfo->dir_pin;
> > +                     ci->i_rsnaps = iinfo->rsnaps;
> >                       ceph_decode_timespec64(&ci->i_rctime, &info->rctime);
> >               }
> >       }
> > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > index 4a26862d7667..3466845c0179 100644
> > --- a/fs/ceph/mds_client.c
> > +++ b/fs/ceph/mds_client.c
> > @@ -176,6 +176,13 @@ static int parse_reply_info_in(void **p, void *end,
> >                       memset(&info->snap_btime, 0, sizeof(info->snap_btime));
> >               }
> >
> > +             /* snapshot count, remains zero for v<=3 */
> > +             if (struct_v >= 4) {
> > +                     ceph_decode_64_safe(p, end, info->rsnaps, bad);
> > +             } else {
> > +                     info->rsnaps = 0;
> > +             }
> > +
> >               *p = end;
> >       } else {
> >               if (features & CEPH_FEATURE_MDS_INLINE_DATA) {
> > @@ -214,7 +221,7 @@ static int parse_reply_info_in(void **p, void *end,
> >               }
> >
> >               info->dir_pin = -ENODATA;
> > -             /* info->snap_btime remains zero */
> > +             /* info->snap_btime and info->rsnaps remain zero */
> >       }
> >       return 0;
> >  bad:
> > diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> > index bc9e95937d7c..76f2ed1a7cbf 100644
> > --- a/fs/ceph/mds_client.h
> > +++ b/fs/ceph/mds_client.h
> > @@ -88,6 +88,7 @@ struct ceph_mds_reply_info_in {
> >       s32 dir_pin;
> >       struct ceph_timespec btime;
> >       struct ceph_timespec snap_btime;
> > +     u64 rsnaps;
> >       u64 change_attr;
> >  };
> >
> > diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> > index 4c3c964b1c54..eb108b69da71 100644
> > --- a/fs/ceph/super.h
> > +++ b/fs/ceph/super.h
> > @@ -332,7 +332,7 @@ struct ceph_inode_info {
> >
> >       /* for dirs */
> >       struct timespec64 i_rctime;
> > -     u64 i_rbytes, i_rfiles, i_rsubdirs;
> > +     u64 i_rbytes, i_rfiles, i_rsubdirs, i_rsnaps;
> >       u64 i_files, i_subdirs;
> >
> >       /* quotas */
> > diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> > index 3a733ac33d9b..c7d8ecc3d04b 100644
> > --- a/fs/ceph/xattr.c
> > +++ b/fs/ceph/xattr.c
> > @@ -231,6 +231,12 @@ static ssize_t ceph_vxattrcb_dir_rsubdirs(struct ceph_inode_info *ci, char *val,
> >       return ceph_fmt_xattr(val, size, "%lld", ci->i_rsubdirs);
> >  }
> >
> > +static ssize_t ceph_vxattrcb_dir_rsnaps(struct ceph_inode_info *ci, char *val,
> > +                                       size_t size)
> > +{
> > +     return ceph_fmt_xattr(val, size, "%lld", ci->i_rsnaps);
> > +}
> > +
> >  static ssize_t ceph_vxattrcb_dir_rbytes(struct ceph_inode_info *ci, char *val,
> >                                       size_t size)
> >  {
> > @@ -352,6 +358,7 @@ static struct ceph_vxattr ceph_dir_vxattrs[] = {
> >       XATTR_RSTAT_FIELD(dir, rentries),
> >       XATTR_RSTAT_FIELD(dir, rfiles),
> >       XATTR_RSTAT_FIELD(dir, rsubdirs),
> > +     XATTR_RSTAT_FIELD(dir, rsnaps),
> >       XATTR_RSTAT_FIELD(dir, rbytes),
> >       XATTR_RSTAT_FIELD(dir, rctime),
> >       {
>
> Sorry we missed this one Yanhu. In the future, please put [PATCH] in the
> subject line in some fashion and we may spot it more easily.

OK. will do.

>
> This looks fine to me -- merged into ceph-client/testing branch, though
> I did revise the changelog to be a bit more descriptive. Tell me if you
> think it needs changes.

LGTM.

>
> Thanks!
> --
> Jeff Layton <jlayton@kernel.org>
>
