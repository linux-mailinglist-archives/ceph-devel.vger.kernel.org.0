Return-Path: <ceph-devel+bounces-16-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E98A7DB80A
	for <lists+ceph-devel@lfdr.de>; Mon, 30 Oct 2023 11:26:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6E5091C20A65
	for <lists+ceph-devel@lfdr.de>; Mon, 30 Oct 2023 10:26:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EA47DDAE;
	Mon, 30 Oct 2023 10:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d1avcQci"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A14E11CB0
	for <ceph-devel@vger.kernel.org>; Mon, 30 Oct 2023 10:26:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D73E1C433C8;
	Mon, 30 Oct 2023 10:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698661610;
	bh=2fDYZCvioH1Y4TGb7Qdk2Ble94wSrNwJ8hnMgD3ZfRk=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=d1avcQci8FXYALFqivkM4Gr8jUZwh6A/ZB9caoAynnK/Y7+e2lwipqK2G0AudkfUR
	 UjR9fZldEMQoL8Xp1RPkObR0tVBrcRlt/vxZzhw9aAuXoEllGsGslxU+hepNOcuQtd
	 RwRCKgXYx5pa0Y0CcKKNNecUS+qAVqt2cnPBM74rKw0lMlS7bM7FMUCiQJdqCV4M5m
	 TVpJnRLVXQH3A0f2WopJ35WL2Va1N//U6NvE2w4gOmYoxA1/IdiFW5tP1WyIMv0Lb+
	 gjtqw+jb9gvvoamJAoB+QXhkXB6zIp9Tp/x66Snh93aPpAR7Tx9UZ8CzgKZBjv4oIv
	 xXokmLZfRDdTg==
Message-ID: <295e074f8217539085bbbe7261788f8bbe25b88a.camel@kernel.org>
Subject: Re: [PATCH 2/3] libceph: save and covert sr_datalen to host-endian
From: Jeff Layton <jlayton@kernel.org>
To: xiubli@redhat.com, ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com, vshankar@redhat.com, mchangir@redhat.com
Date: Mon, 30 Oct 2023 06:26:48 -0400
In-Reply-To: <20231024050039.231143-3-xiubli@redhat.com>
References: <20231024050039.231143-1-xiubli@redhat.com>
	 <20231024050039.231143-3-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2023-10-24 at 13:00 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
>=20
> We need to save the real data length to determine exactly how many
> data we can parse later.
>=20
> URL: https://tracker.ceph.com/issues/62081
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  include/linux/ceph/osd_client.h | 3 ++-
>  net/ceph/osd_client.c           | 7 ++++++-
>  2 files changed, 8 insertions(+), 2 deletions(-)
>=20
> diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_cli=
ent.h
> index bf9823956758..f703fb8030de 100644
> --- a/include/linux/ceph/osd_client.h
> +++ b/include/linux/ceph/osd_client.h
> @@ -45,6 +45,7 @@ enum ceph_sparse_read_state {
>  	CEPH_SPARSE_READ_HDR	=3D 0,
>  	CEPH_SPARSE_READ_EXTENTS,
>  	CEPH_SPARSE_READ_DATA_LEN,
> +	CEPH_SPARSE_READ_DATA_PRE,
>  	CEPH_SPARSE_READ_DATA,
>  };
> =20
> @@ -64,7 +65,7 @@ struct ceph_sparse_read {
>  	u64				sr_req_len;  /* orig request length */
>  	u64				sr_pos;      /* current pos in buffer */
>  	int				sr_index;    /* current extent index */
> -	__le32				sr_datalen;  /* length of actual data */
> +	u32				sr_datalen;  /* length of actual data */
>  	u32				sr_count;    /* extent count in reply */
>  	int				sr_ext_len;  /* length of extent array */
>  	struct ceph_sparse_extent	*sr_extent;  /* extent array */
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index d3a759e052c8..800a2acec069 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -5912,8 +5912,13 @@ static int osd_sparse_read(struct ceph_connection =
*con,
>  		convert_extent_map(sr);
>  		ret =3D sizeof(sr->sr_datalen);
>  		*pbuf =3D (char *)&sr->sr_datalen;
> -		sr->sr_state =3D CEPH_SPARSE_READ_DATA;
> +		sr->sr_state =3D CEPH_SPARSE_READ_DATA_PRE;
>  		break;
> +	case CEPH_SPARSE_READ_DATA_PRE:
> +		/* Convert sr_datalen to host-endian */
> +		sr->sr_datalen =3D le32_to_cpu((__force __le32)sr->sr_datalen);
> +		sr->sr_state =3D CEPH_SPARSE_READ_DATA;
> +		fallthrough;
>  	case CEPH_SPARSE_READ_DATA:
>  		if (sr->sr_index >=3D count) {
>  			sr->sr_state =3D CEPH_SPARSE_READ_HDR;


Reviewed-by: Jeff Layton <jlayton@kernel.org>

