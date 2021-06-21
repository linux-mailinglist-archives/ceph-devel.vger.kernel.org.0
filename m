Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBE363AF73A
	for <lists+ceph-devel@lfdr.de>; Mon, 21 Jun 2021 23:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbhFUVN7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 21 Jun 2021 17:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbhFUVN7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 21 Jun 2021 17:13:59 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B470C061574;
        Mon, 21 Jun 2021 14:11:44 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id q9so2913219ilj.3;
        Mon, 21 Jun 2021 14:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DP6PahqRP1MLu8qPFJfznPIBup13mcFnRiC5R3yfCy0=;
        b=TRZUqpP7ljOMXmH8ZTlAwiTkyiWqtALwCKsL4faQ6tAWFGW9YfOdFkUBosnlYbgVWh
         zB7KUz9eF85/54XbxY8za+pK/nAdbx/A7YRnckbNS9+uD3Bt7oF9OrMdTwvDenq7F6QE
         HHRrpx9AHykrVwzWP6u21gHVOtnRaYrf98PeXLYaUBTX6ptliwEYR7/G2hGAKTv1Ih+S
         G9NSpRrj0/hpvbAiz0WhXOitoUct73olE9NA539jit7QG5g59OBgYJQigzpMovybyAPY
         dVqSGCdZEWqfMz7cthZ1+mNgw5XDKjKO5ydkiFYocDFBVw1XjMhYPoLphECiQRdV2nnq
         rsRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DP6PahqRP1MLu8qPFJfznPIBup13mcFnRiC5R3yfCy0=;
        b=idIhJ6IUoxmNIY6rELf3CzQC769sX6T663j1Yhhy4nCpifGCFNJaSW47avDu6KuUab
         7iQ7SmgneKzm4oDsFon6XCJZRGQ5/GAU/BQ5u+WS0WdDSF5ly707HPxFKl0Noa801PAM
         tQNGCDfnLakpsR922j4iEfK7jdxWCN6TMSHRfk0kPshgpgUL6Es/Xg+9iygKZ4QN/B+m
         L1eb6S+rpyet6BXs6SlQVTjOJE05JxiAXaRieGO1hZavlcWhOuclu+9PUifgvEAgk2LC
         rQqtysb6gSUds2jEommdvQcIwrMwc1J9jIDgn5/ZAqgGNB8FyUKcxdJltkMQnjCOeXfJ
         3l3A==
X-Gm-Message-State: AOAM531LFxCwLCDNiuPzwTJfZvvWXs2al6O2qiEUHPc6p8y74n72FO4M
        2ws+Y5TWrAoRQpjtvRLE4gb6vG7WrqP7n9gbV+o=
X-Google-Smtp-Source: ABdhPJxMPgqp2+C3XHoUxEOs/ttJrcNuDkWvZw6G4xn8VnTQOpTiQij3FudC+TAOP9p4GkwWpkfiQ2UCV9o0GK73fgE=
X-Received: by 2002:a92:cbd0:: with SMTP id s16mr149873ilq.19.1624309904060;
 Mon, 21 Jun 2021 14:11:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210618142740.3345-1-yejune.deng@gmail.com> <ca37212d9c848bbb6228cce95ca7f39ef3696437.camel@kernel.org>
In-Reply-To: <ca37212d9c848bbb6228cce95ca7f39ef3696437.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 21 Jun 2021 23:11:31 +0200
Message-ID: <CAOi1vP_Dv2uV=jOFGwbsyTOdJeZREvrPE+iK68JowkMCTauVKg@mail.gmail.com>
Subject: Re: [PATCH] net: ceph: Use CLOCK_MONOTONIC ktime_get_ts64()
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Yejune Deng <yejune.deng@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sat, Jun 19, 2021 at 12:51 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Fri, 2021-06-18 at 22:27 +0800, Yejune Deng wrote:
> > The Documentation/core-api/timekeeping.rst recommend that we should use
> > monotonic time ktime_get_ts64(), to avoid glitches with a concurrent
> > settimeofday().
> >
> > Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
> > ---
> >  net/ceph/messenger.c    | 2 +-
> >  net/ceph/messenger_v1.c | 2 +-
> >  net/ceph/messenger_v2.c | 2 +-
> >  net/ceph/osd_client.c   | 4 ++--
> >  4 files changed, 5 insertions(+), 5 deletions(-)
> >
> > diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
> > index 57d043b..2d07ab5 100644
> > --- a/net/ceph/messenger.c
> > +++ b/net/ceph/messenger.c
> > @@ -1809,7 +1809,7 @@ bool ceph_con_keepalive_expired(struct ceph_connection *con,
> >           (con->peer_features & CEPH_FEATURE_MSGR_KEEPALIVE2)) {
> >               struct timespec64 now;
> >               struct timespec64 ts;
> > -             ktime_get_real_ts64(&now);
> > +             ktime_get_ts64(&now);
> >               jiffies_to_timespec64(interval, &ts);
> >               ts = timespec64_add(con->last_keepalive_ack, ts);
> >               return timespec64_compare(&now, &ts) >= 0;
> > diff --git a/net/ceph/messenger_v1.c b/net/ceph/messenger_v1.c
> > index 2cb5ffd..2ec7b1d 100644
> > --- a/net/ceph/messenger_v1.c
> > +++ b/net/ceph/messenger_v1.c
> > @@ -310,7 +310,7 @@ static void prepare_write_keepalive(struct ceph_connection *con)
> >       if (con->peer_features & CEPH_FEATURE_MSGR_KEEPALIVE2) {
> >               struct timespec64 now;
> >
> > -             ktime_get_real_ts64(&now);
> > +             ktime_get_ts64(&now);
> >               con_out_kvec_add(con, sizeof(tag_keepalive2), &tag_keepalive2);
> >               ceph_encode_timespec64(&con->v1.out_temp_keepalive2, &now);
> >               con_out_kvec_add(con, sizeof(con->v1.out_temp_keepalive2),
> > diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
> > index cc40ce4..2125e77 100644
> > --- a/net/ceph/messenger_v2.c
> > +++ b/net/ceph/messenger_v2.c
> > @@ -1439,7 +1439,7 @@ static int prepare_keepalive2(struct ceph_connection *con)
> >       struct ceph_timespec *ts = CTRL_BODY(con->v2.out_buf);
> >       struct timespec64 now;
> >
> > -     ktime_get_real_ts64(&now);
> > +     ktime_get_ts64(&now);
> >       dout("%s con %p timestamp %lld.%09ld\n", __func__, con, now.tv_sec,
> >            now.tv_nsec);
> >
> > diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> > index ff8624a..5192a8a 100644
> > --- a/net/ceph/osd_client.c
> > +++ b/net/ceph/osd_client.c
> > @@ -4717,7 +4717,7 @@ ceph_osdc_watch(struct ceph_osd_client *osdc,
> >       ceph_oid_copy(&lreq->t.base_oid, oid);
> >       ceph_oloc_copy(&lreq->t.base_oloc, oloc);
> >       lreq->t.flags = CEPH_OSD_FLAG_WRITE;
> > -     ktime_get_real_ts64(&lreq->mtime);
> > +     ktime_get_ts64(&lreq->mtime);
> >
> >       lreq->reg_req = alloc_watch_request(lreq, CEPH_OSD_WATCH_OP_WATCH);
> >       if (!lreq->reg_req) {
> > @@ -4767,7 +4767,7 @@ int ceph_osdc_unwatch(struct ceph_osd_client *osdc,
> >       ceph_oid_copy(&req->r_base_oid, &lreq->t.base_oid);
> >       ceph_oloc_copy(&req->r_base_oloc, &lreq->t.base_oloc);
> >       req->r_flags = CEPH_OSD_FLAG_WRITE;
> > -     ktime_get_real_ts64(&req->r_mtime);
> > +     ktime_get_ts64(&req->r_mtime);
> >       osd_req_op_watch_init(req, 0, lreq->linger_id,
> >                             CEPH_OSD_WATCH_OP_UNWATCH);
> >
>
> I think this is OK. Most of these timestamps get marshalled onto the
> wire to use as identifiers. Those are almost certainly better off with
> CLOCK_MONOTONIC since you could have a clock jump that caused you to
> send (e.g.) 2 keepalives with the same timestamp otherwise.

While I generally agree that for keepalive (i.e. the first free
instances) using the monotonic clock would be better, in userspace
CLOCK_REALTIME is used and I don't want to diverge.

Thanks,

                Ilya
