Return-Path: <ceph-devel+bounces-938-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F86786C5FE
	for <lists+ceph-devel@lfdr.de>; Thu, 29 Feb 2024 10:48:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C68F3281779
	for <lists+ceph-devel@lfdr.de>; Thu, 29 Feb 2024 09:48:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAB496216B;
	Thu, 29 Feb 2024 09:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="gPnh3BJB";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="apl5EFtq";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="RJkbDk0v";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="PHnlgloL"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B33ED612CC;
	Thu, 29 Feb 2024 09:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709200107; cv=none; b=bpq9lbD9WxbcE1ieIT+3A8jVMtmQvc7+Grk0EaCoAX6JNSvr0tmBz9BLVoHXx56UOh4zrsvT99DWKirzkwrU0+LrmlKF36CSw1HMEd2fpyoPaTkiHI8Z07CZ9Azp+WWSTMOmmqvGnVhevKU+jMtVSvUpM6WoBaLE4dlQShjxtsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709200107; c=relaxed/simple;
	bh=HtBVhjRPvqToCCdgmDJjwKvQqHncoD050cqNewZot7E=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Kc2GsYii2+efyqvx4ytTUZxM2sgLVLYw7UCxsi4V7TZ6M425/IlMQJvy82zCL+wrv+Y4imsYMWr2dZETGOuKh8JjFsgM9cc6XG7g4LEdAMMNAiz83u4ndTBIP8Y424uO73qLRDLz5tmgmSScXdMZ6T0NtnvoiDO7xOJXYil+HRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=gPnh3BJB; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=apl5EFtq; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=RJkbDk0v; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=PHnlgloL; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DE59E1F7CB;
	Thu, 29 Feb 2024 09:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1709200104; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rZ0bHkxXL18Dg5uSFcIFQnha7vPpowxaikFAYhupcls=;
	b=gPnh3BJBeptHvPLCPMQ8fCgsxBo+Nki+rPCyj261fOyxJ+oOlYbn6CXHL0UWjv8iIM99xB
	IIazeqYAFiKMeg/82oA3pkdQDSmdRhhriGh+bpa4MYpwwAU7Qgqe4sf0pkIAu3hVRDwCgh
	X8jLSiz2sGWn5+tHcU7gBAn7onCY21k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1709200104;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rZ0bHkxXL18Dg5uSFcIFQnha7vPpowxaikFAYhupcls=;
	b=apl5EFtqMysQak539x/QjkLTxLuxTOMj7nYMI667LXms7Sl8MJyopyI0yetfy955Z6KODy
	ZT88MKy/B7iDeIBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1709200103; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rZ0bHkxXL18Dg5uSFcIFQnha7vPpowxaikFAYhupcls=;
	b=RJkbDk0vQJi55FjAtmoXMfwmXTNv6TeslD4+JixwIJPlnfqqbPow/K/QY8X68WOMgwbaW+
	n6xPsqGi3rK8kaZG8yfeWXFh3Y4nJc/nPW+rmSwTBwZNwJdfnXZYFdNhprIMu+G7kxOBDd
	HZOSQqZR90l5ROmkcuk7GKYUpZNoRQ4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1709200103;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rZ0bHkxXL18Dg5uSFcIFQnha7vPpowxaikFAYhupcls=;
	b=PHnlgloLmRCFNlbWXRmmNPx29NQSewsdDqzAIHeRMTTHhER1cb491B1npp1qvU29/qAJlw
	9SMxJuQv+B8vSEBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5C5BC13503;
	Thu, 29 Feb 2024 09:48:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eyq8EudS4GWCXgAAD6G6ig
	(envelope-from <lhenriques@suse.de>); Thu, 29 Feb 2024 09:48:23 +0000
Received: from localhost (brahms.olymp [local])
	by brahms.olymp (OpenSMTPD) with ESMTPA id 39e56676;
	Thu, 29 Feb 2024 09:48:22 +0000 (UTC)
From: Luis Henriques <lhenriques@suse.de>
To: xiubli@redhat.com
Cc: ceph-devel@vger.kernel.org,  idryomov@gmail.com,  jlayton@kernel.org,
  vshankar@redhat.com,  mchangir@redhat.com,  stable@vger.kernel.org
Subject: Re: [PATCH] libceph: init the cursor when preparing the sparse read
In-Reply-To: <20240229041950.738878-1-xiubli@redhat.com> (xiubli@redhat.com's
	message of "Thu, 29 Feb 2024 12:19:50 +0800")
References: <20240229041950.738878-1-xiubli@redhat.com>
Date: Thu, 29 Feb 2024 09:48:22 +0000
Message-ID: <87le73wqhl.fsf@suse.de>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Authentication-Results: smtp-out2.suse.de;
	none
X-Spamd-Result: default: False [-0.29 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 FREEMAIL_ENVRCPT(0.00)[gmail.com];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 TO_DN_NONE(0.00)[];
	 RCVD_COUNT_THREE(0.00)[4];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 RCPT_COUNT_SEVEN(0.00)[7];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_LAST(0.00)[];
	 FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com,kernel.org,redhat.com];
	 MID_RHS_MATCH_FROM(0.00)[];
	 BAYES_HAM(-0.19)[70.96%]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -0.29

xiubli@redhat.com writes:

> From: Xiubo Li <xiubli@redhat.com>
>
> The osd code has remove cursor initilizing code and this will make
> the sparse read state into a infinite loop. We should initialize
> the cursor just before each sparse-read in messnger v2.
>
> Cc: stable@vger.kernel.org
> URL: https://tracker.ceph.com/issues/64607
> Fixes: 8e46a2d068c9 ("libceph: just wait for more data to be available on=
 the socket")
> Reported-by: Luis Henriques <lhenriques@suse.de>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>

Thanks a lot Xiubo.  Feel free to add my

Tested-by: Luis Henriques <lhenriques@suse.de>

Cheers,
--=20
Lu=C3=ADs

> ---
>  net/ceph/messenger_v2.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
> index a0ca5414b333..7ae0f80100f4 100644
> --- a/net/ceph/messenger_v2.c
> +++ b/net/ceph/messenger_v2.c
> @@ -2025,6 +2025,7 @@ static int prepare_sparse_read_cont(struct ceph_con=
nection *con)
>  static int prepare_sparse_read_data(struct ceph_connection *con)
>  {
>  	struct ceph_msg *msg =3D con->in_msg;
> +	u64 len =3D con->in_msg->sparse_read_total ? : data_len(con->in_msg);
>=20=20
>  	dout("%s: starting sparse read\n", __func__);
>=20=20
> @@ -2034,6 +2035,8 @@ static int prepare_sparse_read_data(struct ceph_con=
nection *con)
>  	if (!con_secure(con))
>  		con->in_data_crc =3D -1;
>=20=20
> +	ceph_msg_data_cursor_init(&con->v2.in_cursor, con->in_msg, len);
> +
>  	reset_in_kvecs(con);
>  	con->v2.in_state =3D IN_S_PREPARE_SPARSE_DATA_CONT;
>  	con->v2.data_len_remain =3D data_len(msg);
> --=20
>
> 2.43.0
>

