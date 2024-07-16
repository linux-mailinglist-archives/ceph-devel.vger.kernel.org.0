Return-Path: <ceph-devel+bounces-1530-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D74B6932196
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Jul 2024 10:00:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1AC64282BCB
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Jul 2024 08:00:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED23C43AC3;
	Tue, 16 Jul 2024 08:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FOXHBjBw"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA75B48CE0
	for <ceph-devel@vger.kernel.org>; Tue, 16 Jul 2024 08:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721116844; cv=none; b=rtLJpAiGb4K1RQnf+/kGV2LaY1XgL2nZz8am8Z4d5RLvC9hlT0vRtIxDXx3vs0AZN0fSCniEJjkk6XxVxTxxNZSvKJwOe9mDiS4mvx2R6z3utkUjqrGEiwj5GEBZVlddRHsv++S829s9iGywDL8xs41VS+mGyX1PqoFEtVJhwMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721116844; c=relaxed/simple;
	bh=gbtJMdeZ8Nfx54fmCANpGtvgsT4lgrcHSQhoavBiUHE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TQdzt3xpY7NwjxPQPrq02+L0NQBlTuX1oSRBGpKyD4B+pNPaIsNer/pmM/rIj1Qy+YHuHs9+sbGUEElJF+8SDyGcvS3OVYjb9hmCh94EoABBuek4Wn49ZOgFBQ7pRBKJZoRpCuQ8Ru9RW3nOcXkTkHfbpVJy8gwz/zpaPFR9x0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FOXHBjBw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721116841;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HUKCoMTwNi+VNgsVFGaBvWqN5i93bmmgokcO8dazSYM=;
	b=FOXHBjBwJINYAtD5RTHIjZ8I1sfOl4ZDhP8NFF01QonvlUZOUvPt2ABiGsWIfMUXcoEeYR
	nREDzJmSTu+yttmeKASsiSMx4PDzd4201gdkARwFPKssO55oXFaMjbdwmQ0qRGAkKt4iwY
	6bMN0pxde+d04ZC4T33fhhdiqRfcRfU=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-173-4QoO3fULOXeJso6gSg-8EQ-1; Tue, 16 Jul 2024 04:00:40 -0400
X-MC-Unique: 4QoO3fULOXeJso6gSg-8EQ-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a7275e17256so448859366b.0
        for <ceph-devel@vger.kernel.org>; Tue, 16 Jul 2024 01:00:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721116839; x=1721721639;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HUKCoMTwNi+VNgsVFGaBvWqN5i93bmmgokcO8dazSYM=;
        b=LXs/Xu9JM5siTe6Ipd+y10ZK51s8IoyYDwviBsvYEEWkg2Y4Al0KhT6eCREzHMAxsR
         XfForN0hs4q07siB+kCvzqvCkT3wDz9gQwkJoIdM46WlkbTdRNAqc/7f/YQzS79DczlJ
         My7isKiF2JUmZ32K5nMT0AhHibd/8ZREexzDlXELgYBoLZORIvxG9ybUDE6sKTMJ2PmS
         j/1s9fmaNZW5NxAofSdf1HsuLCRmqV21y2wIS+l8PeHU8MswWTl0nU8YfJqFF8StWqdv
         Nz2afwhFadtX/rdwivqzkPbptkXMtqOae+NFQCyrsTWh2NB3feb0qaoD7bN5k9DA6IzC
         P2aA==
X-Gm-Message-State: AOJu0YwYkvP+BuzLATJWC+1IE5Y03COyVBwEnEnVdlhe1GVwOYv/1ucX
	KOmyimC8mr4FPb24WPXpWhaO6MEkehuZnBvxbzDjbY5AlFkg0W0e1uN8daPteJOhBWQPIEdwy1Q
	x3ntBfNJH6ViG0J/ovI7rXESDMYEH6p7jf37C6PCT6EiNJ8U4xRbMn+faUgD+GkiYPMVKlG3d1r
	6uVyMcckvcMOSIv/oaJ+bRCID+1CsGkbiIJA==
X-Received: by 2002:a17:906:2bc4:b0:a77:c199:9d01 with SMTP id a640c23a62f3a-a79ea4012camr81468666b.22.1721116838905;
        Tue, 16 Jul 2024 01:00:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFC62+BXN+qunBS2TGIIyi63ugKcbTFuUvvZBkfnv7ODtmsNygpVNN7Ki1TVNlLehJwPGXc5xZH+/kBCDC8zCA=
X-Received: by 2002:a17:906:2bc4:b0:a77:c199:9d01 with SMTP id
 a640c23a62f3a-a79ea4012camr81466266b.22.1721116838113; Tue, 16 Jul 2024
 01:00:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240711104019.987090-1-xiubli@redhat.com>
In-Reply-To: <20240711104019.987090-1-xiubli@redhat.com>
From: Venky Shankar <vshankar@redhat.com>
Date: Tue, 16 Jul 2024 13:30:01 +0530
Message-ID: <CACPzV1kjU5KYynz4KX9=z6LB6KELUqCZOBc126bpgpyrzRaWsQ@mail.gmail.com>
Subject: Re: [PATCH] ceph: force sending a cap update msg back to MDS for
 revoke op
To: xiubli@redhat.com
Cc: ceph-devel@vger.kernel.org, jlayton@kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Xiubo,

On Thu, Jul 11, 2024 at 4:10=E2=80=AFPM <xiubli@redhat.com> wrote:
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
>  fs/ceph/caps.c  | 16 ++++++++++++----
>  fs/ceph/super.h |  7 ++++---
>  2 files changed, 16 insertions(+), 7 deletions(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 24c31f795938..ba5809cf8f02 100644
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
> @@ -2223,6 +2226,9 @@ void ceph_check_caps(struct ceph_inode_info *ci, in=
t flags)
>                                 goto ack;
>                 }
>
> +               if (flags & CHECK_CAPS_FLUSH_FORCE)
> +                       goto ack;

Maybe check this early on inside the

        for (p =3D rb_first(&ci->i_caps); p; p =3D rb_next(p)) {


        }

loop?

> +
>                 /* things we might delay */
>                 if ((cap->issued & ~retain) =3D=3D 0)
>                         continue;     /* nope, all good */
> @@ -3518,6 +3524,7 @@ static void handle_cap_grant(struct inode *inode,
>         bool queue_invalidate =3D false;
>         bool deleted_inode =3D false;
>         bool fill_inline =3D false;
> +       int flags =3D 0;
>
>         /*
>          * If there is at least one crypto block then we'll trust
> @@ -3751,6 +3758,7 @@ static void handle_cap_grant(struct inode *inode,
>         /* don't let check_caps skip sending a response to MDS for revoke=
 msgs */
>         if (le32_to_cpu(grant->op) =3D=3D CEPH_CAP_OP_REVOKE) {
>                 cap->mds_wanted =3D 0;
> +               flags |=3D CHECK_CAPS_FLUSH_FORCE;
>                 if (cap =3D=3D ci->i_auth_cap)
>                         check_caps =3D 1; /* check auth cap only */
>                 else
> @@ -3806,9 +3814,9 @@ static void handle_cap_grant(struct inode *inode,
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


--=20
Cheers,
Venky


