Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9E61680EF
	for <lists+ceph-devel@lfdr.de>; Fri, 21 Feb 2020 15:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729051AbgBUO4R (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 21 Feb 2020 09:56:17 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:36429 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728264AbgBUO4P (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 21 Feb 2020 09:56:15 -0500
Received: by mail-il1-f194.google.com with SMTP id b15so1851076iln.3
        for <ceph-devel@vger.kernel.org>; Fri, 21 Feb 2020 06:56:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bao0Twvq3+0HhPMt0fownt8g77drdH//57AvWrfsPpw=;
        b=e87Tc463rpNfb+oXOVXrt1mMaTG4nzSpLTbiMudDpH55ohzsOq11XDW4luxAWWZrEX
         FN22EoItq1nTxlTFQgIXJZE9v2PMLqZCQVqLWcq0+zyBcmy2f9LaWTM7dhGIL+Sjz0MG
         owyQjlHnK0LPTRXPdcvSKWyrlck4YEF1ByNO6EJTgpEd1FE2zgXURJ+Q3WF9N6BaHmO2
         dUbEvxjeU44U1b9Hbdjst2yeaBDbS+B0/QjqDixw/1nGWqv0cWLlRUVUITF7tTBGqLt7
         czlyVLN2YrgdQb7Ls537u4UM9f85pkc5zovFpZp/+ZPxwvCbp4gXJ4zYZqwEi7a8/Se6
         xnAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bao0Twvq3+0HhPMt0fownt8g77drdH//57AvWrfsPpw=;
        b=Mu6UrKQptNRw8JhjrTSKHN3mh6fa7tjRRQy8eKfiW1MKtn6OCF9DmssoQ5Rzn6HoTW
         LHf1BRXiZFlD5NpcDgZzvGVDp2hYXKdJ0iYq+YBXRQk2nqHmXZRaJytcKkFRLyooQCuk
         3Seju4W/87Vi7oDIceeoxkRf3+RpJuGMsGq9OoZea23QA2NtYyi6p+nNhlg+pWffWV6t
         8d9Wi+e/tycQG2sJUmKQs+NY3UyOAuCuXC+WzNcK6XKL5RAzU+R/t50+RrDbNUGpFel5
         qYWFV1eBkbNSt2ITkDl8HpdHusb5b50CZ7mxUvucTQK4+a7/rQ3Jyii6Uvxd9m4V5Ze2
         GUrA==
X-Gm-Message-State: APjAAAU+PvQGPVpxr12bKAJDJ90ja5VgOsRoswfw/MMyQtTXQ/uzOrYI
        stm//mNv84xXWqPg6BcInQggqbHg2V3TdHO/JgYGTxOrtdU=
X-Google-Smtp-Source: APXvYqwVDdYmbRAlShWTysD+2qUvkpIdkL4B7RmQpFBa1S4gqF6q9rxtpDGmJiZ4GEFSmuHGYgzWsD0RCby0NMLk92Y=
X-Received: by 2002:a92:ccd0:: with SMTP id u16mr34875848ilq.215.1582296974701;
 Fri, 21 Feb 2020 06:56:14 -0800 (PST)
MIME-Version: 1.0
References: <20200221070556.18922-1-xiubli@redhat.com> <20200221070556.18922-6-xiubli@redhat.com>
 <68e496bca563ed6439c16f0de04d7daeb17f718a.camel@kernel.org>
In-Reply-To: <68e496bca563ed6439c16f0de04d7daeb17f718a.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Fri, 21 Feb 2020 15:56:41 +0100
Message-ID: <CAOi1vP92XUaOfQ_xJFZDXuH4r9D07fW6ckEyd2csr7EhUSRkpg@mail.gmail.com>
Subject: Re: [PATCH v8 5/5] ceph: add global metadata perf metric support
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Xiubo Li <xiubli@redhat.com>, Sage Weil <sage@redhat.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Feb 21, 2020 at 1:03 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Fri, 2020-02-21 at 02:05 -0500, xiubli@redhat.com wrote:
> > From: Xiubo Li <xiubli@redhat.com>
> >
> > It will calculate the latency for the metedata requests, which only
> > include the time cousumed by network and the ceph.
> >
>
> "and the ceph MDS" ?
>
> > item          total       sum_lat(us)     avg_lat(us)
> > -----------------------------------------------------
> > metadata      113         220000          1946
> >
> > URL: https://tracker.ceph.com/issues/43215
> > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > ---
> >  fs/ceph/debugfs.c    |  6 ++++++
> >  fs/ceph/mds_client.c | 20 ++++++++++++++++++++
> >  fs/ceph/metric.h     | 13 +++++++++++++
> >  3 files changed, 39 insertions(+)
> >
> > diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> > index 464bfbdb970d..60f3e307fca1 100644
> > --- a/fs/ceph/debugfs.c
> > +++ b/fs/ceph/debugfs.c
> > @@ -146,6 +146,12 @@ static int metric_show(struct seq_file *s, void *p)
> >       avg = total ? sum / total : 0;
> >       seq_printf(s, "%-14s%-12lld%-16lld%lld\n", "write", total, sum, avg);
> >
> > +     total = percpu_counter_sum(&mdsc->metric.total_metadatas);
> > +     sum = percpu_counter_sum(&mdsc->metric.metadata_latency_sum);
> > +     sum = jiffies_to_usecs(sum);
> > +     avg = total ? sum / total : 0;
> > +     seq_printf(s, "%-14s%-12lld%-16lld%lld\n", "metadata", total, sum, avg);
> > +
> >       seq_printf(s, "\n");
> >       seq_printf(s, "item          total           miss            hit\n");
> >       seq_printf(s, "-------------------------------------------------\n");
> > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > index 0a3447966b26..3e792eca6af7 100644
> > --- a/fs/ceph/mds_client.c
> > +++ b/fs/ceph/mds_client.c
> > @@ -3017,6 +3017,12 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
> >
> >       /* kick calling process */
> >       complete_request(mdsc, req);
> > +
> > +     if (!result || result == -ENOENT) {
> > +             s64 latency = jiffies - req->r_started;
> > +
> > +             ceph_update_metadata_latency(&mdsc->metric, latency);
> > +     }
>
> Should we add an r_end_stamp field to the mds request struct and use
> that to calculate this? Many jiffies may have passed between the reply
> coming in and this point. If you really want to measure the latency that
> would be more accurate, I think.

Yes, capturing it after invoking the callback is inconsistent
with what is done for OSD requests (the new r_end_stamp is set in
finish_request()).

It looks like this is the only place where MDS r_end_stamp would be
needed, so perhaps just move this before complete_request() call?

Thanks,

                Ilya
