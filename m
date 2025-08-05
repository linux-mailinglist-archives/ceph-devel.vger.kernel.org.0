Return-Path: <ceph-devel+bounces-3354-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A777BB1B363
	for <lists+ceph-devel@lfdr.de>; Tue,  5 Aug 2025 14:28:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5DD193A6D25
	for <lists+ceph-devel@lfdr.de>; Tue,  5 Aug 2025 12:28:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D51C127055D;
	Tue,  5 Aug 2025 12:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dzBa2daL"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1646B1A23A0
	for <ceph-devel@vger.kernel.org>; Tue,  5 Aug 2025 12:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754396926; cv=none; b=tZpSpaJYGsTGf+GhbfuONnmLybxMlh2QAabBFGheJBuf2ZSI0n8NPRi5rVV7RRMsgUqMCiGbNHmKYJ0gryZHA2tyKeedRnKh5cVUPyLAUPpUFdapqD1Zesjay3b2Jx3NEc+2hwnon6JmPuSq4/GseTlgCo8yXQNb3Pma2LBlUAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754396926; c=relaxed/simple;
	bh=asYVyDcUesUYhvQMINnDDiQBfsilf+wdaFi2gVIt9gI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fJHE+YvmU0Dt5x3avYVLwRWhsV2GOQxWdZwUl7kUIgf74a9uk/V7HR0leUGd9QEFvI+2IhirWZrxJax+SOppzPFJXn2z2jmejejx5jPOfNtaCoToVBDfTw6j4fuPonhzzrVHPbnR8CIx/z1y/7361X3fwWuFxVj1nwnfennsjrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dzBa2daL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754396923;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MdAzXHrmEgIxrEidw9LeN07oPIrixWYEdSsrPm4g0aA=;
	b=dzBa2daLhq3E9k8764boZ6/Njb0XsIg2/Ph4dOED7wojuLijN1ZA2pvMhsvxrp4rV7Wlu8
	Eiv6kcCrOdy/cv8CbqlKZLT6/SklcKRbedAUej5Q+ipJZjrOPBxenyWcYWFxshfG6x33/q
	NnPeOR61n3YfwFTayt/dxxKMTpZXpw0=
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com
 [209.85.217.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-509-ASlD0224Nme9ySlD2Gfy6A-1; Tue, 05 Aug 2025 08:28:42 -0400
X-MC-Unique: ASlD0224Nme9ySlD2Gfy6A-1
X-Mimecast-MFC-AGG-ID: ASlD0224Nme9ySlD2Gfy6A_1754396921
Received: by mail-vs1-f71.google.com with SMTP id ada2fe7eead31-4fe1f50e44cso1035810137.2
        for <ceph-devel@vger.kernel.org>; Tue, 05 Aug 2025 05:28:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754396921; x=1755001721;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MdAzXHrmEgIxrEidw9LeN07oPIrixWYEdSsrPm4g0aA=;
        b=fUtDC2Vjdbh8Cby4ilMuwYlX+IpC35CWLzZE3aQ1m9c7AYOQVR6/jdGFoD2CUpD8RI
         xKNw8zVDQwpbSxuLtfX7oduXxzozgeHxCs/enhLEBb6mSkXXjQEpVeNCt1OVP3stYqCK
         kcVKx7c/S9NhKu7vDEVMtWfRXZuA6TgNt/tqS1MYmoxwbkvAuumwI3gbAPwM/WT82NyG
         THZUAWFF09BNb7IVbtKywTalA7DzqbiV9TPCEBHEBSvg5dypql6YOBvIqksyCeuhxX37
         Y1JaVTCO0g/Ui3jm7rvUQbcwLpDQ0TBtqkNQINxtsm0AZU77DzDDv/D+FCId1eJMAMAd
         9C9A==
X-Gm-Message-State: AOJu0YzSxkglk0aLmS0Kc6BPZJ+owEr9Wt64ZjQycilkpul3LywrfMj/
	oUQ8Hhhc1u1ZSocaPCyyy7RBuL3B2qT5b+VlTxF90sI8eR9YdHUzZLn6B925RQhGBr8ACBjhioX
	JwSRdPLxCQgx709obje8i6uTqH92+++ccLQ7cAKDLZ2B6Na25gaZXpp6ahoreMVJeIIj7tI2/d6
	c61rGFYi4kMDUcXHPZ5AMEOlaxDixSGu7cMlq1HdWxP/+hr6XcvCA=
X-Gm-Gg: ASbGncuXfwrXjzSxm4dvUvLachlUJlL5vI5t/7Uv+KSislUtmuKKZ8o4nTh2Qu0IQ6F
	4zPZW6sXRWzWqv05rXWAMXt0gC2KHDx4VkbtnMDoR36DtPdHiwANJhf8PSRv7r/az0Q81AncJcp
	EkppqG1SAiXuOKRmtG8gCwqDvYyLi7/Amfn/yttA==
X-Received: by 2002:a05:6102:942:b0:4f9:69a9:4ec5 with SMTP id ada2fe7eead31-4fdc4c036b6mr5365017137.27.1754396920913;
        Tue, 05 Aug 2025 05:28:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFL0P2wXp4JQW74rzvmVlOGK27HSNIxNeZANocAUkC3Rym4vHHE9Z5Jk6QPjbtGTT3d6VxAA49+tnoEjFzUNHQ=
X-Received: by 2002:a05:6102:942:b0:4f9:69a9:4ec5 with SMTP id
 ada2fe7eead31-4fdc4c036b6mr5365008137.27.1754396920531; Tue, 05 Aug 2025
 05:28:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250804095942.2167541-1-amarkuze@redhat.com> <20250804095942.2167541-3-amarkuze@redhat.com>
 <0d4ffc45c292005a65ca244b013a313f7d35e607.camel@ibm.com>
In-Reply-To: <0d4ffc45c292005a65ca244b013a313f7d35e607.camel@ibm.com>
From: Alex Markuze <amarkuze@redhat.com>
Date: Tue, 5 Aug 2025 16:28:28 +0400
X-Gm-Features: Ac12FXyH_DUahWpI0xqGQs6BOP5JU-fSqViKpkZX-hnYyF1Ju6M1j8DZrS-OxFg
Message-ID: <CAO8a2ShMmC6kRTiVmRG54xb7N8-cQe45ecJYMhOcECjPy9wvTg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] ceph: fix client race condition where r_parent
 becomes stale before sending message
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, "idryomov@gmail.com" <idryomov@gmail.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

That's the BUG, we are fixing here. If a mismatch happens the update
if not fixed can cause a mess. A full WARN may be an overkill I agree.

On Tue, Aug 5, 2025 at 1:58=E2=80=AFAM Viacheslav Dubeyko <Slava.Dubeyko@ib=
m.com> wrote:
>
> On Mon, 2025-08-04 at 09:59 +0000, Alex Markuze wrote:
> > When the parent directory's i_rwsem is not locked, req->r_parent may be=
come
> > stale due to concurrent operations (e.g. rename) between dentry lookup =
and
> > message creation. Validate that r_parent matches the encoded parent ino=
de
> > and update to the correct inode if a mismatch is detected.
> > ---
> >  fs/ceph/inode.c | 52 +++++++++++++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 50 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> > index 814f9e9656a0..7da648b5e901 100644
> > --- a/fs/ceph/inode.c
> > +++ b/fs/ceph/inode.c
> > @@ -56,6 +56,51 @@ static int ceph_set_ino_cb(struct inode *inode, void=
 *data)
> >       return 0;
> >  }
> >
> > +/*
> > + * Check if the parent inode matches the vino from directory reply inf=
o
> > + */
> > +static inline bool ceph_vino_matches_parent(struct inode *parent, stru=
ct ceph_vino vino)
> > +{
> > +     return ceph_ino(parent) =3D=3D vino.ino && ceph_snap(parent) =3D=
=3D vino.snap;
> > +}
> > +
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
> > +
> > +    /* If we didn't have a cached parent inode to begin with, just bai=
l out. */
> > +    if (!parent)
> > +        return NULL;
> > +
> > +    vino.ino  =3D le64_to_cpu(rinfo->diri.in->ino);
> > +    vino.snap =3D le64_to_cpu(rinfo->diri.in->snapid);
> > +
> > +    if (likely(ceph_vino_matches_parent(parent, vino)))
> > +        return parent; /* matches =E2=80=93 use the original reference=
 */
> > +
> > +    /* Mismatch =E2=80=93 this should be rare.  Emit a WARN and obtain=
 the correct inode. */
> > +    WARN(1, "ceph: reply dir mismatch (parent valid %llx.%llx reply %l=
lx.%llx)\n",
> > +         ceph_ino(parent), ceph_snap(parent), vino.ino, vino.snap);
>
> I am not completely sure that I follow why we would like to use namely WA=
RN()
> here? If we have some condition, then WARN() looks like natural choice.
> Otherwise, if we have unconditional situation, then, maybe, pr_warn() wil=
l be
> better? Would we like to show call trace here?
>
> Are we really sure that this mismatch could be the rare case? Otherwise, =
call
> traces from multiple threads will create the real mess in the system log.
>
> Thanks,
> Slava.
>
> > +
> > +    return ceph_get_inode(sb, vino, NULL);
> > +}
> > +
> >  /**
> >   * ceph_new_inode - allocate a new inode in advance of an expected cre=
ate
> >   * @dir: parent directory for new inode
> > @@ -1548,8 +1593,11 @@ int ceph_fill_trace(struct super_block *sb, stru=
ct ceph_mds_request *req)
> >       }
> >
> >       if (rinfo->head->is_dentry) {
> > -             struct inode *dir =3D req->r_parent;
> > -
> > +             /*
> > +              * r_parent may be stale, in cases when R_PARENT_LOCKED i=
s not set,
> > +              * so we need to get the correct inode
> > +              */
> > +             struct inode *dir =3D ceph_get_reply_dir(sb, req->r_paren=
t, rinfo);
> >               if (dir) {
> >                       err =3D ceph_fill_inode(dir, NULL, &rinfo->diri,
> >                                             rinfo->dirfrag, session, -1=
,
>
> --
> Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>


