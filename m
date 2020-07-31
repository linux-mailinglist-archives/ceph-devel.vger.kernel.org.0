Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48CA1233D3A
	for <lists+ceph-devel@lfdr.de>; Fri, 31 Jul 2020 04:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731165AbgGaCiY (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 30 Jul 2020 22:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727039AbgGaCiY (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 30 Jul 2020 22:38:24 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7A55C061574;
        Thu, 30 Jul 2020 19:38:23 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id j8so17983089ioe.9;
        Thu, 30 Jul 2020 19:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Rlj5R58q1SSD6BWu0ll8WlrzBNntL/4AqB0ll8CArmU=;
        b=bowJQP2ZES89AR+MaKOsb3Te1rTnH89iPRmo0Hsz9wxYU66dBy6YTKPKBdSoaAFkwK
         3ODTgO2yOZAP7Khs88cmSicn3+/r+S3YJNDEWvCRZA+3SHJqmisiTaGyNpn3NDha2p3L
         ERY9f6Ees06Q111Md111fszJM380ui9K6GtfSC+yaohG3w46/VWewPRj1TzFS/0CvwiE
         KSMq2yoj0enlidEwjetH9AxTx+0MSBN27EuItVeDq4f3KwJWz32hvsjyLIfva8bdCsB/
         iNuGkH/gnlA8+IepGj0W/H2XcPMZTl6MFuoWbNdQ3xnbVLT6CmZ0IKR/cS/0DVnzQLkZ
         AFSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Rlj5R58q1SSD6BWu0ll8WlrzBNntL/4AqB0ll8CArmU=;
        b=dErVPgCnIscwJ8vKIy0+PJLy3mC4XrBmVIXxxWI3KfOr+AETjGRtnwEkzZ2WxJvdag
         DpK5jLYR3uUw0kGd+T8CGAaImANp2Q9qRjWb2X2PTtlYvB5X1ad5NQTAuP5A1ZhlUyxZ
         VzCBnNK+qG3djJDCCbml6vjBYQcu47QX/UvuFUFFY5hreBDMbSQldoSUt+7UbHF9zCQn
         ytbpC3I+DC/09mF2JhQuGcl6mbnzgNklRPqg6ynmqq0Bd9Y5PuMUWgmFokbNznmD63Ux
         xlFiQAuuVy3qqLRtuNQS74mt14mo8LDb1ElqRgTr0mZ95RgOPA30kbjfwcTCgvHRKzs7
         VwrQ==
X-Gm-Message-State: AOAM532MGust6ESch/vSC8NWADyjcE3m7pU9T4Bt5eI3VeDqoy1SvYoW
        351gXnvPITC6SAKY1msczt55fp3jWRaBiPU870RFdkx7uuQ=
X-Google-Smtp-Source: ABdhPJyB17/NgFldZUX53F50gRd1tR07IBXS9uRCRXsXzZbzsTy1sfD4Rl+ZEHHgyU419avbVJvgrA9BKWc6pMgQITE=
X-Received: by 2002:a02:a389:: with SMTP id y9mr2482521jak.82.1596163103259;
 Thu, 30 Jul 2020 19:38:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200730112242.31648-1-gmayyyha@gmail.com> <e9c69117a1ce870c2a96565d2a2d64d066a6604f.camel@kernel.org>
In-Reply-To: <e9c69117a1ce870c2a96565d2a2d64d066a6604f.camel@kernel.org>
From:   Yanhu Cao <gmayyyha@gmail.com>
Date:   Fri, 31 Jul 2020 10:38:11 +0800
Message-ID: <CAB9OAC0-6o73af7xjYpGHyT-BS+BNda6jRFvkgDm7S06uH1i8A@mail.gmail.com>
Subject: Re: [PATCH] ceph: use frag's MDS in either mode
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Jul 31, 2020 at 12:46 AM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Thu, 2020-07-30 at 19:22 +0800, Yanhu Cao wrote:
> > if frag.mds != cap->session->s_mds, the client's req will be resent.
> >
> > e.g.
> >
> > file: mnt/cephfs/dir03/dir003 (0x10000000003)
> > ceph.dir.pin="1"
> >
> > echo 'aaa' > /mnt/cephfs/dir03/dir003/file29
> >
> > kernel: ceph:  __choose_mds 00000000ca362c7a is_hash=1 (0x7c768b89) mode 2
> > kernel: ceph:  __choose_mds 00000000ca362c7a 10000000003.fffffffffffffffe frag 0 mds1 (auth)
> > kernel: ceph:  __choose_mds 00000000ca362c7a 10000000003.fffffffffffffffe mds0 (auth cap 00000000679c38e2)
> > kernel: ceph:  __choose_mds using resend_mds mds1
> >
> > Signed-off-by: Yanhu Cao <gmayyyha@gmail.com>
> > ---
> >  fs/ceph/mds_client.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
>
> I think you're right that there is a bug here, but this patch
> description is not terribly descriptive. Can you explain the problem and
> solution a bit better?

Sorry, just describing the steps to reproduce it.

The problem is when doing some tests with multiple mds, there are many
mds forwarding requests between them
and then the client request is resent. So I analyze how the client
chooses the target mds to send the request.

If the request is a modification operation and the mode is set to USE_AUTH_MDS.
Auth mds should be selected to handle the request, and if auth mds for
frag is already set, it can be returned directly without the logic
behind it.
But the current logic doesn't return directly because the condition
'mode == USE_AUTH_MDS',
and sometimes frag's mds is not equal to cap's session mds, which then
causes the request to be resent.


I'll resubmit PR.

Thanks.

>
> A good patch description should walk me through the problem and your
> reasoning to fix it. Why is this wrong now, and how does your change
> address it?
>
> Thanks,
> Jeff
>
> > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > index a50497142e59..b2255a9be7c0 100644
> > --- a/fs/ceph/mds_client.c
> > +++ b/fs/ceph/mds_client.c
> > @@ -1103,8 +1103,7 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
> >                                    frag.frag, mds);
> >                               if (ceph_mdsmap_get_state(mdsc->mdsmap, mds) >=
> >                                   CEPH_MDS_STATE_ACTIVE) {
> > -                                     if (mode == USE_ANY_MDS &&
> > -                                         !ceph_mdsmap_is_laggy(mdsc->mdsmap,
> > +                                     if (!ceph_mdsmap_is_laggy(mdsc->mdsmap,
> >                                                                 mds))
> >                                               goto out;
> >                               }
>
> --
> Jeff Layton <jlayton@kernel.org>
>
