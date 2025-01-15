Return-Path: <ceph-devel+bounces-2452-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DDD10A12BFB
	for <lists+ceph-devel@lfdr.de>; Wed, 15 Jan 2025 20:49:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F04473A730C
	for <lists+ceph-devel@lfdr.de>; Wed, 15 Jan 2025 19:49:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CC961CF28B;
	Wed, 15 Jan 2025 19:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XJ4sbeKR"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B5A024A7C1
	for <ceph-devel@vger.kernel.org>; Wed, 15 Jan 2025 19:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736970564; cv=none; b=aEl+wB9dQQ+J9w2r6mcDAezrNPOrTkpP6EKgnq2KvgDB6dVVfPty+ue4a01AAsSldXeTPbZYpHLijFUIL8totKf4euvclrrgfn7FNc6k3sHMgatzYgYstWY9zhn7uQjRBha58wHnEIN5Ej+c083xplicDSOihw+wpWZuYmSEs9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736970564; c=relaxed/simple;
	bh=B3JvyVRMnJ/qq9lWmhc50Y/kbugUYo5xCbUe1qXD0ZA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YC4CNKmc8dqVh5REeKdrkj2F2OgkO4S5YwsD/g6hV8MeKRypJnHpUbIUkDoWScVwYenZA+U9sv4qbWRRdRpTVEcmAx6HRVx/ebpNYGkrz1sCOnv3V7mDW4dsv0h3l2/JWV0T6NAA0DqHkHWdEF3hQOQr8MSuzvcLVsD5zQalKXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XJ4sbeKR; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2ef748105deso276914a91.1
        for <ceph-devel@vger.kernel.org>; Wed, 15 Jan 2025 11:49:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736970562; x=1737575362; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zTwDgbYJiswpfxgE/jqu30N+uJVi06vvCIeCFnMPF24=;
        b=XJ4sbeKRHofUF/wAYhqWbQqyxu0phZzqgGzHveRI8XBncu7ayT+xVOE3JX/A/Op6wt
         0pqfS1bbTgN/D/YM3derjveQU07BApCU77C3fhpxJEWkjJACxdV10WszdtGbQhyK4uz1
         RKxEs2kUJuKk0w/7191DYnhW6HoY3b4Va6ZkeLYAAJH/mFw6SB5MlK1YGtJ/bT6J2ClZ
         xm3j1mnwqXeIdbNZAQnHUirsQq08jcdcKA5Ymt0NEVHux7yWY7so7PgfCIKpfIUxrebM
         TtbbOLTSab6VkUchQxq6B05KrGZZ9HpeqIss6kt4wNppuaMRtz6oMP4FBq+v0RXi0Ifx
         mVpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736970562; x=1737575362;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zTwDgbYJiswpfxgE/jqu30N+uJVi06vvCIeCFnMPF24=;
        b=U5Z9qp2StibVnZsG+kiK38XUR5owA/3cTyVailyHnCtAAuAuyOS5zJG4O7ddAOrUIe
         TtOqnc9P6SeWC0uLsHqe9nNi4BWPDanoJ2j3kzwgTy09OuT3gkFkgobE8M4Pw2ox2PFO
         NnNHotMUgi9IbuTN9bAHmqy9nT2UlJcRyYzdRlfpxs+89e2aAgsNh/9R5NT3k1oUxR2H
         hrWxp65JiJWophiV6M/EUt3bSnUgamKmizYSteguMQe4M2+xsfSg+nCNyvALE/hX7a26
         eVnRmQd0ljiCIvZ8FIWJ9S7wCqPA8O+X5zkABnbabYQbLixgZqEmLI2qU3DCN7KrtwHX
         ckfw==
X-Gm-Message-State: AOJu0YxRuMjGO7b3OzrZVKPJA28is/YqDcjxU0pAn8UydPdwAWKNaJJl
	XRGT/aAzgKZC2AGeYC2V01pbCtfyZKsA1Hb5W8mRaYNVvruPaRI971s4crgb+tcHWvnqOo8Cts0
	hgrH96BwXkP2u1Zp/R7OGCCwGTY4=
X-Gm-Gg: ASbGncvPLJ0K2A+eR60CjfgtbY0zZkoZ58sTbqeOgpF0MFWL3jlS3/MzrabzUFkmFN6
	/2PVEzbhGiYstdx7UM0EDpClGDxLa/hmbHug0vQ==
X-Google-Smtp-Source: AGHT+IHqZDIhybpEUgZZNlC49fkxYE4c3yQs6o6J01bbOhQYcC/UiAgr+YpRMenu4VEb+3mxN26s0MtWbMr7QSCLGiM=
X-Received: by 2002:a17:90b:51c4:b0:2ee:e18b:c1fa with SMTP id
 98e67ed59e1d1-2f548f1d732mr42172598a91.28.1736970562304; Wed, 15 Jan 2025
 11:49:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250114123806.2339159-1-antoine@lesviallon.fr>
 <20250114224514.2399813-1-antoine@lesviallon.fr> <9cd7c8f4c194fcb8c63c818f2155a9b4f55ce682.camel@ibm.com>
In-Reply-To: <9cd7c8f4c194fcb8c63c818f2155a9b4f55ce682.camel@ibm.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Wed, 15 Jan 2025 20:49:10 +0100
X-Gm-Features: AbW1kvboRB2jUCh0e8S8FwK8czgWsRZI6t_msW57sCBY6Sl8eGCnyCE7OPHjqXY
Message-ID: <CAOi1vP-zzoBrJF=rSLVRLdE_=pk8A5UWmQwQV0VhvdnzsPijkg@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: fix memory leak in ceph_mds_auth_match()
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, 
	"antoine@lesviallon.fr" <antoine@lesviallon.fr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 15, 2025 at 6:49=E2=80=AFPM Viacheslav Dubeyko
<Slava.Dubeyko@ibm.com> wrote:
>
> On Tue, 2025-01-14 at 23:45 +0100, Antoine Viallon wrote:
> > We now free the temporary target path substring allocation on every
> > possible branch, instead of omitting the default branch.
> > In some cases, a memory leak occured, which could rapidly crash the
> > system (depending on how many file accesses were attempted).
> >
> > This was detected in production because it caused a continuous memory
> > growth,
> > eventually triggering kernel OOM and completely hard-locking the
> > kernel.
> >
> > Relevant kmemleak stacktrace:
> >
> >     unreferenced object 0xffff888131e69900 (size 128):
> >       comm "git", pid 66104, jiffies 4295435999
> >       hex dump (first 32 bytes):
> >         76 6f 6c 75 6d 65 73 2f 63 6f 6e 74 61 69 6e 65
> > volumes/containe
> >         72 73 2f 67 69 74 65 61 2f 67 69 74 65 61 2f 67
> > rs/gitea/gitea/g
> >       backtrace (crc 2f3bb450):
> >         [<ffffffffaa68fb49>] __kmalloc_noprof+0x359/0x510
> >         [<ffffffffc32bf1df>] ceph_mds_check_access+0x5bf/0x14e0
> > [ceph]
> >         [<ffffffffc3235722>] ceph_open+0x312/0xd80 [ceph]
> >         [<ffffffffaa7dd786>] do_dentry_open+0x456/0x1120
> >         [<ffffffffaa7e3729>] vfs_open+0x79/0x360
> >         [<ffffffffaa832875>] path_openat+0x1de5/0x4390
> >         [<ffffffffaa834fcc>] do_filp_open+0x19c/0x3c0
> >         [<ffffffffaa7e44a1>] do_sys_openat2+0x141/0x180
> >         [<ffffffffaa7e4945>] __x64_sys_open+0xe5/0x1a0
> >         [<ffffffffac2cc2f7>] do_syscall_64+0xb7/0x210
> >         [<ffffffffac400130>] entry_SYSCALL_64_after_hwframe+0x77/0x7f
> >
> > It can be triggered by mouting a subdirectory of a CephFS filesystem,
> > and then trying to access files on this subdirectory with an auth
> > token using a path-scoped capability:
> >
> >     $ ceph auth get client.services
> >     [client.services]
> >             key =3D REDACTED
> >             caps mds =3D "allow rw fsname=3Dcephfs path=3D/volumes/"
> >             caps mon =3D "allow r fsname=3Dcephfs"
> >             caps osd =3D "allow rw tag cephfs data=3Dcephfs"
> >
> >     $ cat /proc/self/mounts
> >
> > services@00000000-0000-0000-0000-000000000000.cephfs=3D/volumes/contain
> > ers /ceph/containers ceph
> > rw,noatime,name=3Dservices,secret=3D<hidden>,ms_mode=3Dprefer-
> > crc,mount_timeout=3D300,acl,mon_addr=3D[REDACTED]:3300,recover_session=
=3Dcl
> > ean 0 0
> >
> >     $ seq 1 1000000 | xargs -P32 --replace=3D{} touch
> > /ceph/containers/file-{} && \
> >     seq 1 1000000 | xargs -P32 --replace=3D{} cat
> > /ceph/containers/file-{}
> >
> > Signed-off-by: Antoine Viallon <antoine@lesviallon.fr>
> > ---
> >  fs/ceph/mds_client.c | 15 +++++++++------
> >  1 file changed, 9 insertions(+), 6 deletions(-)
> >
> > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > index 785fe489ef4b..c3b63243c2dd 100644
> > --- a/fs/ceph/mds_client.c
> > +++ b/fs/ceph/mds_client.c
> > @@ -5690,18 +5690,21 @@ static int ceph_mds_auth_match(struct
> > ceph_mds_client *mdsc,
> >                        *
> >                        * All the other cases
> > --> mismatch
> >                        */
> > +                     int rc =3D 1;
> >                       char *first =3D strstr(_tpath, auth-
> > >match.path);
> >                       if (first !=3D _tpath) {
> > -                             if (free_tpath)
> > -                                     kfree(_tpath);
> > -                             return 0;
> > +                             rc =3D 0;
> >                       }
> >
> >                       if (tlen > len && _tpath[len] !=3D '/') {
> > -                             if (free_tpath)
> > -                                     kfree(_tpath);
> > -                             return 0;
> > +                             rc =3D 0;
> >                       }
> > +
> > +                     if (free_tpath)
> > +                       kfree(_tpath);
> > +
> > +                     if (!rc)
> > +                       return 0;
> >               }
> >       }
> >
>
> Looks good.
>
> Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>

Hi Antoine, Slava,

I have a slight nit that

    if (first !=3D _tpath) {
            rc =3D 0;
    }

    if (tlen > len && _tpath[len] !=3D '/') {
            rc =3D 0;
    }

isn't the exact equivalent of the previous

    if (first !=3D _tpath) {
            ...
            return 0;
    }

    if (tlen > len && _tpath[len] !=3D '/') {
            ...
            return 0;
    }

logic.  I think

    if (first !=3D _tpath ||
        (tlen > len && _tpath[len] !=3D '/')) {
            rc =3D 0;
    }

would be better and a tiny bit more efficient.  Also, renaming rc to
path_matched and making it a bool for consistency with gid_matched in
the first half of the function seems worth it.

I went ahead and applied the patch with these changes plus indentation
fixups:

https://github.com/ceph/ceph-client/commit/3b7d93db450e9d8ead80d75e2a303248=
f1528c35

Please let me know if there are any objections.

Thanks,

                Ilya

