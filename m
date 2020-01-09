Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61C61135BC5
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Jan 2020 15:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731864AbgAIOxj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 Jan 2020 09:53:39 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:35754 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731858AbgAIOxi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 9 Jan 2020 09:53:38 -0500
Received: by mail-il1-f195.google.com with SMTP id g12so5948083ild.2;
        Thu, 09 Jan 2020 06:53:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nxj1NohLwynzusvTylkvqHcVRRLlgAq4FJ2K76DsupI=;
        b=ZQriRxIioOZpxkvtOGQpGXVN6tAeUmZrPb6witcbCzIm+YWY4RZZan0VcWiq2TtIN5
         x5sUTIZ7XkgNwvdQVofAogqAY8oQS64yZnhAUq0sK1IT2HAoYmYqagT9VKKjD2dSk0lI
         bmRnRo3oYdc/uz4YGQkG8wbJ1AG55x+wi2A+rtMa09bH3nP0xX+7rlCSf/StF4t2MqVT
         aAJ0Vk2h7ucQfYH+xOCEv14FR6oAY1dFzeOM6MOuWWWsDSx3EM6lFLhk4MF28b7pkm2t
         306zBuQ/VX4aj1MPMtOOaH/WxxQrv8M4Wc0IljE759XyezGCiA2dFjCUn9s+iYKegWgT
         7luA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nxj1NohLwynzusvTylkvqHcVRRLlgAq4FJ2K76DsupI=;
        b=eOGJxIzo2HqWSlXzLEtFoiTfmScz0CpLbU/a5mvSQvcPUOsUbzSSRpm1e0DQBfcZuo
         /hXBailTAmOu5nTMgyhLmwg9TXpAjrfQtPWBM4XXF5m4ljH727Qhx1OMGe8hjz87wpF0
         SxOCzsAxbANz+yiuBQax16fzBgsvdxcxr7eGW8+TPtdSHqSCla6BOpaZcwoXdmKS2uBa
         TYCVNqKrajZIyg+uVkk5w0GKbRDPeL6E8wM4uu7Q3Cq/23EkQiN7f4ddV8/6fyAaezvz
         AqcXkT6Dunt4RnGFWr0Wqlqt//+YiicjbJuSH0yr/KUJTr3ULf1fP/3o0mMynJ/cN++C
         uWmg==
X-Gm-Message-State: APjAAAXGCeFfToOiNf4ev2JowwNvnQck5dyc4YG8ajFiaV8GiZ7O3qQ0
        1m36vMwEb8e132oaoO8jCIPlcLNpcRECfHYIpKqfYUxnOfs=
X-Google-Smtp-Source: APXvYqwprwBK8Hm+GSZWJwA5Oxwhytc9+kCgLxO00EHxYwF3mJywBmC5nPKm9KwDme1hPSyPMqg8UrHw69dN5T+v27I=
X-Received: by 2002:a92:d7c6:: with SMTP id g6mr8744388ilq.282.1578581618138;
 Thu, 09 Jan 2020 06:53:38 -0800 (PST)
MIME-Version: 1.0
References: <20200108100353.23770-1-lhenriques@suse.com> <913eb28e6bb698f27f1831f75ea5250497ee659c.camel@kernel.org>
 <20200109143011.GA14582@brahms>
In-Reply-To: <20200109143011.GA14582@brahms>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 9 Jan 2020 15:53:28 +0100
Message-ID: <CAOi1vP-YbPswsmk5TicVwnspBSkz9_8HreOWmpU=kZeTWWiV-A@mail.gmail.com>
Subject: Re: [RFC PATCH v4] ceph: use 'copy-from2' operation in copy_file_range
To:     Luis Henriques <lhenriques@suse.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        Gregory Farnum <gfarnum@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Jan 9, 2020 at 3:30 PM Luis Henriques <lhenriques@suse.com> wrote:
>
> On Thu, Jan 09, 2020 at 08:06:17AM -0500, Jeff Layton wrote:
> > On Wed, 2020-01-08 at 10:03 +0000, Luis Henriques wrote:
> > > Instead of using the 'copy-from' operation, switch copy_file_range to the
> > > new 'copy-from2' operation, which allows to send the truncate_seq and
> > > truncate_size parameters.
> > >
> > > If an OSD does not support the 'copy-from2' operation it will return
> > > -EOPNOTSUPP.  In that case, the kernel client will stop trying to do
> > > remote object copies for this fs client and will always use the generic
> > > VFS copy_file_range.
> > >
> > > Signed-off-by: Luis Henriques <lhenriques@suse.com>
> > > ---
> > > Hi Jeff,
> > >
> > > This is a follow-up to the discussion in [1].  Since PR [2] has been
> > > merged, it's now time to change the kernel client to use the new
> > > 'copy-from2'.  And that's what this patch does.
> > >
> > > [1] https://lore.kernel.org/lkml/20191118120935.7013-1-lhenriques@suse.com/
> > > [2] https://github.com/ceph/ceph/pull/31728
> > >
> > >  fs/ceph/file.c                  | 13 ++++++++++++-
> > >  fs/ceph/super.c                 |  1 +
> > >  fs/ceph/super.h                 |  3 +++
> > >  include/linux/ceph/osd_client.h |  1 +
> > >  include/linux/ceph/rados.h      |  2 ++
> > >  net/ceph/osd_client.c           | 18 ++++++++++++------
> > >  6 files changed, 31 insertions(+), 7 deletions(-)
> > >
> > > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > > index 11929d2bb594..1e6cdf2dfe90 100644
> > > --- a/fs/ceph/file.c
> > > +++ b/fs/ceph/file.c
> > > @@ -1974,6 +1974,10 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
> > >     if (ceph_test_mount_opt(src_fsc, NOCOPYFROM))
> > >             return -EOPNOTSUPP;
> > >
> > > +   /* Do the OSDs support the 'copy-from2' operation? */
> > > +   if (!src_fsc->have_copy_from2)
> > > +           return -EOPNOTSUPP;
> > > +
> > >     /*
> > >      * Striped file layouts require that we copy partial objects, but the
> > >      * OSD copy-from operation only supports full-object copies.  Limit
> > > @@ -2101,8 +2105,15 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
> > >                     CEPH_OSD_OP_FLAG_FADVISE_NOCACHE,
> > >                     &dst_oid, &dst_oloc,
> > >                     CEPH_OSD_OP_FLAG_FADVISE_SEQUENTIAL |
> > > -                   CEPH_OSD_OP_FLAG_FADVISE_DONTNEED, 0);
> > > +                   CEPH_OSD_OP_FLAG_FADVISE_DONTNEED,
> > > +                   dst_ci->i_truncate_seq, dst_ci->i_truncate_size,
> > > +                   CEPH_OSD_COPY_FROM_FLAG_TRUNCATE_SEQ);
> > >             if (err) {
> > > +                   if (err == -EOPNOTSUPP) {
> > > +                           src_fsc->have_copy_from2 = false;
> > > +                           pr_notice("OSDs don't support 'copy-from2'; "
> > > +                                     "disabling copy_file_range\n");
> > > +                   }
> > >                     dout("ceph_osdc_copy_from returned %d\n", err);
> > >                     if (!ret)
> > >                             ret = err;
> >
> > The patch itself looks fine to me. I'll not merge yet, since you sent it
> > as an RFC, but I don't have any objection to it at first glance.
>
> I was going to drop the RFC, but then at the last minute decided to leave.
>
> >                                                                    The
> > only other comment I'd make is that you should probably split this into
> > two patches -- one for the libceph changes and one for cephfs.
>
> Hmm... TBH I didn't thought about that, but since the libceph patch would
> be changing its API (ceph_osdc_copy_from would have 2 extra parameters), I
> don't think that's a good idea.  Bisection would be broken between these 2
> patches.

Yeah, no need to split.

Thanks,

                Ilya
