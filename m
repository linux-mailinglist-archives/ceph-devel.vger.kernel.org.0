Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D05EA15C08B
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Feb 2020 15:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727511AbgBMOnb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 13 Feb 2020 09:43:31 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:39945 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726300AbgBMOnb (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 13 Feb 2020 09:43:31 -0500
Received: by mail-qk1-f196.google.com with SMTP id b7so5861363qkl.7
        for <ceph-devel@vger.kernel.org>; Thu, 13 Feb 2020 06:43:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KUInczdfSXBpNTUNTdhoW6zoOglojk7wXQVpcuM4Z5o=;
        b=fSnp3QdXQh3spCK4JgigtwAEzgJPmRpwLh0LGiMmE4kVYktpCoInm8MI/829N0AQov
         a31P6APW4W65flXDVU8PDOiJ6240h0O9FiUrkYBXk7bYf1mE1ASOhZsUvfCGHEK0XLJu
         mrNSn8Cvp6Clma74KrXwaeBJlBiL2GYR110MWo7/QSarRQ/WwH26EK71/nfBKzdGlksW
         95niJL0blodVnacVHikIqTlFOL2E9Ba8k4go9AwxDke+PMDcvoc7Fwnw+4qbD+UyMsbW
         xBUHKHxcjj3SG/RlXZILMPZayDsCNGuNvG61983h7rUHLndtWnHHCn2nrUUiTsDf/WkU
         kOhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KUInczdfSXBpNTUNTdhoW6zoOglojk7wXQVpcuM4Z5o=;
        b=KK3fhm+NDEgxtqsaHfHOAvMwvu1ToYwfbIPMg99JQzvT4FhkK8L6l+m6fI2uLWwt2c
         N4zQAevjdTl7n5kraJFOBZtX5UjtwfPEng79Qq89VJFa85f6HRDDY93Y2EiGoZMkAA3K
         TtxeN8iclVHWXKhYLs1itay9CPG4ODkZk3Tyu765DKuYWT6sxGEJEFQQt7yICuZ3Awmd
         Lj38UJHFKFTtBnNoEqCAo3sJ6T5tQhNL8JSchS7pxht+rM6gCMT8jg3CMlYhNrSTnsQH
         XTDus3WKJgT5VzKjdU57wSnltJsul0Jy2o7DrIYrXeai2NsIx2vyDrQEtoHxzqvDMQP8
         yLFw==
X-Gm-Message-State: APjAAAWQhYvge7BaCIvaQIMn7urC1dgf48bVGUhuWrCucFguSbRC8RXr
        6tyKmBOqk69a/v6RcBrZ73CWj0trJmukAlideXo=
X-Google-Smtp-Source: APXvYqzmEgk/YR3EjVXMOKvzJAEL7rVzOiyCgbp2KKIPxxJSiCeJS0AsUsqCl2KDtFgINxZaV5+MMQAxPaTmX1jNOC8=
X-Received: by 2002:a05:620a:101a:: with SMTP id z26mr7416422qkj.141.1581605010350;
 Thu, 13 Feb 2020 06:43:30 -0800 (PST)
MIME-Version: 1.0
References: <20200212172729.260752-1-jlayton@kernel.org> <CAAM7YAmz9U4TmBMNhFV+4xiDRNM5GVwhe94wZmedwp7g4RgFoQ@mail.gmail.com>
 <079aab73e6d189de419dce98057c687b734134fc.camel@kernel.org>
In-Reply-To: <079aab73e6d189de419dce98057c687b734134fc.camel@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Thu, 13 Feb 2020 22:43:19 +0800
Message-ID: <CAAM7YA=h-xR3WDYFkPw27mBiaYtPXRqyftvbg4LT3tzSm14TBw@mail.gmail.com>
Subject: Re: [PATCH v4 0/9] ceph: add support for asynchronous directory operations
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>, idridryomov@gmail.com,
        Sage Weil <sage@redhat.com>, Zheng Yan <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Feb 13, 2020 at 9:20 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Thu, 2020-02-13 at 21:05 +0800, Yan, Zheng wrote:
> > On Thu, Feb 13, 2020 at 1:29 AM Jeff Layton <jlayton@kernel.org> wrote:
> > > I've dropped the async unlink patch from testing branch and am
> > > resubmitting it here along with the rest of the create patches.
> > >
> > > Zheng had pointed out that DIR_* caps should be cleared when the session
> > > is reconnected. The underlying submission code needed changes to
> > > handle that so it needed a bit of rework (along with the create code).
> > >
> > > Since v3:
> > > - rework async request submission to never queue the request when the
> > >   session isn't open
> > > - clean out DIR_* caps, layouts and delegated inodes when session goes down
> > > - better ordering for dependent requests
> > > - new mount options (wsync/nowsync) instead of module option
> > > - more comprehensive error handling
> > >
> > > Jeff Layton (9):
> > >   ceph: add flag to designate that a request is asynchronous
> > >   ceph: perform asynchronous unlink if we have sufficient caps
> > >   ceph: make ceph_fill_inode non-static
> > >   ceph: make __take_cap_refs non-static
> > >   ceph: decode interval_sets for delegated inos
> > >   ceph: add infrastructure for waiting for async create to complete
> > >   ceph: add new MDS req field to hold delegated inode number
> > >   ceph: cache layout in parent dir on first sync create
> > >   ceph: attempt to do async create when possible
> > >
> > >  fs/ceph/caps.c               |  73 +++++++---
> > >  fs/ceph/dir.c                | 101 +++++++++++++-
> > >  fs/ceph/file.c               | 253 +++++++++++++++++++++++++++++++++--
> > >  fs/ceph/inode.c              |  58 ++++----
> > >  fs/ceph/mds_client.c         | 156 +++++++++++++++++++--
> > >  fs/ceph/mds_client.h         |  17 ++-
> > >  fs/ceph/super.c              |  20 +++
> > >  fs/ceph/super.h              |  21 ++-
> > >  include/linux/ceph/ceph_fs.h |  17 ++-
> > >  9 files changed, 637 insertions(+), 79 deletions(-)
> > >
> >
> > Please implement something like
> > https://github.com/ceph/ceph/pull/32576/commits/e9aa5ec062fab8324e13020ff2f583537e326a0b.
> > MDS may revoke Fx when replaying unsafe/async requests. Make mds not
> > do this is quite complex.
> >
>
> I added this in reconnect_caps_cb in the latest set:
>
>         /* These are lost when the session goes away */
>         if (S_ISDIR(inode->i_mode)) {
>                 if (cap->issued & CEPH_CAP_DIR_CREATE) {
>                         ceph_put_string(rcu_dereference_raw(ci->i_cached_layout.pool_ns));
>                         memset(&ci->i_cached_layout, 0, sizeof(ci->i_cached_layout));
>                 }
>                 cap->issued &= ~(CEPH_CAP_DIR_CREATE|CEPH_CAP_DIR_UNLINK);
>         }
>

It's not enough.  for async create/unlink, we need to call

ceph_put_cap_refs(..., CEPH_CAP_FILE_EXCL | CEPH_CAP_DIR_FOO) to release caps


> Basically, wipe out the layout and Duc caps when we reconnect the
> session. Outstanding references to the caps will be put when the call
> completes. Is that not sufficient?
> --
> Jeff Layton <jlayton@kernel.org>
>
