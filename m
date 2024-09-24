Return-Path: <ceph-devel+bounces-1837-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 73BA29846AA
	for <lists+ceph-devel@lfdr.de>; Tue, 24 Sep 2024 15:24:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 010341F21EBC
	for <lists+ceph-devel@lfdr.de>; Tue, 24 Sep 2024 13:24:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30A0C155726;
	Tue, 24 Sep 2024 13:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DdSFOYNm"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3E1224D7
	for <ceph-devel@vger.kernel.org>; Tue, 24 Sep 2024 13:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727184266; cv=none; b=DSDS300rF9y+f8Ki8MArccLdjWKhwqk+Euf4IHS2FvR7Q/M8YKbvS2/ImYdmG+75uPhD0poJh0DcrmWNvM9ICgIpp5AGWlaXFdoZuFHQpjMvy8XdsVJ0bl2t4uDcoQzz27GvLSAxU8CvDsDID0cU5kft1DwGK2kdfJ4lZEuLGq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727184266; c=relaxed/simple;
	bh=LeOlOUCtghfrPOs8lzeM0fxZdP0NHQG7mpltotbZKd0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Vbj4IIZ5mwZLwF2LOoTVhX4I55lwJGVA1ReV0LTRW72AjCWdvFHDtZrD2nl0fOFgrUefFNCavsoL48dH+GfK3NP0XC7GcZfoFWLv4T+pWi7a3Ab/RY+OKCcgAwfmevZVKa7W0PibYtZ90lfMlV1nenzMu4rEzH84d81K0+GTCUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DdSFOYNm; arc=none smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-3e039889ca0so3100514b6e.3
        for <ceph-devel@vger.kernel.org>; Tue, 24 Sep 2024 06:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727184263; x=1727789063; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yc2+5y6SHWT8TIYFEzU5FgH6PQGqjgppKrtlrQRAJMU=;
        b=DdSFOYNmPzSVNSH3BG0qNwJC9NNgacB3UIUjb3odVWbXxpl90wh+B5vuc3C1BHGeLb
         SyGaXzhLhFK47/yDkaKhBKPX5O4qyOIdB/suPtkuzmPicdIFBCzGNTmITfRT3BEp0KY0
         dfYzt42hPEO36yp8PeMVg52foWXMAWjiCAy0B3kHIADZGQE1zurQb7ME9ABXYqoW6GpF
         KDWzJG2KUDHU4cJJapTK3690hOS722yTHYD+REPjMDg6a8G8CmP3KKvooJKbsJKtmACu
         JtQOYh4e7Fz8rjD5EfqJCubqCW4NDBjaCRH/eQu5Lz4d195xRigiC+AknxNFSTHrbWo1
         J8fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727184263; x=1727789063;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Yc2+5y6SHWT8TIYFEzU5FgH6PQGqjgppKrtlrQRAJMU=;
        b=wTwi305koq1Hqhcz0a8P8fYOQw+Vj0u+4imCVCYHVKwGFpJatD82Qiu2LV6DWyTmhd
         rHfrtUlZt8/xjXD2AKGdXzB3axDCvAQ2btLZJwIXXc5KiyraVF3EbKgrF71ab+wPzIdl
         lOgtTuy21Bf3WOecB1eOoGSEKxmKZ5xuqtFIShDBRKDk2TcIYr0Jziv0PUA0NXV23b9O
         ZU7yZEUjc1Arlqf3riC5D1PeutLbb09qPpXgaDmyF/RzYrEdwKmZ5GJDLjNAsfQwkvz6
         A9sQZvmqjpb+BFzAZswvnCRonA0cBrgwOwukoQ97/E8q4gzbBAitr4g2OzCD/n8Cdp6G
         YXFg==
X-Gm-Message-State: AOJu0Yy2jazAe/XIvQIqK+x01DCf040EsH31ViwgHlAnY6pAn5jVV0++
	xNofKXWm3CbUF9xVYmS8zBid2ahJmkfSX1NgZhvQ0wkTpTxzpVeHndRzbb8biKp0nqHidwpWMqv
	LRhU2BYhCz6WqfqBscw37AzsL2vk=
X-Google-Smtp-Source: AGHT+IFiTJdr7dtdPxFsOPr9PkKaNb7mmn8XD7PdvAQQpKgTMjcRH3LiMUzxf4mNOLWNtrBtNcztb4YbNEsyhh4Sd6k=
X-Received: by 2002:a05:6870:e386:b0:277:db7f:cfb2 with SMTP id
 586e51a60fabf-2803a6035fbmr12429037fac.14.1727184263354; Tue, 24 Sep 2024
 06:24:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240730054135.640396-1-xiubli@redhat.com> <20240730054135.640396-3-xiubli@redhat.com>
 <CAOi1vP9g92tv8sEbFbSkV73PwrqqNNQktcYxUvdwCYBZkhhnsw@mail.gmail.com> <336f83cc-4a57-48dd-8598-e5b4ceab7d46@redhat.com>
In-Reply-To: <336f83cc-4a57-48dd-8598-e5b4ceab7d46@redhat.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Tue, 24 Sep 2024 15:24:11 +0200
Message-ID: <CAOi1vP_LbSL2Zh-ndry2jXCMmueEc4=j-gbCTyrWn96g=1jmvg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] ceph: flush all the caps release when syncing the
 whole filesystem
To: Xiubo Li <xiubli@redhat.com>
Cc: ceph-devel@vger.kernel.org, vshankar@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 24, 2024 at 1:47=E2=80=AFPM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 9/24/24 14:26, Ilya Dryomov wrote:
> > On Tue, Jul 30, 2024 at 7:41=E2=80=AFAM <xiubli@redhat.com> wrote:
> >> From: Xiubo Li <xiubli@redhat.com>
> >>
> >> We have hit a race between cap releases and cap revoke request
> >> that will cause the check_caps() to miss sending a cap revoke ack
> >> to MDS. And the client will depend on the cap release to release
> >> that revoking caps, which could be delayed for some unknown reasons.
> >>
> >> In Kclient we have figured out the RCA about race and we need
> >> a way to explictly trigger this manually could help to get rid
> >> of the caps revoke stuck issue.
> >>
> >> URL: https://tracker.ceph.com/issues/67221
> >> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> >> ---
> >>   fs/ceph/caps.c       | 22 ++++++++++++++++++++++
> >>   fs/ceph/mds_client.c |  1 +
> >>   fs/ceph/super.c      |  1 +
> >>   fs/ceph/super.h      |  1 +
> >>   4 files changed, 25 insertions(+)
> >>
> >> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> >> index c09add6d6516..a0a39243aeb3 100644
> >> --- a/fs/ceph/caps.c
> >> +++ b/fs/ceph/caps.c
> >> @@ -4729,6 +4729,28 @@ void ceph_flush_dirty_caps(struct ceph_mds_clie=
nt *mdsc)
> >>          ceph_mdsc_iterate_sessions(mdsc, flush_dirty_session_caps, tr=
ue);
> >>   }
> >>
> >> +/*
> >> + * Flush all cap releases to the mds
> >> + */
> >> +static void flush_cap_releases(struct ceph_mds_session *s)
> >> +{
> >> +       struct ceph_mds_client *mdsc =3D s->s_mdsc;
> >> +       struct ceph_client *cl =3D mdsc->fsc->client;
> >> +
> >> +       doutc(cl, "begin\n");
> >> +       spin_lock(&s->s_cap_lock);
> >> +       if (s->s_num_cap_releases)
> >> +               ceph_flush_session_cap_releases(mdsc, s);
> >> +       spin_unlock(&s->s_cap_lock);
> >> +       doutc(cl, "done\n");
> >> +
> >> +}
> >> +
> >> +void ceph_flush_cap_releases(struct ceph_mds_client *mdsc)
> >> +{
> >> +       ceph_mdsc_iterate_sessions(mdsc, flush_cap_releases, true);
> >> +}
> >> +
> >>   void __ceph_touch_fmode(struct ceph_inode_info *ci,
> >>                          struct ceph_mds_client *mdsc, int fmode)
> >>   {
> >> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> >> index 86d0148819b0..fc563b59959a 100644
> >> --- a/fs/ceph/mds_client.c
> >> +++ b/fs/ceph/mds_client.c
> >> @@ -5904,6 +5904,7 @@ void ceph_mdsc_sync(struct ceph_mds_client *mdsc=
)
> >>          want_tid =3D mdsc->last_tid;
> >>          mutex_unlock(&mdsc->mutex);
> >>
> >> +       ceph_flush_cap_releases(mdsc);
> >>          ceph_flush_dirty_caps(mdsc);
> >>          spin_lock(&mdsc->cap_dirty_lock);
> >>          want_flush =3D mdsc->last_cap_flush_tid;
> >> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> >> index f489b3e12429..0a1215b4f0ba 100644
> >> --- a/fs/ceph/super.c
> >> +++ b/fs/ceph/super.c
> >> @@ -126,6 +126,7 @@ static int ceph_sync_fs(struct super_block *sb, in=
t wait)
> >>          if (!wait) {
> >>                  doutc(cl, "(non-blocking)\n");
> >>                  ceph_flush_dirty_caps(fsc->mdsc);
> >> +               ceph_flush_cap_releases(fsc->mdsc);
> > Hi Xiubo,
> >
> > Is there a significance to flushing cap releases before dirty caps on
> > the blocking path and doing it vice versa (i.e. flushing cap releases
> > after dirty caps) on the non-blocking path?
>
> Hi Ilya,
>
> The dirty caps and the cap releases are not related.
>
> If caps are dirty it should be in the dirty list anyway in theory. Else
> when the file is closed or inode is released will it be in the release
> lists.

So doing

    ceph_flush_dirty_caps(mdsc);
    ceph_flush_cap_releases(mdsc);

in both cases just so that it's consistent is fine, right?

Thanks,

                Ilya

