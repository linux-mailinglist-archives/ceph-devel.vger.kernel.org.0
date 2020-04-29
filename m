Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54F0C1BE36F
	for <lists+ceph-devel@lfdr.de>; Wed, 29 Apr 2020 18:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbgD2QIv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 29 Apr 2020 12:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726926AbgD2QIu (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 29 Apr 2020 12:08:50 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1293C03C1AD
        for <ceph-devel@vger.kernel.org>; Wed, 29 Apr 2020 09:08:49 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id b12so2779043ion.8
        for <ceph-devel@vger.kernel.org>; Wed, 29 Apr 2020 09:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LIWOT7ehVUCcjBbmuljO9Ef2sLMIFXfzt8K+kntGC14=;
        b=nRP1ApB4HtAXwjToIVolpQ3x1TfpothWNUqoiJsNVg/q/JJpZ3o9lWXq1YkNUqemP5
         L+2rwhNSFoMge8AFws33SHEXckBj7NE22G9M56E8lYPXPvbrGdYkRvRn+eLrPPPXuurB
         dmIqfskr4tzswO3qlpqDyu6qFjSpfi3+SQXsWnDBAFoRkCsrH+AtwY+2ULcxS7liRAok
         cAFWR2CERojALgPWgkQDmraAd+lrYHc2PODeS+gy1nJqL2lfbYDNCh2UX1rbez78Tw9Y
         v0/iO4LIdgDEnJSavXGpQuCf77Y330LWkcJ2sGn7nMk5k/eopd+Wjfp/OUqjwqscCqFk
         LULw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LIWOT7ehVUCcjBbmuljO9Ef2sLMIFXfzt8K+kntGC14=;
        b=RvQS3dtDRqFNF0ZICYOsSVr3nL7fuUnbnsIV9L5PZK2rUQWoS0bYl15n4O1leHFQd3
         LR1I2d+ydbhpCCYvxOcoQmfbBXvM4YIm7SHyBbzf9Tv5pkp1WboA4GFmUBbYR5H3t3cC
         to9HsZ4JIJcYtTO5b2SRLw0AJQuce1pQwKx8aieoCdpKQQK2rwZ3AK/1W+tm6OFecEB/
         /h45vcQyybeuVGB/eODBTcZYYzd8rvmI4PZucpVI9vKGKO8nbpVW5rfMaznZI2ndW3nG
         030uAKtMgizqsDUSzjmlAWPwlfjN1Lw5QGiGLQ9+GnPKkO8Gb7CLBwPHwaFqfhIt4fZO
         WFgw==
X-Gm-Message-State: AGi0Pub0ZwS6YNcDhkibCjcZVJZRhGEYzhYk+eOfofY9BfCxVVBmsBUu
        eO7LB3oO+8q+7yQXvuwi96Tl704qdcv+CxZ9XsI=
X-Google-Smtp-Source: APiQypJF+qFYj3UGqTr3TwvteKxfUInpgzi72TODzCQurPDR0k+kT0L27A6FboOW46e2iE0I58Fn9F2OhQS6VYXboi0=
X-Received: by 2002:a02:3b4b:: with SMTP id i11mr31260291jaf.16.1588176529096;
 Wed, 29 Apr 2020 09:08:49 -0700 (PDT)
MIME-Version: 1.0
References: <1588023986-23672-1-git-send-email-edward6@linux.ibm.com>
 <f36451800e4656f99483f4d47487a40ea5f942cd.camel@kernel.org>
 <d322ad5e-8409-7e5e-8d16-a2706223f26f@linux.ibm.com> <ea3dc3b2657a766f2fc253fe6b1bac08aeb968db.camel@kernel.org>
In-Reply-To: <ea3dc3b2657a766f2fc253fe6b1bac08aeb968db.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 29 Apr 2020 18:08:49 +0200
Message-ID: <CAOi1vP-6sWTw68UJx4kV-0fmhLGE0=hw3ZYPYd8tp6aXVNYJXg@mail.gmail.com>
Subject: Re: [PATCH] ceph: fix up endian bug in managing feature bits
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Eduard Shishkin <edward6@linux.ibm.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        Ulrich.Weigand@de.ibm.com, Tuan.Hoang1@ibm.com,
        "Yan, Zheng" <ukernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Apr 29, 2020 at 5:42 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Wed, 2020-04-29 at 11:46 +0200, Eduard Shishkin wrote:
> > On 4/28/20 2:23 PM, Jeff Layton wrote:
> > > On Mon, 2020-04-27 at 23:46 +0200, edward6@linux.ibm.com wrote:
> > > > From: Eduard Shishkin <edward6@linux.ibm.com>
> > > >
> > > > In the function handle_session() variable @features always
> > > > contains little endian order of bytes. Just because the feature
> > > > bits are packed bytewise from left to right in
> > > > encode_supported_features().
> > > >
> > > > However, test_bit(), called to check features availability, assumes
> > > > the host order of bytes in that variable. This leads to problems on
> > > > big endian architectures. Specifically it is impossible to mount
> > > > ceph volume on s390.
> > > >
> > > > This patch adds conversion from little endian to the host order
> > > > of bytes, thus fixing the problem.
> > > >
> > > > Signed-off-by: Eduard Shishkin <edward6@linux.ibm.com>
> > > > ---
> > > >   fs/ceph/mds_client.c | 4 ++--
> > > >   1 file changed, 2 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > > > index 486f91f..190598d 100644
> > > > --- a/fs/ceph/mds_client.c
> > > > +++ b/fs/ceph/mds_client.c
> > > > @@ -3252,7 +3252,7 @@ static void handle_session(struct ceph_mds_session *session,
> > > >           struct ceph_mds_session_head *h;
> > > >           u32 op;
> > > >           u64 seq;
> > > > - unsigned long features = 0;
> > > > + __le64 features = 0;
> > > >           int wake = 0;
> > > >           bool blacklisted = false;
> > > >
> > > > @@ -3301,7 +3301,7 @@ static void handle_session(struct ceph_mds_session *session,
> > > >                   if (session->s_state == CEPH_MDS_SESSION_RECONNECTING)
> > > >                           pr_info("mds%d reconnect success\n", session->s_mds);
> > > >                   session->s_state = CEPH_MDS_SESSION_OPEN;
> > > > -         session->s_features = features;
> > > > +         session->s_features = le64_to_cpu(features);
> > > >                   renewed_caps(mdsc, session, 0);
> > > >                   wake = 1;
> > > >                   if (mdsc->stopping)
> > >
> > > (cc'ing Zheng since he did the original patches here)
> > >
> > > Thanks Eduard. The problem is real, but I think we can just do the
> > > conversion during the decode.
> > >
> > > The feature mask words sent by the MDS are 64 bits, so if it's smaller
> > > we can assume that it's malformed. So, I don't think we need to handle
> > > the case where it's smaller than 8 bytes.
> > >
> > > How about this patch instead?
> >
> > Hi Jeff,
> >
> > This also works. Please, apply.
> >
> > Thanks,
> > Eduard.
> >
>
> Thanks. Merged into ceph-client/testing branch, and should make v5.8.

I think this is stable material.  I'll tag it and get it queued up for 5.7-rc.

Thanks,

                Ilya
