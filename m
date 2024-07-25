Return-Path: <ceph-devel+bounces-1556-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 45D8693BBD7
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jul 2024 06:52:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A4D41C23850
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jul 2024 04:52:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B71C81A277;
	Thu, 25 Jul 2024 04:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RS0Xsobh"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480D317565
	for <ceph-devel@vger.kernel.org>; Thu, 25 Jul 2024 04:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721883147; cv=none; b=m/4L1ZOZAnDouyjF+bOV2GoqWjy6fpr2oqX5qD/PU2xcu2/TBkeUjM/ctOTffPceCJ9JEzKa9huJM1IjlmP0uHh23RhJc5oILZYjKDCx36qqD8piAhg7D9UyRti4vbZe+8wWTgnLJYoMbqSF6Koj0hMou0ua7hnns8lQngnAg8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721883147; c=relaxed/simple;
	bh=mL/nyKmujwn6YkWjBZNMcJIZOibTKy6k6+4CnXS3WAU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rC+5fLZR/MZP0H4BSwCQECJgRXNEZaBp3kNbWMu2GjzdMLo1xmBVPK4Hi59QNLP5UxXnpX8cKnrYte9d5n60RdADqLl1Ipj7KUrbv0ateXslXfMZH9XS5igsvqDA8HH29ejmoT9P/RDToImy80yWf6gmmlQm9vYL0koTmFwDlwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RS0Xsobh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721883144;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x+b9QnXA6/oecn6EgMexQdtInvSuvypLufcCpqhW1tU=;
	b=RS0Xsobh9UDDO0izyI0WCZVYkTASxhrVC5SN7VpIkC2TEyDm7D/xIVOIxamy9Hht/OI6o8
	d9wwXxGbZ/218btWGXBYELBm17YCV/4E+0cR0rN123KIqatbA0JJxHH1/UFN9J0/iCK+JJ
	INMDN19SOD3Lue4aH81GtKQabQW0/04=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-161-3aBNBXqaNhKSNMWVRmuwHw-1; Thu, 25 Jul 2024 00:52:22 -0400
X-MC-Unique: 3aBNBXqaNhKSNMWVRmuwHw-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a7ab4817f34so11411366b.2
        for <ceph-devel@vger.kernel.org>; Wed, 24 Jul 2024 21:52:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721883140; x=1722487940;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x+b9QnXA6/oecn6EgMexQdtInvSuvypLufcCpqhW1tU=;
        b=LvZLJL1gOBMlP1B8ckT/4TSOomkIEwaiTOhSrQaLVmJM+6L7WmebVFNTpAlPL/ARIu
         Z71qBNWxLqONjsnVvER2/bZu1hWXAC5DU2yI0d+uYmKtiPsjw6VoB990BjdxM7334H/J
         ESAerB5QmCOr5CJLeOUh7MOPJ1Coh9ERSTj9LffgKm5L3kpmBXY9pQx4hQYHvl/9p73Y
         HfSmfn2tQcb9esJd1sMew1gRshc5Dar2jmPQO6fqDrPSAny3CRof6CitVqgM54U4rgPp
         yDGjRNVIYAKDxuS5Acl648chonKG+ABoMMxnTwYlf+DHFR1kKJRnPJ6jYUvLK0Z1Hbqq
         yqtw==
X-Gm-Message-State: AOJu0YwtwRJfLmk/YEBvHFSndzAa8Lqpnhwc78U9IFmin27a+Iw3vseV
	9hI7ZofJmqlqpbthVGHGsQXyEVaUCreg1WJ5/ryQhIXEgC3eKbOu36KnK+UaoL/S0T+VPAUaC/W
	oQPFsTg7G6IPjQ8XOVejDg71/cTIOBXGyAZgxCX8WC0TQAbR3vnquQS61zDgX85hNT8jPSAXlP/
	AGfhefRP+JQMxawd6OWoxDRMdJa8A+zx+50w==
X-Received: by 2002:a17:907:1c23:b0:a6f:4fc8:2666 with SMTP id a640c23a62f3a-a7ac52e0aedmr119401966b.44.1721883140446;
        Wed, 24 Jul 2024 21:52:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGSfx3SLfS+WYvE6/Mk8MopVY/M652NJELZ9bSlD9ZLMvQoA6gNNxq2qDvK0DzS6IyAPi8OsYGBrQxqVOTB3VA=
X-Received: by 2002:a17:907:1c23:b0:a6f:4fc8:2666 with SMTP id
 a640c23a62f3a-a7ac52e0aedmr119400966b.44.1721883140009; Wed, 24 Jul 2024
 21:52:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240716120724.134512-1-xiubli@redhat.com> <CACPzV1kqN49AW4ihgd0yDvmaujMWKr+4B7tonnUpn=dPPs6Nhw@mail.gmail.com>
 <dac1bb9f-c544-4c56-b1eb-b565a6405f76@redhat.com>
In-Reply-To: <dac1bb9f-c544-4c56-b1eb-b565a6405f76@redhat.com>
From: Venky Shankar <vshankar@redhat.com>
Date: Thu, 25 Jul 2024 10:21:42 +0530
Message-ID: <CACPzV1=jOYoqpRrZ+Si2bBMrQ23nWN_hJbxsRLxPpRr9NOL2fg@mail.gmail.com>
Subject: Re: [PATCH v3] ceph: force sending a cap update msg back to MDS for
 revoke op
To: Xiubo Li <xiubli@redhat.com>
Cc: ceph-devel@vger.kernel.org, idryomov@gmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 25, 2024 at 6:31=E2=80=AFAM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 7/24/24 22:08, Venky Shankar wrote:
> > Hi Xiubo,
> >
> > On Tue, Jul 16, 2024 at 5:37=E2=80=AFPM <xiubli@redhat.com> wrote:
> >> From: Xiubo Li <xiubli@redhat.com>
> >>
> >> If a client sends out a cap update dropping caps with the prior 'seq'
> >> just before an incoming cap revoke request, then the client may drop
> >> the revoke because it believes it's already released the requested
> >> capabilities.
> >>
> >> This causes the MDS to wait indefinitely for the client to respond
> >> to the revoke. It's therefore always a good idea to ack the cap
> >> revoke request with the bumped up 'seq'.
> >>
> >> Currently if the cap->issued equals to the newcaps the check_caps()
> >> will do nothing, we should force flush the caps.
> >>
> >> Cc: stable@vger.kernel.org
> >> Link: https://tracker.ceph.com/issues/61782
> >> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> >> ---
> >>
> >> V3:
> >> - Move the force check earlier
> >>
> >> V2:
> >> - Improved the patch to force send the cap update only when no caps
> >> being used.
> >>
> >>
> >>   fs/ceph/caps.c  | 35 ++++++++++++++++++++++++-----------
> >>   fs/ceph/super.h |  7 ++++---
> >>   2 files changed, 28 insertions(+), 14 deletions(-)
> >>
> >> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> >> index 24c31f795938..672c6611d749 100644
> >> --- a/fs/ceph/caps.c
> >> +++ b/fs/ceph/caps.c
> >> @@ -2024,6 +2024,8 @@ bool __ceph_should_report_size(struct ceph_inode=
_info *ci)
> >>    *  CHECK_CAPS_AUTHONLY - we should only check the auth cap
> >>    *  CHECK_CAPS_FLUSH - we should flush any dirty caps immediately, w=
ithout
> >>    *    further delay.
> >> + *  CHECK_CAPS_FLUSH_FORCE - we should flush any caps immediately, wi=
thout
> >> + *    further delay.
> >>    */
> >>   void ceph_check_caps(struct ceph_inode_info *ci, int flags)
> >>   {
> >> @@ -2105,7 +2107,7 @@ void ceph_check_caps(struct ceph_inode_info *ci,=
 int flags)
> >>          }
> >>
> >>          doutc(cl, "%p %llx.%llx file_want %s used %s dirty %s "
> >> -             "flushing %s issued %s revoking %s retain %s %s%s%s\n",
> >> +             "flushing %s issued %s revoking %s retain %s %s%s%s%s\n"=
,
> >>               inode, ceph_vinop(inode), ceph_cap_string(file_wanted),
> >>               ceph_cap_string(used), ceph_cap_string(ci->i_dirty_caps)=
,
> >>               ceph_cap_string(ci->i_flushing_caps),
> >> @@ -2113,7 +2115,8 @@ void ceph_check_caps(struct ceph_inode_info *ci,=
 int flags)
> >>               ceph_cap_string(retain),
> >>               (flags & CHECK_CAPS_AUTHONLY) ? " AUTHONLY" : "",
> >>               (flags & CHECK_CAPS_FLUSH) ? " FLUSH" : "",
> >> -            (flags & CHECK_CAPS_NOINVAL) ? " NOINVAL" : "");
> >> +            (flags & CHECK_CAPS_NOINVAL) ? " NOINVAL" : "",
> >> +            (flags & CHECK_CAPS_FLUSH_FORCE) ? " FLUSH_FORCE" : "");
> >>
> >>          /*
> >>           * If we no longer need to hold onto old our caps, and we may
> >> @@ -2188,6 +2191,11 @@ void ceph_check_caps(struct ceph_inode_info *ci=
, int flags)
> >>                                  queue_writeback =3D true;
> >>                  }
> >>
> >> +               if (flags & CHECK_CAPS_FLUSH_FORCE) {
> >> +                       doutc(cl, "force to flush caps\n");
> >> +                       goto ack;
> >> +               }
> >> +
> >>                  if (cap =3D=3D ci->i_auth_cap &&
> >>                      (cap->issued & CEPH_CAP_FILE_WR)) {
> >>                          /* request larger max_size from MDS? */
> >> @@ -3518,6 +3526,8 @@ static void handle_cap_grant(struct inode *inode=
,
> >>          bool queue_invalidate =3D false;
> >>          bool deleted_inode =3D false;
> >>          bool fill_inline =3D false;
> >> +       bool revoke_wait =3D false;
> >> +       int flags =3D 0;
> >>
> >>          /*
> >>           * If there is at least one crypto block then we'll trust
> >> @@ -3713,16 +3723,18 @@ static void handle_cap_grant(struct inode *ino=
de,
> >>                        ceph_cap_string(cap->issued), ceph_cap_string(n=
ewcaps),
> >>                        ceph_cap_string(revoking));
> >>                  if (S_ISREG(inode->i_mode) &&
> >> -                   (revoking & used & CEPH_CAP_FILE_BUFFER))
> >> +                   (revoking & used & CEPH_CAP_FILE_BUFFER)) {
> >>                          writeback =3D true;  /* initiate writeback; w=
ill delay ack */
> >> -               else if (queue_invalidate &&
> >> +                       revoke_wait =3D true;
> >> +               } else if (queue_invalidate &&
> >>                           revoking =3D=3D CEPH_CAP_FILE_CACHE &&
> >> -                        (newcaps & CEPH_CAP_FILE_LAZYIO) =3D=3D 0)
> >> -                       ; /* do nothing yet, invalidation will be queu=
ed */
> >> -               else if (cap =3D=3D ci->i_auth_cap)
> >> +                        (newcaps & CEPH_CAP_FILE_LAZYIO) =3D=3D 0) {
> >> +                       revoke_wait =3D true; /* do nothing yet, inval=
idation will be queued */
> >> +               } else if (cap =3D=3D ci->i_auth_cap) {
> >>                          check_caps =3D 1; /* check auth cap only */
> >> -               else
> >> +               } else {
> >>                          check_caps =3D 2; /* check all caps */
> >> +               }
> >>                  /* If there is new caps, try to wake up the waiters *=
/
> >>                  if (~cap->issued & newcaps)
> >>                          wake =3D true;
> >> @@ -3749,8 +3761,9 @@ static void handle_cap_grant(struct inode *inode=
,
> >>          BUG_ON(cap->issued & ~cap->implemented);
> >>
> >>          /* don't let check_caps skip sending a response to MDS for re=
voke msgs */
> >> -       if (le32_to_cpu(grant->op) =3D=3D CEPH_CAP_OP_REVOKE) {
> >> +       if (!revoke_wait && le32_to_cpu(grant->op) =3D=3D CEPH_CAP_OP_=
REVOKE) {
> >>                  cap->mds_wanted =3D 0;
> >> +               flags |=3D CHECK_CAPS_FLUSH_FORCE;
> >>                  if (cap =3D=3D ci->i_auth_cap)
> >>                          check_caps =3D 1; /* check auth cap only */
> >>                  else
> >> @@ -3806,9 +3819,9 @@ static void handle_cap_grant(struct inode *inode=
,
> >>
> >>          mutex_unlock(&session->s_mutex);
> >>          if (check_caps =3D=3D 1)
> >> -               ceph_check_caps(ci, CHECK_CAPS_AUTHONLY | CHECK_CAPS_N=
OINVAL);
> >> +               ceph_check_caps(ci, flags | CHECK_CAPS_AUTHONLY | CHEC=
K_CAPS_NOINVAL);
> >>          else if (check_caps =3D=3D 2)
> >> -               ceph_check_caps(ci, CHECK_CAPS_NOINVAL);
> >> +               ceph_check_caps(ci, flags | CHECK_CAPS_NOINVAL);
> >>   }
> >>
> >>   /*
> >> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> >> index b0b368ed3018..831e8ec4d5da 100644
> >> --- a/fs/ceph/super.h
> >> +++ b/fs/ceph/super.h
> >> @@ -200,9 +200,10 @@ struct ceph_cap {
> >>          struct list_head caps_item;
> >>   };
> >>
> >> -#define CHECK_CAPS_AUTHONLY   1  /* only check auth cap */
> >> -#define CHECK_CAPS_FLUSH      2  /* flush any dirty caps */
> >> -#define CHECK_CAPS_NOINVAL    4  /* don't invalidate pagecache */
> >> +#define CHECK_CAPS_AUTHONLY     1  /* only check auth cap */
> >> +#define CHECK_CAPS_FLUSH        2  /* flush any dirty caps */
> >> +#define CHECK_CAPS_NOINVAL      4  /* don't invalidate pagecache */
> >> +#define CHECK_CAPS_FLUSH_FORCE  8  /* force flush any caps */
> >>
> >>   struct ceph_cap_flush {
> >>          u64 tid;
> >> --
> >> 2.45.1
> >>
> > Unfortunately, the test run using this change has unrelated issues,
> > therefore, the tests have to be rerun. I'll schedule a fs suite run on
> > priority so that we get the results by tomorrow.
> >
> > Will update once done. Apologies!
>
> No worry. Just take your time.

Here are the test results

        https://pulpito.ceph.com/vshankar-2024-07-24_14:14:53-fs-main-testi=
ng-default-smithi/

Mostly look good. I'll review those in depth to see if something stands out=
.

Thanks, Xiubo!

--=20
Cheers,
Venky


