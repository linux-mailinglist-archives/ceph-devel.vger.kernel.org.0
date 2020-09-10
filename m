Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D92EA263CE4
	for <lists+ceph-devel@lfdr.de>; Thu, 10 Sep 2020 08:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbgIJGBk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 10 Sep 2020 02:01:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbgIJGBC (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 10 Sep 2020 02:01:02 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5127EC061573
        for <ceph-devel@vger.kernel.org>; Wed,  9 Sep 2020 23:01:01 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id l4so4620284ilq.2
        for <ceph-devel@vger.kernel.org>; Wed, 09 Sep 2020 23:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TF/ydsengbd4wJskSgsKyK9aVHLUv1vLGJ7JAs7cqUc=;
        b=R5UuzlrF10oErcxUCpNyCMRGzZGmMxFCchjDidnnU0WLLN7PmCvevdgZErIaGC25l+
         xb0lSDJSaHofdk6fS388TvmWpEremRCWFgUu8FqplZ+8Os914nkGRwKY/1pDGXrYCCQ9
         QjN+w2RjIdY6Mqpn3vYsRVWyVWR2r5DKmmP5lhfdPiUGcYfauQfL/zHzpW4sQBmtiaHi
         kZ0sWZw9ftdtlxt/qnFpmNwpSNWSNs2wRUdHqAl/UsG+5KFCZwKob78k+QawATSCOQTs
         +YgfxbKtxjwrbpl3olLURdm5L7N0P+RZ1hlMsRwWd0BsyAknGyWZZS8+QzL0omX7JwmN
         1tgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TF/ydsengbd4wJskSgsKyK9aVHLUv1vLGJ7JAs7cqUc=;
        b=Pt5qYBV1BTDb2H7FNv2YSgFzj+d/jKqzXgwlmWYClpr+51sh688O/gyULJg5Kp+AQk
         hAgvDs8e4oRs56sJgsUrgcKWw+paNAIP3+XkiIZ9WT9CiUDEcRmPIUUt+mwgPVYqP+bI
         uNG0r54kyJ/iuzabaxGU+L+P8Dt6sUvCBFrU/GreT6US6MxANQZVzIEJSBmvWc6QWKUN
         vm0D7iCq4neEOOeRu1Ff6xcKKZlZnZaZAG3NttTmaZ1yW5kERfaP9NE/HY8k2BGFvl/l
         l9f7gzTZH3T9Jw/VgwW1tPkghrN9XsqNHKJCqKaec+JiK6VRwFbNtGdopPQPcfQf4qbc
         4I1w==
X-Gm-Message-State: AOAM532oqvrouNN1jHzFQn5kurCehWiBzXooWsJmhMUqzyRW5tj1Bs3p
        AhdihdlsV1/XuhU+o37SSmvRd7PgZ4o6jw5oJ+JO3cALS8tREA==
X-Google-Smtp-Source: ABdhPJxqcKGo7IWvfsPf1cIr66A6utBZCwuLYI7HhFTzKO8PPhJfULQWFFOPHRShAdb5n2w5UfeEXQu6Fqisk6ueIW4=
X-Received: by 2002:a92:8708:: with SMTP id m8mr6954831ild.19.1599717660693;
 Wed, 09 Sep 2020 23:01:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200903130140.799392-1-xiubli@redhat.com> <449a56624f3dd4e2a4a4cf95cd24d69c53700b6d.camel@kernel.org>
 <ad35f2f8-6692-3918-6137-adc8e95607c6@redhat.com> <CAOi1vP-8rbzZ=-Apir2B4Z6U10ZKrp41d6+BYgvGsyL+ND-JnQ@mail.gmail.com>
 <cdf40ea5-ecd0-0df6-7db4-7897aa3a5ad0@redhat.com>
In-Reply-To: <cdf40ea5-ecd0-0df6-7db4-7897aa3a5ad0@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 10 Sep 2020 08:00:51 +0200
Message-ID: <CAOi1vP-XxXVcvyZgQF7mWaxm-21hiY5fF4tRYkua-F9ikof7UA@mail.gmail.com>
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

On Thu, Sep 10, 2020 at 2:59 AM Xiubo Li <xiubli@redhat.com> wrote:
>
> On 2020/9/10 4:34, Ilya Dryomov wrote:
> > On Thu, Sep 3, 2020 at 4:22 PM Xiubo Li <xiubli@redhat.com> wrote:
> >> On 2020/9/3 22:18, Jeff Layton wrote:
> >>> On Thu, 2020-09-03 at 09:01 -0400, xiubli@redhat.com wrote:
> >>>> From: Xiubo Li <xiubli@redhat.com>
> >>>>
> >>>> Changed in V5:
> >>>> - Remove mdsc parsing helpers except the ceph_sb_to_mdsc()
> >>>> - Remove the is_opened member.
> >>>>
> >>>> Changed in V4:
> >>>> - A small fix about the total_inodes.
> >>>>
> >>>> Changed in V3:
> >>>> - Resend for V2 just forgot one patch, which is adding some helpers
> >>>> support to simplify the code.
> >>>>
> >>>> Changed in V2:
> >>>> - Add number of inodes that have opened files.
> >>>> - Remove the dir metrics and fold into files.
> >>>>
> >>>>
> >>>>
> >>>> Xiubo Li (2):
> >>>>     ceph: add ceph_sb_to_mdsc helper support to parse the mdsc
> >>>>     ceph: metrics for opened files, pinned caps and opened inodes
> >>>>
> >>>>    fs/ceph/caps.c    | 41 +++++++++++++++++++++++++++++++++++++----
> >>>>    fs/ceph/debugfs.c | 11 +++++++++++
> >>>>    fs/ceph/dir.c     | 20 +++++++-------------
> >>>>    fs/ceph/file.c    | 13 ++++++-------
> >>>>    fs/ceph/inode.c   | 11 ++++++++---
> >>>>    fs/ceph/locks.c   |  2 +-
> >>>>    fs/ceph/metric.c  | 14 ++++++++++++++
> >>>>    fs/ceph/metric.h  |  7 +++++++
> >>>>    fs/ceph/quota.c   | 10 +++++-----
> >>>>    fs/ceph/snap.c    |  2 +-
> >>>>    fs/ceph/super.h   |  6 ++++++
> >>>>    11 files changed, 103 insertions(+), 34 deletions(-)
> >>>>
> >>> Looks good. I went ahead and merge this into testing.
> >>>
> >>> Small merge conflict in quota.c, which I guess is probably due to not
> >>> basing this on testing branch. I also dropped what looks like an
> >>> unrelated hunk in the second patch.
> >>>
> >>> In the future, if you can be sure that patches you post apply cleanly to
> >>> testing branch then that would make things easier.
> >> Okay, will do it.
> > Hi Xiubo,
> >
> > There is a problem with lifetimes here.  mdsc isn't guaranteed to exist
> > when ->free_inode() is called.  This can lead to crashes on a NULL mdsc
> > in ceph_free_inode() in case of e.g. "umount -f".  I know it was Jeff's
> > suggestion to move the decrement of total_inodes into ceph_free_inode(),
> > but it doesn't look like it can be easily deferred past ->evict_inode().
>
> Okay, I will take a look.

Given that it's just a counter which we don't care about if the
mount is going away, some form of "if (mdsc)" check might do, but
need to make sure that it covers possible races, if any.

Thanks,

                Ilya
