Return-Path: <ceph-devel+bounces-2342-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 42B669F2FD5
	for <lists+ceph-devel@lfdr.de>; Mon, 16 Dec 2024 12:53:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4DF057A2DA1
	for <lists+ceph-devel@lfdr.de>; Mon, 16 Dec 2024 11:53:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EBAB204589;
	Mon, 16 Dec 2024 11:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z59HD+Df"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C45C204577
	for <ceph-devel@vger.kernel.org>; Mon, 16 Dec 2024 11:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734349889; cv=none; b=i0tou5W6Gyo3ZvxOL4IO9bA3Iho2nDFrjg9IrCFjP44aL+7qxI4+W64WpJKxLc/IK4VAZL3ipZiTCP18tWWheYGNVMoGKuMaHvGZNP0P9zBzsTngff22pMmEhvI1d+PE/MKTAHQM58P4aOqhasKZUh+145PNO1LF6oNN8sxmUH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734349889; c=relaxed/simple;
	bh=EdcXrJM8eciF75ssg1aOMtBd/pzZtUA4Inzd7mCN6Aw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=md92ofAMeuxW27TaFAxiiMv+8Z10vTVA+1QNTp62haF+z4XRudkCTQdVYEdYbQ83TRRIiGYu8Je6ttPN6rGOFzgbfc4nFwd1SK42qfOADrc03KVizabiWwg478ulIGVUUFitHI3BUHwj6P4j0jxYcjNvgUjRK/bC9sVdiJ/6hRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z59HD+Df; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734349884;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RnPQjDEcgL8iaO19tcntyyUWKSo+4FgA82NHisxYZ9g=;
	b=Z59HD+DfZzuQAqywlRyXkGHlWx73Y0zQyY20+IXVK7HFL0ziUxY0qPq35jx4RvJDR4Kib6
	quQXZlKbiFjM6YiNyE5QZ2IqQzisCgveS6bbMmykboH6GKnR/sxRAXCcemLzslgFeZWpqW
	beIZbO+F5GeBqky1T+BzoBJyj9FT3i8=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-641-HWD6uR8sNb2PDnvDAfhpGw-1; Mon, 16 Dec 2024 06:51:23 -0500
X-MC-Unique: HWD6uR8sNb2PDnvDAfhpGw-1
X-Mimecast-MFC-AGG-ID: HWD6uR8sNb2PDnvDAfhpGw
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-aa68203d288so299083066b.1
        for <ceph-devel@vger.kernel.org>; Mon, 16 Dec 2024 03:51:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734349882; x=1734954682;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RnPQjDEcgL8iaO19tcntyyUWKSo+4FgA82NHisxYZ9g=;
        b=PssLEP+2GmwZ5HXp5i02AEIQtfF4Q93Fc7nUMx9p5K7/2tqRtocvFUTFbrOLVYD5zE
         LqJqthCBuLp9KXW+ucXMStVZpuBZ1cKqOyl3fEpNSwKgQ0/qdvQqwKpSJQQ3F7WseZ7O
         7YerRjD+39wXLFscNcFbTeRv4S0ttJQgSZ0zNgz4lfSvWomkpIv2kVKdJYM5JybKEn7p
         AhP833QGH3k54qk+x9TF6XuWeoo3TXrtCHu4UBlwiYCK/fuQtLe4zKhpS1SmPPBMioav
         dwfdOFQfK08XffR/1xVZVN8qaUfsrCgQBEpQUV42ASMKMIuMNrzTUDLhpSwIGQ0fLgCc
         GqXA==
X-Gm-Message-State: AOJu0Yz/8NHr09L5ePA3jqajWcwegdFy/zWtZEOpBl2+Ip8gzf9OYpqr
	bDd8IvIkgnTWaNdD4oP/TUnQTjgNyXYan+h1Ezz1Re2z/TJNDLbXJNqB5Ijt3CqUNsKuJirouv4
	OxmKgy6r44jpcr/GsXTtLwF1+FKV3Mmi9jZ4rdvpL4zoP+Mls+2R17kUuZ70xBLO87/0bPb59rj
	vUYs43i+fc/mKutaTbnZlJyuK8yh17G85YqMFjgQLhsrxH
X-Gm-Gg: ASbGncu+LWkfR5nvLmjEMyPDmGnPOWXFA0xNdiO9dIlxQDa56KvbqsROc2LyqdrsShW
	hlmsuH5QNovreCn6qtuJW8IyPk+3pxjmwZ2k=
X-Received: by 2002:a17:907:9690:b0:aa6:ac19:7502 with SMTP id a640c23a62f3a-aab778e0769mr1069562166b.4.1734349882395;
        Mon, 16 Dec 2024 03:51:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFAOZ112rlmPL61foQzhWwfs/lgW6vyvHe217pV0qzLjSMBCsLb5HyfJmg26dPAxaygGgSWaCYbxu+ybsI2FcQ=
X-Received: by 2002:a17:907:9690:b0:aa6:ac19:7502 with SMTP id
 a640c23a62f3a-aab778e0769mr1069560966b.4.1734349882091; Mon, 16 Dec 2024
 03:51:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241207182622.97113-1-idryomov@gmail.com> <20241207182622.97113-2-idryomov@gmail.com>
In-Reply-To: <20241207182622.97113-2-idryomov@gmail.com>
From: Alex Markuze <amarkuze@redhat.com>
Date: Mon, 16 Dec 2024 13:51:11 +0200
Message-ID: <CAO8a2Sj9Ks4QMDgU+5-DoEXx86GVkdtAS0DqhvrBqSc68xv67g@mail.gmail.com>
Subject: Re: [PATCH 1/2] ceph: fix memory leak in ceph_direct_read_write()
To: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org, Max Kellermann <max.kellermann@ionos.com>, 
	Jeff Layton <jlayton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Reviewed-by: Alex Markuze <amarkuze@redhat.com>

On Sat, Dec 7, 2024 at 8:26=E2=80=AFPM Ilya Dryomov <idryomov@gmail.com> wr=
ote:
>
> The bvecs array which is allocated in iter_get_bvecs_alloc() is leaked
> and pages remain pinned if ceph_alloc_sparse_ext_map() fails.
>
> There is no need to delay the allocation of sparse_ext map until after
> the bvecs array is set up, so fix this by moving sparse_ext allocation
> a bit earlier.  Also, make a similar adjustment in __ceph_sync_read()
> for consistency (a leak of the same kind in __ceph_sync_read() has been
> addressed differently).
>
> Cc: stable@vger.kernel.org
> Fixes: 03bc06c7b0bd ("ceph: add new mount option to enable sparse reads")
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> ---
>  fs/ceph/file.c | 43 ++++++++++++++++++++++---------------------
>  1 file changed, 22 insertions(+), 21 deletions(-)
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index f9bb9e5493ce..0df2ffc69e92 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -1116,6 +1116,16 @@ ssize_t __ceph_sync_read(struct inode *inode, loff=
_t *ki_pos,
>                         len =3D read_off + read_len - off;
>                 more =3D len < iov_iter_count(to);
>
> +               op =3D &req->r_ops[0];
> +               if (sparse) {
> +                       extent_cnt =3D __ceph_sparse_read_ext_count(inode=
, read_len);
> +                       ret =3D ceph_alloc_sparse_ext_map(op, extent_cnt)=
;
> +                       if (ret) {
> +                               ceph_osdc_put_request(req);
> +                               break;
> +                       }
> +               }
> +
>                 num_pages =3D calc_pages_for(read_off, read_len);
>                 page_off =3D offset_in_page(off);
>                 pages =3D ceph_alloc_page_vector(num_pages, GFP_KERNEL);
> @@ -1129,16 +1139,6 @@ ssize_t __ceph_sync_read(struct inode *inode, loff=
_t *ki_pos,
>                                                  offset_in_page(read_off)=
,
>                                                  false, true);
>
> -               op =3D &req->r_ops[0];
> -               if (sparse) {
> -                       extent_cnt =3D __ceph_sparse_read_ext_count(inode=
, read_len);
> -                       ret =3D ceph_alloc_sparse_ext_map(op, extent_cnt)=
;
> -                       if (ret) {
> -                               ceph_osdc_put_request(req);
> -                               break;
> -                       }
> -               }
> -
>                 ceph_osdc_start_request(osdc, req);
>                 ret =3D ceph_osdc_wait_request(osdc, req);
>
> @@ -1557,6 +1557,16 @@ ceph_direct_read_write(struct kiocb *iocb, struct =
iov_iter *iter,
>                         break;
>                 }
>
> +               op =3D &req->r_ops[0];
> +               if (sparse) {
> +                       extent_cnt =3D __ceph_sparse_read_ext_count(inode=
, size);
> +                       ret =3D ceph_alloc_sparse_ext_map(op, extent_cnt)=
;
> +                       if (ret) {
> +                               ceph_osdc_put_request(req);
> +                               break;
> +                       }
> +               }
> +
>                 len =3D iter_get_bvecs_alloc(iter, size, &bvecs, &num_pag=
es);
>                 if (len < 0) {
>                         ceph_osdc_put_request(req);
> @@ -1566,6 +1576,8 @@ ceph_direct_read_write(struct kiocb *iocb, struct i=
ov_iter *iter,
>                 if (len !=3D size)
>                         osd_req_op_extent_update(req, 0, len);
>
> +               osd_req_op_extent_osd_data_bvecs(req, 0, bvecs, num_pages=
, len);
> +
>                 /*
>                  * To simplify error handling, allow AIO when IO within i=
_size
>                  * or IO can be satisfied by single OSD request.
> @@ -1597,17 +1609,6 @@ ceph_direct_read_write(struct kiocb *iocb, struct =
iov_iter *iter,
>                         req->r_mtime =3D mtime;
>                 }
>
> -               osd_req_op_extent_osd_data_bvecs(req, 0, bvecs, num_pages=
, len);
> -               op =3D &req->r_ops[0];
> -               if (sparse) {
> -                       extent_cnt =3D __ceph_sparse_read_ext_count(inode=
, size);
> -                       ret =3D ceph_alloc_sparse_ext_map(op, extent_cnt)=
;
> -                       if (ret) {
> -                               ceph_osdc_put_request(req);
> -                               break;
> -                       }
> -               }
> -
>                 if (aio_req) {
>                         aio_req->total_len +=3D len;
>                         aio_req->num_reqs++;
> --
> 2.46.1
>
>


