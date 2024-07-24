Return-Path: <ceph-devel+bounces-1554-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99CA493B255
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Jul 2024 16:09:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB9F71C2258D
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Jul 2024 14:09:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A587158D75;
	Wed, 24 Jul 2024 14:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ByomPFPR"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1935CDDC5
	for <ceph-devel@vger.kernel.org>; Wed, 24 Jul 2024 14:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721830163; cv=none; b=LpglXXFRAZj5AwSWqKzoVms2hj+5gAbRxUUk1975KGFt39WQh8T51/dHCB7dZlr/rGIaec9wHIaLp/r/oZ22B4iaGKVtUhUgW52UTv9UFuHWWHjPzQa4kYGUm+Tb5fvzER2o7h5tlH99D6L+AyMcdVA5PY9HuDvvBcql+WSxBAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721830163; c=relaxed/simple;
	bh=PYV5lhPmqLRL19fbEfAOyqWqOecSAE6KiZa+m3JmkRo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tIkeu/kBZlcLs01/9/2zFdpIBxJ8S5N0TW8sHp1jXMCNJz8XO5TGYHt3yQy7Yjeh7YlmK0zbBtJPTZUXJhkNc0dR0P3A2U5AFjLNHF2P0wnw4BHlhfwvCH0sjrnXR54Up8fdw9Sg6MhVZIFn8ZsBJRa/OuiHL/ugmhRKgz6JvQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ByomPFPR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721830160;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MDHigb5F/TsnifZT7SnQvoF553EWIMT0YbdI6vMem8I=;
	b=ByomPFPRN8rFb+gJvesoJwN2chvUFeStYI3N/ioD5U7Tpfc3N9sWwnzhG6x8o+DCo77ciC
	8s1/zHZUO7bEv5Kqw1VF/K0gxlwlQK75L/OxGBzJE4Rqu3nf7W3IKN5y182/cJ3aaxkE0L
	6Ao1BELqaTVPDxt0CLgX0WcItsyPpX0=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-355-D3ciJEFIMtygWjEvziOQMQ-1; Wed, 24 Jul 2024 10:09:17 -0400
X-MC-Unique: D3ciJEFIMtygWjEvziOQMQ-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a7aa56d8b14so67851566b.1
        for <ceph-devel@vger.kernel.org>; Wed, 24 Jul 2024 07:09:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721830157; x=1722434957;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MDHigb5F/TsnifZT7SnQvoF553EWIMT0YbdI6vMem8I=;
        b=c0/vi4o1q1ombKOGh/4x3I31/X1MS1IpGlYsabqwjaxNcDju9Zp3mSBoo1aDaBt2oA
         8lP+EbPVSE4+M+Mgpo0mcxfvhDJAWXwZqiWGLnojC8UNa7++M38gl/VgZbw3Cuickl2R
         fXJnCEjntawGyn/WUVVyekKr55/fR+8BouQBQXMUI0FvJFX76uSUBjVVKH8lHcA/9d5t
         G/9F+9/zYEqe7wEX8Nkv+W16GQujpSwf6pH8Cn7CIY5y50fj8NDsMfw8/7qmOTy17fR+
         EJz5J8jPmOhtUAQ0fGdI1IYHN3ST3Npj/m1UpV6+feKzlnw+iexSVlVWIef9XKujR/m+
         EWWg==
X-Gm-Message-State: AOJu0Yz5nviLej6LRsPYZDxewcI0rNR0+FzL5IVmMqxxdcc5bYYAuVsv
	lWTfnrZULifhRLBVuBebU6Uxd2pmik7M9OiJWZNmr3Y3Q0cwn8lXfoz72FvQH9SqIB/oTOgSu4o
	Cw/N+Zf4wUfuNXAm2Wg4OTBBD523qfgESuYxE996Q28QnupDiNfafuMCyhKhoXJSiI7+zYRYlDK
	ldUlm0ySnuzNEZ+i+40aqezCyYMZ7cRPIhKA==
X-Received: by 2002:a17:907:94c8:b0:a7a:ab8a:380 with SMTP id a640c23a62f3a-a7aab8a05c1mr231385566b.69.1721830156640;
        Wed, 24 Jul 2024 07:09:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH9odWhsd2Dkm18F2IhcinS3V5BVXwbYtWkcruc4uBcFXK/DTbVcXDn5y0ufSPw/QBpTS8musV4ohDKn0fxDbg=
X-Received: by 2002:a17:907:94c8:b0:a7a:ab8a:380 with SMTP id
 a640c23a62f3a-a7aab8a05c1mr231383366b.69.1721830156157; Wed, 24 Jul 2024
 07:09:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240716120724.134512-1-xiubli@redhat.com>
In-Reply-To: <20240716120724.134512-1-xiubli@redhat.com>
From: Venky Shankar <vshankar@redhat.com>
Date: Wed, 24 Jul 2024 19:38:39 +0530
Message-ID: <CACPzV1kqN49AW4ihgd0yDvmaujMWKr+4B7tonnUpn=dPPs6Nhw@mail.gmail.com>
Subject: Re: [PATCH v3] ceph: force sending a cap update msg back to MDS for
 revoke op
To: xiubli@redhat.com
Cc: ceph-devel@vger.kernel.org, idryomov@gmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Xiubo,

On Tue, Jul 16, 2024 at 5:37=E2=80=AFPM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> If a client sends out a cap update dropping caps with the prior 'seq'
> just before an incoming cap revoke request, then the client may drop
> the revoke because it believes it's already released the requested
> capabilities.
>
> This causes the MDS to wait indefinitely for the client to respond
> to the revoke. It's therefore always a good idea to ack the cap
> revoke request with the bumped up 'seq'.
>
> Currently if the cap->issued equals to the newcaps the check_caps()
> will do nothing, we should force flush the caps.
>
> Cc: stable@vger.kernel.org
> Link: https://tracker.ceph.com/issues/61782
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>
> V3:
> - Move the force check earlier
>
> V2:
> - Improved the patch to force send the cap update only when no caps
> being used.
>
>
>  fs/ceph/caps.c  | 35 ++++++++++++++++++++++++-----------
>  fs/ceph/super.h |  7 ++++---
>  2 files changed, 28 insertions(+), 14 deletions(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 24c31f795938..672c6611d749 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -2024,6 +2024,8 @@ bool __ceph_should_report_size(struct ceph_inode_in=
fo *ci)
>   *  CHECK_CAPS_AUTHONLY - we should only check the auth cap
>   *  CHECK_CAPS_FLUSH - we should flush any dirty caps immediately, witho=
ut
>   *    further delay.
> + *  CHECK_CAPS_FLUSH_FORCE - we should flush any caps immediately, witho=
ut
> + *    further delay.
>   */
>  void ceph_check_caps(struct ceph_inode_info *ci, int flags)
>  {
> @@ -2105,7 +2107,7 @@ void ceph_check_caps(struct ceph_inode_info *ci, in=
t flags)
>         }
>
>         doutc(cl, "%p %llx.%llx file_want %s used %s dirty %s "
> -             "flushing %s issued %s revoking %s retain %s %s%s%s\n",
> +             "flushing %s issued %s revoking %s retain %s %s%s%s%s\n",
>              inode, ceph_vinop(inode), ceph_cap_string(file_wanted),
>              ceph_cap_string(used), ceph_cap_string(ci->i_dirty_caps),
>              ceph_cap_string(ci->i_flushing_caps),
> @@ -2113,7 +2115,8 @@ void ceph_check_caps(struct ceph_inode_info *ci, in=
t flags)
>              ceph_cap_string(retain),
>              (flags & CHECK_CAPS_AUTHONLY) ? " AUTHONLY" : "",
>              (flags & CHECK_CAPS_FLUSH) ? " FLUSH" : "",
> -            (flags & CHECK_CAPS_NOINVAL) ? " NOINVAL" : "");
> +            (flags & CHECK_CAPS_NOINVAL) ? " NOINVAL" : "",
> +            (flags & CHECK_CAPS_FLUSH_FORCE) ? " FLUSH_FORCE" : "");
>
>         /*
>          * If we no longer need to hold onto old our caps, and we may
> @@ -2188,6 +2191,11 @@ void ceph_check_caps(struct ceph_inode_info *ci, i=
nt flags)
>                                 queue_writeback =3D true;
>                 }
>
> +               if (flags & CHECK_CAPS_FLUSH_FORCE) {
> +                       doutc(cl, "force to flush caps\n");
> +                       goto ack;
> +               }
> +
>                 if (cap =3D=3D ci->i_auth_cap &&
>                     (cap->issued & CEPH_CAP_FILE_WR)) {
>                         /* request larger max_size from MDS? */
> @@ -3518,6 +3526,8 @@ static void handle_cap_grant(struct inode *inode,
>         bool queue_invalidate =3D false;
>         bool deleted_inode =3D false;
>         bool fill_inline =3D false;
> +       bool revoke_wait =3D false;
> +       int flags =3D 0;
>
>         /*
>          * If there is at least one crypto block then we'll trust
> @@ -3713,16 +3723,18 @@ static void handle_cap_grant(struct inode *inode,
>                       ceph_cap_string(cap->issued), ceph_cap_string(newca=
ps),
>                       ceph_cap_string(revoking));
>                 if (S_ISREG(inode->i_mode) &&
> -                   (revoking & used & CEPH_CAP_FILE_BUFFER))
> +                   (revoking & used & CEPH_CAP_FILE_BUFFER)) {
>                         writeback =3D true;  /* initiate writeback; will =
delay ack */
> -               else if (queue_invalidate &&
> +                       revoke_wait =3D true;
> +               } else if (queue_invalidate &&
>                          revoking =3D=3D CEPH_CAP_FILE_CACHE &&
> -                        (newcaps & CEPH_CAP_FILE_LAZYIO) =3D=3D 0)
> -                       ; /* do nothing yet, invalidation will be queued =
*/
> -               else if (cap =3D=3D ci->i_auth_cap)
> +                        (newcaps & CEPH_CAP_FILE_LAZYIO) =3D=3D 0) {
> +                       revoke_wait =3D true; /* do nothing yet, invalida=
tion will be queued */
> +               } else if (cap =3D=3D ci->i_auth_cap) {
>                         check_caps =3D 1; /* check auth cap only */
> -               else
> +               } else {
>                         check_caps =3D 2; /* check all caps */
> +               }
>                 /* If there is new caps, try to wake up the waiters */
>                 if (~cap->issued & newcaps)
>                         wake =3D true;
> @@ -3749,8 +3761,9 @@ static void handle_cap_grant(struct inode *inode,
>         BUG_ON(cap->issued & ~cap->implemented);
>
>         /* don't let check_caps skip sending a response to MDS for revoke=
 msgs */
> -       if (le32_to_cpu(grant->op) =3D=3D CEPH_CAP_OP_REVOKE) {
> +       if (!revoke_wait && le32_to_cpu(grant->op) =3D=3D CEPH_CAP_OP_REV=
OKE) {
>                 cap->mds_wanted =3D 0;
> +               flags |=3D CHECK_CAPS_FLUSH_FORCE;
>                 if (cap =3D=3D ci->i_auth_cap)
>                         check_caps =3D 1; /* check auth cap only */
>                 else
> @@ -3806,9 +3819,9 @@ static void handle_cap_grant(struct inode *inode,
>
>         mutex_unlock(&session->s_mutex);
>         if (check_caps =3D=3D 1)
> -               ceph_check_caps(ci, CHECK_CAPS_AUTHONLY | CHECK_CAPS_NOIN=
VAL);
> +               ceph_check_caps(ci, flags | CHECK_CAPS_AUTHONLY | CHECK_C=
APS_NOINVAL);
>         else if (check_caps =3D=3D 2)
> -               ceph_check_caps(ci, CHECK_CAPS_NOINVAL);
> +               ceph_check_caps(ci, flags | CHECK_CAPS_NOINVAL);
>  }
>
>  /*
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index b0b368ed3018..831e8ec4d5da 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -200,9 +200,10 @@ struct ceph_cap {
>         struct list_head caps_item;
>  };
>
> -#define CHECK_CAPS_AUTHONLY   1  /* only check auth cap */
> -#define CHECK_CAPS_FLUSH      2  /* flush any dirty caps */
> -#define CHECK_CAPS_NOINVAL    4  /* don't invalidate pagecache */
> +#define CHECK_CAPS_AUTHONLY     1  /* only check auth cap */
> +#define CHECK_CAPS_FLUSH        2  /* flush any dirty caps */
> +#define CHECK_CAPS_NOINVAL      4  /* don't invalidate pagecache */
> +#define CHECK_CAPS_FLUSH_FORCE  8  /* force flush any caps */
>
>  struct ceph_cap_flush {
>         u64 tid;
> --
> 2.45.1
>

Unfortunately, the test run using this change has unrelated issues,
therefore, the tests have to be rerun. I'll schedule a fs suite run on
priority so that we get the results by tomorrow.

Will update once done. Apologies!

--=20
Cheers,
Venky


