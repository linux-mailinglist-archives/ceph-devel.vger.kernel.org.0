Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A17F263785
	for <lists+ceph-devel@lfdr.de>; Wed,  9 Sep 2020 22:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729005AbgIIUev (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 9 Sep 2020 16:34:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbgIIUeu (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 9 Sep 2020 16:34:50 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C421EC061573
        for <ceph-devel@vger.kernel.org>; Wed,  9 Sep 2020 13:34:49 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id d18so4625986iop.13
        for <ceph-devel@vger.kernel.org>; Wed, 09 Sep 2020 13:34:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z6vlYFDR/6lGP5wNoj3+4SYzXCUu/fkfvTT0oo6rf3w=;
        b=SjG782x99UTi1PxwRKztsHS7+uCWZcVJMW2hYaceXR9IFzqdCmtz3fkyVibhFanTlF
         7UL4H+kWeKL/Z9G/SE9F1UEzl3x5MMpxN7mFNc98XW49QJhUJTL+f1y5xXPoUCQ/6Z01
         sX26CorSjNVUFu0d06eDVcGZdIzKNZdqnPT0qx2xDlHizf8XUYIONuqsuUfrsloLVv23
         k3TGx7da8rFHMdJmR34FbLKLmvpBBBgcRwf9LOLU/OZCcsMco6PGrcVQXhdzTum1uKu2
         thNUBblirrsfne0wo7N/CltsbHf0MrlhoYLLLDyqzTGA8dQ01hUsEJZkU27W3xWuWMER
         XaZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z6vlYFDR/6lGP5wNoj3+4SYzXCUu/fkfvTT0oo6rf3w=;
        b=qh3AjeqxaPk466NRNx7N4nIoi5uRvAFjub7RDzprDplkBkcVw7eFZxztNga7rfVVta
         ibah8eWdT1ZUoAZYaYkezGkC3mZJN7IuA3mtj0A6VOe549ISJ2AfRxg/XsCYj9I0GtW+
         iJZzxxPm3ientV54q0yJbn450uymnLtvq4XQXzfQ2b39m9+W8fw1KbXD9RJlhQmVxMz6
         aeCaxyHYqI6qHVjjhjXH8QdfvMibpjc6r6TeUOIw7qBYiXN2JO3trZGx9Un+Ucp8jvVu
         Sqcs9eBKVBgk6en0dZZF/2s+BwOXjupEYGF4yyI40x07u0bEiNgkssBfLOKe369evy5G
         pTow==
X-Gm-Message-State: AOAM5326hxHXsIqb1DcDktkIqwUYWGN9OMcWZ2KR4PlsGALKwKthbYGD
        +j1COAK1vpKzJa9CdvyaZWex16J4Z7s2b7VN4Kc=
X-Google-Smtp-Source: ABdhPJwHLpN5Rso7TQvOF7XGqT37y/xhYKR1CAjs2Cdu5tTI50vc4TCv+8HyVG1yH18Ek/cA7fb1HdSPE1xrUO4LnpI=
X-Received: by 2002:a6b:244:: with SMTP id 65mr4718106ioc.7.1599683688616;
 Wed, 09 Sep 2020 13:34:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200903130140.799392-1-xiubli@redhat.com> <449a56624f3dd4e2a4a4cf95cd24d69c53700b6d.camel@kernel.org>
 <ad35f2f8-6692-3918-6137-adc8e95607c6@redhat.com>
In-Reply-To: <ad35f2f8-6692-3918-6137-adc8e95607c6@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 9 Sep 2020 22:34:38 +0200
Message-ID: <CAOi1vP-8rbzZ=-Apir2B4Z6U10ZKrp41d6+BYgvGsyL+ND-JnQ@mail.gmail.com>
Subject: Re: [PATCH v5 0/2] ceph: metrics for opened files, pinned caps and
 opened inodes
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>, "Yan, Zheng" <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Sep 3, 2020 at 4:22 PM Xiubo Li <xiubli@redhat.com> wrote:
>
> On 2020/9/3 22:18, Jeff Layton wrote:
> > On Thu, 2020-09-03 at 09:01 -0400, xiubli@redhat.com wrote:
> >> From: Xiubo Li <xiubli@redhat.com>
> >>
> >> Changed in V5:
> >> - Remove mdsc parsing helpers except the ceph_sb_to_mdsc()
> >> - Remove the is_opened member.
> >>
> >> Changed in V4:
> >> - A small fix about the total_inodes.
> >>
> >> Changed in V3:
> >> - Resend for V2 just forgot one patch, which is adding some helpers
> >> support to simplify the code.
> >>
> >> Changed in V2:
> >> - Add number of inodes that have opened files.
> >> - Remove the dir metrics and fold into files.
> >>
> >>
> >>
> >> Xiubo Li (2):
> >>    ceph: add ceph_sb_to_mdsc helper support to parse the mdsc
> >>    ceph: metrics for opened files, pinned caps and opened inodes
> >>
> >>   fs/ceph/caps.c    | 41 +++++++++++++++++++++++++++++++++++++----
> >>   fs/ceph/debugfs.c | 11 +++++++++++
> >>   fs/ceph/dir.c     | 20 +++++++-------------
> >>   fs/ceph/file.c    | 13 ++++++-------
> >>   fs/ceph/inode.c   | 11 ++++++++---
> >>   fs/ceph/locks.c   |  2 +-
> >>   fs/ceph/metric.c  | 14 ++++++++++++++
> >>   fs/ceph/metric.h  |  7 +++++++
> >>   fs/ceph/quota.c   | 10 +++++-----
> >>   fs/ceph/snap.c    |  2 +-
> >>   fs/ceph/super.h   |  6 ++++++
> >>   11 files changed, 103 insertions(+), 34 deletions(-)
> >>
> > Looks good. I went ahead and merge this into testing.
> >
> > Small merge conflict in quota.c, which I guess is probably due to not
> > basing this on testing branch. I also dropped what looks like an
> > unrelated hunk in the second patch.
> >
> > In the future, if you can be sure that patches you post apply cleanly to
> > testing branch then that would make things easier.
>
> Okay, will do it.

Hi Xiubo,

There is a problem with lifetimes here.  mdsc isn't guaranteed to exist
when ->free_inode() is called.  This can lead to crashes on a NULL mdsc
in ceph_free_inode() in case of e.g. "umount -f".  I know it was Jeff's
suggestion to move the decrement of total_inodes into ceph_free_inode(),
but it doesn't look like it can be easily deferred past ->evict_inode().

Thanks,

                Ilya
