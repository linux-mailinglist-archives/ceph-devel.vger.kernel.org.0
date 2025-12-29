Return-Path: <ceph-devel+bounces-4232-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DBB72CE81A6
	for <lists+ceph-devel@lfdr.de>; Mon, 29 Dec 2025 21:08:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 22BA23017F28
	for <lists+ceph-devel@lfdr.de>; Mon, 29 Dec 2025 20:07:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8410924E4C6;
	Mon, 29 Dec 2025 20:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EkIoV+lR";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="pNGxw8Y7"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0FA5244675
	for <ceph-devel@vger.kernel.org>; Mon, 29 Dec 2025 20:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767038872; cv=none; b=axcEKcwFf/WxYSo5kFRls+sqs2RMtQsGZkFO55u2WM5um1DBu+iRlXEvFtv5elhzu3JqtFG32c8x6eiLEc/hODmu09Cvb4zprXK6PuUM3Y31j0ou/4VcvpQdLaVj2w9mR1kYDF5C4JBiOmy85oHUy3s2SwIWOa8/dcaOksWQX/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767038872; c=relaxed/simple;
	bh=/eFe5X/MiPQzCVRsOQR87ZwcRxHL+Xocet7VA0Yu+1E=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lkrKDkK2QzvPAL0Sf42As8d+L6Jxam40UL7iEyqXAQYUG8/zGYRnLSu3czqT45KaNR0DlqmnrjFrP1RPogBuWu70XV05PjfcUwReexldBbZmfFBIm6JOH6T9yXz1HG0BzyDdAptYRped6p7rtdAaa8Csc4VnWP7QNz3qaDE4yOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EkIoV+lR; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=pNGxw8Y7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767038868;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FANPnRx+d1+Aac+1y7bxs/DQO9wHzLZ4cKfY4uoxLLw=;
	b=EkIoV+lRmva5EWi1JcCbeVTC8OZIaQsUFUyJOsoDYFYJOdOTiDfHo+tmqKw4wF/I9llU/C
	xz8h6+hP641YGRD4gf788ELlLzlqCtLhOhh0f1nONHMOrWL28Cnx2OZEDb2iheplUnA8Ug
	ScSBAwseW6Z7yJKZbUa6gJ8pkvYP6po=
Received: from mail-yx1-f69.google.com (mail-yx1-f69.google.com
 [74.125.224.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-126-rhsguSSiPxKbFpUHb9Yxag-1; Mon, 29 Dec 2025 15:07:46 -0500
X-MC-Unique: rhsguSSiPxKbFpUHb9Yxag-1
X-Mimecast-MFC-AGG-ID: rhsguSSiPxKbFpUHb9Yxag_1767038866
Received: by mail-yx1-f69.google.com with SMTP id 956f58d0204a3-64473bfcb4eso13495500d50.2
        for <ceph-devel@vger.kernel.org>; Mon, 29 Dec 2025 12:07:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767038866; x=1767643666; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FANPnRx+d1+Aac+1y7bxs/DQO9wHzLZ4cKfY4uoxLLw=;
        b=pNGxw8Y7ReKRE4AfVu/tVnh5+Ra5dmxdDO+QHpJ5I2PJ1cBRoioo1uZ5SsTqYjyvsC
         77YaIjr7cN8NQ6oFbXKyH1EC5xKowfy8Lx+Mdvzf/3470fMZCagvHSkEz1EoSB3UN20g
         Omgm47tzhuzzEMU2+WD1VIRCY7XdoR5MG3cptE9HzpwrgTZEombgl2cAiY+jZALWRVkv
         8MbqsiK1p3bklaWSnd3N4JNfUqFbGqPoSAsVIZ5DnlnErazTAIVmAd3GL+CCk5bKqxb3
         72L6Q6JiM1EI9MEI56sJgIo0qMUbeyIrhNaJo7fG6bgyt5ROtes5uiKZMicgRy9pAyw8
         Zwlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767038866; x=1767643666;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FANPnRx+d1+Aac+1y7bxs/DQO9wHzLZ4cKfY4uoxLLw=;
        b=Lm/akx2mt+hXGZnU/Vw7fIjAilzbF4P3AVzq+lOZXeVh4RSswdwONTAiFHl0CJouwY
         W2CqWLkfwaBakLHT/ES7mKbqrvE1K0IeLYid1h7z/M3MS8CXvGn63vpE1WPA7+sPFSCb
         Ua1lvte0vuBWuvsB5NoI8Xm8L/GaonrF4yTK5pnI8q/hBMQKxlXnwjjQt5s69LYPoKmF
         qEnqGe1D1WmvfodbotXq9y0r/m4KOchxektDnMM5FNkMpG/oy3S5AyuU8IHN+mB2Jy1K
         Zw/UHxqdGMOZ21Zm4Sz9nXGjKhTx8zhgxfpoCsk9PIiXGEVHzEDbRa2iB5zQIjnaH1JZ
         /SiQ==
X-Forwarded-Encrypted: i=1; AJvYcCXuiyEaAIvhaduhg9IcVp6ey/EgkfXRpmJNawzlD+4R39ACSlMaTWfoOHyVkptwHDMdVLJQgcQibt3W@vger.kernel.org
X-Gm-Message-State: AOJu0YwiKuFBnAdKVJ0uiw8tSG0JTOtjqLBfT7ExHhLhRFkrwHf+xEA5
	T4rAFylwWogI+btyC5ezBd/jtrbMhfpb4x5KInKYxn3KOJoI6czLpKwFxa4jxlsPUBrTiSkWswD
	agECV8C5Sl/yA/hP7GV+GmgTU4jultjky51hjAcSrZKWIQl6Mdu2Sot35hYyt7CI=
X-Gm-Gg: AY/fxX6gf23ux+jX3laRVgmxlrtJ+3rWbjp9hW2PxLx1QN+wiQscAJ9eX5N+v2p3NuB
	w23jW583xVCu+XIg8BG3xY4wWTDRRLif+xi40TImwUxylHGI7YP8Nq9Ek/Kd9OM2iZr5up3lj7L
	pDRHgGGDWE7SsFet8N2C1muG4ARMd3ujUf7D78YxUsXc6hLpTwmH1jGOckJmrBG9N686VXLpSkA
	bflMhpx3iPx3l0cBwjbW9SINFBYw8GNHiIqvbwxpjI0dNaWB02z+bcukcm7viUrFbAexwVGfekl
	LGfHD3kHWh3j8hiWJily5AxzKjom0MPCITltZeQu/Bj6fs3hQF1TD1sP9BPfO58IqCqxIrvfnWx
	ZxAET7sIJ8ftBmC2mnebfrknUxN7avMHpSyAZqvMa
X-Received: by 2002:a05:690e:1248:b0:644:4259:9b64 with SMTP id 956f58d0204a3-6466a8a8827mr24430640d50.59.1767038866315;
        Mon, 29 Dec 2025 12:07:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHcZmVkrs11EQ/RkKg5nsD4LQaHPLeWIPuDuOrOg8pt0bwiJ3+n1wbkbeIZhkYmKh2w4fmzXA==
X-Received: by 2002:a05:690e:1248:b0:644:4259:9b64 with SMTP id 956f58d0204a3-6466a8a8827mr24430616d50.59.1767038865784;
        Mon, 29 Dec 2025 12:07:45 -0800 (PST)
Received: from li-4c4c4544-0032-4210-804c-c3c04f423534.ibm.com ([2600:1700:6476:1430::41])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6466a8b1948sm15187905d50.5.2025.12.29.12.07.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Dec 2025 12:07:45 -0800 (PST)
Message-ID: <dbb256f3e770ea469fea2be7b42b6e5a43c2eccb.camel@redhat.com>
Subject: Re: [PATCH v4 2/3] ceph: parse subvolume_id from InodeStat v9 and
 store in inode
From: Viacheslav Dubeyko <vdubeyko@redhat.com>
To: Alex Markuze <amarkuze@redhat.com>, ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com, linux-fsdevel@vger.kernel.org
Date: Mon, 29 Dec 2025 12:07:44 -0800
In-Reply-To: <20251223123510.796459-3-amarkuze@redhat.com>
References: <20251223123510.796459-1-amarkuze@redhat.com>
	 <20251223123510.796459-3-amarkuze@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 (3.58.2-1.fc43) 
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2025-12-23 at 12:35 +0000, Alex Markuze wrote:
> Add support for parsing the subvolume_id field from InodeStat v9 and
> storing it in the inode for later use by subvolume metrics tracking.
>=20
> The subvolume_id identifies which CephFS subvolume an inode belongs to,
> enabling per-subvolume I/O metrics collection and reporting.
>=20
> This patch:
> - Adds subvolume_id field to struct ceph_mds_reply_info_in
> - Adds i_subvolume_id field to struct ceph_inode_info
> - Parses subvolume_id from v9 InodeStat in parse_reply_info_in()
> - Adds ceph_inode_set_subvolume() helper to propagate the ID to inodes
> - Initializes i_subvolume_id in inode allocation and clears on destroy
>=20
> Signed-off-by: Alex Markuze <amarkuze@redhat.com>
> ---
>  fs/ceph/inode.c      | 23 +++++++++++++++++++++++
>  fs/ceph/mds_client.c |  7 +++++++
>  fs/ceph/mds_client.h |  1 +
>  fs/ceph/super.h      |  2 ++
>  4 files changed, 33 insertions(+)
>=20
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index a6e260d9e420..835049004047 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -638,6 +638,7 @@ struct inode *ceph_alloc_inode(struct super_block *sb=
)
> =20
>  	ci->i_max_bytes =3D 0;
>  	ci->i_max_files =3D 0;
> +	ci->i_subvolume_id =3D 0;

I still don't see the named constant here. It looks like the patch v3 4/4 w=
as
completely lost.

> =20
>  	memset(&ci->i_dir_layout, 0, sizeof(ci->i_dir_layout));
>  	memset(&ci->i_cached_layout, 0, sizeof(ci->i_cached_layout));
> @@ -742,6 +743,8 @@ void ceph_evict_inode(struct inode *inode)
> =20
>  	percpu_counter_dec(&mdsc->metric.total_inodes);
> =20
> +	ci->i_subvolume_id =3D 0;

Ditto.

> +
>  	netfs_wait_for_outstanding_io(inode);
>  	truncate_inode_pages_final(&inode->i_data);
>  	if (inode->i_state & I_PINNING_NETFS_WB)
> @@ -873,6 +876,22 @@ int ceph_fill_file_size(struct inode *inode, int iss=
ued,
>  	return queue_trunc;
>  }
> =20
> +/*
> + * Set the subvolume ID for an inode. Following the FUSE client conventi=
on,
> + * 0 means unknown/unset (MDS only sends non-zero IDs for subvolume inod=
es).
> + */
> +void ceph_inode_set_subvolume(struct inode *inode, u64 subvolume_id)
> +{
> +	struct ceph_inode_info *ci;
> +
> +	if (!inode || !subvolume_id)
> +		return;
> +
> +	ci =3D ceph_inode(inode);
> +	if (READ_ONCE(ci->i_subvolume_id) !=3D subvolume_id)
> +		WRITE_ONCE(ci->i_subvolume_id, subvolume_id);

The logic from patch v3 4/4 was completely lost.

> +}
> +
>  void ceph_fill_file_time(struct inode *inode, int issued,
>  			 u64 time_warp_seq, struct timespec64 *ctime,
>  			 struct timespec64 *mtime, struct timespec64 *atime)
> @@ -1087,6 +1106,7 @@ int ceph_fill_inode(struct inode *inode, struct pag=
e *locked_page,
>  	new_issued =3D ~issued & info_caps;
> =20
>  	__ceph_update_quota(ci, iinfo->max_bytes, iinfo->max_files);
> +	ceph_inode_set_subvolume(inode, iinfo->subvolume_id);
> =20
>  #ifdef CONFIG_FS_ENCRYPTION
>  	if (iinfo->fscrypt_auth_len &&
> @@ -1594,6 +1614,8 @@ int ceph_fill_trace(struct super_block *sb, struct =
ceph_mds_request *req)
>  			goto done;
>  		}
>  		if (parent_dir) {
> +			ceph_inode_set_subvolume(parent_dir,
> +						 rinfo->diri.subvolume_id);
>  			err =3D ceph_fill_inode(parent_dir, NULL, &rinfo->diri,
>  					      rinfo->dirfrag, session, -1,
>  					      &req->r_caps_reservation);
> @@ -1682,6 +1704,7 @@ int ceph_fill_trace(struct super_block *sb, struct =
ceph_mds_request *req)
>  		BUG_ON(!req->r_target_inode);
> =20
>  		in =3D req->r_target_inode;
> +		ceph_inode_set_subvolume(in, rinfo->targeti.subvolume_id);
>  		err =3D ceph_fill_inode(in, req->r_locked_page, &rinfo->targeti,
>  				NULL, session,
>  				(!test_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags) &&
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index d7d8178e1f9a..099b8f22683b 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -105,6 +105,8 @@ static int parse_reply_info_in(void **p, void *end,
>  	int err =3D 0;
>  	u8 struct_v =3D 0;
> =20
> +	info->subvolume_id =3D 0;

Ditto.

> +
>  	if (features =3D=3D (u64)-1) {
>  		u32 struct_len;
>  		u8 struct_compat;
> @@ -251,6 +253,10 @@ static int parse_reply_info_in(void **p, void *end,
>  			ceph_decode_skip_n(p, end, v8_struct_len, bad);
>  		}
> =20
> +		/* struct_v 9 added subvolume_id */
> +		if (struct_v >=3D 9)
> +			ceph_decode_64_safe(p, end, info->subvolume_id, bad);
> +
>  		*p =3D end;
>  	} else {
>  		/* legacy (unversioned) struct */
> @@ -3970,6 +3976,7 @@ static void handle_reply(struct ceph_mds_session *s=
ession, struct ceph_msg *msg)
>  			goto out_err;
>  		}
>  		req->r_target_inode =3D in;
> +		ceph_inode_set_subvolume(in, rinfo->targeti.subvolume_id);
>  	}
> =20
>  	mutex_lock(&session->s_mutex);
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index 0428a5eaf28c..bd3690baa65c 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -118,6 +118,7 @@ struct ceph_mds_reply_info_in {
>  	u32 fscrypt_file_len;
>  	u64 rsnaps;
>  	u64 change_attr;
> +	u64 subvolume_id;
>  };
> =20
>  struct ceph_mds_reply_dir_entry {
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index a1f781c46b41..c0372a725960 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -385,6 +385,7 @@ struct ceph_inode_info {
> =20
>  	/* quotas */
>  	u64 i_max_bytes, i_max_files;
> +	u64 i_subvolume_id;	/* 0 =3D unknown/unset, matches FUSE client */

Ditto.

Thanks,
Slava.

> =20
>  	s32 i_dir_pin;
> =20
> @@ -1057,6 +1058,7 @@ extern struct inode *ceph_get_inode(struct super_bl=
ock *sb,
>  extern struct inode *ceph_get_snapdir(struct inode *parent);
>  extern int ceph_fill_file_size(struct inode *inode, int issued,
>  			       u32 truncate_seq, u64 truncate_size, u64 size);
> +extern void ceph_inode_set_subvolume(struct inode *inode, u64 subvolume_=
id);
>  extern void ceph_fill_file_time(struct inode *inode, int issued,
>  				u64 time_warp_seq, struct timespec64 *ctime,
>  				struct timespec64 *mtime,


