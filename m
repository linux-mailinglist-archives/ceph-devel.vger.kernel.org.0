Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3DDA560FAC
	for <lists+ceph-devel@lfdr.de>; Thu, 30 Jun 2022 05:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232075AbiF3DdX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 29 Jun 2022 23:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231500AbiF3DdR (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 29 Jun 2022 23:33:17 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4F01EE30
        for <ceph-devel@vger.kernel.org>; Wed, 29 Jun 2022 20:33:10 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id l2so16333320pjf.1
        for <ceph-devel@vger.kernel.org>; Wed, 29 Jun 2022 20:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dlQGUhBuQqnv6HlnfmDyi2Qtd0EQFWWwCUNRaJXuW04=;
        b=MxJwxwA55PzukW0Q2AUw3NVzQfk+pUEs6gxyFqzn9x5xcM6HXNEP4YjTz1JmUFcobH
         0K+azXf5DUmX7mJ91RLH6+HjHjcbKTXPTdgNpu+tNMFe3qS/oON+NgD6guWumwqgkdej
         hYX6ezQPwp6+lAGDaloyK4Z6Xll/fTiy71SCwXfWGmcquxwU2E6+SLgo9ivenPLuLHXy
         XFmtDM+NVZCu6gOXa280aQQ4kmGqNcKrXMXXauq6/k7y1DHVT3N2itVV0NpQBpDRGsmk
         RZM0Mfx1zSDStO1yVhX4KuuJE241eTruvxlq0ovMqmiPCKd0icOIkxT9wc8lywIHcqnd
         8zkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dlQGUhBuQqnv6HlnfmDyi2Qtd0EQFWWwCUNRaJXuW04=;
        b=w2PrjUHGt+PZtkHK/JDhPRr2baTTcnhM/HTifbMYulpXi5/LM2pn+k1sq/evPEUyBc
         DYfbbK7eQOLOIavW2MpCglysv76WoY6zgAHnSNeH3RKJmRfH74/bd+D4Frg2Tm2ecCHl
         qSqY+4i2bNv07UFKHw39A5P1uJa44EmFJmtzvurKNsUA1ln5YTKAaW6SZ6DNQD2Gv7OR
         f5m+aMVZrahrN8zhgrPjtHsJShei6xYivD0gClQogUmvMYnoDHzQ4zBTpXLvoQaeWtFB
         BaD1YTrK+d/vBX9TdjiG/h9dasRXK2gdbprHFdYNouaRjCSBu39zj3AJvR2Yzlc1LUZn
         pT5A==
X-Gm-Message-State: AJIora8W5+j6hQkQ5ZU4/Dn1psydiboLrZxGQg3vpRBsBs4et1DCRGVX
        gf6+ckxsgHODFmOgiDutLrUJweNFD1JN3oYaBfOJ1hSJnKDc10OJ
X-Google-Smtp-Source: AGRyM1vjMB1zDO8iwSFioL6kpvo1IpkVztgUyD2ArzYun4AgNhV1w6P9s06c3Ssmtn/pwtYVHMTinBUpmV15uO4ghT0=
X-Received: by 2002:a17:903:2311:b0:16a:6b9c:2b4d with SMTP id
 d17-20020a170903231100b0016a6b9c2b4dmr12422859plh.100.1656559990157; Wed, 29
 Jun 2022 20:33:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220606233142.150457-1-jlayton@kernel.org> <CAAM7YAmguEUbX7XWc9HV0traYT-CgKWdDWV8-OyjwLc2+Tk8EQ@mail.gmail.com>
 <b66bd239bc69f432ae474c207591a67d3990d09f.camel@kernel.org> <CAAM7YAm59fBCboB3iBSazZvs_fnmdcDXcuDourDQBXmrzSqT5w@mail.gmail.com>
In-Reply-To: <CAAM7YAm59fBCboB3iBSazZvs_fnmdcDXcuDourDQBXmrzSqT5w@mail.gmail.com>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Thu, 30 Jun 2022 11:32:58 +0800
Message-ID: <CAAM7YA=dLYWZj6zBSBhqDosqqFQPxgidLPw6R_EUfkUxzKd8fA@mail.gmail.com>
Subject: Re: [PATCH] ceph: wait on async create before checking caps for syncfs
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Jun 30, 2022 at 10:33 AM Yan, Zheng <ukernel@gmail.com> wrote:
>
> On Wed, Jun 29, 2022 at 8:08 PM Jeff Layton <jlayton@kernel.org> wrote:
> >
> > Are you suggesting that the MDS ought to hold a cap message for an inode
> > before its create request is processed? Note that the MDS won't even be
> > aware that the inode even _exists_ at that point. As far as the MDS
> > knows, it's just be a delegated inode number to the client. At what
> > point does the MDS give up on holding such a cap request if the create
> > request never comes in for some reason?
> >
> For an async request, MDS should not process it immediately.  If there
> is any wait when handling async request, it's mds bug. I suggest
> tracking down any wait, and fix it.
>

I mean: For an async request, MDS should process it immediately. This
is important for preserving request ordering.

>
> > I don't see the harm in making the client wait until it gets a create
> > reply before sending a cap message. If we want to revert fbed7045f552
> > instead, we can do that, but it'll cause a regression until the MDS is
> > fixed [1]. Regardless, we need to either take this patch or revert that
> > one.
> >
> > I move that we take this patch for now to address the softlockups. Once
> > the MDS is fixed we could revert this and fbed7045f552 without causing a
> > regression.
> >
> > [1]: https://tracker.ceph.com/issues/54107
> >
> >
> > On Thu, 2022-06-09 at 10:15 +0800, Yan, Zheng wrote:
> > > The recent series of patches that add "wait on async xxxx" at various
> > > places do not seem correct. The correct fix should make mds avoid any
> > > wait when handling async requests.
> > >
> > >
> > > On Wed, Jun 8, 2022 at 12:56 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > >
> > > > Currently, we'll call ceph_check_caps, but if we're still waiting on the
> > > > reply, we'll end up spinning around on the same inode in
> > > > flush_dirty_session_caps. Wait for the async create reply before
> > > > flushing caps.
> > > >
> > > > Fixes: fbed7045f552 (ceph: wait for async create reply before sending any cap messages)
> > > > URL: https://tracker.ceph.com/issues/55823
> > > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > > ---
> > > >  fs/ceph/caps.c | 1 +
> > > >  1 file changed, 1 insertion(+)
> > > >
> > > > I don't know if this will fix the tx queue stalls completely, but I
> > > > haven't seen one with this patch in place. I think it makes sense on its
> > > > own, either way.
> > > >
> > > > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > > > index 0a48bf829671..5ecfff4b37c9 100644
> > > > --- a/fs/ceph/caps.c
> > > > +++ b/fs/ceph/caps.c
> > > > @@ -4389,6 +4389,7 @@ static void flush_dirty_session_caps(struct ceph_mds_session *s)
> > > >                 ihold(inode);
> > > >                 dout("flush_dirty_caps %llx.%llx\n", ceph_vinop(inode));
> > > >                 spin_unlock(&mdsc->cap_dirty_lock);
> > > > +               ceph_wait_on_async_create(inode);
> > > >                 ceph_check_caps(ci, CHECK_CAPS_FLUSH, NULL);
> > > >                 iput(inode);
> > > >                 spin_lock(&mdsc->cap_dirty_lock);
> > > > --
> > > > 2.36.1
> > > >
> >
> > --
> > Jeff Layton <jlayton@kernel.org>
