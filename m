Return-Path: <ceph-devel+bounces-3340-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CDC0B16CB1
	for <lists+ceph-devel@lfdr.de>; Thu, 31 Jul 2025 09:25:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1F7823AD0CE
	for <lists+ceph-devel@lfdr.de>; Thu, 31 Jul 2025 07:24:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F82F29C35C;
	Thu, 31 Jul 2025 07:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HBzK74qL"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3920B1F4CBF
	for <ceph-devel@vger.kernel.org>; Thu, 31 Jul 2025 07:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753946685; cv=none; b=M3ebBCMvb/4K2K3ERe+LPULZnrg4lV+0wgFlJ2tN2/dCU8J6dujPc7BzILEsvqBpnYW02DNVAA90DySduFVPkrhVvLGh4X/xkg8b28n3tzeAixTPnnG2itva5aIC9GAy5smXQbhOtBGpluxnn5Chci1RnPzO/fYpsyHRZ2Cfy34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753946685; c=relaxed/simple;
	bh=UWc7EMe+rjVWd0xnyGHGQsGnsgAL4BFn/kcNu30IEUg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fXEG+q5QlHl4yNjzZhjjRl49VS73M4dxl0lrMsFeq/iq+DrHxcfgMCoEPVvpEY2c4MEUyA/dTK8h/kK13qUzoxWK+hIuBYPK7dHunUmQ6h4HyEDHxcI2ZPJM2FFdUaZvjFeZCZ+Hp8Vdb5A9yt+ndMzT6VdeiBDJhbUGk+PmGnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HBzK74qL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753946682;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dCXF+ofc1ksuIi92Ur4/RviW6uHbykewCF5+ABWAhew=;
	b=HBzK74qLgT5AsiUZHdAKSwA4eYLPCt/lWkP4v67fgCd51SG9/rqnBQZKVVhQDGXgWBKBYI
	Su2EFAC2v1SUdsDNWmP8f7Phe7FnoaVgvlvPDFTj/g4uNzktqnomYbI63Bt5mFOSrWB1Fj
	s/j1Qsc/ZDtTOyMqtIt53QkH9Rjczmw=
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com
 [209.85.221.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-85-zisgVYaQPxivvMS1NxALlQ-1; Thu, 31 Jul 2025 03:24:40 -0400
X-MC-Unique: zisgVYaQPxivvMS1NxALlQ-1
X-Mimecast-MFC-AGG-ID: zisgVYaQPxivvMS1NxALlQ_1753946679
Received: by mail-vk1-f199.google.com with SMTP id 71dfb90a1353d-53157659c58so1631357e0c.1
        for <ceph-devel@vger.kernel.org>; Thu, 31 Jul 2025 00:24:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753946679; x=1754551479;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dCXF+ofc1ksuIi92Ur4/RviW6uHbykewCF5+ABWAhew=;
        b=QidjIysfzI/WG5hYw+go+CYa1b4Ev3KYCMOdqN7CX3qn0CL2ch9qyEZJrA/gr1oC3Z
         vrMzc7R/dUvl5yhud/SwveH7uywhWeot5WqH66DYSO353N3/K9XCqFwJ98aDs3U0un+g
         rJz8/aG4xFTFgcfF+h0tRj1yxtFfC54lRQG6oEFMKNGlBNIlj3Lal4HO5y/ypZbUBTgY
         ApOwBk9Ja3eoYndhML/vICI2h8hpAKhX8FVLrSR1imbHmih8r3F/rgs2SBPw5vb4N/nF
         F+s5Y4v5cz7lCOQ5oKjVJw1IUBCgW+3Kzrl4WViDSAI1cBt+lnE8dcfnpKjKBqcm/4oL
         13zw==
X-Gm-Message-State: AOJu0Ywp9oTAyrklS/1mwWx0YBBW+VtTDtxhWH+kKqpbJ5yDRnu9N/YH
	KBPVI8K18JBoFp22aX5jNrmWMW/hIiYqyZlVKvERItH03SdUyS7YDI3FMsehtxB7OEX0YFOJ0G5
	5aUIM3a9w0WmeNl84MAztuOyqaFRw5FSx6YOiaCWUccyPgTS2DNoGVQS/m9gHff8rHDiipTf31d
	0cZM8Ujr2Wj3OUcYCgvYoCQW2nuc74pTYdrCOwReGlKGZeZK+n+hqRs11V
X-Gm-Gg: ASbGnct1Pq9Dl1JkwX/IIV5HiNPOHrhsMfbOIy9/vrSjFW1G3Th440fEfAkYaxe1r9u
	hf9L2VTimGexua2+8aqa9KEYfxnMK9Hbkolv8e6Rr8E7te0oeZDkyoX6wE/VyTMg6GagSYIB1aW
	w97IawOuFaVjqjie0V/0xVz8DHuhfU+Qs+K1J0vg==
X-Received: by 2002:a05:6122:208f:b0:535:ed79:2aed with SMTP id 71dfb90a1353d-5393859a191mr415049e0c.2.1753946679339;
        Thu, 31 Jul 2025 00:24:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE3xO+JW44TTaxYyhohHvH8ki6jvVp+MCsZhdj1HhZi4ipLl9i4NDfjn/akYsn1R4lBXIi6wUuUHXbH/HdkWno=
X-Received: by 2002:a05:6122:208f:b0:535:ed79:2aed with SMTP id
 71dfb90a1353d-5393859a191mr415042e0c.2.1753946678956; Thu, 31 Jul 2025
 00:24:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250730151900.1591177-1-amarkuze@redhat.com> <20250730151900.1591177-3-amarkuze@redhat.com>
 <4b14172543092167ca910eaf886b5bda06c32bc4.camel@ibm.com>
In-Reply-To: <4b14172543092167ca910eaf886b5bda06c32bc4.camel@ibm.com>
From: Alex Markuze <amarkuze@redhat.com>
Date: Thu, 31 Jul 2025 11:24:28 +0400
X-Gm-Features: Ac12FXyiCN5i3Pjf5_Dl3Px8OZT7agpYePC_ofihURh5brMgLubBAvzuGA_nL7k
Message-ID: <CAO8a2Si-1grAicbkLKFK5BQXJAbpLJyD0p2wmvGU=jOO1Ztk+g@mail.gmail.com>
Subject: Re: [PATCH 2/2] ceph: fix client race condition where r_parent
 becomes stale before sending message
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This fix comes after an analysis of trace from a client bug:
RCA:
Usually two operations cant interleave due to extensive VFS locking.
But CEPH maintains leases for cached dentry structures, when these
leases expire the client may create a lookup request without taking
VFS locks, this is done by choice. But it does leave a window for this
type of a race that we have witnessed. The reply handler in one
specific place doesn't make sure that the appropriate locks are held
but still trusts the r_parent pointer that now holds an incorrect
value due to the rename operation. I prepared a fix that now compares
the cached r_parent and the ino from the reply. I'll ask @Andr=C3=A9 to
prepare a new image; this image should also resolve the boot issue for
the previous debug version.

It's the message handling code, so the request is always valid but not
every request will have a parent. R_PARENT_LOCKED may not be set by
design, it's a valid state.

On Thu, Jul 31, 2025 at 1:39=E2=80=AFAM Viacheslav Dubeyko
<Slava.Dubeyko@ibm.com> wrote:
>
> On Wed, 2025-07-30 at 15:19 +0000, Alex Markuze wrote:
> > When the parent directory's i_rwsem is not locked, req->r_parent may be=
come
> > stale due to concurrent operations (e.g. rename) between dentry lookup =
and
> > message creation. Validate that r_parent matches the encoded parent ino=
de
> > and update to the correct inode if a mismatch is detected.
>
> Could we share any description of crash or workload misbehavior that can
> illustrate the symptoms of the issue?
>
> > ---
> >  fs/ceph/inode.c | 44 ++++++++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 42 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> > index 814f9e9656a0..49fb1e3a02e8 100644
> > --- a/fs/ceph/inode.c
> > +++ b/fs/ceph/inode.c
> > @@ -56,6 +56,46 @@ static int ceph_set_ino_cb(struct inode *inode, void=
 *data)
> >       return 0;
> >  }
> >
> > +/*
> > + * Validate that the directory inode referenced by @req->r_parent matc=
hes the
> > + * inode number and snapshot id contained in the reply's directory rec=
ord.  If
> > + * they do not match =E2=80=93 which can theoretically happen if the p=
arent dentry was
> > + * moved between the time the request was issued and the reply arrived=
 =E2=80=93 fall
> > + * back to looking up the correct inode in the inode cache.
> > + *
> > + * A reference is *always* returned.  Callers that receive a different=
 inode
> > + * than the original @parent are responsible for dropping the extra re=
ference
> > + * once the reply has been processed.
> > + */
> > +static struct inode *ceph_get_reply_dir(struct super_block *sb,
> > +                                       struct inode *parent,
> > +                                       struct ceph_mds_reply_info_pars=
ed *rinfo)
> > +{
> > +    struct ceph_vino vino;
> > +
> > +    if (unlikely(!rinfo->diri.in))
> > +        return parent; /* nothing to compare against */
>
> If we could receive parent =3D=3D NULL, then is it possible to receive ri=
nfo =3D=3D
> NULL?
>
> > +
> > +    /* If we didn't have a cached parent inode to begin with, just bai=
l out. */
> > +    if (!parent)
> > +        return NULL;
>
> Is it normal workflow that parent =3D=3D NULL? Should we complain about i=
t here?
>
> > +
> > +    vino.ino  =3D le64_to_cpu(rinfo->diri.in->ino);
> > +    vino.snap =3D le64_to_cpu(rinfo->diri.in->snapid);
> > +
> > +    if (likely(parent && ceph_ino(parent) =3D=3D vino.ino && ceph_snap=
(parent) =3D=3D vino.snap))
>
> It looks like long line. Could we introduce a inline static function with=
 good
> name here?
>
> We already checked that parent is not NULL above. Does it makes sense to =
have
> this duplicated check here?
>
> > +        return parent; /* matches =E2=80=93 use the original reference=
 */
> > +
> > +    /* Mismatch =E2=80=93 this should be rare.  Emit a WARN and obtain=
 the correct inode. */
> > +    WARN(1, "ceph: reply dir mismatch (parent %s %llx.%llx reply %llx.=
%llx)\n",
> > +         parent ? "valid" : "NULL",
>
> How parent can be NULL here? We already checked this pointer. And this
> construction looks pretty complicated.
>
> > +         parent ? ceph_ino(parent) : 0ULL,
> > +         parent ? ceph_snap(parent) : 0ULL,
> > +         vino.ino, vino.snap);
> > +
> > +    return ceph_get_inode(sb, vino, NULL);
> > +}
> > +
> >  /**
> >   * ceph_new_inode - allocate a new inode in advance of an expected cre=
ate
> >   * @dir: parent directory for new inode
> > @@ -1548,8 +1588,8 @@ int ceph_fill_trace(struct super_block *sb, struc=
t ceph_mds_request *req)
> >       }
> >
> >       if (rinfo->head->is_dentry) {
> > -             struct inode *dir =3D req->r_parent;
> > -
> > +             /* r_parent may be stale, in cases when R_PARENT_LOCKED i=
s not set, so we need to get the correct inode */
>
> Comment is too long for one line. We could have multi-line comment here. =
If
> R_PARENT_LOCKED is not set, then, is it normal execution flow or not? Sho=
uld we
> fix the use-case of not setting R_PARENT_LOCKED?
>
> Thanks,
> Slava.
>
> > +             struct inode *dir =3D ceph_get_reply_dir(sb, req->r_paren=
t, rinfo);
> >               if (dir) {
> >                       err =3D ceph_fill_inode(dir, NULL, &rinfo->diri,
> >                                             rinfo->dirfrag, session, -1=
,


