Return-Path: <ceph-devel+bounces-921-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 95559869D8D
	for <lists+ceph-devel@lfdr.de>; Tue, 27 Feb 2024 18:27:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4C47F28528A
	for <lists+ceph-devel@lfdr.de>; Tue, 27 Feb 2024 17:27:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE41913A884;
	Tue, 27 Feb 2024 17:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="j0Y4guR5";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="qpIkoT9E";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="L1Evg5D5";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Nb4Lh4H5"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD12A148300
	for <ceph-devel@vger.kernel.org>; Tue, 27 Feb 2024 17:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709054583; cv=none; b=n6OtWRxXY+35MbircmKskWXNfarjjnwysKUwl93MeOR+yx8xkw3E+wzLdEkpChxfgdY0Xq64gYUKZGlLcew1BKyZFeDqY6MDbENwPJKE83mhJcbcVFCdjPz3TQcHoJv75/mW+tR/MEnr0bruvhnyOXva1Muw9FhWtGOcB7IiUxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709054583; c=relaxed/simple;
	bh=b1NpiwnXh78BEsezwSpt9TknntjZmavUOBBrvE7g1po=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=RHcQQrT9vXl1ITkWAcF5hnMmWQLuQ0vzic6DRpOGoWDLlqrEmG8yjSNN1dPnKFslU+6gNghDjEfyTUMgXygT2/nJ/pipZ3CuqgBlm56abjgRFu4AOx9vR3NAUNZ/CtqZbegFEFMriRzLOCYixHXlrCwZGFu2gX3CeVS8Ibrb2/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=j0Y4guR5; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=qpIkoT9E; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=L1Evg5D5; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Nb4Lh4H5; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D1E6A22784;
	Tue, 27 Feb 2024 17:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1709054577; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F2RlJWCHX0+kB70dKeSM+eTaztKmmZDJ9TxNA/UJ2wA=;
	b=j0Y4guR5Ni9hldpEMegR3CMeGO7Z4RNSxSOKpRD6ilu4jyTFXAEoAAYIFX+nBiZ57/437L
	29K71Nq8WYy1Sj3Ym+/UCHM+lDjUR9eT1F5Tuj2kVSoBKcVTX2n43yeWCfcnEERCk/pk+6
	n0keIxo2xMWhyClNLXKoKU0+WZM3UBI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1709054577;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F2RlJWCHX0+kB70dKeSM+eTaztKmmZDJ9TxNA/UJ2wA=;
	b=qpIkoT9Ej8soe085M9bJ4gI7VKlVQ8p2DqJRFPq2FiaagGKfz3vJqK2jx44OOMkeSdF2Vi
	vUj2gi2+QFSt4KDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1709054576; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F2RlJWCHX0+kB70dKeSM+eTaztKmmZDJ9TxNA/UJ2wA=;
	b=L1Evg5D5rJVEs2VZ6fkiJPgUZUnU7phzANkeKd6n7FCkxBpAuw+vKKScMgShj9OB+uPoyQ
	UrRYV5fRmD9XkQBfld3ozQoxX+7Ogv8IXLDIYI+n9WLLrvfEzlLEsw0tNuWaxEZY1OLKpb
	fns2hDHCnwwXb6p/gjaXFn9DJGXVKFo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1709054576;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F2RlJWCHX0+kB70dKeSM+eTaztKmmZDJ9TxNA/UJ2wA=;
	b=Nb4Lh4H5Rcg+W1OJv7GX07NxURQ791+ce5UJliF0tdxtngNKICSq3VP33vsYxlH085/6jd
	JuKqvTKb9UO02IBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 555BF13A58;
	Tue, 27 Feb 2024 17:22:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id xljPEHAa3mUCaAAAD6G6ig
	(envelope-from <lhenriques@suse.de>); Tue, 27 Feb 2024 17:22:56 +0000
Received: from localhost (brahms.olymp [local])
	by brahms.olymp (OpenSMTPD) with ESMTPA id af82a16c;
	Tue, 27 Feb 2024 17:22:51 +0000 (UTC)
From: Luis Henriques <lhenriques@suse.de>
To: xiubli@redhat.com
Cc: ceph-devel@vger.kernel.org,  idryomov@gmail.com,  jlayton@kernel.org,
  vshankar@redhat.com,  mchangir@redhat.com
Subject: Re: [PATCH v6 3/3] libceph: just wait for more data to be available
 on the socket
In-Reply-To: <20240125023920.1287555-4-xiubli@redhat.com> (xiubli@redhat.com's
	message of "Thu, 25 Jan 2024 10:39:20 +0800")
References: <20240125023920.1287555-1-xiubli@redhat.com>
	<20240125023920.1287555-4-xiubli@redhat.com>
Date: Tue, 27 Feb 2024 17:22:51 +0000
Message-ID: <871q8x4yac.fsf@suse.de>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Authentication-Results: smtp-out1.suse.de;
	none
X-Spamd-Result: default: False [-3.10 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 FREEMAIL_ENVRCPT(0.00)[gmail.com];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 TO_DN_NONE(0.00)[];
	 RCPT_COUNT_FIVE(0.00)[6];
	 RCVD_COUNT_THREE(0.00)[4];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_LAST(0.00)[];
	 FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com,kernel.org,redhat.com];
	 MID_RHS_MATCH_FROM(0.00)[];
	 BAYES_HAM(-3.00)[100.00%]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -3.10

Hi Xiubo!

xiubli@redhat.com writes:

> From: Xiubo Li <xiubli@redhat.com>
>
> A short read may occur while reading the message footer from the
> socket.  Later, when the socket is ready for another read, the
> messenger shoudl invoke all read_partial* handlers, except the
> read_partial_sparse_msg_data().  The contract between the messenger
> and these handlers is that the handlers should bail if the area
> of the message is responsible for is already processed.  So,
> in this case, it's expected that read_sparse_msg_data() would bail,
> allowing the messenger to invoke read_partial() for the footer and
> pick up where it left off.
>
> However read_partial_sparse_msg_data() violates that contract and
> ends up calling into the state machine in the OSD client. The
> sparse-read state machine just assumes that it's a new op and
> interprets some piece of the footer as the sparse-read extents/data
> and then returns bogus extents/data length, etc.
>
> This will just reuse the 'total_resid' to determine whether should
> the read_partial_sparse_msg_data() bail out or not. Because once
> it reaches to zero that means all the extents and data have been
> successfully received in last read, else it could break out when
> partially reading any of the extents and data. And then the
> osd_sparse_read() could continue where it left off.

I'm seeing an issue with fstest generic/580, which seems to enter an
infinite loop effectively rendering the testing VM unusable.  It's pretty
easy to reproduce, just run the test ensuring to be using msgv2 (I'm
mounting the filesystem with 'ms_mode=3Dcrc'), and you should see the
following on the logs:

[...]
  libceph: prepare_sparse_read_cont: ret 0x1000 total_resid 0x0 resid 0x0=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20
  libceph: osd1 (2)192.168.155.1:6810 read processing error=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
  libceph: mon0 (2)192.168.155.1:40608 session established=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
  libceph: bad late_status 0x1=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
  libceph: osd1 (2)192.168.155.1:6810 protocol error, bad epilogue=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
  libceph: mon0 (2)192.168.155.1:40608 session established=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
  libceph: prepare_sparse_read_cont: ret 0x1000 total_resid 0x0 resid 0x0=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20
  libceph: osd1 (2)192.168.155.1:6810 read processing error=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20
  libceph: mon0 (2)192.168.155.1:40608 session established=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
  libceph: bad late_status 0x1=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[...]

Reverting this patch (commit 8e46a2d068c9 ("libceph: just wait for more
data to be available on the socket")) seems to fix.  I haven't
investigated it further, but since it'll take me some time to refresh my
memory, I thought I should report it immediately.  Maybe someone has any
idea.

Cheers,
--=20
Lu=C3=ADs


> URL: https://tracker.ceph.com/issues/63586
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> Reviewed-by: Jeff Layton <jlayton@kernel.org>
> ---
>  include/linux/ceph/messenger.h |  2 +-
>  net/ceph/messenger_v1.c        | 25 +++++++++++++------------
>  net/ceph/messenger_v2.c        |  4 ++--
>  net/ceph/osd_client.c          |  9 +++------
>  4 files changed, 19 insertions(+), 21 deletions(-)
>
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
>=20=20
>  	struct ceph_msgpool *pool;
> diff --git a/net/ceph/messenger_v1.c b/net/ceph/messenger_v1.c
> index 4cb60bacf5f5..126b2e712247 100644
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
>=20=20
>  /*
> @@ -1036,7 +1037,7 @@ static int read_partial_sparse_msg_data(struct ceph=
_connection *con)
>  	if (do_datacrc)
>  		crc =3D con->in_data_crc;
>=20=20
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
>=20=20
>  		memset(&con->v1.in_sr_kvec, 0, sizeof(con->v1.in_sr_kvec));
>  		ret =3D con->ops->sparse_read(con, cursor,
>  				(char **)&con->v1.in_sr_kvec.iov_base);
> +		if (ret <=3D 0) {
> +			ret =3D ret ? ret : 1; /* must return > 0 to indicate success */
> +			break;
> +		}
>  		con->v1.in_sr_len =3D ret;
> -	} while (ret > 0);
> +	}
>=20=20
>  	if (do_datacrc)
>  		con->in_data_crc =3D crc;
>=20=20
> -	return ret < 0 ? ret : 1;  /* must return > 0 to indicate success */
> +	return ret;
>  }
>=20=20
>  static int read_partial_msg_data(struct ceph_connection *con)
> @@ -1253,7 +1254,7 @@ static int read_partial_message(struct ceph_connect=
ion *con)
>  		if (!m->num_data_items)
>  			return -EIO;
>=20=20
> -		if (m->sparse_read)
> +		if (m->sparse_read_total)
>  			ret =3D read_partial_sparse_msg_data(con);
>  		else if (ceph_test_opt(from_msgr(con->msgr), RXBOUNCE))
>  			ret =3D read_partial_msg_data_bounce(con);
> diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
> index f8ec60e1aba3..a0ca5414b333 100644
> --- a/net/ceph/messenger_v2.c
> +++ b/net/ceph/messenger_v2.c
> @@ -1128,7 +1128,7 @@ static int decrypt_tail(struct ceph_connection *con)
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
>=20=20
>  	if (data_len(msg)) {
> -		if (msg->sparse_read)
> +		if (msg->sparse_read_total)
>  			con->v2.in_state =3D IN_S_PREPARE_SPARSE_DATA;
>  		else
>  			con->v2.in_state =3D IN_S_PREPARE_READ_DATA;
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index 837b69541376..ad2ed334cdbb 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -5510,7 +5510,7 @@ static struct ceph_msg *get_reply(struct ceph_conne=
ction *con,
>  	}
>=20=20
>  	m =3D ceph_msg_get(req->r_reply);
> -	m->sparse_read =3D (bool)srlen;
> +	m->sparse_read_total =3D srlen;
>=20=20
>  	dout("get_reply tid %lld %p\n", tid, m);
>=20=20
> @@ -5777,11 +5777,8 @@ static int prep_next_sparse_read(struct ceph_conne=
ction *con,
>  	}
>=20=20
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
>=20=20
> --=20
>
> 2.43.0
>


