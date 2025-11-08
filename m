Return-Path: <ceph-devel+bounces-3942-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CAD2C42A2E
	for <lists+ceph-devel@lfdr.de>; Sat, 08 Nov 2025 10:19:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 2D9044E4EEC
	for <lists+ceph-devel@lfdr.de>; Sat,  8 Nov 2025 09:19:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DC532EBBB4;
	Sat,  8 Nov 2025 09:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XbCrXJqp"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9FE2DF6E9
	for <ceph-devel@vger.kernel.org>; Sat,  8 Nov 2025 09:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762593581; cv=none; b=rV8YJFcm9IzrGvx0gm6KYcYcBd75n2UxPPNlfkIMXpDAp45Bi3EzDmvF1jlM6aKBCAkTlxIJ7WNuMLdX7ef2meS9uD0FF7kbJh5Ti3XMrPa7kByGth7jnI16SHs7fl9YlXeH6D+bl1y5UQquBA4SnpamqGz+Qm0WLVqx0eLWtPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762593581; c=relaxed/simple;
	bh=Y49FEVhEZCj60/+Ylnua7B5NNXsJ25LsdBXGXmWxbi8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tf+Sfu1a4qPnc9YDFTCNgt5F1AbIkA8v9/0YNwVUeFf1ocPgu30AszpYFhg8UinAoQXbSgxMHsmiwVAL14jYL/NkbxRebEzubMEgmJq7H0G1nxQqv5upIX2OtfC7yVNetEOIoyXFP0ATJzMrxZmwMzFLeQ4z3oAqxgQ9Y7rFHEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XbCrXJqp; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-295ceaf8dacso15663855ad.0
        for <ceph-devel@vger.kernel.org>; Sat, 08 Nov 2025 01:19:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762593577; x=1763198377; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xMJJSbsWQXZcDWYlPD+q/sMKmcoPg7XO2KNCJJBRcPk=;
        b=XbCrXJqpU5Fw1gS912IzNS7KgBmBpEzt7BjCmmVFTL8kHJTuGLWxxwgdaXCUg4CV2D
         tKCOjl7wqtFqq2KqtRwQmCQoZ2kxqJrxqAaLSYbI9D+6BC6bJNEbr7E7KTvOL4UqahSf
         w/QgA8EXXBEeLOZgkH/mm2j8/uswIitunMmgBdG766MxnsGJq42mTLMaDjXhzkm/zaEH
         UtlB680jTq7xY0S9vzTnm9oN5yO7Du7xhiUuoHeQloIlgSzi/qSU8H/Y2rUf/XMJj6Bh
         tzv4XdJ7tB0GUfU9Ij+3Tup68eVUiffb9PZoDl640BmypjzahazCqHEiCv+hciS4uHrF
         TsZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762593577; x=1763198377;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xMJJSbsWQXZcDWYlPD+q/sMKmcoPg7XO2KNCJJBRcPk=;
        b=qcFr7VKvqyel8gcBt7CxGrFM7p6VzY+rvNPM7wCH/1ArokvygmOUJQ0uWJSvk6boPi
         /J59I4d2V81oKtuFdua20fqyZa7Gb1ul7LxVaUATpbgj9QM5FMQ08xliUCx4DTvAtO3T
         dZEp2jGgwA5WSrP6GGFF4Wh3qoY6tNtkxVnS2QF8oK+Q06y4kMp0rnw6ewsOWqLlyIP7
         MEWw0kxOyP2fqVyE7hVRSOx9jTFMUzQs5MJjQw2+En5XsZ97Whfu+DlFdDmyRnIzVNT0
         TdpVZ0hV2T53bDeSI/32f23WAhINs+mmWlRELQIFS2hcmvt6gIhzffWZySPn2W20vuxt
         pToQ==
X-Forwarded-Encrypted: i=1; AJvYcCXfa4Y8hD6Rn4IFhoLytrvt13lg3taUzAxDFBA0HywlJS9nXUMdndJ8O2zBhoclYHsmt7aSRDLsPGkL@vger.kernel.org
X-Gm-Message-State: AOJu0YzPFbyClnIAn4YKlulFFRo0MDHn/yBxWzo8tEkOdhnRXXiMqCox
	9RzJM2QuUoUb5B7LM2Ei4lu5Zu7B3X2vDY9OQhK7hbTiGi/KLc+WfDx+
X-Gm-Gg: ASbGnctjAuoGVJbRFMIRuHd3ZjkUw/yADVHrQaiuOxh72J+YwPRAvsEU8Tt3XHR7rOR
	S32n80I0LGbNpMfmDriFsZcuH6RHFmYU34esrIxQqVzjI7xmEqfk1rTxy55C09XQC7YAD9du5qY
	Jq/ulh9oj7gMhDlP4u9/R/h8adhWF2YUnkKQzXZn6t9XcSRVQeTEwyQwp4Du2zOyd8ifcFGBEg8
	gcO7+GsUtPJPohwCaTo0eZkJAjbfXi9dCu2an6Mu45MjsBseKSrb6bAId31Vs9y3bvX6dyD6yEB
	ICpZ0wncJgk34iJ+gGQ44jLau9DsbsrLi1Q25xBe/d2mjkYXgugCgsc0S4yTNAWFAFd9/yxK1hV
	ikh1zsc64Riw/m+lz5xA2lYlPXpVdzaAitQbNFpZ7yT8g1Wvp7hVkPuq2REqFOsw4f0limU5CrV
	JPuVZOJjpMThs=
X-Google-Smtp-Source: AGHT+IGxcceL/cUmEO7hnoApXfEFPAPpQerRMJTCvaDgcasBmFqwVjXcVlI2/yGLIfmLK+orIB3gUw==
X-Received: by 2002:a17:902:da84:b0:292:fc65:3584 with SMTP id d9443c01a7336-297e56f9b21mr24987685ad.50.1762593577039;
        Sat, 08 Nov 2025 01:19:37 -0800 (PST)
Received: from archie.me ([210.87.74.117])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29650c5c6b3sm82791745ad.24.2025.11.08.01.19.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Nov 2025 01:19:35 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 77412400200B; Sat, 08 Nov 2025 16:19:33 +0700 (WIB)
Date: Sat, 8 Nov 2025 16:19:33 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Dominique Martinet <asmadeus@codewreck.org>,
	Jeff Layton <jlayton@kernel.org>
Cc: Eric Van Hensbergen <ericvh@kernel.org>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	David Sterba <dsterba@suse.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	Chris Mason <clm@fb.com>, Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>, Jan Harkes <jaharkes@cs.cmu.edu>,
	coda@cs.cmu.edu, Tyler Hicks <code@tyhicks.com>,
	Jeremy Kerr <jk@ozlabs.org>, Ard Biesheuvel <ardb@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Yangtao Li <frank.li@vivo.com>, Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Dave Kleikamp <shaggy@kernel.org>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Bob Copeland <me@bobcopeland.com>,
	Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Hans de Goede <hansg@kernel.org>, Carlos Maiolino <cem@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	NeilBrown <neilb@ownmail.net>, linux-kernel@vger.kernel.org,
	v9fs@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org,
	ceph-devel@vger.kernel.org, codalist@coda.cs.cmu.edu,
	ecryptfs@vger.kernel.org, linux-efi@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	gfs2@lists.linux.dev, linux-um@lists.infradead.org,
	linux-mm@kvack.org, linux-mtd@lists.infradead.org,
	jfs-discussion@lists.sourceforge.net, linux-nfs@vger.kernel.org,
	linux-nilfs@vger.kernel.org, ntfs3@lists.linux.dev,
	ocfs2-devel@lists.linux.dev,
	linux-karma-devel@lists.sourceforge.net, devel@lists.orangefs.org,
	linux-unionfs@vger.kernel.org, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, linux-xfs@vger.kernel.org,
	linux-hardening@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v2] vfs: remove the excl argument from the ->create()
 inode_operation
Message-ID: <aQ8LJfKC0R-4ehLU@archie.me>
References: <20251107-create-excl-v2-1-f678165d7f3f@kernel.org>
 <aQ7fOmknHIxcxuha@codewreck.org>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="hTQgJTXrd9+JcPiP"
Content-Disposition: inline
In-Reply-To: <aQ7fOmknHIxcxuha@codewreck.org>


--hTQgJTXrd9+JcPiP
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 08, 2025 at 03:12:10PM +0900, Dominique Martinet wrote:
> Jeff Layton wrote on Fri, Nov 07, 2025 at 10:05:03AM -0500:
> > diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesyst=
ems/vfs.rst
> > index 4f13b01e42eb5e2ad9d60cbbce7e47d09ad831e6..7a55e491e0c87a0d18909bd=
181754d6d68318059 100644
> > --- a/Documentation/filesystems/vfs.rst
> > +++ b/Documentation/filesystems/vfs.rst
> > @@ -505,7 +505,10 @@ otherwise noted.
> >  	if you want to support regular files.  The dentry you get should
> >  	not have an inode (i.e. it should be a negative dentry).  Here
> >  	you will probably call d_instantiate() with the dentry and the
> > -	newly created inode
> > +        newly created inode. This operation should always provide O_EX=
CL
>=20
> This and the block below change halfway from tab (old text) to spaces
> (your patch)
>=20
> Looks like the file has a few space-indented sections though so it won't
> be the first if that goes in as is, the html-rendering doesn't seem to
> care :)

FYI: I'm using Vim. My important settings (in ~/.vimrc) are:

```
set nojoinspaces
set textwidth=3D0
set backspace=3D2
```

However, ftplugin override these for each file type, so you have to essenti=
ally
"fork" the relevant ftplugin file for each type if you want for your settin=
gs
to take precedence. For example, in case of reST, copy
/usr/share/vim/vim91/ftplugin/rst.vim to ~/.vim/ftplugin/rst and override t=
he
already defined options there:

```
=2E..
" keep tabs as-is
setlocal comments=3Dfb:.. commentstring=3D..\ %s noexpandtab
=2E..
if exists("g:rst_style") && g:rst_style !=3D 0
    setlocal noexpandtab shiftwidth=3D8 softtabstop=3D0 tabstop=3D8
endif
=2E..
```

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--hTQgJTXrd9+JcPiP
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCaQ8LHwAKCRD2uYlJVVFO
o2WVAPsFBRuUsYfWxAnWROgP/61sBqVYDc/UsPimcXm5dJJfgQD9ESTXpfxlpefS
VKeWBneX6svZYShHE5RzrbcYO+G5GA0=
=gW2v
-----END PGP SIGNATURE-----

--hTQgJTXrd9+JcPiP--

