Return-Path: <ceph-devel+bounces-17-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD6487DB816
	for <lists+ceph-devel@lfdr.de>; Mon, 30 Oct 2023 11:27:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9C680B20D1F
	for <lists+ceph-devel@lfdr.de>; Mon, 30 Oct 2023 10:27:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7108F11C93;
	Mon, 30 Oct 2023 10:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D5HBZmSh"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113E0DDDF
	for <ceph-devel@vger.kernel.org>; Mon, 30 Oct 2023 10:27:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F07FC433C8;
	Mon, 30 Oct 2023 10:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698661654;
	bh=/8qqJvD80mfaFQGVhACpKeLa08FE08VtZT0Jhu0e78o=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=D5HBZmShJGy6BRqLiGbDme1LfDPUunBp1nikCdIggHd3a5NYwmze2ZqZncCPGAIAI
	 aP0nqgs96J/X2TzRWP96EPAeadU39vPs/nRcEfnKUJO6MjCusPf26d+pErtWmtb5xF
	 gm3rTfYUjabylYtLQ1vgbLP41lY7sblA5yXcdXl3Aj2UiDKv0OA/ypGZ7YBH2ORZbC
	 6CRJhJ3UKt86/fZeO8VLoGpdmgOxeS4r0m5mzBVDQ9a8WkYAgngJewYTjIkLL8DF2E
	 fr6JlpLP97XIcebsRFY+GI9rh4b2I6kPRFYmRpr+dAGhSiVbUuDckpXKaVRjYXLoiT
	 X7H6Ws+8Zh4VQ==
Message-ID: <69be7ac2f83462d7df9766b7280eef936d3ee11d.camel@kernel.org>
Subject: Re: [PATCH 3/3] libceph: check the data length when finishes
From: Jeff Layton <jlayton@kernel.org>
To: xiubli@redhat.com, ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com, vshankar@redhat.com, mchangir@redhat.com
Date: Mon, 30 Oct 2023 06:27:33 -0400
In-Reply-To: <20231024050039.231143-4-xiubli@redhat.com>
References: <20231024050039.231143-1-xiubli@redhat.com>
	 <20231024050039.231143-4-xiubli@redhat.com>
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
> For sparse reading the real length of the data should equal to the
> total length from the extent array.
>=20
> URL: https://tracker.ceph.com/issues/62081
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  net/ceph/osd_client.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>=20
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index 800a2acec069..7af35106acaf 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -5921,6 +5921,13 @@ static int osd_sparse_read(struct ceph_connection =
*con,
>  		fallthrough;
>  	case CEPH_SPARSE_READ_DATA:
>  		if (sr->sr_index >=3D count) {
> +			if (sr->sr_datalen && count) {
> +				pr_warn_ratelimited("sr_datalen %d sr_index %d count %d\n",
> +						    sr->sr_datalen, sr->sr_index,
> +						    count);
> +				WARN_ON_ONCE(sr->sr_datalen);
> +			}
> +
>  			sr->sr_state =3D CEPH_SPARSE_READ_HDR;
>  			goto next_op;
>  		}
> @@ -5928,6 +5935,8 @@ static int osd_sparse_read(struct ceph_connection *=
con,
>  		eoff =3D sr->sr_extent[sr->sr_index].off;
>  		elen =3D sr->sr_extent[sr->sr_index].len;
> =20
> +		sr->sr_datalen -=3D elen;
> +
>  		dout("[%d] ext %d off 0x%llx len 0x%llx\n",
>  		     o->o_osd, sr->sr_index, eoff, elen);
> =20

Seems like a reasonable sanity check.

Reviewed-by: Jeff Layton <jlayton@kernel.org>

