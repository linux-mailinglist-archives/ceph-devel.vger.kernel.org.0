Return-Path: <ceph-devel+bounces-1564-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F195393C10A
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jul 2024 13:42:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 351C9B21B52
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jul 2024 11:42:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64763199397;
	Thu, 25 Jul 2024 11:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OEhC+VbS"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688D819925B
	for <ceph-devel@vger.kernel.org>; Thu, 25 Jul 2024 11:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721907752; cv=none; b=XyPo5iWOYWg6nbh23tV3dLY+a5KmYz1U63gNBJteJ59S82AsSoi1A0tAbAv7b92jwk0kx2fVK2+lTiO0NVzdE/IX+u2afn1t2WrWMNhBclSdPAnyJ/o/B9gyDf0Bru9qN089/8lgoZE5S3Dl9gAo5FcGukXvSs5DVxTd+I2B0QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721907752; c=relaxed/simple;
	bh=y8Tzkjt3WEFzvpKh9C7Qb8XLQEz4aUjZ0wIgoulmCOU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bpd4EPFSaYsOY5Cfk7WabDKdhDSZtDXiC6rqklk2wh6ONoC99SF4C697u8C6BoL9SUvK5YgRFBIhZoXqvOQSvRw1k6/wBt4pGtEFu9ZVJ+r61g88MIHDC47AwzMzE1mN34zzV69VCM09EUxjGfoVguKIz0R88jv6OKNdekCpoeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OEhC+VbS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721907749;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n5omChVN0d3O1VEI9wuk2MqAV/WoccHrIriVgLmhRRE=;
	b=OEhC+VbSpkxZ577ZRLwtKs7i/2qXHDT5AJCT7PQZzS/zRA1UhClH+VCxc93ZeNu9ZcDTVV
	fDryunI1bR2uZu+9y8QRKJ5pTAqTnoYiJc+pho9PhwxPoI4FAWmBPNkOfk5crqybN2/vv/
	IgucBqXYx5KIgUZpcjQpwbTLcQN9m6A=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-178-8dpNYl1jP2-PzaNWwPGbCw-1; Thu, 25 Jul 2024 07:42:28 -0400
X-MC-Unique: 8dpNYl1jP2-PzaNWwPGbCw-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-a79c35c28f1so39541966b.3
        for <ceph-devel@vger.kernel.org>; Thu, 25 Jul 2024 04:42:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721907747; x=1722512547;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n5omChVN0d3O1VEI9wuk2MqAV/WoccHrIriVgLmhRRE=;
        b=q1dMGr9xYJ/bQksu7QMejh32pzGknZY796aQE7kb8GVRxjRG2V3UvQ0rSqlc42rvMX
         TX5FxR0o4nt30L2rWnt2wr0jzruGQwfI/hxFA62Bz0NTI8O3y6oWdJFPN8u19zZQCPZN
         VQPWMQzXhqxe+BrOqnDzU9/acY4+dsXrRC8NdWKUFd5/c3HNO8TZ/HaPk9buSpzCSu5q
         wcFzGoiDEaMBI+9jA59gJqBzImjkUDvChzhfSUKpeLSbh8Upa0xC00Jkz4ISIVQwTUQL
         FQIRi4Zcg1rArYRxBQFHoycxE9LX4H9v8fDrZgQwZoZVEp8ZVhRYBsFna1w1Qwn02wlX
         Vk/g==
X-Gm-Message-State: AOJu0YxhMq+hXv0f/JWk0cI5BSaOuwjnZe98xbMI/YdaeLVBVC7/w13+
	qq9c7plTwiGgzwGYjn6XGpasJZpcRkTONwzfnrZYh5BopeQ2gIwMGoRA+CDw9Mrfa/gFaUGbuY2
	qXuS8kfAplQK1CERvXnbfxqUe5os+dT/3r9uhhSFKS+1cRrghhbNVpSaaEZ3gTpctBTBJich9tD
	yTcOjg95UyOGGsZvVgNM8P11/MF5o+6PHzmA==
X-Received: by 2002:a17:906:3919:b0:a72:633d:5fd6 with SMTP id a640c23a62f3a-a7ac51c32e7mr125613266b.32.1721907746852;
        Thu, 25 Jul 2024 04:42:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEmadhxxx575qyx8hqVbxwuDtzxrO4Wi+b1xdVgOFO4thCx7wcJ83rXORBI0bEPquJCJWR0cI3H8T0sD2M942g=
X-Received: by 2002:a17:906:3919:b0:a72:633d:5fd6 with SMTP id
 a640c23a62f3a-a7ac51c32e7mr125611566b.32.1721907746257; Thu, 25 Jul 2024
 04:42:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240716120724.134512-1-xiubli@redhat.com>
In-Reply-To: <20240716120724.134512-1-xiubli@redhat.com>
From: Venky Shankar <vshankar@redhat.com>
Date: Thu, 25 Jul 2024 17:11:49 +0530
Message-ID: <CACPzV1=3m3zKcBuUKTYD6JfkSvo9dTuPU_8shrNBOEdBeSZDuA@mail.gmail.com>
Subject: Re: [PATCH v3] ceph: force sending a cap update msg back to MDS for
 revoke op
To: xiubli@redhat.com
Cc: ceph-devel@vger.kernel.org, idryomov@gmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

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

v3 pathset looks good.

Reviewed-by: Venky Shankar <vshankar@redhat.com>
Tested-by: Venky Shankar <vshankar@redhat.com>

--=20
Cheers,
Venky


