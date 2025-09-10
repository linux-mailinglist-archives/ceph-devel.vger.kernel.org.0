Return-Path: <ceph-devel+bounces-3567-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F0BEB51484
	for <lists+ceph-devel@lfdr.de>; Wed, 10 Sep 2025 12:52:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3E7B1189BA4A
	for <lists+ceph-devel@lfdr.de>; Wed, 10 Sep 2025 10:52:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21FCE3101CD;
	Wed, 10 Sep 2025 10:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V3wEidSl"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F93B8528E
	for <ceph-devel@vger.kernel.org>; Wed, 10 Sep 2025 10:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757501519; cv=none; b=PcfRXlU7F5MV26Qa4WIokl+8A89WdXRlgrklQOck5UBfER9cJqUx71y5/PRs708p3XsdCxxihVTLRpkblajKwyMwXbrVrwJKMKjRpjOUWqnxNxXCpAbfO3RqBNBaZMG+k+IAXNd/Ph+ioa9PtSyOCAxtmvUfBDQTsoVF1j/0ZZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757501519; c=relaxed/simple;
	bh=lvMg2T29B+rgu6laqnurbUkTf9akKoOmnH1BPzt1itI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V2on2POXW7QSIQV5JUBjwUZgcL7LLGe+y3Jld72RwhpRJB61XcMCL+d6fBRXYO9YbuysPJyeEodoUaVOoM6cNMFHiJH02zxk+lvvPrGF1uqUQb7H3sIdjioE5MDrlXBdMy8/fu+t92rOnzjpnqQgykBrwGlfy2w9JYd0Vyt5f9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V3wEidSl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757501516;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X57ExVGYOqu+C2zXM3CZmS8GigIlZMulN1ZinLgWtbA=;
	b=V3wEidSlp9BjNofru2IT+HYsAOLyofMBJqttB18xXLXY/idddGljUbdlLWefRACG+Tg3Ar
	01QhyBpwEJQs/N1NPmkTe7WD61jHOQ1c2LNP9dGvIFL0GhrN7AU1xsUf+uAiqXxG5GCu1G
	pd9IA4AaB7iUf1haGJBX7LGhVIFnaO4=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-219-GloDgWOlPUGPUvWLqIddpw-1; Wed, 10 Sep 2025 06:51:54 -0400
X-MC-Unique: GloDgWOlPUGPUvWLqIddpw-1
X-Mimecast-MFC-AGG-ID: GloDgWOlPUGPUvWLqIddpw_1757501514
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-24ca417fb41so79240375ad.1
        for <ceph-devel@vger.kernel.org>; Wed, 10 Sep 2025 03:51:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757501514; x=1758106314;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X57ExVGYOqu+C2zXM3CZmS8GigIlZMulN1ZinLgWtbA=;
        b=u8tEDh25ur1hF69QcgzwPN1DTTwRS4MVOez9QicXML5jOEiI92J1oaqp5ZA/r8ii+x
         77LSVPlBD/wtKtKX+kD4R+lwjFyfPQU44gryiz1Ke7Fk3G3SvE60OwNHTDaKk7kefJgr
         1k+11mpe4GJ2kY9qR7TddzkN6zPNdWn/fl/M7ztTIu6717kyRIpGrcXstpw8h1qDLOAl
         Hr+9JsAXryHP7nIS+15WPlXWy85gVsPuA64cfhVPgeEG9c6yGvp/5SydMJw5sC4QNCsa
         SBBYQWOB4EPz+nUfHrRZpQTzzb1BhC9wK43XJJLbTFzCDiYW1MaXGiJDgHYEUYXFshIJ
         oCBw==
X-Gm-Message-State: AOJu0YwpfcGvjSMkdd/FfrO20xrFmOdA0yRQH3foFn1gbtL8rIo7oCbH
	/EmicmtUCB6W9dm3nF3u8/Qkb/fgv2JWhp7gh+VtMqgnFlkIU99fBTQNUJGWqtW1bHuEAvaGvi5
	CjG5EBUhA9BjCGN/gt2l50yfs5RbAMszvAFrclkAhWYZw2gfVzP52eHTc2f7eFFvLj1hLT/QFPr
	Rd9pmK427h8ZG+vsEhcCGD7jrtgUlhmgncA+WI
X-Gm-Gg: ASbGncsAueXFMCO20DzfDEt0dEcv2b7hcl6cnBEgAZNCtQf0TXDUb5+P269BhhsIahw
	5kjmOsPrTtOEnXcsc5U5xk4Z8lvulq4/TfC6lNECRJjNUkImURphTdo4w8n7ZGudUtL89uXdxy/
	dFb9b4foidRVyPKQOz
X-Received: by 2002:a17:902:f682:b0:24c:1a84:f73e with SMTP id d9443c01a7336-2517616008bmr173846205ad.60.1757501513744;
        Wed, 10 Sep 2025 03:51:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF0vD7NcGS+SFp8IWRgfrlUat/+U3XcdDM/lP7Sz4+IXE3Bl2ws+n0leiPEB2BmuQni6nVkm7sxUrwcI72eGTs=
X-Received: by 2002:a17:902:f682:b0:24c:1a84:f73e with SMTP id
 d9443c01a7336-2517616008bmr173845785ad.60.1757501513062; Wed, 10 Sep 2025
 03:51:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250824184858.24413-1-khiremat@redhat.com> <9f15c800374bc29bb9bf89df3d4949f58195fed5.camel@ibm.com>
In-Reply-To: <9f15c800374bc29bb9bf89df3d4949f58195fed5.camel@ibm.com>
From: Kotresh Hiremath Ravishankar <khiremat@redhat.com>
Date: Wed, 10 Sep 2025 16:21:41 +0530
X-Gm-Features: Ac12FXyh-qy4ccqWsMWpwT5U9p-ye6_gvzZ0N8OJB9c037ojI_PCQluFEsqLFyY
Message-ID: <CAPgWtC5NtjQo=fB7D0iFzk-xuJZc39sDD4o_EmNR99RfCCLc=A@mail.gmail.com>
Subject: Re: [PATCH v3] ceph: Fix multifs mds auth caps issue
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, "idryomov@gmail.com" <idryomov@gmail.com>, 
	Alex Markuze <amarkuze@redhat.com>, Patrick Donnelly <pdonnell@redhat.com>, 
	Venky Shankar <vshankar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sorry, couldn't get to this after my PTO. Comments inline.

On Tue, Aug 26, 2025 at 12:02=E2=80=AFAM Viacheslav Dubeyko
<Slava.Dubeyko@ibm.com> wrote:
>
> On Mon, 2025-08-25 at 00:18 +0530, khiremat@redhat.com wrote:
> > From: Kotresh HR <khiremat@redhat.com>
> >
> > The mds auth caps check should also validate the
> > fsname along with the associated caps. Not doing
> > so would result in applying the mds auth caps of
> > one fs on to the other fs in a multifs ceph cluster.
> > The bug causes multiple issues w.r.t user
> > authentication, following is one such example.
> >
> > Steps to Reproduce (on vstart cluster):
> > 1. Create two file systems in a cluster, say 'fsname1' and 'fsname2'
> > 2. Authorize read only permission to the user 'client.usr' on fs 'fsnam=
e1'
> >     $ceph fs authorize fsname1 client.usr / r
> > 3. Authorize read and write permission to the same user 'client.usr' on=
 fs 'fsname2'
> >     $ceph fs authorize fsname2 client.usr / rw
> > 4. Update the keyring
> >     $ceph auth get client.usr >> ./keyring
> >
> > With above permssions for the user 'client.usr', following is the
> > expectation.
> >   a. The 'client.usr' should be able to only read the contents
> >      and not allowed to create or delete files on file system 'fsname1'=
.
> >   b. The 'client.usr' should be able to read/write on file system 'fsna=
me2'.
> >
> > But, with this bug, the 'client.usr' is allowed to read/write on file
> > system 'fsname1'. See below.
> >
> > 5. Mount the file system 'fsname1' with the user 'client.usr'
> >      $sudo bin/mount.ceph usr@.fsname1=3D/ /kmnt_fsname1_usr/
> > 6. Try creating a file on file system 'fsname1' with user 'client.usr'.=
 This
> >    should fail but passes with this bug.
> >      $touch /kmnt_fsname1_usr/file1
> > 7. Mount the file system 'fsname1' with the user 'client.admin' and cre=
ate a
> >    file.
> >      $sudo bin/mount.ceph admin@.fsname1=3D/ /kmnt_fsname1_admin
> >      $echo "data" > /kmnt_fsname1_admin/admin_file1
> > 8. Try removing an existing file on file system 'fsname1' with the user
> >    'client.usr'. This shoudn't succeed but succeeds with the bug.
> >      $rm -f /kmnt_fsname1_usr/admin_file1
> >
> > For more information, please take a look at the corresponding mds/fuse =
patch
> > and tests added by looking into the tracker mentioned below.
> >
> > v2: Fix a possible null dereference in doutc
> > v3: Don't store fsname from mdsmap, validate against
> >     ceph_mount_options's fsname and use it
> >
> > URL: https://tracker.ceph.com/issues/72167
> > Signed-off-by: Kotresh HR <khiremat@redhat.com>
> > ---
> >  fs/ceph/mds_client.c | 10 ++++++++++
> >  fs/ceph/mdsmap.c     | 14 +++++++++++++-
> >  2 files changed, 23 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > index ce0c129f4651..638a12626432 100644
> > --- a/fs/ceph/mds_client.c
> > +++ b/fs/ceph/mds_client.c
> > @@ -5680,11 +5680,21 @@ static int ceph_mds_auth_match(struct ceph_mds_=
client *mdsc,
> >       u32 caller_uid =3D from_kuid(&init_user_ns, cred->fsuid);
> >       u32 caller_gid =3D from_kgid(&init_user_ns, cred->fsgid);
> >       struct ceph_client *cl =3D mdsc->fsc->client;
> > +     const char *fs_name =3D mdsc->fsc->mount_options->mds_namespace;
> >       const char *spath =3D mdsc->fsc->mount_options->server_path;
> >       bool gid_matched =3D false;
> >       u32 gid, tlen, len;
> >       int i, j;
> >
>
> The doutc is debug output and it will never be shown without enabling it.=
 So, it
> will be completely enough to place the doutc one time for both cases here=
.
>
ok. makes sense. I will get this done in the next patch version.

> > +     if (auth->match.fs_name && strcmp(auth->match.fs_name, fs_name)) =
{
> > +             doutc(cl, "fsname check failed fs_name=3D%s  match.fs_nam=
e=3D%s\n",
> > +                   fs_name, auth->match.fs_name);
> > +             return 0;
>
> If the check is failed, then it sounds to me that we need to show an erro=
r
> message here and return error code:
>
> pr_err_client(<error message>);
> return -EINVAL; ????
>
> Am I correct here?
No. The code should continue to validate the next fsname in the mds
cap and see if it matches.

>
> > +     } else {
> > +             doutc(cl, "fsname check passed fs_name=3D%s  match.fs_nam=
e=3D%s\n",
> > +                   fs_name, auth->match.fs_name ? auth->match.fs_name =
: "");
> > +     }
> > +
> >       doutc(cl, "match.uid %lld\n", auth->match.uid);
> >       if (auth->match.uid !=3D MDS_AUTH_UID_ANY) {
> >               if (auth->match.uid !=3D caller_uid)
> > diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
> > index 8109aba66e02..44f435351daa 100644
> > --- a/fs/ceph/mdsmap.c
> > +++ b/fs/ceph/mdsmap.c
> > @@ -356,7 +356,19 @@ struct ceph_mdsmap *ceph_mdsmap_decode(struct ceph=
_mds_client *mdsc, void **p,
> >               /* enabled */
> >               ceph_decode_8_safe(p, end, m->m_enabled, bad_ext);
> >               /* fs_name */
> > -             ceph_decode_skip_string(p, end, bad_ext);
> > +             const char *mds_namespace =3D mdsc->fsc->mount_options->m=
ds_namespace;
> > +             u32 fsname_len;
>
> I am afraid we could have compiler warnings for such C declarations. Let'=
s have
> all declarations in the beginning of scope:
>
> if (mdsmap_ev >=3D 8) {
>      const char *mds_namespace =3D mdsc->fsc->mount_options->mds_namespac=
e;
>      u32 fsname_len;
>
>      /* enabled */
>     ceph_decode_8_safe(p, end, m->m_enabled, bad_ext);
>     /* fs_name */
>     <rest logic>
> }
>
Sure, I will fix this up in the next patch version.

> > +             ceph_decode_32_safe(p, end, fsname_len, bad_ext);
> > +
> > +             void *sp =3D *p;
>
> What the point to introduce sp variable but not to use p pointer directly=
? Any
> particular reason?
>
No. It was overlooked. I will address this in the next patch version.

> > +             if (!(mds_namespace &&
> > +                   strlen(mds_namespace) =3D=3D fsname_len &&
> > +                   !strncmp(mds_namespace, (char *)sp, fsname_len))) {
>
> Frankly speaking, I think to introduce a static inline function for this =
check
> could make the code cleaner. I mean something like this:
>
> if (fsname_mismatch()) {
>    <complain>
>    goto bad;
> }
Makes sense. I will address this in the next patch version.

>
> > +                     pr_warn_client(cl, "fsname doesn't match\n");
>
> What's about sharing the mismatched names?
>
> pr_warn_client(cl, "fsname %s doesn't match to mds_namespace %s\n");
>
I was doubtful initially that this code can get executed before the
mds_namespace is initialized and
also if fsname can be null. I think this can be done as pr_warn_client
handles NULL gracefully?

> Thanks,
> Slava.
>
> > +                     goto bad;
> > +             }
> > +             // skip fsname after validation
> > +             ceph_decode_skip_n(p, end, fsname_len, bad);
> >       }
> >       /* damaged */
> >       if (mdsmap_ev >=3D 9) {
>


