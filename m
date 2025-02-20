Return-Path: <ceph-devel+bounces-2725-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 87AB2A3E2B7
	for <lists+ceph-devel@lfdr.de>; Thu, 20 Feb 2025 18:41:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 227C1162B15
	for <lists+ceph-devel@lfdr.de>; Thu, 20 Feb 2025 17:41:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CF972139B0;
	Thu, 20 Feb 2025 17:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="Gzl4uYnY"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2073213228
	for <ceph-devel@vger.kernel.org>; Thu, 20 Feb 2025 17:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740073260; cv=none; b=VwGzQ34DWq3z5LsVLtCL7BWTdrj+9oKf8r2Kwy6newA2ElmwuaXp8jZKXAzrDMwfs13HR+nc1O/VyFw6NQSYFr/0rMpU/S8iZEhx1SFxpGJRrxJTB/M+3GQZzdSnsEmfL1qS5BnWesD3aL8apq9uCvJ1mwBDcnbcnEBC5iQ0xQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740073260; c=relaxed/simple;
	bh=8rPnFaNq1SfJ7jVpZvL0HRIukQfDe+00TekDIZglHqA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G1zBwx7bWklnZ/Zvq0jbmTqAah019+b5Jv3CiYH0eSGooyF2Txybso5ySgLsry8OC2s/5H2qeKUUwGojUJrt3W7cUVpe98bX6yjx7lxBxJWiaUmw2x3mrrS3zVboa7SzhX9QNUqpKA304ZHs7Fa2t9DTjspJa0Y5j2YSjRSGI7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=Gzl4uYnY; arc=none smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-6ef7c9e9592so10129907b3.1
        for <ceph-devel@vger.kernel.org>; Thu, 20 Feb 2025 09:40:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1740073257; x=1740678057; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vu7DO/yBBwA/XGaFJzr9sCM18a7jAEeqhWVP0InQkzI=;
        b=Gzl4uYnY65hl2BR5i6mgM3CNtkSXWslno2D8Dnpl+u8ocKicHeVFJwa7ZZtC4wMFH8
         gmtg2x/k9zMLSV0SDP11z8Vq/O5eDfxb2JcdNr9OeFUJHY6SaRyIDQYslyFujIQlSUpW
         B0co0t6aeKkBZrI/KxZEhi830groy6lXNgCMQLi09gqASilQ6Db+Hef2YEh4Ik14nLM5
         k0laCRFdlOpu3swydEUVYl9oYAwsXHdVzFhb9IZpu1kgLFjEiYHzh2eMgNY3VvAZMYJ6
         7Tx+rCj+FnzkJV6XIwzPtKoudM8Ji38ghEA5u96gxg0kUn+rOzYbdyvAwbZP8gMK4nDC
         U6TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740073257; x=1740678057;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vu7DO/yBBwA/XGaFJzr9sCM18a7jAEeqhWVP0InQkzI=;
        b=U+n23DBVxDAhHF4k6eom5z6xdmCUO19Yr27q1vUPMovJK/M4iM893Aq2Qnn2pLVXGI
         EeXkMVu60nqRn8IGZ7OaNSwewW1S7yhziHWNCmYzxl0dxqT2256k/PXfuVVliVD8j7T2
         sBp7OOe2yLbogWijIs6MhQy/z2zps+exjaezNJCu0pTTK9rbmXFV0583KxCA/OhtbGoF
         Ahii7S/SwtdR0ltnLoPiADROmQxy22GPWfe7KIE0cGmqlW//Wiyy06NEczv38ZVSfiNj
         PcXvA9RT/uIDukEWhcrwEsaTpYAMA6X3WynCyCQOr7QRuNb1RzWe7G5o+tsG1GRpUmzo
         w3xw==
X-Forwarded-Encrypted: i=1; AJvYcCU+wpO77dp/aHl34KLMqtNFSltHfg5/XUzQXAU9SjU+mS0COfXc6e4QUjO/QPXHi2A+FfWty9C4bvE5@vger.kernel.org
X-Gm-Message-State: AOJu0YzZkQr5msBGx+51PQ57Na5C1c+ccTYhAExygWQFmgl9bJf2b2Ff
	I/JbcPzqWI4Gp+dQxyIBZf0WeFKr+U5uNu620+0QD3Tp+3+2Wi7G+Z7G9Ryk35bn5P6xv8UiODf
	0Ub+ywl0qNs4mq25A8ZWxFAGB3IUBFUI7laUC
X-Gm-Gg: ASbGnct9ay+zI5OI/e9yyAqZHkq+7uC1efFJbVp+EyMFIDk2DtacDYU0udEFfp291WN
	qMf48GrO+Eo89WJQeZ03Ug+hfUhBsk+SndKfi+wY+hrEDM6p61p9/ah//g9/At956BnR7FvV3
X-Google-Smtp-Source: AGHT+IGOC3n697KQWN6744ppAX2UiJaNpyU2qsRLzjIySb2kBI0edUGzQLUx4OZtKin2ejcQnHHBTTRTr9VNGFYZed0=
X-Received: by 2002:a05:690c:6283:b0:6f9:a75f:f220 with SMTP id
 00721157ae682-6fb58361e38mr219054337b3.25.1740073256563; Thu, 20 Feb 2025
 09:40:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241023212158.18718-1-casey@schaufler-ca.com>
 <20241023212158.18718-5-casey@schaufler-ca.com> <CAEjxPJ56H_Y-ObgNHrCggDK28NOARZ0CDmLDRvY5qgzu=YgE=A@mail.gmail.com>
In-Reply-To: <CAEjxPJ56H_Y-ObgNHrCggDK28NOARZ0CDmLDRvY5qgzu=YgE=A@mail.gmail.com>
From: Paul Moore <paul@paul-moore.com>
Date: Thu, 20 Feb 2025 12:40:45 -0500
X-Gm-Features: AWEUYZkFZy4bmFlQEibuzns5VOKgC88N9W9hwaf8Sszpl0Su5qJth6e0K_A3KCU
Message-ID: <CAHC9VhSSpLx=ku7ZJ7qVxHHyOZZPQWs_hoxVRZpTfhOJ=T2X9w@mail.gmail.com>
Subject: Re: [PATCH v3 4/5] LSM: lsm_context in security_dentry_init_security
To: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>, linux-security-module@vger.kernel.org, 
	jmorris@namei.org, serge@hallyn.com, keescook@chromium.org, 
	john.johansen@canonical.com, penguin-kernel@i-love.sakura.ne.jp, 
	linux-kernel@vger.kernel.org, selinux@vger.kernel.org, mic@digikod.net, 
	ceph-devel@vger.kernel.org, linux-nfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 20, 2025 at 11:43=E2=80=AFAM Stephen Smalley
<stephen.smalley.work@gmail.com> wrote:
> On Wed, Oct 23, 2024 at 5:23=E2=80=AFPM Casey Schaufler <casey@schaufler-=
ca.com> wrote:
> >
> > Replace the (secctx,seclen) pointer pair with a single lsm_context
> > pointer to allow return of the LSM identifier along with the context
> > and context length. This allows security_release_secctx() to know how
> > to release the context. Callers have been modified to use or save the
> > returned data from the new structure.
> >
> > Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> > Cc: ceph-devel@vger.kernel.org
> > Cc: linux-nfs@vger.kernel.org
> > ---
> >  fs/ceph/super.h               |  3 +--
> >  fs/ceph/xattr.c               | 16 ++++++----------
> >  fs/fuse/dir.c                 | 35 ++++++++++++++++++-----------------
> >  fs/nfs/nfs4proc.c             | 20 ++++++++++++--------
> >  include/linux/lsm_hook_defs.h |  2 +-
> >  include/linux/security.h      | 26 +++-----------------------
> >  security/security.c           |  9 ++++-----
> >  security/selinux/hooks.c      |  9 +++++----
> >  8 files changed, 50 insertions(+), 70 deletions(-)
> >
>
> > diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
> > index 76776d716744..0b116ef3a752 100644
> > --- a/fs/nfs/nfs4proc.c
> > +++ b/fs/nfs/nfs4proc.c
> > @@ -114,6 +114,7 @@ static inline struct nfs4_label *
> >  nfs4_label_init_security(struct inode *dir, struct dentry *dentry,
> >         struct iattr *sattr, struct nfs4_label *label)
> >  {
> > +       struct lsm_context shim;
> >         int err;
> >
> >         if (label =3D=3D NULL)
> > @@ -128,21 +129,24 @@ nfs4_label_init_security(struct inode *dir, struc=
t dentry *dentry,
> >         label->label =3D NULL;
> >
> >         err =3D security_dentry_init_security(dentry, sattr->ia_mode,
> > -                               &dentry->d_name, NULL,
> > -                               (void **)&label->label, &label->len);
> > -       if (err =3D=3D 0)
> > -               return label;
> > +                               &dentry->d_name, NULL, &shim);
> > +       if (err)
> > +               return NULL;
> >
> > -       return NULL;
> > +       label->label =3D shim.context;
> > +       label->len =3D shim.len;
> > +       return label;
> >  }
> >  static inline void
> >  nfs4_label_release_security(struct nfs4_label *label)
> >  {
> > -       struct lsm_context scaff; /* scaffolding */
> > +       struct lsm_context shim;
> >
> >         if (label) {
> > -               lsmcontext_init(&scaff, label->label, label->len, 0);
> > -               security_release_secctx(&scaff);
> > +               shim.context =3D label->label;
> > +               shim.len =3D label->len;
> > +               shim.id =3D LSM_ID_UNDEF;
>
> Is there a patch that follows this one to fix this? Otherwise, setting
> this to UNDEF causes SELinux to NOT free the context, which produces a
> memory leak for every NFS inode security context. Reported by kmemleak
> when running the selinux-testsuite NFS tests.

I don't recall seeing anything related to this, but patches are
definitely welcome.

--=20
paul-moore.com

