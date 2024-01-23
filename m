Return-Path: <ceph-devel+bounces-650-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D12D8391B4
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Jan 2024 15:48:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 995ADB28129
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Jan 2024 14:48:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 506F55FBB5;
	Tue, 23 Jan 2024 14:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HYRgxoIY"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65EB5FBA5
	for <ceph-devel@vger.kernel.org>; Tue, 23 Jan 2024 14:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706021252; cv=none; b=Vwigo8TocNVnM0ZYzFkpHomEU6d271gIeGHmKjwKbTMoYBsgMN0t6BipqysFt0l+zOds2YDUkD2SsG/TMQyu09LZUY9ozz5fyxn+ImLzGmU6LBlG0GJMgEzZJzo/DxJGoCDkrEwhBr1by8BatvzGq3vGLp3lTsSP35AndVdFpIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706021252; c=relaxed/simple;
	bh=QJgyC7cxY5V5IFzjOf4r7f+zMhFCO886dVU1YqAm18Q=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JhaNBtSkKuN2w+1TUBp1f6gOUo6scCYKwNETUVKEw9h2HyKE83+6jiMwuCSFqbbi81WwsLAjT5DxdIGvJrwP57mIxS263aOnazF+NrJjRVTzt8x5CeRaM6Sekj/8jhGeEIOumUtK1HrXfPfInULmFm2xLRyjhYTIDHztUss9D24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HYRgxoIY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0BE6C43394;
	Tue, 23 Jan 2024 14:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706021252;
	bh=QJgyC7cxY5V5IFzjOf4r7f+zMhFCO886dVU1YqAm18Q=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=HYRgxoIYlqqIzcAMPEq9096kxzwnILdTrL9XYch4AOKxD5/dYq8pfq1hmhlj3ukvE
	 MfxzAJY7xMuFoH95IcxnN8Ns4Wg5Ekvbv62ZbG+wPdWw4t9gZYgvz9n0Tmj3ulEQYq
	 prkLA/kno2my+jOmPrWFbFFD9lkEJrHUx7WJ7xe1Y+dzmfaUjWM+yUIRVEXVrR2dAG
	 w2ws2WYtzR+NgdjNkcJ/TTp1i7torliNUBGg4lEw+N4iqJ/YHI+Tr3XolpED3Qx0k5
	 IqEKADMIESD7tqMPBN49tUd2Cgj62gJnEd5PYSRIeden4MVcPYGuWTSaIJ1shRv6Kf
	 RDKukmtB172Uw==
Message-ID: <3139b844b60348f306449e3ea4a3c91c40a18d74.camel@kernel.org>
Subject: Re: [PATCH v5 3/3] libceph: just wait for more data to be available
 on the socket
From: Jeff Layton <jlayton@kernel.org>
To: xiubli@redhat.com, ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com, vshankar@redhat.com, mchangir@redhat.com
Date: Tue, 23 Jan 2024 09:47:30 -0500
In-Reply-To: <20240123131204.1166101-4-xiubli@redhat.com>
References: <20240123131204.1166101-1-xiubli@redhat.com>
	 <20240123131204.1166101-4-xiubli@redhat.com>
Autocrypt: addr=jlayton@kernel.org; prefer-encrypt=mutual;
 keydata=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
	kZWuOsJdJQdmwlWC5L5ln9xgfr/4mOY38B0U=
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.3 (3.50.3-1.fc39) 
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2024-01-23 at 21:12 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
>=20
> A short read may occur while reading the message footer from the
> socket.  Later, when the socket is ready for another read, the
> messenger shoudl invoke all read_partial* handlers, except the
> read_partial_sparse_msg_data().  The contract between the messenger
> and these handlers is that the handlers should bail if the area
> of the message is responsible for is already processed.  So,
> in this case, it's expected that read_sparse_msg_data() would bail,
> allowing the messenger to invoke read_partial() for the footer and
> pick up where it left off.
>=20
> However read_partial_sparse_msg_data() violates that contract and
> ends up calling into the state machine in the OSD client. The
> sparse-read state machine just assumes that it's a new op and
> interprets some piece of the footer as the sparse-read extents/data
> and then returns bogus extents/data length, etc.
>=20
> This will just reuse the 'total_resid' to determine whether should
> the read_partial_sparse_msg_data() bail out or not. Because once
> it reaches to zero that means all the extents and data have been
> successfully received in last read, else it could break out when
> partially reading any of the extents and data. And then the
> osd_sparse_read() could continue where it left off.
>=20

Thanks for the detailed description. That really helps!

> URL: https://tracker.ceph.com/issues/63586
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  include/linux/ceph/messenger.h |  2 +-
>  net/ceph/messenger_v1.c        | 25 +++++++++++++------------
>  net/ceph/messenger_v2.c        |  4 ++--
>  net/ceph/osd_client.c          |  9 +++------
>  4 files changed, 19 insertions(+), 21 deletions(-)
>=20
> diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenge=
r.h
> index 2eaaabbe98cb..1717cc57cdac 100644
> --- a/include/linux/ceph/messenger.h
> +++ b/include/linux/ceph/messenger.h
> @@ -283,7 +283,7 @@ struct ceph_msg {
>  	struct kref kref;
>  	bool more_to_follow;
>  	bool needs_out_seq;
> -	bool sparse_read;
> +	u64 sparse_read_total;
>  	int front_alloc_len;
> =20
>  	struct ceph_msgpool *pool;
> diff --git a/net/ceph/messenger_v1.c b/net/ceph/messenger_v1.c
> index 4cb60bacf5f5..4c76c8390de1 100644
> --- a/net/ceph/messenger_v1.c
> +++ b/net/ceph/messenger_v1.c
> @@ -160,8 +160,9 @@ static size_t sizeof_footer(struct ceph_connection *c=
on)
>  static void prepare_message_data(struct ceph_msg *msg, u32 data_len)
>  {
>  	/* Initialize data cursor if it's not a sparse read */
> -	if (!msg->sparse_read)
> -		ceph_msg_data_cursor_init(&msg->cursor, msg, data_len);
> +	u64 len =3D msg->sparse_read_total ? : data_len;
> +
> +	ceph_msg_data_cursor_init(&msg->cursor, msg, len);
>  }
> =20
>  /*
> @@ -1036,7 +1037,7 @@ static int read_partial_sparse_msg_data(struct ceph=
_connection *con)
>  	if (do_datacrc)
>  		crc =3D con->in_data_crc;
> =20
> -	do {
> +	while (cursor->total_resid) {
>  		if (con->v1.in_sr_kvec.iov_base)
>  			ret =3D read_partial_message_chunk(con,
>  							 &con->v1.in_sr_kvec,
> @@ -1044,23 +1045,23 @@ static int read_partial_sparse_msg_data(struct ce=
ph_connection *con)
>  							 &crc);
>  		else if (cursor->sr_resid > 0)
>  			ret =3D read_partial_sparse_msg_extent(con, &crc);
> -
> -		if (ret <=3D 0) {
> -			if (do_datacrc)
> -				con->in_data_crc =3D crc;
> -			return ret;
> -		}
> +		if (ret <=3D 0)
> +			break;
> =20
>  		memset(&con->v1.in_sr_kvec, 0, sizeof(con->v1.in_sr_kvec));
>  		ret =3D con->ops->sparse_read(con, cursor,
>  				(char **)&con->v1.in_sr_kvec.iov_base);
> +		if (ret <=3D 0) {
> +			ret =3D ret ? : 1; /* must return > 0 to indicate success */

nit: this syntax is a gcc-ism (AIUI) and is not preferred. It'd be
better spell it out in this case (particularly since it's only 4 extra
chars:

			ret =3D ret ? ret : 1;

> +			break;
> +		}
>  		con->v1.in_sr_len =3D ret;
> -	} while (ret > 0);
> +	}
> =20
>  	if (do_datacrc)
>  		con->in_data_crc =3D crc;
> =20
> -	return ret < 0 ? ret : 1;  /* must return > 0 to indicate success */
> +	return ret;
>  }
> =20
>  static int read_partial_msg_data(struct ceph_connection *con)
> @@ -1253,7 +1254,7 @@ static int read_partial_message(struct ceph_connect=
ion *con)
>  		if (!m->num_data_items)
>  			return -EIO;
> =20
> -		if (m->sparse_read)
> +		if (m->sparse_read_total)
>  			ret =3D read_partial_sparse_msg_data(con);
>  		else if (ceph_test_opt(from_msgr(con->msgr), RXBOUNCE))
>  			ret =3D read_partial_msg_data_bounce(con);
> diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
> index f8ec60e1aba3..a0ca5414b333 100644
> --- a/net/ceph/messenger_v2.c
> +++ b/net/ceph/messenger_v2.c
> @@ -1128,7 +1128,7 @@ static int decrypt_tail(struct ceph_connection *con=
)
>  	struct sg_table enc_sgt =3D {};
>  	struct sg_table sgt =3D {};
>  	struct page **pages =3D NULL;
> -	bool sparse =3D con->in_msg->sparse_read;
> +	bool sparse =3D !!con->in_msg->sparse_read_total;
>  	int dpos =3D 0;
>  	int tail_len;
>  	int ret;
> @@ -2060,7 +2060,7 @@ static int prepare_read_tail_plain(struct ceph_conn=
ection *con)
>  	}
> =20
>  	if (data_len(msg)) {
> -		if (msg->sparse_read)
> +		if (msg->sparse_read_total)
>  			con->v2.in_state =3D IN_S_PREPARE_SPARSE_DATA;
>  		else
>  			con->v2.in_state =3D IN_S_PREPARE_READ_DATA;
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index 6beab9be51e2..1a5b1e1e24ca 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -5510,7 +5510,7 @@ static struct ceph_msg *get_reply(struct ceph_conne=
ction *con,
>  	}
> =20
>  	m =3D ceph_msg_get(req->r_reply);
> -	m->sparse_read =3D (bool)srlen;
> +	m->sparse_read_total =3D srlen;
> =20
>  	dout("get_reply tid %lld %p\n", tid, m);
> =20
> @@ -5777,11 +5777,8 @@ static int prep_next_sparse_read(struct ceph_conne=
ction *con,
>  	}
> =20
>  	if (o->o_sparse_op_idx < 0) {
> -		u64 srlen =3D sparse_data_requested(req);
> -
> -		dout("%s: [%d] starting new sparse read req. srlen=3D0x%llx\n",
> -		     __func__, o->o_osd, srlen);
> -		ceph_msg_data_cursor_init(cursor, con->in_msg, srlen);
> +		dout("%s: [%d] starting new sparse read req\n",
> +		     __func__, o->o_osd);
>  	} else {
>  		u64 end;
> =20

The patch itself looks fine though.

Reviewed-by: Jeff Layton <jlayton@kernel.org>

