Return-Path: <ceph-devel+bounces-2854-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C2BD3A4DDDD
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Mar 2025 13:26:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E808E189331C
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Mar 2025 12:26:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE482202984;
	Tue,  4 Mar 2025 12:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FgyfwJXU"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E374978F4C
	for <ceph-devel@vger.kernel.org>; Tue,  4 Mar 2025 12:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741091168; cv=none; b=TjANucnMcFZWzoQPT7/CM1th5xlbL9L+9OJQkSPITHKtMel/gTHUTFmRN7Yw1PSEXuYixnDZSrzqeOZczBt8m9cPIATRtfzDpcp/vwnnNp92Xd/uGzK27XSuNUg0AcMS6IW4nvEFZyOomwtS5YcAHGiakHlvbaTa00u8hcww4iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741091168; c=relaxed/simple;
	bh=kYDNojtzVeBYeFX0FSbALMVfxUpg3XcCa74ud00h96U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jJLvJLTXVsmsE7yiNRjz5BMfCjq7y9x0rdelc3at5bEAiqPkRFxfkLX+DioUI3sIu+hAgYI19Hi2f6rs1qOE35OIN4I9wTKarutROc2WWSb6F3STopb+pTRRqOAItgs8S+wi0QiY2NBIyEW5JrEXKQNSwH3SgmCkIHCLRiuDYPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FgyfwJXU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741091165;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RpfTIYjR2fqGjFf5dQ50RUFTC3qMvYpGsNXcO8SeSqs=;
	b=FgyfwJXUC9KcM2OxEYAZFtICw7h4dt116pu74cW88oLweiDje6jMCCjF05XbjUkzOPCr+4
	xlLTqFBrEPQal5ouJSiNu/3zjuFn87j2PcMB+U1F0D/h4z7Nd5KRun4MPQr7aCi6OnjFfp
	fgEA9ZZZRCJDIrb2P0EqSoz3cxTtdRg=
Received: from mail-vk1-f198.google.com (mail-vk1-f198.google.com
 [209.85.221.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-145-vk4osMjSOr63wD417yWsRg-1; Tue, 04 Mar 2025 07:26:04 -0500
X-MC-Unique: vk4osMjSOr63wD417yWsRg-1
X-Mimecast-MFC-AGG-ID: vk4osMjSOr63wD417yWsRg_1741091164
Received: by mail-vk1-f198.google.com with SMTP id 71dfb90a1353d-523b9e72fb5so583999e0c.3
        for <ceph-devel@vger.kernel.org>; Tue, 04 Mar 2025 04:26:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741091164; x=1741695964;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RpfTIYjR2fqGjFf5dQ50RUFTC3qMvYpGsNXcO8SeSqs=;
        b=UGX8RKK55Tn+amlvEouUhcanrVFnyMyr1JE4hOoQkU4S/zh8pLlcphkAMc9zPp5Mzd
         V0ytmrHvyNqR/CRHPY8eYCQGac6CoG1vfly6sYAFu1Omaw5HfD10oz7EUzBOFX1Cx/qg
         sf6F8e8vpgVm3Ru8zEblt5RXbmtqXpzaJu9UezTjiKjSD+5dEpShmcyrqSPI06HCVyKK
         sm4RlNCOo5cHiklOO1Db0BGqVx+IylTm/rgPhw4onLaFORMYm08Nk6x/z+iV3/RR8mQ+
         q31yKD8G7fyLpFpEOnQgksjkB45f52cckQCJ6ftpceOIF/TgVQ8RGUftkojjXlerszhM
         KPLw==
X-Gm-Message-State: AOJu0Yy8xKoQx7UHhlRZAbNnOSL1RnSFMZM49Chk5XLsQvOTbhr9QOXC
	JXHjHtHWcTOjFWuZ5tlhDel4VHpv57k/UEa1DfAOoqLMz6P/7+k3BRShJCOLuA8Br791ustO8ip
	kyJ+XPCTTxbvxudcFBKpR6Me9WRLsYa3yQ08Zh8jhgXtlHmESRmCx4WWq/y8Tu4h6NYn4Ch2v3Z
	vIvBCB/WRh7/gUyJkgQW46qp+VoIf5irC5XA==
X-Gm-Gg: ASbGnct0BwMGJtQsk6Q6Bo+dK4fYM0DVYB8l2Gpbxd+mtci4LL04RHaThF8l7QYDatI
	voeijvenxzt4ePJ3PJJviVEUUcg+B6j76UkLaCdFtrkfsdBooBIKPIwikg6hWSjtCsDxsrnTC
X-Received: by 2002:a05:6122:8cb:b0:520:61ee:c7f9 with SMTP id 71dfb90a1353d-5235b8bdff9mr11040226e0c.7.1741091164175;
        Tue, 04 Mar 2025 04:26:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEDx6gb5PkgjLLCOLIzl90WqunTEE7EQsEwOsTsqYJiseyYhhjqfEqGPQUG/CKHdvbnbwPqBu6zfbyu6w6fgJ8=
X-Received: by 2002:a05:6122:8cb:b0:520:61ee:c7f9 with SMTP id
 71dfb90a1353d-5235b8bdff9mr11040213e0c.7.1741091163468; Tue, 04 Mar 2025
 04:26:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250210230158.178252-1-slava@dubeyko.com>
In-Reply-To: <20250210230158.178252-1-slava@dubeyko.com>
From: Alex Markuze <amarkuze@redhat.com>
Date: Tue, 4 Mar 2025 14:25:52 +0200
X-Gm-Features: AQ5f1JrKEQat7dUiIiUY01cOWoVYIvjvvDzSNqKlBBDzj9AmH1rjDWwazh-wGvQ
Message-ID: <CAO8a2SgEcLQyd0w3Rg3AOyZMN0nsFc7r78AWAxr9i9nvwZUnWw@mail.gmail.com>
Subject: Re: [PATCH] ceph: cleanup hardcoded constants of file handle size
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: ceph-devel@vger.kernel.org, idryomov@gmail.com, 
	linux-fsdevel@vger.kernel.org, pdonnell@redhat.com, Slava.Dubeyko@ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Reviewed-by: Alex Markuze <amarkuze@redhat.com>

On Tue, Feb 11, 2025 at 1:02=E2=80=AFAM Viacheslav Dubeyko <slava@dubeyko.c=
om> wrote:
>
> From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
>
> The ceph/export.c contains very confusing logic of
> file handle size calculation based on hardcoded values.
> This patch makes the cleanup of this logic by means of
> introduction the named constants.
>
> Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
> ---
>  fs/ceph/export.c | 21 +++++++++++++--------
>  1 file changed, 13 insertions(+), 8 deletions(-)
>
> diff --git a/fs/ceph/export.c b/fs/ceph/export.c
> index 150076ced937..b2f2af104679 100644
> --- a/fs/ceph/export.c
> +++ b/fs/ceph/export.c
> @@ -33,12 +33,19 @@ struct ceph_nfs_snapfh {
>         u32 hash;
>  } __attribute__ ((packed));
>
> +#define BYTES_PER_U32          (sizeof(u32))
> +#define CEPH_FH_BASIC_SIZE \
> +       (sizeof(struct ceph_nfs_fh) / BYTES_PER_U32)
> +#define CEPH_FH_WITH_PARENT_SIZE \
> +       (sizeof(struct ceph_nfs_confh) / BYTES_PER_U32)
> +#define CEPH_FH_SNAPPED_INODE_SIZE \
> +       (sizeof(struct ceph_nfs_snapfh) / BYTES_PER_U32)
> +
>  static int ceph_encode_snapfh(struct inode *inode, u32 *rawfh, int *max_=
len,
>                               struct inode *parent_inode)
>  {
>         struct ceph_client *cl =3D ceph_inode_to_client(inode);
> -       static const int snap_handle_length =3D
> -               sizeof(struct ceph_nfs_snapfh) >> 2;
> +       static const int snap_handle_length =3D CEPH_FH_SNAPPED_INODE_SIZ=
E;
>         struct ceph_nfs_snapfh *sfh =3D (void *)rawfh;
>         u64 snapid =3D ceph_snap(inode);
>         int ret;
> @@ -88,10 +95,8 @@ static int ceph_encode_fh(struct inode *inode, u32 *ra=
wfh, int *max_len,
>                           struct inode *parent_inode)
>  {
>         struct ceph_client *cl =3D ceph_inode_to_client(inode);
> -       static const int handle_length =3D
> -               sizeof(struct ceph_nfs_fh) >> 2;
> -       static const int connected_handle_length =3D
> -               sizeof(struct ceph_nfs_confh) >> 2;
> +       static const int handle_length =3D CEPH_FH_BASIC_SIZE;
> +       static const int connected_handle_length =3D CEPH_FH_WITH_PARENT_=
SIZE;
>         int type;
>
>         if (ceph_snap(inode) !=3D CEPH_NOSNAP)
> @@ -308,7 +313,7 @@ static struct dentry *ceph_fh_to_dentry(struct super_=
block *sb,
>         if (fh_type !=3D FILEID_INO32_GEN  &&
>             fh_type !=3D FILEID_INO32_GEN_PARENT)
>                 return NULL;
> -       if (fh_len < sizeof(*fh) / 4)
> +       if (fh_len < sizeof(*fh) / BYTES_PER_U32)
>                 return NULL;
>
>         doutc(fsc->client, "%llx\n", fh->ino);
> @@ -427,7 +432,7 @@ static struct dentry *ceph_fh_to_parent(struct super_=
block *sb,
>
>         if (fh_type !=3D FILEID_INO32_GEN_PARENT)
>                 return NULL;
> -       if (fh_len < sizeof(*cfh) / 4)
> +       if (fh_len < sizeof(*cfh) / BYTES_PER_U32)
>                 return NULL;
>
>         doutc(fsc->client, "%llx\n", cfh->parent_ino);
> --
> 2.48.0
>


