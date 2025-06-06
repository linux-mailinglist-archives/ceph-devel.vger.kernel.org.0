Return-Path: <ceph-devel+bounces-3070-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F419AD0733
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Jun 2025 19:08:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A91D03AB4E2
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Jun 2025 17:08:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50C50289E01;
	Fri,  6 Jun 2025 17:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="etBM2jMy"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8095A1DCB09;
	Fri,  6 Jun 2025 17:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749229722; cv=none; b=MM3NIekyR5l39Dpayq7oe2+JYoy2tHP0dLxT7+dL5NxberlDC29ZMiuxax5xu7qB72t1lIIoqv5QkWTV9oFdskI0x6y8NSny3NnrfgYAtMgvSS72YKqs/jucjb4hf38s/4+zy+bcNi3Ujg45jBfJ5fSGNXj43ouJ5ELTfhovKSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749229722; c=relaxed/simple;
	bh=ueD8CCgOMFo5JWaeUfEECytWBg54koJy3TkvGoh6G1Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=scoLxEypMzH4pvZiyNSj8ZdPwmPI2xmGbfCo35CFfnb0N/zUU+FTH24CMrV5gJnd00yxa0wsnxdLTYZbqxu6Tcd+BbMYlsGuzA6Ov1VCWtdKtHKr43PZVur+YEDPuQEh+81aVBvJZ7PXQQ0N7gCYW9lSKsVDsv0iCuXoIhpV12k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=etBM2jMy; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-b2c3c689d20so1565753a12.3;
        Fri, 06 Jun 2025 10:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749229720; x=1749834520; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vZkwqJSmD3B+lCUpAtGv3UtMF/CrL8e2Z1drHCzLEEQ=;
        b=etBM2jMyHniTEyd2A41IScByWAXQi3i5MK5RvA5EbvSW6fqraB5I8swvgmcof5EOS6
         uH6VktGIhUTsspm+bL8fdI9JOqD1YGkO+mjKqUNa71i+T4JZN8cKNCw8UVtMUcabvZ1x
         w6U7Z+VTJv3vAgW2YavW/J0ABwuAfXKtTpyw9d7YGNDEGrGgjqoYXIEYezPTAKjAqQHs
         xmkge0LT97oi/m9t3u41bnismnJ1ZDpTn7Id72xw9F7KeAxPqc6H+tqR0wxnJ8nAe8hW
         Sh1Fnnedtm4xKA5mDIJKRWcAxr2G+TsqOcvSx3bS4wPwdcuA+BIPnXCT2snzbYxrVnAr
         N5HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749229720; x=1749834520;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vZkwqJSmD3B+lCUpAtGv3UtMF/CrL8e2Z1drHCzLEEQ=;
        b=r+iGprB/+YQzPVWjWBAHdUJKdMj/YDxGt0ObicNecQ6x+JXGyzmNvhJfrpbIjfHXxt
         Guo9Xz62RcP40tA1TaeZ1/fc8+8wOflK8f56AcyaRZ2S2wUA291YR/BwVTnpWiGs5v9g
         EQcapvRAPg4IAxmn82J4VPfQJ0D7WZfjfsvtiC4rkDG6j0/dWikA4JlBY4hxmJYWgVBJ
         DvLYxCvlE3eDDDrQE4maDhh6r7KPw0A6KL8pAQzPd3Ba+xDCcXehE5rDW2Ad3ZhAlcB5
         iws4K7w7oQilSoRFQNgZMRkCgy5YynL42YtyuZwNli7dRVqFbXYLHVgi+Eh601V6EllX
         iFcg==
X-Forwarded-Encrypted: i=1; AJvYcCVvdfmTFFSnzOgk9AHy8Q1sydeaJ8D6oFrct/srSbkHPTj3gvTZd68HY1WgcZ8Vi6OQZn9kLsd3WdR/OC68@vger.kernel.org, AJvYcCW07X4HfWeC13Kk/1Y4DlN3xU6+et9cA5oxiwBOj+bfv8lAd4q6ZqP0nazRukogF609/HH5EaIVTf9u@vger.kernel.org
X-Gm-Message-State: AOJu0YzfbZPU+LHp1FhN8HOCo1VQhBdsytpvod1AELbwH/OILRfj/2Ki
	hFefoDBwVPfiH7QLTZxcvSvEvVsBTGIIMpPTB+XHQLjll1Y6hA0RJnyBM4bRcaeIjjD+9DN1Ye2
	Aa9TJK6SeVsJ8+MFP0vXs0ziAGzYpsyE=
X-Gm-Gg: ASbGncuM2yOQKB4wlE8B2SzuKlcLw1Ygudq1ghg7QDOUOqAP5y6unKe586VAsL9isxG
	T6qM8Bg0AC081AhUCqyMo+FrKkIrivDtravZg5kVIeM3Bl0mys4WcuIGPPkiMDSEpy+mpcQ3zAS
	1JTzV6LeSPKjfybadB1Rt17EJu6As8m0aq
X-Google-Smtp-Source: AGHT+IFg53ecrxWiw7i1cUHdjZP5OWxCICT75fkYqQnQiXxHcjbUiBQAuMdzydjhNAv53IINHAqXSMzMmjqZmID4uGs=
X-Received: by 2002:a17:90b:4f48:b0:312:1d2d:18e1 with SMTP id
 98e67ed59e1d1-3134768f7acmr5287313a91.22.1749229719807; Fri, 06 Jun 2025
 10:08:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241206165014.165614-1-max.kellermann@ionos.com> <CAKPOu+8eQfqJ9tVz-DzDzqKPEtQVCooxtxe1+OZanu5gi3oQzQ@mail.gmail.com>
In-Reply-To: <CAKPOu+8eQfqJ9tVz-DzDzqKPEtQVCooxtxe1+OZanu5gi3oQzQ@mail.gmail.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Fri, 6 Jun 2025 19:08:28 +0200
X-Gm-Features: AX0GCFt7No9VJfWA4dA8k4hp5BIt15Vf0Q3aNHSTYKLm13dUzT1PmJBfoUoWOaI
Message-ID: <CAOi1vP-dARssCkj-2FiKDJLRv9+Dq+_GE3pfQy4BseF_8sjUNQ@mail.gmail.com>
Subject: Re: [PATCH] fs/ceph/io: make ceph_start_io_*() killable
To: Max Kellermann <max.kellermann@ionos.com>
Cc: xiubli@redhat.com, amarkuze@redhat.com, ceph-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 19, 2025 at 12:15=E2=80=AFPM Max Kellermann
<max.kellermann@ionos.com> wrote:
>
> What happened to this patch submission? Similar patches were accepted
> in NFS and VFS core.

Hi Slava,

Can you take another look?  It doesn't make sense to deviate from NFS
or other filesystems in this area.

Thanks,

                Ilya

>
> On Fri, Dec 6, 2024 at 5:50=E2=80=AFPM Max Kellermann <max.kellermann@ion=
os.com> wrote:
> >
> > This allows killing processes that wait for a lock when one process is
> > stuck waiting for the Ceph server.  This is similar to the NFS commit
> > 38a125b31504 ("fs/nfs/io: make nfs_start_io_*() killable").
> >
> > Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> > ---
> >  fs/ceph/file.c | 22 +++++++++++++---------
> >  fs/ceph/io.c   | 44 +++++++++++++++++++++++++++++++++-----------
> >  fs/ceph/io.h   |  8 +++++---
> >  3 files changed, 51 insertions(+), 23 deletions(-)
> >
> > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > index 4b8d59ebda00..d79c0774dc6e 100644
> > --- a/fs/ceph/file.c
> > +++ b/fs/ceph/file.c
> > @@ -2127,10 +2127,11 @@ static ssize_t ceph_read_iter(struct kiocb *ioc=
b, struct iov_iter *to)
> >         if (ceph_inode_is_shutdown(inode))
> >                 return -ESTALE;
> >
> > -       if (direct_lock)
> > -               ceph_start_io_direct(inode);
> > -       else
> > -               ceph_start_io_read(inode);
> > +       ret =3D direct_lock
> > +               ? ceph_start_io_direct(inode)
> > +               : ceph_start_io_read(inode);
> > +       if (ret)
> > +               return ret;
> >
> >         if (!(fi->flags & CEPH_F_SYNC) && !direct_lock)
> >                 want |=3D CEPH_CAP_FILE_CACHE;
> > @@ -2283,7 +2284,9 @@ static ssize_t ceph_splice_read(struct file *in, =
loff_t *ppos,
> >             (fi->flags & CEPH_F_SYNC))
> >                 return copy_splice_read(in, ppos, pipe, len, flags);
> >
> > -       ceph_start_io_read(inode);
> > +       ret =3D ceph_start_io_read(inode);
> > +       if (ret)
> > +               return ret;
> >
> >         want =3D CEPH_CAP_FILE_CACHE;
> >         if (fi->fmode & CEPH_FILE_MODE_LAZY)
> > @@ -2362,10 +2365,11 @@ static ssize_t ceph_write_iter(struct kiocb *io=
cb, struct iov_iter *from)
> >                 direct_lock =3D true;
> >
> >  retry_snap:
> > -       if (direct_lock)
> > -               ceph_start_io_direct(inode);
> > -       else
> > -               ceph_start_io_write(inode);
> > +       err =3D direct_lock
> > +               ? ceph_start_io_direct(inode)
> > +               : ceph_start_io_write(inode);
> > +       if (err)
> > +               goto out_unlocked;
> >
> >         if (iocb->ki_flags & IOCB_APPEND) {
> >                 err =3D ceph_do_getattr(inode, CEPH_STAT_CAP_SIZE, fals=
e);
> > diff --git a/fs/ceph/io.c b/fs/ceph/io.c
> > index c456509b31c3..2735503bc479 100644
> > --- a/fs/ceph/io.c
> > +++ b/fs/ceph/io.c
> > @@ -47,20 +47,30 @@ static void ceph_block_o_direct(struct ceph_inode_i=
nfo *ci, struct inode *inode)
> >   * Note that buffered writes and truncates both take a write lock on
> >   * inode->i_rwsem, meaning that those are serialised w.r.t. the reads.
> >   */
> > -void
> > +int
> >  ceph_start_io_read(struct inode *inode)
> >  {
> >         struct ceph_inode_info *ci =3D ceph_inode(inode);
> > +       int err;
> >
> >         /* Be an optimist! */
> > -       down_read(&inode->i_rwsem);
> > +       err =3D down_read_killable(&inode->i_rwsem);
> > +       if (err)
> > +               return err;
> > +
> >         if (!(READ_ONCE(ci->i_ceph_flags) & CEPH_I_ODIRECT))
> > -               return;
> > +               return 0;
> >         up_read(&inode->i_rwsem);
> > +
> >         /* Slow path.... */
> > -       down_write(&inode->i_rwsem);
> > +       err =3D down_write_killable(&inode->i_rwsem);
> > +       if (err)
> > +               return err;
> > +
> >         ceph_block_o_direct(ci, inode);
> >         downgrade_write(&inode->i_rwsem);
> > +
> > +       return 0;
> >  }
> >
> >  /**
> > @@ -83,11 +93,13 @@ ceph_end_io_read(struct inode *inode)
> >   * Declare that a buffered write operation is about to start, and ensu=
re
> >   * that we block all direct I/O.
> >   */
> > -void
> > +int
> >  ceph_start_io_write(struct inode *inode)
> >  {
> > -       down_write(&inode->i_rwsem);
> > -       ceph_block_o_direct(ceph_inode(inode), inode);
> > +       int err =3D down_write_killable(&inode->i_rwsem);
> > +       if (!err)
> > +               ceph_block_o_direct(ceph_inode(inode), inode);
> > +       return err;
> >  }
> >
> >  /**
> > @@ -133,20 +145,30 @@ static void ceph_block_buffered(struct ceph_inode=
_info *ci, struct inode *inode)
> >   * Note that buffered writes and truncates both take a write lock on
> >   * inode->i_rwsem, meaning that those are serialised w.r.t. O_DIRECT.
> >   */
> > -void
> > +int
> >  ceph_start_io_direct(struct inode *inode)
> >  {
> >         struct ceph_inode_info *ci =3D ceph_inode(inode);
> > +       int err;
> >
> >         /* Be an optimist! */
> > -       down_read(&inode->i_rwsem);
> > +       err =3D down_read_killable(&inode->i_rwsem);
> > +       if (err)
> > +               return err;
> > +
> >         if (READ_ONCE(ci->i_ceph_flags) & CEPH_I_ODIRECT)
> > -               return;
> > +               return 0;
> >         up_read(&inode->i_rwsem);
> > +
> >         /* Slow path.... */
> > -       down_write(&inode->i_rwsem);
> > +       err =3D down_write_killable(&inode->i_rwsem);
> > +       if (err)
> > +               return err;
> > +
> >         ceph_block_buffered(ci, inode);
> >         downgrade_write(&inode->i_rwsem);
> > +
> > +       return 0;
> >  }
> >
> >  /**
> > diff --git a/fs/ceph/io.h b/fs/ceph/io.h
> > index fa594cd77348..08d58253f533 100644
> > --- a/fs/ceph/io.h
> > +++ b/fs/ceph/io.h
> > @@ -2,11 +2,13 @@
> >  #ifndef _FS_CEPH_IO_H
> >  #define _FS_CEPH_IO_H
> >
> > -void ceph_start_io_read(struct inode *inode);
> > +#include <linux/compiler_attributes.h> // for __must_check
> > +
> > +__must_check int ceph_start_io_read(struct inode *inode);
> >  void ceph_end_io_read(struct inode *inode);
> > -void ceph_start_io_write(struct inode *inode);
> > +__must_check int ceph_start_io_write(struct inode *inode);
> >  void ceph_end_io_write(struct inode *inode);
> > -void ceph_start_io_direct(struct inode *inode);
> > +__must_check int ceph_start_io_direct(struct inode *inode);
> >  void ceph_end_io_direct(struct inode *inode);
> >
> >  #endif /* FS_CEPH_IO_H */
> > --
> > 2.45.2
> >

