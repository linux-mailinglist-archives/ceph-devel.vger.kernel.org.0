Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E55451DE177
	for <lists+ceph-devel@lfdr.de>; Fri, 22 May 2020 10:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728371AbgEVIB7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 22 May 2020 04:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728152AbgEVIB6 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 22 May 2020 04:01:58 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC8CEC061A0E
        for <ceph-devel@vger.kernel.org>; Fri, 22 May 2020 01:01:58 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id fb16so4344447qvb.5
        for <ceph-devel@vger.kernel.org>; Fri, 22 May 2020 01:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9W6z8O+XqQuDuVippV/ZH4zzbGTV7q0BLvCNX5r537Q=;
        b=fRiobJir3LOoTBpx8HSkS2+9jHzjIoVbJwdOy6JIIGGVewjQyHb008ypavWkRm1bJ3
         eoo1ACOXsjOIzlN0SQ8vQ7nCrc3U0G9q4fkrtsatt9GBpYgaHtQkFvgsGvqG1od60atR
         O8g8PSMXANLGKQSeix1hJoUEyUsbXBO3CotMoPTfm5NcKiyyHfDHjagRo+ROykX4Kjd8
         3YpqE8JajvJxBYv7HbukqbFtapkK7thv59zHQUpASLIR2ByzRQodwIHpEYu9yQrmw2ie
         UMDF9HTNrjMCYvl75bbvJf9fKL0rU7Bb04sKB7aFYhkBdf8ZjHw+OR9tD/ygp4M0DTdr
         pUXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9W6z8O+XqQuDuVippV/ZH4zzbGTV7q0BLvCNX5r537Q=;
        b=g2mS22kZ0HAL8dqzbq/DH3UPtokAw9qZzEz2tRdzg175eeCjPvjwm1RffgXd6NtjvG
         P5j3EorfMlwTM+SvUkooPLdsHzC/Wkl6LjAPeRixDrVni1bdM2bzCGDD/ft9OH3joR3A
         gbo23Bjk2LvUtn+ULaPZXbWRRxScIlOGnKQjyRwRzjNRNh3W9SkdKB3d7BQcepyGe97T
         KZdu5Nds/uq4FgyBKfnKGSDu2pPfooEPv6Kk7pKu8K3nSaZa9rb0BYu6JwsX5J0F9rAh
         lVenOQ6OE+49Lt1d3Tcfvp2eFFIl6uINqPl6N0kkkBe8zC3UqiPUowWNdyVY/reCuoCx
         5naw==
X-Gm-Message-State: AOAM531thxOEoqy1mApQw87/cLxi9o7xUTU3bgLhRqZPD1AZOJaEoH90
        73OkEl48KZYY6Rub0bebHpsUSMpCcrYwmY39xeKUToq2vnQ=
X-Google-Smtp-Source: ABdhPJxKETZh2qCK1F8p250VxVyS7xs0/FpJrTOtmDgh8vavywfBolodTUJ2iqK03oaju25/7wRhpiTyBo/qhteM4mQ=
X-Received: by 2002:a0c:f887:: with SMTP id u7mr2616776qvn.32.1590134517970;
 Fri, 22 May 2020 01:01:57 -0700 (PDT)
MIME-Version: 1.0
References: <1590046576-1262-1-git-send-email-xiubli@redhat.com>
 <CAAM7YAmoCHXB1fLSXt0fqOczqbm9s_2yfWbyAaaMuQRCNR5+3Q@mail.gmail.com> <c1cfcbda-217a-18ca-4320-99f67696f85d@redhat.com>
In-Reply-To: <c1cfcbda-217a-18ca-4320-99f67696f85d@redhat.com>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Fri, 22 May 2020 16:01:46 +0800
Message-ID: <CAAM7YAm3h4zLN68R2akE3+MatQe2SBd_d5o5CvZGisRrMapCBg@mail.gmail.com>
Subject: Re: [PATCH] ceph: add ceph_async_check_caps() to avoid double lock
 and deadlock
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, Zheng Yan <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, May 22, 2020 at 3:31 PM Xiubo Li <xiubli@redhat.com> wrote:
>
> On 2020/5/21 16:45, Yan, Zheng wrote:
> > On Thu, May 21, 2020 at 3:39 PM <xiubli@redhat.com> wrote:
> >> From: Xiubo Li <xiubli@redhat.com>
> >>
> >> In the ceph_check_caps() it may call the session lock/unlock stuff.
> >>
> >> There have some deadlock cases, like:
> >> handle_forward()
> >> ...
> >> mutex_lock(&mdsc->mutex)
> >> ...
> >> ceph_mdsc_put_request()
> >>    --> ceph_mdsc_release_request()
> >>      --> ceph_put_cap_request()
> >>        --> ceph_put_cap_refs()
> >>          --> ceph_check_caps()
> >> ...
> >> mutex_unlock(&mdsc->mutex)
> > For this case, it's better to call ceph_mdsc_put_request() after
> > unlock mdsc->mutex
>
> Hi Zheng Yan, Jeff
>
> For this case there at least have 6 places, for some cases we can call
> ceph_mdsc_put_request() after unlock mdsc->mutex very easily, but for
> the others like:
>
> cleanup_session_requests()
>
>      --> mutex_lock(&mdsc->mutex);
>
>      --> __unregister_request()
>
>          --> ceph_mdsc_put_request() ===> will call session lock/unlock pair
>
>      --> mutex_unlock(&mdsc->mutex);
>
> There also has some more complicated cases, such as in handle_session(do
> the mdsc->mutex lock/unlock pair) --> __wake_requests() -->
> __do_request() --> __unregister_request() --> ceph_mdsc_put_request().
>
> Maybe using the ceph_async_check_caps() is a better choice here, any idea ?
>

I think it's better to put_cap_refs async (only for
ceph_mdsc_release_dir_caps) instead of async check_caps.

> Thanks
>
> BRs
>
> Xiubo
>
>
> >> And also there maybe has some double session lock cases, like:
> >>
> >> send_mds_reconnect()
> >> ...
> >> mutex_lock(&session->s_mutex);
> >> ...
> >>    --> replay_unsafe_requests()
> >>      --> ceph_mdsc_release_dir_caps()
> >>        --> ceph_put_cap_refs()
> >>          --> ceph_check_caps()
> >> ...
> >> mutex_unlock(&session->s_mutex);
> > There is no point to check_caps() and send cap message while
> > reconnecting caps. So I think it's better to just skip calling
> > ceph_check_caps() for this case.
> >
> > Regards
> > Yan, Zheng
> >
> >> URL: https://tracker.ceph.com/issues/45635
> >> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> >> ---
> >>   fs/ceph/caps.c  |  2 +-
> >>   fs/ceph/inode.c | 10 ++++++++++
> >>   fs/ceph/super.h | 12 ++++++++++++
> >>   3 files changed, 23 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> >> index 27c2e60..08194c4 100644
> >> --- a/fs/ceph/caps.c
> >> +++ b/fs/ceph/caps.c
> >> @@ -3073,7 +3073,7 @@ void ceph_put_cap_refs(struct ceph_inode_info *ci, int had)
> >>               last ? " last" : "", put ? " put" : "");
> >>
> >>          if (last)
> >> -               ceph_check_caps(ci, 0, NULL);
> >> +               ceph_async_check_caps(ci);
> >>          else if (flushsnaps)
> >>                  ceph_flush_snaps(ci, NULL);
> >>          if (wake)
> >> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> >> index 357c937..84a61d4 100644
> >> --- a/fs/ceph/inode.c
> >> +++ b/fs/ceph/inode.c
> >> @@ -35,6 +35,7 @@
> >>   static const struct inode_operations ceph_symlink_iops;
> >>
> >>   static void ceph_inode_work(struct work_struct *work);
> >> +static void ceph_check_caps_work(struct work_struct *work);
> >>
> >>   /*
> >>    * find or create an inode, given the ceph ino number
> >> @@ -518,6 +519,7 @@ struct inode *ceph_alloc_inode(struct super_block *sb)
> >>          INIT_LIST_HEAD(&ci->i_snap_flush_item);
> >>
> >>          INIT_WORK(&ci->i_work, ceph_inode_work);
> >> +       INIT_WORK(&ci->check_caps_work, ceph_check_caps_work);
> >>          ci->i_work_mask = 0;
> >>          memset(&ci->i_btime, '\0', sizeof(ci->i_btime));
> >>
> >> @@ -2012,6 +2014,14 @@ static void ceph_inode_work(struct work_struct *work)
> >>          iput(inode);
> >>   }
> >>
> >> +static void ceph_check_caps_work(struct work_struct *work)
> >> +{
> >> +       struct ceph_inode_info *ci = container_of(work, struct ceph_inode_info,
> >> +                                                 check_caps_work);
> >> +
> >> +       ceph_check_caps(ci, 0, NULL);
> >> +}
> >> +
> >>   /*
> >>    * symlinks
> >>    */
> >> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> >> index 226f19c..96d0e41 100644
> >> --- a/fs/ceph/super.h
> >> +++ b/fs/ceph/super.h
> >> @@ -421,6 +421,8 @@ struct ceph_inode_info {
> >>          struct timespec64 i_btime;
> >>          struct timespec64 i_snap_btime;
> >>
> >> +       struct work_struct check_caps_work;
> >> +
> >>          struct work_struct i_work;
> >>          unsigned long  i_work_mask;
> >>
> >> @@ -1102,6 +1104,16 @@ extern void ceph_flush_snaps(struct ceph_inode_info *ci,
> >>   extern bool __ceph_should_report_size(struct ceph_inode_info *ci);
> >>   extern void ceph_check_caps(struct ceph_inode_info *ci, int flags,
> >>                              struct ceph_mds_session *session);
> >> +static void inline
> >> +ceph_async_check_caps(struct ceph_inode_info *ci)
> >> +{
> >> +       struct inode *inode = &ci->vfs_inode;
> >> +
> >> +       /* It's okay if queue_work fails */
> >> +       queue_work(ceph_inode_to_client(inode)->inode_wq,
> >> +                  &ceph_inode(inode)->check_caps_work);
> >> +}
> >> +
> >>   extern void ceph_check_delayed_caps(struct ceph_mds_client *mdsc);
> >>   extern void ceph_flush_dirty_caps(struct ceph_mds_client *mdsc);
> >>   extern int  ceph_drop_caps_for_unlink(struct inode *inode);
> >> --
> >> 1.8.3.1
> >>
>
