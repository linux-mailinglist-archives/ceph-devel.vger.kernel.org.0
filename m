Return-Path: <ceph-devel+bounces-2560-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E635A1C452
	for <lists+ceph-devel@lfdr.de>; Sat, 25 Jan 2025 17:26:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3C8241884005
	for <lists+ceph-devel@lfdr.de>; Sat, 25 Jan 2025 16:26:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CCDC6F073;
	Sat, 25 Jan 2025 16:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=omnibond-com.20230601.gappssmtp.com header.i=@omnibond-com.20230601.gappssmtp.com header.b="pKAYO0g+"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7A26088F
	for <ceph-devel@vger.kernel.org>; Sat, 25 Jan 2025 16:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737822358; cv=none; b=f4POHdOZ6JuozPiFgBJdVfxrcK+EXDADm7cmKOxz70MGmB+8JxErtZUBBi9KgelRA4MiVVsCzHR1hiIM5ONhEgsGGeAeL4qt/S5c/pytJkj02AgPVzv0UvvdTplcCnwR/Is8wfxkTdpysfvQP1wRutYp070O10zSjfuOpGpIKYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737822358; c=relaxed/simple;
	bh=Gd+UwXIueKOW4BRRtN9KBJUlKbMmHPEr3qiXTPPY06k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OQg8UazCXTkNWhiph4kuQ5ah7iRX2W3E/LXRFakbWSD+Swoa9C0PrSP3piRCfA93EbSqY4XPlsm9A7yJdMtvAVwnbxeFqt1ZXmDFb2SsMfSVf2X6An9ufjzzvpzFeJKWkB/v1QNoH3h2RZ6JsUrsmdEJMtOikRgJTfwCR9aafwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=omnibond.com; spf=pass smtp.mailfrom=omnibond.com; dkim=pass (2048-bit key) header.d=omnibond-com.20230601.gappssmtp.com header.i=@omnibond-com.20230601.gappssmtp.com header.b=pKAYO0g+; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=omnibond.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=omnibond.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2f78a4ca5deso4238424a91.0
        for <ceph-devel@vger.kernel.org>; Sat, 25 Jan 2025 08:25:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=omnibond-com.20230601.gappssmtp.com; s=20230601; t=1737822354; x=1738427154; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9w0yclXKq1+ZE4rb7z474GY4D3cL/agwNUJRHPKnvMI=;
        b=pKAYO0g+kfpZG1lfC7pr6Pqs6v5dATBcy2vkvvUb2Oh2c7cXiHl+U/8kh0APu7psZD
         yzMvzVg6H3b2X4Uhm8DGXvtKr/I8G8g2zowYM3U4uvSxJp8u1Rcrl4renn+G2mx6hMQG
         DHeG7GLOW2+C8QtSitv+eUBxkViVutvzeMqTk1xad5vg6/Ylx+tNI6WJwUAVWjsclHlU
         GAOheuKAmZghIOEz5e3ZJGNmy5AbwNBFTphB2xedn/OEkO5pZfb46dme1Wg/POraXmoX
         VNC+oafuPoMYsOsYbX5McUrmsFIcvIspqUoB3NJpQVBk42lxd7ub0HPuMPPlVMPYsZ9R
         IwNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737822354; x=1738427154;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9w0yclXKq1+ZE4rb7z474GY4D3cL/agwNUJRHPKnvMI=;
        b=Wq9iwhvrLRZSTTHm0M1ETuE0zGQUh2JzwdAXG5D61dy2uvINWCNn9HbKdSJRgoJ3mQ
         gjh19tf1lAtBZyQpAv/L9BK47H8dnCdauqIOpt1tGslJobFtlIUHaGBooFu/MN7Ubhxu
         Hnz1SIpyzAGeoqi+MfRnvvMbdMYyAqOeC18EO2gUbMiMRr5Bfe78isEDsUBShyzFmQCM
         LJ2NkNN6OHe1X01p+IsJUrgujoO1ZemxMEoZ1dnSIwXR1LEkoPG0KnWoUiA6Y1dsxz+N
         4LnVK6gX9izSDw6ZU9pAjrlt1yNfGziu3BkQ/B7yV4gSdW/iirr0HhKGT8BPsfv3/o2e
         zZiw==
X-Forwarded-Encrypted: i=1; AJvYcCU94QMjRrXnf4WcrHXqHPxEExp2CkdhXciN+MMeJaJsdy25EjBmiTEEZFOHsvbcFuyQc0cBJt6IJcLc@vger.kernel.org
X-Gm-Message-State: AOJu0Ywnl9u8F/OwddE3TcBAHRHc6SDTDY6SgLwtkQth0QmD6XWqvdFA
	rJ09CUF3aHVWtm/JFubKSQFrDC/MbA1YW5wRAUE33i9iGMjLKSNUHZ7tT1l2kAG7+bz50PWpeNX
	Cy5npANDkvJ1jh5LriWE0Snh9tAgUqReGKbd8
X-Gm-Gg: ASbGncuXeaGFzHFcjo0XoYRhU6kwo/+wyjL/wIiKkLbQLycwxGtyn51Y1rjMEbJG+e2
	afRG1JXAfaRnjfh/qyv1pyEMKIIVWz71FB5aquBfQI6XbTCnccDSjCmq7oWIlwHnjqNBC2g14Fg
	==
X-Google-Smtp-Source: AGHT+IHYinXSusgjbEegl0Q3oc5v3YMpnH3cgpRw66F16T4kF6MOtD01PGslFZsO9Lw2vhkg3s0T7IjjSmkdcoVRwVM=
X-Received: by 2002:a17:90a:c2d0:b0:2ee:cb5c:6c with SMTP id
 98e67ed59e1d1-2f782d383a1mr41395453a91.22.1737822354379; Sat, 25 Jan 2025
 08:25:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250123014511.GA1962481@ZenIV> <20250123014643.1964371-1-viro@zeniv.linux.org.uk>
 <20250123014643.1964371-19-viro@zeniv.linux.org.uk>
In-Reply-To: <20250123014643.1964371-19-viro@zeniv.linux.org.uk>
From: Mike Marshall <hubcap@omnibond.com>
Date: Sat, 25 Jan 2025 11:25:43 -0500
X-Gm-Features: AWEUYZmtTzGFDbO9QisKFQJH3QVSme3cG4eX9OmyvnAovbPjPT_7TPMe3OgZJqA
Message-ID: <CAOg9mSQrak+49+g6JB5YEiWZOrcWr7PJyeGmi5ZdRWEwYPbcwg@mail.gmail.com>
Subject: Re: [PATCH v3 19/20] orangefs_d_revalidate(): use stable parent inode
 and name passed by caller
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, agruenba@redhat.com, amir73il@gmail.com, 
	brauner@kernel.org, ceph-devel@vger.kernel.org, dhowells@redhat.com, 
	jack@suse.cz, krisman@kernel.org, linux-nfs@vger.kernel.org, 
	miklos@szeredi.hu, torvalds@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Tested-by: Mike Marshall <hubcap@omnibond.com>

On Wed, Jan 22, 2025 at 8:46=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk> w=
rote:
>
> ->d_name use is a UAF if the userland side of things can be slowed down
> by attacker.
>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  fs/orangefs/dcache.c | 19 ++++++++-----------
>  1 file changed, 8 insertions(+), 11 deletions(-)
>
> diff --git a/fs/orangefs/dcache.c b/fs/orangefs/dcache.c
> index c32c9a86e8d0..a19d1ad705db 100644
> --- a/fs/orangefs/dcache.c
> +++ b/fs/orangefs/dcache.c
> @@ -13,10 +13,9 @@
>  #include "orangefs-kernel.h"
>
>  /* Returns 1 if dentry can still be trusted, else 0. */
> -static int orangefs_revalidate_lookup(struct dentry *dentry)
> +static int orangefs_revalidate_lookup(struct inode *parent_inode, const =
struct qstr *name,
> +                                     struct dentry *dentry)
>  {
> -       struct dentry *parent_dentry =3D dget_parent(dentry);
> -       struct inode *parent_inode =3D parent_dentry->d_inode;
>         struct orangefs_inode_s *parent =3D ORANGEFS_I(parent_inode);
>         struct inode *inode =3D dentry->d_inode;
>         struct orangefs_kernel_op_s *new_op;
> @@ -26,14 +25,14 @@ static int orangefs_revalidate_lookup(struct dentry *=
dentry)
>         gossip_debug(GOSSIP_DCACHE_DEBUG, "%s: attempting lookup.\n", __f=
unc__);
>
>         new_op =3D op_alloc(ORANGEFS_VFS_OP_LOOKUP);
> -       if (!new_op) {
> -               ret =3D -ENOMEM;
> -               goto out_put_parent;
> -       }
> +       if (!new_op)
> +               return -ENOMEM;
>
>         new_op->upcall.req.lookup.sym_follow =3D ORANGEFS_LOOKUP_LINK_NO_=
FOLLOW;
>         new_op->upcall.req.lookup.parent_refn =3D parent->refn;
> -       strscpy(new_op->upcall.req.lookup.d_name, dentry->d_name.name);
> +       /* op_alloc() leaves ->upcall zeroed */
> +       memcpy(new_op->upcall.req.lookup.d_name, name->name,
> +                       min(name->len, ORANGEFS_NAME_MAX - 1));
>
>         gossip_debug(GOSSIP_DCACHE_DEBUG,
>                      "%s:%s:%d interrupt flag [%d]\n",
> @@ -78,8 +77,6 @@ static int orangefs_revalidate_lookup(struct dentry *de=
ntry)
>         ret =3D 1;
>  out_release_op:
>         op_release(new_op);
> -out_put_parent:
> -       dput(parent_dentry);
>         return ret;
>  out_drop:
>         gossip_debug(GOSSIP_DCACHE_DEBUG, "%s:%s:%d revalidate failed\n",
> @@ -115,7 +112,7 @@ static int orangefs_d_revalidate(struct inode *dir, c=
onst struct qstr *name,
>          * If this passes, the positive dentry still exists or the negati=
ve
>          * dentry still does not exist.
>          */
> -       if (!orangefs_revalidate_lookup(dentry))
> +       if (!orangefs_revalidate_lookup(dir, name, dentry))
>                 return 0;
>
>         /* We do not need to continue with negative dentries. */
> --
> 2.39.5
>

