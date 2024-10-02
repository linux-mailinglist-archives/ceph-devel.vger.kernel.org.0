Return-Path: <ceph-devel+bounces-1872-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 718C798E594
	for <lists+ceph-devel@lfdr.de>; Wed,  2 Oct 2024 23:53:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E33851F2206C
	for <lists+ceph-devel@lfdr.de>; Wed,  2 Oct 2024 21:53:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B623A199386;
	Wed,  2 Oct 2024 21:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wwvz+5C9"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5FC119412A;
	Wed,  2 Oct 2024 21:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727905938; cv=none; b=ZTzO8/MvAGXuz3eTA5SUs0oMp8VI/1urPwRKu0M2Zgwkd0Dmr2ppMviEyJU4dOVuxOGcyw2c4R4z0FhL6xk5VbDM5D5gwLiw7BlqDJmBW2gmUaXwL5qWkLqaUyuLH94lCHG/Vy9KSwX6J1qwUfwMzMt2cbCdI0CvkHFRcc/FnnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727905938; c=relaxed/simple;
	bh=dz8doS85JXKLKBaXk37DuCfj4dlruqU8Rfvq/fE5MhI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G8WC7ciCe3hKyZ6ly2QgCokprhOTcASMLZoCcZ28tmrWxcOpYIHLSUehIAz6SIO9ctLxA+reZo821jaGbbfMLmp0gxV+MgcR1Z6YEaOI7F2NtJCqEybNECULYj6X5OiP9FceQk3dcsXTmIfs/jHAFyafm20lHAJPOtziJ+PeBQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wwvz+5C9; arc=none smtp.client-ip=209.85.167.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-3e0438e81aaso222951b6e.3;
        Wed, 02 Oct 2024 14:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727905936; x=1728510736; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uU/MdWpSsfY9txOsca4vvM4K0KOZtCPC7D1wIi4Vl3Y=;
        b=Wwvz+5C95LKVMDGn5o9mEV4py0H9VD/fYLlDSHkxQ5i39hl6lFFUawBzYzqXBeILzp
         o9u5nuUTtfjXkpHPzLoVOD5BtuyHmvIxhHjELQluj0yHbR2hFsG2mX24cz9HFhfslOiT
         tLzCYTsIMbLclX4I2PquRsGmkTgOsbUWVRl0WQ8+2wDBibOoa0uB51+RLSg/uX6Ol42u
         O4CgvpUgLcgBa9p5kT8QXa9r0DNajwOr5nPXB8OsF9AlTLpP6hgVBJFhtS9qOr28BFon
         tUKhdHCJD/0lk6TmO5h9cRaodosgYaa5jRywYawP7O3xcNBc7Y7JPz1Kaf9lETI7dYPJ
         ij7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727905936; x=1728510736;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uU/MdWpSsfY9txOsca4vvM4K0KOZtCPC7D1wIi4Vl3Y=;
        b=YWXtbwdgoKVqANbD3dK6ovOkf8/vIqPbns49xaOyrFwYrJ1FprvlLnuvGmWm/xGM34
         ZphWv8ztAE2zsA/8J4AaTIKLROXslHpbIHbaZrHYcHGHLlL9z0Rp7jOzzGLUqRagyt4R
         i5dv78luapq6dGq0bb0drmW8tNonH+mCj4u37UPH/yc/+T/YYl+fyqwFq0q8Tk96IGfK
         IUzMLx1FN8ztvo1bgy+JFH53Eo0v7All5QTMvCM/l3xosMkukj5JKMOJtJLHfGhTfwF+
         OvSc59Zt2Xce3KXE+ats5u1C+WJe35CSdIT+Ph2+hOuhJcThdOeWqxlXRIuGDwo/2CSf
         Pedg==
X-Forwarded-Encrypted: i=1; AJvYcCUi+sLjnxfAi2DTDHZPs1U05g/SoxHrbMnXwyOLtsFaxFf+1ugqcHRMETx2ssNTzVmfLmFfubNcuimf@vger.kernel.org, AJvYcCVqqHe4EdLHZ9PpCHfwwNahB6tgFC09qordwivZwgriEti+pAH0GgOrM50zRnjtV1Pc2GOLAFjo@vger.kernel.org, AJvYcCWUk8p2xNuB4y/fAyKduwR/D/k1yfQlmP2I3rZ1FgBafZQNvrCDd+6tiEVpnJ5vM9i1OMcQ66QGBTFOw6GV@vger.kernel.org
X-Gm-Message-State: AOJu0YzbZLUiAdkOqweed4zp59u8SGMUdtpHQibak9st296uA2freVWC
	mQ5r5PxX8nMxZ2N9fE1UontCfU/es0W0KdVlW0hUXwWsai02mNDUM6RLun1gawOqUdE3ZLvMXtu
	ICxVxtYq/vDFCYIX+hK1jQw82wa0xMV+9
X-Google-Smtp-Source: AGHT+IEcehJAO0OI+eU3ENs1384djIrYf5xm/4Fovksttd2IqeGQTrEgu6YlTdxAWST8ny475DsiqHdRmzXhkO8OnNU=
X-Received: by 2002:a05:6808:22ac:b0:3e3:98fd:dc42 with SMTP id
 5614622812f47-3e3b40eaccemr4770438b6e.7.1727905936024; Wed, 02 Oct 2024
 14:52:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241002200805.34376-1-batrick@batbytes.com>
In-Reply-To: <20241002200805.34376-1-batrick@batbytes.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Wed, 2 Oct 2024 23:52:04 +0200
Message-ID: <CAOi1vP_Y0BDxNR9_y_1aMtqKovf5zz8h65b1U+vserFgoc4heA@mail.gmail.com>
Subject: Re: [PATCH] ceph: fix cap ref leak via netfs init_request
To: Patrick Donnelly <batrick@batbytes.com>
Cc: Xiubo Li <xiubli@redhat.com>, David Howells <dhowells@redhat.com>, 
	Patrick Donnelly <pdonnell@redhat.com>, stable@vger.kernel.org, ceph-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 2, 2024 at 10:08=E2=80=AFPM Patrick Donnelly <batrick@batbytes.=
com> wrote:
>
> From: Patrick Donnelly <pdonnell@redhat.com>
>
> Log recovered from a user's cluster:
>
>     <7>[ 5413.970692] ceph:  get_cap_refs 00000000958c114b ret 1 got Fr
>     <7>[ 5413.970695] ceph:  start_read 00000000958c114b, no cache cap

Hi Patrick,

Noting that start_read() was removed in kernel 5.13 in commit
49870056005c ("ceph: convert ceph_readpages to ceph_readahead").

>     ...
>     <7>[ 5473.934609] ceph:   my wanted =3D Fr, used =3D Fr, dirty -
>     <7>[ 5473.934616] ceph:  revocation: pAsLsXsFr -> pAsLsXs (revoking F=
r)
>     <7>[ 5473.934632] ceph:  __ceph_caps_issued 00000000958c114b cap 0000=
0000f7784259 issued pAsLsXs
>     <7>[ 5473.934638] ceph:  check_caps 10000000e68.fffffffffffffffe file=
_want - used Fr dirty - flushing - issued pAsLsXs revoking Fr retain pAsLsX=
sFsr  AUTHONLY NOINVAL FLUSH_FORCE
>
> The MDS subsequently complains that the kernel client is late releasing c=
aps.
>
> Closes: https://tracker.ceph.com/issues/67008
> Fixes: a5c9dc4451394b2854493944dcc0ff71af9705a3 ("ceph: Make ceph_init_re=
quest() check caps on readahead")

I think it's worth going into a bit more detail here because
superficially this commit just replaced

    ret =3D ceph_try_get_caps(inode, CEPH_CAP_FILE_RD, want, true, &got);
    if (ret < 0)
            dout("start_read %p, error getting cap\n", inode);
    else if (!(got & want))
            dout("start_read %p, no cache cap\n", inode);

    if (ret <=3D 0)
            return;

in ceph_readahead() with

    ret =3D ceph_try_get_caps(inode, CEPH_CAP_FILE_RD, want, true, &got);
    if (ret < 0) {
            dout("start_read %p, error getting cap\n", inode);
            return ret;
    }

    if (!(got & want)) {
            dout("start_read %p, no cache cap\n", inode);
            return -EACCES;
    }
    if (ret =3D=3D 0)
            return -EACCES;

in ceph_init_request().  Neither called ceph_put_cap_refs() before
bailing.  It was commit 49870056005c ("ceph: convert ceph_readpages to
ceph_readahead") that turned a direct call to ceph_put_cap_refs() in
start_read() to one in ceph_readahead_cleanup() (later renamed to
ceph_netfs_free_request()).

The actual problem is that netfs_alloc_request() just frees rreq if
init_request() callout fails and ceph_netfs_free_request() is never
called, right?  If so, I'd mention that explicitly and possibly also
reference commit 2de160417315 ("netfs: Change ->init_request() to
return an error code") which introduced that.

> Signed-off-by: Patrick Donnelly <pdonnell@redhat.com>
> Cc: stable@vger.kernel.org
> ---
>  fs/ceph/addr.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 53fef258c2bc..702c6a730b70 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -489,8 +489,11 @@ static int ceph_init_request(struct netfs_io_request=
 *rreq, struct file *file)
>         rreq->io_streams[0].sreq_max_len =3D fsc->mount_options->rsize;
>
>  out:
> -       if (ret < 0)
> +       if (ret < 0) {
> +               if (got)
> +                       ceph_put_cap_refs(ceph_inode(inode), got);
>                 kfree(priv);
> +       }
>
>         return ret;
>  }

The change itself looks fine.  Great catch!

Thanks,

                Ilya

