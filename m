Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F01023461B
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Jun 2019 14:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbfFDMCM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 4 Jun 2019 08:02:12 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:39424 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727250AbfFDMCM (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 4 Jun 2019 08:02:12 -0400
Received: by mail-qt1-f193.google.com with SMTP id i34so13327401qta.6
        for <ceph-devel@vger.kernel.org>; Tue, 04 Jun 2019 05:02:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d2kT9ddrlkbZhDjbUUe/qaBYJo0zhfU/CUO+dTXYIRE=;
        b=s2M/IgVEhaluQleg8tZOdtBz1xH/3UpHpcZcIHvKrXSdPWdaycKymVEo9vNTHL3kpr
         Hko83AZZk/ybbMpcrc3ZVpfs+lxPEtOl2sy2NcFaM6EfN0KabVA+QBdCHokpHvPKIYQi
         cvFtOxlEGmCkuJSZUvtLGcMGJLrc+QdIDg93WCKgiOzTsMu8jHx66mSPBDt8IIxtULKJ
         372nqTnWYEY4axczktozkO399mTVWECe9RUzDc/hEP9QiwGdZYDU9wTiRjO6E76Hj7M5
         62JN6rZ3ennJajDuN5KUjK2Oa/JuuKfjFc1np0XJY7LqapM3mrBTCuYTPv3a3UiRXpRc
         ughg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d2kT9ddrlkbZhDjbUUe/qaBYJo0zhfU/CUO+dTXYIRE=;
        b=YnY/sxiqZcDL1A9t/+EqARbx4Aoi71GLsT0Gvv9ESTNFc+ZfKy/htoOEl+xdzkjYJ5
         UYAQCY6jnYe1kRnOx2pKcoNUhfIi1nPPChVJfTLyyUdaUBhB8KvLc0GXcICNf6oKrXqU
         bZm9sBqaLCWjtAG+3xNiW+YC5ohoiy/bpnJddQiPD9u4ll9hExxSEv0WM/7A5BSMMcvx
         xBg7g2Xgr3MSfxRfE9lgQHbqPt/iGpFaOuwnRWz88uxwGL2STML300f4QAOpW/Bd6z9r
         a6LdEQjP6G/jF3iP/kdL9kB3A2Q/IQ6kT9Ns2FvNSjVN5M0d5KdwPQe3eMCMWkjrJmdp
         ZUYA==
X-Gm-Message-State: APjAAAXhVW440K2cTzQPc+ImLwyxAPAzBaTUnqFYDrCObubU7uGZWgq8
        hvsJMwtT5bUR2jI4o3zomRatEg9Y5nm0WC1RjU0=
X-Google-Smtp-Source: APXvYqxfkJaPoANZspvYwHIjilbN+X4wSFxgV4K5RjUb64gXygKcRvkQXESpF7vrLPPtnH9cROPI8Fgj+qsDPYxX6U0=
X-Received: by 2002:ad4:43e3:: with SMTP id f3mr25577050qvu.108.1559649731147;
 Tue, 04 Jun 2019 05:02:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190531122802.12814-1-zyan@redhat.com> <20190531122802.12814-2-zyan@redhat.com>
 <CAOi1vP8O6VviiNKrozmwUOtVN+GtvA=-0fEOXcdbg8O+pu1PhQ@mail.gmail.com>
 <CAAM7YAmY-ky2E_9aPHNSNMmmTp9rC+Aw-eBMN_KP1suY_u+Wmg@mail.gmail.com>
 <CAJ4mKGZHm3TqwU8Q=rn1xQtePMhaJNvU4yHGj0jDqR_9oxz2fA@mail.gmail.com>
 <CAOi1vP8k88mFJgLYvD-zWBFgwV4vQ4DR0wBDzSDeDCDBaSLj_g@mail.gmail.com>
 <CAJ4mKGY+jhc926uSRJUtHgL174wtq_3dLO3_1ks=2kpNk9Pkaw@mail.gmail.com>
 <CAOi1vP88A7G_7ScstLSNwe-tUZcBUxhK=W5Qdix2tgPEOB9i8g@mail.gmail.com>
 <CAAM7YAmF4_9ajORX3ENmRGEgQO6Y-H4XNUu67U+bss+D-rt7PA@mail.gmail.com> <CAOi1vP_MGaWmytu7QvAttXq7bGftXtr6gWqEh3j1TShzb_kn3w@mail.gmail.com>
In-Reply-To: <CAOi1vP_MGaWmytu7QvAttXq7bGftXtr6gWqEh3j1TShzb_kn3w@mail.gmail.com>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Tue, 4 Jun 2019 20:01:59 +0800
Message-ID: <CAAM7YAmmGsRmuU76Av-xx42ik1tsnusdh3ZkO7awgf_o3E=XkA@mail.gmail.com>
Subject: Re: [PATCH 2/3] ceph: add method that forces client to reconnect
 using new entity addr
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Gregory Farnum <gfarnum@redhat.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@redhat.com>,
        Jeff Layton <jlayton@redhat.com>,
        Luis Henriques <lhenriques@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jun 4, 2019 at 5:25 PM Ilya Dryomov <idryomov@gmail.com> wrote:
>
> On Tue, Jun 4, 2019 at 4:10 AM Yan, Zheng <ukernel@gmail.com> wrote:
> >
> > On Tue, Jun 4, 2019 at 5:18 AM Ilya Dryomov <idryomov@gmail.com> wrote:
> > >
> > > On Mon, Jun 3, 2019 at 10:23 PM Gregory Farnum <gfarnum@redhat.com> wrote:
> > > >
> > > > On Mon, Jun 3, 2019 at 1:07 PM Ilya Dryomov <idryomov@gmail.com> wrote:
> > > > > Can we also discuss how useful is allowing to recover a mount after it
> > > > > has been blacklisted?  After we fail everything with EIO and throw out
> > > > > all dirty state, how many applications would continue working without
> > > > > some kind of restart?  And if you are restarting your application, why
> > > > > not get a new mount?
> > > > >
> > > > > IOW what is the use case for introducing a new debugfs knob that isn't
> > > > > that much different from umount+mount?
> > > >
> > > > People don't like it when their filesystem refuses to umount, which is
> > > > what happens when the kernel client can't reconnect to the MDS right
> > > > now. I'm not sure there's a practical way to deal with that besides
> > > > some kind of computer admin intervention. (Even if you umount -l, that
> > > > by design doesn't reply to syscalls and let the applications exit.)
> > >
> > > Well, that is what I'm saying: if an admin intervention is required
> > > anyway, then why not make it be umount+mount?  That is certainly more
> > > intuitive than an obscure write-only file in debugfs...
> > >
> >
> > I think  'umount -f' + 'mount -o remount' is better than the debugfs file
>
> Why '-o remount'?  I wouldn't expect 'umount -f' to leave behind any
> actionable state, it should tear down all data structures, mount point,
> etc.  What would '-o remount' act on?
>

If mount point is in use, 'umount -f ' only closes mds sessions and
aborts osd requests. Mount point is still there, any operation on it
will return -EIO. The remount change the mount point back to normal
state.

> Thanks,
>
>                 Ilya
