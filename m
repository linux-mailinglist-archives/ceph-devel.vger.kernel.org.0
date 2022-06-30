Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BCC2560F3C
	for <lists+ceph-devel@lfdr.de>; Thu, 30 Jun 2022 04:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbiF3Cdj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 29 Jun 2022 22:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiF3Cdi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 29 Jun 2022 22:33:38 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9DB321825
        for <ceph-devel@vger.kernel.org>; Wed, 29 Jun 2022 19:33:37 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 145so3010549pga.12
        for <ceph-devel@vger.kernel.org>; Wed, 29 Jun 2022 19:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UACxhOcZ8VIC9HkFkJdDgC9GclIZEwKT3/wsAJIULWs=;
        b=PzmQ+riA76iChqtIhSvQ2EKyMxRt6vsLDJErlFA7978lW7a/96eQb0xxWUEB9NhgnA
         uGJhNiGrBHF9q94mzxvD6i7SWtfnwfS+kwcoJZIWpd8eY+NHhmlRXna6AYpFP8Ho8FnX
         YMkgBlqrXbzuU1vmGcmBsC+drf8Ilro4Z2bB4mntV8pE052XCCJHJI0B9r8YZ4MhVTJK
         KfILZTV40zR4rOawbdNJrONW6qrL6FtLnrLi8U3bWKNfDLcsRQfV1KLoLGNoS7aPVZnF
         iFVTMbv2LLOjgMi6Zm6suI2vE4vJaGLRUPY4fdHY6kj3jQIzHKpC/Eccvwuupd1SZCoM
         vgyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UACxhOcZ8VIC9HkFkJdDgC9GclIZEwKT3/wsAJIULWs=;
        b=MNEpvftcvLO0m1o/Kkbq9b/jdfCfyFObMDjHC+1LGA+A+ibo6zTNsgITnGV+Vtmqvx
         mtZMUGgs4jTHcVEeCxTh/eTgJEG4xCLCO9YeAf4FhBrkeNiEWXMWIGk6g0y2MoXkwLOo
         CxqQk4HNsdjeY0kWiz/2s2IUcQx5RlKp2GNt7HJg6PfA71i8MZQB7/59f+BDctWEZ056
         AuDgk4exHAnBNWYMH2LJg1fyT3wj8HTHeJy1iKAv+A96AtJdFzh5/actt6V04wvpb6xm
         lGZp6jPMjdm/k2p2eMZXS1jxdj2DxZekUJRqLRFmM9sDcmnxu0+tjN/shfPXy3Blvvjj
         uj5g==
X-Gm-Message-State: AJIora97CvHz8aikQS0cJqHM5EiBtmQ2nH6RWCOVB4geSdxOos6R3kUL
        jw1XJSJ9ngLI1J9GkfKaFEaVIqXcP5dScc8YUMM=
X-Google-Smtp-Source: AGRyM1tK0NkBTvDEQq3zZqKI4ymQFR/t3WcQoVAOlnWY7A2b0opPqNeuFgEgKTKylsTGkZYqIZo1nBItPB8SHoyadtw=
X-Received: by 2002:a63:4853:0:b0:3fa:dc6:7ac2 with SMTP id
 x19-20020a634853000000b003fa0dc67ac2mr5759944pgk.298.1656556417233; Wed, 29
 Jun 2022 19:33:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220606233142.150457-1-jlayton@kernel.org> <CAAM7YAmguEUbX7XWc9HV0traYT-CgKWdDWV8-OyjwLc2+Tk8EQ@mail.gmail.com>
 <b66bd239bc69f432ae474c207591a67d3990d09f.camel@kernel.org>
In-Reply-To: <b66bd239bc69f432ae474c207591a67d3990d09f.camel@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Thu, 30 Jun 2022 10:33:25 +0800
Message-ID: <CAAM7YAm59fBCboB3iBSazZvs_fnmdcDXcuDourDQBXmrzSqT5w@mail.gmail.com>
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

On Wed, Jun 29, 2022 at 8:08 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> Are you suggesting that the MDS ought to hold a cap message for an inode
> before its create request is processed? Note that the MDS won't even be
> aware that the inode even _exists_ at that point. As far as the MDS
> knows, it's just be a delegated inode number to the client. At what
> point does the MDS give up on holding such a cap request if the create
> request never comes in for some reason?
>
For an async request, MDS should not process it immediately.  If there
is any wait when handling async request, it's mds bug. I suggest
tracking down any wait, and fix it.


> I don't see the harm in making the client wait until it gets a create
> reply before sending a cap message. If we want to revert fbed7045f552
> instead, we can do that, but it'll cause a regression until the MDS is
> fixed [1]. Regardless, we need to either take this patch or revert that
> one.
>
> I move that we take this patch for now to address the softlockups. Once
> the MDS is fixed we could revert this and fbed7045f552 without causing a
> regression.
>
> [1]: https://tracker.ceph.com/issues/54107
>
>
> On Thu, 2022-06-09 at 10:15 +0800, Yan, Zheng wrote:
> > The recent series of patches that add "wait on async xxxx" at various
> > places do not seem correct. The correct fix should make mds avoid any
> > wait when handling async requests.
> >
> >
> > On Wed, Jun 8, 2022 at 12:56 PM Jeff Layton <jlayton@kernel.org> wrote:
> > >
> > > Currently, we'll call ceph_check_caps, but if we're still waiting on the
> > > reply, we'll end up spinning around on the same inode in
> > > flush_dirty_session_caps. Wait for the async create reply before
> > > flushing caps.
> > >
> > > Fixes: fbed7045f552 (ceph: wait for async create reply before sending any cap messages)
> > > URL: https://tracker.ceph.com/issues/55823
> > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > ---
> > >  fs/ceph/caps.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > I don't know if this will fix the tx queue stalls completely, but I
> > > haven't seen one with this patch in place. I think it makes sense on its
> > > own, either way.
> > >
> > > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > > index 0a48bf829671..5ecfff4b37c9 100644
> > > --- a/fs/ceph/caps.c
> > > +++ b/fs/ceph/caps.c
> > > @@ -4389,6 +4389,7 @@ static void flush_dirty_session_caps(struct ceph_mds_session *s)
> > >                 ihold(inode);
> > >                 dout("flush_dirty_caps %llx.%llx\n", ceph_vinop(inode));
> > >                 spin_unlock(&mdsc->cap_dirty_lock);
> > > +               ceph_wait_on_async_create(inode);
> > >                 ceph_check_caps(ci, CHECK_CAPS_FLUSH, NULL);
> > >                 iput(inode);
> > >                 spin_lock(&mdsc->cap_dirty_lock);
> > > --
> > > 2.36.1
> > >
>
> --
> Jeff Layton <jlayton@kernel.org>
