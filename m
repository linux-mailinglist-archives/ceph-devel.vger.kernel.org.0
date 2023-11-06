Return-Path: <ceph-devel+bounces-47-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C2067E1FC3
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Nov 2023 12:17:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BD4BB1C20AE3
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Nov 2023 11:17:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B30718AE4;
	Mon,  6 Nov 2023 11:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s0vVvQxc"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D5812CA9
	for <ceph-devel@vger.kernel.org>; Mon,  6 Nov 2023 11:17:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A4DC433C9;
	Mon,  6 Nov 2023 11:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699269465;
	bh=BPNgVrNhOGNheEeibJvTEZN0Bv3R0GvHJn2FVskDr9M=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=s0vVvQxc3fJxois2dyVjc4mQ6uCnH1hIrnpRSiOxDjQWscJZeVSpXiGHbysMK1VSl
	 g3q9EoEQ2EFr3NvqPmCLrDTLZksn416m096OGlmxpHFtBU5ek8BMrNIGH5FSXJM8SO
	 mrwRyk5lq96OKfTBzPzTVKMxEMY8fPjaILYYeUMMJ04B0FSR7lWIKLkkfSOMHGHX7z
	 c5p3INICc4NCIutxgM/TTF0XhAko7YSAs2QuHgp0fjUBxJonKuhUO/19wwJEZnzzZ1
	 Rq9ZUxyjVRbjeegRft/p8ZijgbP1/YCO8ZP/R9ZeEHL12/+KMigeTyQ5/HvhYuYCX/
	 JBfR5MCkIYsXg==
Message-ID: <c6310e744cb34761b53963dc7b45f7164ac0defb.camel@kernel.org>
Subject: Re: [PATCH v2] libceph: increase the max extents check for sparse
 read
From: Jeff Layton <jlayton@kernel.org>
To: xiubli@redhat.com, ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com, vshankar@redhat.com, mchangir@redhat.com
Date: Mon, 06 Nov 2023 06:17:43 -0500
In-Reply-To: <20231106010300.247597-1-xiubli@redhat.com>
References: <20231106010300.247597-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2023-11-06 at 09:03 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
>=20
> There is no any limit for the extent array size and it's possible
> that we will hit 4096 limit just after a lot of random writes to
> a file and then read with a large size. In this case the messager
> will fail by reseting the connection and keeps resending the inflight
> IOs infinitely.
>=20
> Just increase the limit to a larger number and then warn it to
> let user know that allocating memory could fail with this.
>=20
> URL: https://tracker.ceph.com/issues/62081
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>=20
> V2:
> - Increase the MAX_EXTENTS instead of removing it.
> - Do not return an errno when hit the limit.
>=20
>=20
>  net/ceph/osd_client.c | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
>=20
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index c03d48bd3aff..050dc39065fb 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -5850,7 +5850,7 @@ static inline void convert_extent_map(struct ceph_s=
parse_read *sr)
>  }
>  #endif
> =20
> -#define MAX_EXTENTS 4096
> +#define MAX_EXTENTS (16*1024*1024)
> =20
>  static int osd_sparse_read(struct ceph_connection *con,
>  			   struct ceph_msg_data_cursor *cursor,
> @@ -5883,14 +5883,13 @@ static int osd_sparse_read(struct ceph_connection=
 *con,
>  		if (count > 0) {
>  			if (!sr->sr_extent || count > sr->sr_ext_len) {
>  				/*
> -				 * Apply a hard cap to the number of extents.
> -				 * If we have more, assume something is wrong.
> +				 * Warn if hits a hard cap to the number of extents.
> +				 * Too many extents could make the following
> +				 * kmalloc_array() fail.
>  				 */
> -				if (count > MAX_EXTENTS) {
> -					dout("%s: OSD returned 0x%x extents in a single reply!\n",
> -					     __func__, count);
> -					return -EREMOTEIO;
> -				}
> +				if (count > MAX_EXTENTS)
> +					pr_warn_ratelimited("%s: OSD returned 0x%x extents in a single repl=
y!\n",
> +							    __func__, count);
> =20
>  				/* no extent array provided, or too short */
>  				kfree(sr->sr_extent);

Looks reasonable.

Reviewed-by: Jeff Layton <jlayton@kernel.org>

