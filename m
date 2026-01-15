Return-Path: <ceph-devel+bounces-4439-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 90066D280EE
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Jan 2026 20:26:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1F7B43060308
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Jan 2026 19:23:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C09AA2F39A1;
	Thu, 15 Jan 2026 19:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J+d8bhIL"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D805B2EBB8F
	for <ceph-devel@vger.kernel.org>; Thu, 15 Jan 2026 19:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768505013; cv=none; b=Gm6NMPEyp4pRUbIaeDrBH0f9eQBhGEbzgz2BepQI4R0TzYLBeHAI2byXxusbotXioF9Zz9aQrrIHGmtjS1x3q7t9zvpi8ET/c4gMU5xBb9Qccu2Gg7ffKazpfv0Lz0Xn0rierRQ4yVn6rP70x2FM0UAcMQQAcYc/f0PyHJdiXhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768505013; c=relaxed/simple;
	bh=K7EKeFZcYOwWj32Ok6OEcoTNGvsHPX2vPwhKzUVyoug=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R03LYhjyTnYxUbnAY8t4frXG1u2dOlDJ10UtXgN+JgSlupDSwrPK+KXaWjAa4D3EWBpTjYKCvtDd6VuC6JCjkMkacQp1+terAwRo3MtjAJPFm43NgTu31ZnNZ6hOH8mbAXdViNzA4ZAAZkRP87OGpE0ncY7exvrgA/J5VO9oCDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J+d8bhIL; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b8707005183so212245266b.0
        for <ceph-devel@vger.kernel.org>; Thu, 15 Jan 2026 11:23:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768505009; x=1769109809; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1HpNW/ml4xLa7Q+ZYoOd6NCigBelaQL2RtJ0aaDh9mI=;
        b=J+d8bhILA0dbk7t5hkmNO1mcsMKdM8fhTW1Ocr1dvZWCSsmJa7JumfRtv6adpfFHqm
         6EoeiPfosiEqcgJDEF8iRVcBmEzKJZYKHGka5fPFFnEO5DjlmHHCyplVtllcdEWKxVPS
         7f9HnOwO44sfz33ApLvvdQDuS2o1nPotoefgiAzWSyyvN8Mnw9E8397Y9GkYVtAcH5mK
         BTLEixHMcFNcxaRv9OxW2AqX58uGVSpZwSaeQhuPKJdv4mvEVz+EwSWYEdRXMZd2+jiL
         xAd7jVwMUpQ2rqFOyA1wKHBUdFrHiwAMCQeemIRpz7T0KnCZsKby8mDjZ1PerF/UP56G
         g4hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768505009; x=1769109809;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1HpNW/ml4xLa7Q+ZYoOd6NCigBelaQL2RtJ0aaDh9mI=;
        b=McDrb+Q5BSPTDmljYh5N/fqHJwaBjSfFlrwgQ4V8RD+1+8xwdENXiigCtLKFj7A5XB
         9/64iZfZul0U6hvIacKYZ9IoclNLKwrAprS0BHZNp+ALy2QJ9VuERKu0EiUhJq6xIyhS
         S6gEfGo8lCRsOYndAVyOlLRPgzzGyZKEEsRBDAnB9v4/r/8002AlrIzkMjVLRHMTYt3c
         KbyuQFZ5YzEWjgdwfmvU5FlcByh2duyIfAdBC453Dh/5duSBgNZgO0f/gr3rJI8+QoOT
         cgYGvx7z7DHkA/bmcbJYcLNJ5sgKced9CsZntPV5FiXr3DoNxj9M3ZOdOHdOjzbQ7SW6
         ae2Q==
X-Forwarded-Encrypted: i=1; AJvYcCXdOOgjjC5EBjObeLxe4TV2hiFnKDCOgc17sj6zg6wTcxj8SCLIz4QDAGJb070E3vqab/5hf7uLRadg@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4ZzHzjkz3MQt9imy26QAxa3RvEqdIQDbBmrTeZCo8GazoxcFD
	AO2usScWL+spYGHM643fy2V0Ql5COeQuhHVZO/rNBXHQBs/54ncB2RfnX9QT9sFj9o+mmyecp8i
	jy9Xi9sW6pJcceb6jC+gnJbxOJreY1gc=
X-Gm-Gg: AY/fxX7In1QUU8X8K3evNe0p73hgoeFarQ0Zh+9IfoaVUQLZwHszi/RdZQwopWJ0ZS2
	wZB8wWdyWLqAt4NsF0XRj23PIv4+5UY/0wnqeGc/3u1pKvgZcUZaKB6OCyBHMZn3Gys2y6KdJ+0
	F9Gum9tP2HlixVon9iFRV+JlFBC7PRuA32jeSsooHFeFfMpnAGUpAFCXXmdbZsYHTC1wZ5xEGJo
	E5r5L+xBjJfwgTT5laCC4kW8Hc/pLng0K5C6If/hty2lDFc5UhbhO04YAjkY8n8KQYp6yyjiG86
	tBCoTZsw1ZijUE+lKIRowU3if4z3Og==
X-Received: by 2002:a17:907:3e97:b0:b73:7c3e:e17c with SMTP id
 a640c23a62f3a-b879327e30bmr63085666b.44.1768505008810; Thu, 15 Jan 2026
 11:23:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org> <20260115-exportfs-nfsd-v1-29-8e80160e3c0c@kernel.org>
In-Reply-To: <20260115-exportfs-nfsd-v1-29-8e80160e3c0c@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 15 Jan 2026 20:23:17 +0100
X-Gm-Features: AZwV_Qj21qC7f0_83CWGwxMbCuhLisWPoHuSIOsZGqfnrVByhBJVGvUqJqXdQ-8
Message-ID: <CAOQ4uxg304=s1Uoeayy3rm1e154Nf7ScOgseJHThw4uQjKwk0A@mail.gmail.com>
Subject: Re: [PATCH 29/29] nfsd: only allow filesystems that set EXPORT_OP_STABLE_HANDLES
To: Jeff Layton <jlayton@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>, 
	Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Theodore Ts'o" <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, Gao Xiang <xiang@kernel.org>, 
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, 
	Carlos Maiolino <cem@kernel.org>, Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Luis de Bethencourt <luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>, 
	Phillip Lougher <phillip@squashfs.org.uk>, Steve French <sfrench@samba.org>, 
	Paulo Alcantara <pc@manguebit.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Mike Marshall <hubcap@omnibond.com>, 
	Martin Brandenburg <martin@omnibond.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Ryusuke Konishi <konishi.ryusuke@gmail.com>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Dave Kleikamp <shaggy@kernel.org>, 
	David Woodhouse <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, Jan Kara <jack@suse.cz>, 
	Andreas Gruenbacher <agruenba@redhat.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Christoph Hellwig <hch@infradead.org>, linux-nfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	linux-xfs@vger.kernel.org, ceph-devel@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-unionfs@vger.kernel.org, 
	devel@lists.orangefs.org, ocfs2-devel@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-nilfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-mtd@lists.infradead.org, gfs2@lists.linux.dev, 
	linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 15, 2026 at 6:51=E2=80=AFPM Jeff Layton <jlayton@kernel.org> wr=
ote:
>
> Some filesystems have grown export operations in order to provide
> filehandles for local usage. Some of these filesystems are unsuitable
> for use with nfsd, since their filehandles are not persistent across
> reboots.
>
> In __fh_verify, check whether EXPORT_OP_STABLE_HANDLES is set
> and return nfserr_stale if it isn't.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/nfsd/nfsfh.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/fs/nfsd/nfsfh.c b/fs/nfsd/nfsfh.c
> index ed85dd43da18e6d4c4667ff14dc035f2eacff1d6..da9d5fb2e6613c2707195da2e=
8678b3fcb3d444d 100644
> --- a/fs/nfsd/nfsfh.c
> +++ b/fs/nfsd/nfsfh.c
> @@ -334,6 +334,10 @@ __fh_verify(struct svc_rqst *rqstp,
>         dentry =3D fhp->fh_dentry;
>         exp =3D fhp->fh_export;
>
> +       error =3D nfserr_stale;
> +       if (!(dentry->d_sb->s_export_op->flags & EXPORT_OP_STABLE_HANDLES=
))
> +               goto out;
> +
>         trace_nfsd_fh_verify(rqstp, fhp, type, access);
>

IDGI. Don't you want  to deny the export of those fs in check_export()?
By the same logic that check_export() checks for can_decode_fh()
not for can_encode_fh().

Thanks,
Amir.

