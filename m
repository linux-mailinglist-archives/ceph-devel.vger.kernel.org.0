Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0609AEBC2
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Sep 2019 15:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729662AbfIJNk6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Sep 2019 09:40:58 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:42236 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbfIJNk6 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 10 Sep 2019 09:40:58 -0400
Received: by mail-lj1-f196.google.com with SMTP id y23so16464558lje.9
        for <ceph-devel@vger.kernel.org>; Tue, 10 Sep 2019 06:40:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=h+27CluHFp15Zqb2yaPMx1N1Zv/mF0OI4lLlI1xDBqM=;
        b=NXHtRXHkMJFT0VpSYxqetS7wAx4ca5n/xzv1qpGNUr6//Uazqq9IdaTMs0HqD3ICJn
         JWPRnScfF21jap3QYJeqF0nhW8cwOtU0zlHm3RNJdKAAgNLSVD6Rt8n7c7CWCcfykD1r
         I8WaVGCW71CUfFFaMHnPu9uHtoA6twrVnaTfQ97YJkFpmgJzz3wK6pWM/HDC+ytPLGLw
         f/u8o7BDyCViQ1ep3vQGh0TrBRIFSMWjFgYMKlPxqU/y/Kg4ukEBgAaDcSeXeWxG6Dsd
         OI4bsQ74PcKVhehIeEKxT5+bmRsYJMjgtJRcfujfPZfbor+SyzYldcqoLd4bYuu3jQPv
         9WsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=h+27CluHFp15Zqb2yaPMx1N1Zv/mF0OI4lLlI1xDBqM=;
        b=T2/IZHWjAAEdX34LO2MV0wNOxe70BibVENMY8kehI4v04NXgjeJF7MaHkA3qTGTOGm
         tsOQZrU1YznAHr0vaIPU1MSgWJNn5OWu/n5g1BZD7QAc0ukxuX6BTBECxJNwr1hDiuiY
         XtZWhlURkBxId5SOmqkArDGxGnYxgf7hRMDAQrYaiSWQEFZP/DUDUwXqj5hL3fU1DiTU
         2BFeHslHfc9UKiQb6M6kR4c3ICkr7ccvk1PFRidDk7+NxlYxpEHVihsnPRa7CRge1lWH
         qSxhAHd5kxhRNUJIHkirFCd/JDVyiF+lrjBg0Gqs1vUPTH7UADn8l5SXRfMGP13dafuc
         kYVQ==
X-Gm-Message-State: APjAAAW3D61pD7uCwhaDxPE9Q+N6fhvCFjdQnxO3vMdSw/8fpnXmUqsy
        dfYDu4EvMuNpsd73qbuFfA2q4J0zVDPiL19bJdZp56yM
X-Google-Smtp-Source: APXvYqxnbVnNZ/Wfnwfzt9UiQSOygnEUxh1zHDkgrcKXaStZrV05LsDfIqRttMaAk4UD1Ggh3i8QHGyVHjPpB7KGSNw=
X-Received: by 2002:a2e:8694:: with SMTP id l20mr20042901lji.68.1568122854978;
 Tue, 10 Sep 2019 06:40:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190910130912.46277-1-chenerqi@gmail.com> <5f0d307b37615756d0f284da5e2a505ab7436198.camel@kernel.org>
In-Reply-To: <5f0d307b37615756d0f284da5e2a505ab7436198.camel@kernel.org>
From:   erqi chen <chenerqi@gmail.com>
Date:   Tue, 10 Sep 2019 21:40:43 +0800
Message-ID: <CA+eEYqWV6wJLMd0s4Nv2UfLNapo57LyV+X_DGuTLtWLc3t3vNw@mail.gmail.com>
Subject: Re: [PATCH] ceph: reconnect connection if session hang in opening state
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi,

I made a stupid mistake that "{" is missed at the last of the patch, I
found it just now when I compile the code, please help update it.

Jeff Layton <jlayton@kernel.org> =E4=BA=8E2019=E5=B9=B49=E6=9C=8810=E6=97=
=A5=E5=91=A8=E4=BA=8C =E4=B8=8B=E5=8D=889:13=E5=86=99=E9=81=93=EF=BC=9A
>
> On Tue, 2019-09-10 at 21:09 +0800, chenerqi@gmail.com wrote:
> > From: chenerqi <chenerqi@gmail.com>
> >
> > If client mds session is evicted in CEPH_MDS_SESSION_OPENING state,
> > mds won't send session msg to client, and delayed_work skip
> > CEPH_MDS_SESSION_OPENING state session, the session hang forever.
> > ceph_con_keepalive reconnct connection for CEPH_MDS_SESSION_OPENING
> > session to avoid session hang.
> >
> > Fixes: https://tracker.ceph.com/issues/41551
> > Signed-off-by: Erqi Chen chenerqi@gmail.com
> > ---
> >  fs/ceph/mds_client.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > index 937e887..8f382b5 100644
> > --- a/fs/ceph/mds_client.c
> > +++ b/fs/ceph/mds_client.c
> > @@ -3581,7 +3581,9 @@ static void delayed_work(struct work_struct *work=
)
> >                               pr_info("mds%d hung\n", s->s_mds);
> >                       }
> >               }
> > -             if (s->s_state < CEPH_MDS_SESSION_OPEN) {
> > +             if (s->s_state =3D=3D CEPH_MDS_SESSION_NEW ||
> > +                 s->s_state =3D=3D CEPH_MDS_SESSION_RESTARTING ||
> > +                 s->s_state =3D=3D CEPH_MDS_SESSION_REJECTED) {
> >                       /* this mds is failed or recovering, just wait */
> >                       ceph_put_mds_session(s);
> >                       continue;
>
> This has already been merged into the testing branch and should make
> v5.4. Was there a reason you decided to resend it?
> --
> Jeff Layton <jlayton@kernel.org>
>
