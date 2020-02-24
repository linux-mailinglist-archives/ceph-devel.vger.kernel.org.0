Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D79E16A33F
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Feb 2020 10:56:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727321AbgBXJ4Q (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 24 Feb 2020 04:56:16 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:42533 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbgBXJ4P (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 24 Feb 2020 04:56:15 -0500
Received: by mail-il1-f196.google.com with SMTP id x2so7193658ila.9
        for <ceph-devel@vger.kernel.org>; Mon, 24 Feb 2020 01:56:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4wv/KefsssF4ZAgGRmJ0v/aNWjDKOmpU4Z/VjcgFtbk=;
        b=n6xaQu16406oC/XM47oP7AjGQS299102zv1xv9nRgKum6d5dNMb8cN2s9urqjrI3oW
         KYcfseR+mrRlrZ3dhycE90z+cQLGFKSrN0qaWRLCmguVR8hXOQMdQtmDH2LwoKqj0KCG
         ZWkjHotHggAbkjim30H1iTv95ona8lktEsnnsQcpPJxVmkkUUFuaMmKvKywYUNlhOJIn
         ky+/2mtifV8MyqOH9mp148YepI6q8NXO08oQQT2PS79obDIeYckh7ikoqFTloIy0t6kI
         N3XR1CYAapxCVSbO/6pSXpMfUVbQ/Sp9u1E6uANJdSHQ7PCp7XPaPKcQjE/o3eV5kIfc
         SIPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4wv/KefsssF4ZAgGRmJ0v/aNWjDKOmpU4Z/VjcgFtbk=;
        b=o/asI8VW4zfa4nMUPOV5NBzzQFY+xlW8rh5RfhgDro8GCZ3LIi6dhbS4Sgrcz4ldtr
         2pj7WXWCQLhMyHPXEWsPL2XDM7u9ETRzkPOUES2k3cWOiokRgxcYx6e379bV504bhBYM
         /6KpTOFpOqzb0JqOO68soTQtkrnHAlklLNMQCd2NMvfGjIiSozXJLFfOQoVrSa1MgOC5
         Gakx8u1Vnrqp89mEE3mBImuO4a4ezNvx60DBvf/WNOyu5GK/a4oXC/UeYuL4Sb4Qtt0r
         o2ZNxpgr0wiQY5wLtXh29jNTZIIUgg07IGej2GKBW2mE0SiVQuogJo5gm6z/uXjL0MTD
         KFkQ==
X-Gm-Message-State: APjAAAX8bPP4z7icZgUa7AfgKorn/k0qditEI7jYnb+lnPC+2JwRzi6x
        bQgEVgT6wEZhpojOGnE41JiFe1vTQLVJ1QGYaDU=
X-Google-Smtp-Source: APXvYqygsyhwAJby69u6/rf20cBu7FEP6DKVPG8oa8azmWGOTO+8VOYBP+5H/poTicOHVGVGABVih8Pj0eWpeT5ok/g=
X-Received: by 2002:a92:3a8d:: with SMTP id i13mr60491909ilf.112.1582538174886;
 Mon, 24 Feb 2020 01:56:14 -0800 (PST)
MIME-Version: 1.0
References: <20200221070556.18922-1-xiubli@redhat.com> <20200221070556.18922-6-xiubli@redhat.com>
 <68e496bca563ed6439c16f0de04d7daeb17f718a.camel@kernel.org>
 <CAOi1vP92XUaOfQ_xJFZDXuH4r9D07fW6ckEyd2csr7EhUSRkpg@mail.gmail.com> <8d977d6a-da80-5900-aead-395b9b4eaa76@redhat.com>
In-Reply-To: <8d977d6a-da80-5900-aead-395b9b4eaa76@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 24 Feb 2020 10:56:05 +0100
Message-ID: <CAOi1vP_w_uNRjqWpQUN6L5_Zk6QT23o1EfBTNKU1oJRz=5Oq7w@mail.gmail.com>
Subject: Re: [PATCH v8 5/5] ceph: add global metadata perf metric support
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sat, Feb 22, 2020 at 2:21 AM Xiubo Li <xiubli@redhat.com> wrote:
>
> On 2020/2/21 22:56, Ilya Dryomov wrote:
> > On Fri, Feb 21, 2020 at 1:03 PM Jeff Layton <jlayton@kernel.org> wrote:
> >> On Fri, 2020-02-21 at 02:05 -0500, xiubli@redhat.com wrote:
> >>> From: Xiubo Li <xiubli@redhat.com>
> >>>
> >>> It will calculate the latency for the metedata requests, which only
> >>> include the time cousumed by network and the ceph.
> >>>
> >> "and the ceph MDS" ?
> >>
> >>> item          total       sum_lat(us)     avg_lat(us)
> >>> -----------------------------------------------------
> >>> metadata      113         220000          1946
> >>>
> >>> URL: https://tracker.ceph.com/issues/43215
> >>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> >>> ---
> >>>   fs/ceph/debugfs.c    |  6 ++++++
> >>>   fs/ceph/mds_client.c | 20 ++++++++++++++++++++
> >>>   fs/ceph/metric.h     | 13 +++++++++++++
> >>>   3 files changed, 39 insertions(+)
> >>>
> >>> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> >>> index 464bfbdb970d..60f3e307fca1 100644
> >>> --- a/fs/ceph/debugfs.c
> >>> +++ b/fs/ceph/debugfs.c
> >>> @@ -146,6 +146,12 @@ static int metric_show(struct seq_file *s, void *p)
> >>>        avg = total ? sum / total : 0;
> >>>        seq_printf(s, "%-14s%-12lld%-16lld%lld\n", "write", total, sum, avg);
> >>>
> >>> +     total = percpu_counter_sum(&mdsc->metric.total_metadatas);
> >>> +     sum = percpu_counter_sum(&mdsc->metric.metadata_latency_sum);
> >>> +     sum = jiffies_to_usecs(sum);
> >>> +     avg = total ? sum / total : 0;
> >>> +     seq_printf(s, "%-14s%-12lld%-16lld%lld\n", "metadata", total, sum, avg);
> >>> +
> >>>        seq_printf(s, "\n");
> >>>        seq_printf(s, "item          total           miss            hit\n");
> >>>        seq_printf(s, "-------------------------------------------------\n");
> >>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> >>> index 0a3447966b26..3e792eca6af7 100644
> >>> --- a/fs/ceph/mds_client.c
> >>> +++ b/fs/ceph/mds_client.c
> >>> @@ -3017,6 +3017,12 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
> >>>
> >>>        /* kick calling process */
> >>>        complete_request(mdsc, req);
> >>> +
> >>> +     if (!result || result == -ENOENT) {
> >>> +             s64 latency = jiffies - req->r_started;
> >>> +
> >>> +             ceph_update_metadata_latency(&mdsc->metric, latency);
> >>> +     }
> >> Should we add an r_end_stamp field to the mds request struct and use
> >> that to calculate this? Many jiffies may have passed between the reply
> >> coming in and this point. If you really want to measure the latency that
> >> would be more accurate, I think.
> > Yes, capturing it after invoking the callback is inconsistent
> > with what is done for OSD requests (the new r_end_stamp is set in
> > finish_request()).
> >
> > It looks like this is the only place where MDS r_end_stamp would be
> > needed, so perhaps just move this before complete_request() call?
>
> Currently for the OSD requests, they are almost in the same place where
> at the end of the handle_reply.

For OSD requests, r_end_request is captured _before_ the supplied
callback is invoked.  I suggest to do the same for MDS requests.

>
> If we don't want to calculate the consumption by the most of
> handle_reply code, we may set the r_end_stamp in the begin of it for
> both OSD/MDS requests ?
>
> I'm thinking since in the handle_reply, it may also wait for the mutex
> locks and then sleeps, so move the r_end_stamp to the beginning should
> make sense...

No, the time spent in handle_reply() must be included, just like the
time spent in submit_request() is included.  If you look at the code,
you will see that there is a case where handle_reply() drops the reply
on the floor and resubmits the OSD request.  Further, on many errors,
handle_reply() isn't even called, so finish_request() is the only place
where r_end_stamp can be captured in a consistent manner.

Thanks,

                Ilya
