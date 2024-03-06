Return-Path: <ceph-devel+bounces-957-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 20910873587
	for <lists+ceph-devel@lfdr.de>; Wed,  6 Mar 2024 12:24:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 873421F26C4A
	for <lists+ceph-devel@lfdr.de>; Wed,  6 Mar 2024 11:24:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8BCC7CF3A;
	Wed,  6 Mar 2024 11:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="CDcHP2WC";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="DZUEh/+j";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="CDcHP2WC";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="DZUEh/+j"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B628F7BB17;
	Wed,  6 Mar 2024 11:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709724281; cv=none; b=ecDz/tI40y+ZjB67tkl9Jv3wemcwhtGJwdFj78Of0e4rAJfOuRAYVo1dEXFEV1rZ9UK/zHMk/sNXpfI7fLq+xByRMvA1kiPv5BGbSZIadjQ2ayjS/4nuJNb0OI/ZN0zydIb0mQ3dKcDezlYO+5hmGP33TZUVlUdj+72t/WgT0I8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709724281; c=relaxed/simple;
	bh=nLXY6FdbORSIR6lx3hLaHRZJzgY+pdtrixTnkTvcyBU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=fI7NjudXTFmD/oTjLeLJT/GijI8k509EajlRqK0MbU816btDd4ywYv1g5E9qJIA55jv9ecs6UbK1r4zD7NvRPL5Y+a8n0SMyr2RAC05dpHpnUhIzez7tZpM+dBH62NCbfFqZnpaVD9tPPBC5J74PfHC3CcTLURA3ipojFyKyn/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=CDcHP2WC; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=DZUEh/+j; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=CDcHP2WC; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=DZUEh/+j; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B2AA668836;
	Wed,  6 Mar 2024 11:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1709724277; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=btRou0Rd51lnj5GZrjg73LrUj608fRRr98VyK+uI1hU=;
	b=CDcHP2WCnIsowGyww0Vy8Hc0okGO5z3RkUxLHKQeLr9oyc/b5xm2H7DzoAmUFk6apBLGhL
	Fa6m8Q0QCThEJf+bu9MtUvoPPlpsrhvKaU9XOFmn6W9wo2XagFnhwnt3QBo25qpyNOuPs1
	bG/CU3oK/oAM7ylMDGummyyt8nA0qOQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1709724277;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=btRou0Rd51lnj5GZrjg73LrUj608fRRr98VyK+uI1hU=;
	b=DZUEh/+j3ashhl7h3NOjjrvhgHNQa82IcSX0qKEYBUUKkInSrMkBookX5Sqh9jH+55ZaUJ
	db+GSI8dQlfMrTAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1709724277; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=btRou0Rd51lnj5GZrjg73LrUj608fRRr98VyK+uI1hU=;
	b=CDcHP2WCnIsowGyww0Vy8Hc0okGO5z3RkUxLHKQeLr9oyc/b5xm2H7DzoAmUFk6apBLGhL
	Fa6m8Q0QCThEJf+bu9MtUvoPPlpsrhvKaU9XOFmn6W9wo2XagFnhwnt3QBo25qpyNOuPs1
	bG/CU3oK/oAM7ylMDGummyyt8nA0qOQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1709724277;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=btRou0Rd51lnj5GZrjg73LrUj608fRRr98VyK+uI1hU=;
	b=DZUEh/+j3ashhl7h3NOjjrvhgHNQa82IcSX0qKEYBUUKkInSrMkBookX5Sqh9jH+55ZaUJ
	db+GSI8dQlfMrTAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2FDAC13A65;
	Wed,  6 Mar 2024 11:24:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kbayBnVS6GUVEwAAD6G6ig
	(envelope-from <lhenriques@suse.de>); Wed, 06 Mar 2024 11:24:37 +0000
Received: from localhost (brahms.olymp [local])
	by brahms.olymp (OpenSMTPD) with ESMTPA id e845dec5;
	Wed, 6 Mar 2024 11:24:32 +0000 (UTC)
From: Luis Henriques <lhenriques@suse.de>
To: xiubli@redhat.com
Cc: ceph-devel@vger.kernel.org,  idryomov@gmail.com,  jlayton@kernel.org,
  vshankar@redhat.com,  mchangir@redhat.com,  stable@vger.kernel.org
Subject: Re: [PATCH v2] libceph: init the cursor when preparing the sparse read
In-Reply-To: <20240306010544.182527-1-xiubli@redhat.com> (xiubli@redhat.com's
	message of "Wed, 6 Mar 2024 09:05:44 +0800")
References: <20240306010544.182527-1-xiubli@redhat.com>
Date: Wed, 06 Mar 2024 11:24:32 +0000
Message-ID: <87msrbr4b3.fsf@suse.de>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=CDcHP2WC;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="DZUEh/+j"
X-Spamd-Result: default: False [-1.56 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	 FROM_HAS_DN(0.00)[];
	 FREEMAIL_ENVRCPT(0.00)[gmail.com];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 TO_DN_NONE(0.00)[];
	 DWL_DNSWL_LOW(-1.00)[suse.de:dkim];
	 RCVD_COUNT_THREE(0.00)[4];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 DKIM_TRACE(0.00)[suse.de:+];
	 MX_GOOD(-0.01)[];
	 RCPT_COUNT_SEVEN(0.00)[7];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[ceph.com:url,suse.de:dkim,suse.de:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_LAST(0.00)[];
	 FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com,kernel.org,redhat.com];
	 MID_RHS_MATCH_FROM(0.00)[];
	 BAYES_HAM(-0.25)[73.24%]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: B2AA668836
X-Spam-Level: 
X-Spam-Score: -1.56
X-Spam-Flag: NO

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
> ---
>
> V2:
> - Just removed the unnecessary 'sparse_read_total' check.
>

Thanks a lot for the quick fix, Xiubo.  FWIW:

Tested-by: Luis Henriques <lhenriques@suse.de>

Note that I still see this test failing occasionally, but I haven't had
time to help debugging it.  And that's a different issue, of course.  TBH
I don't remember if this test ever used to reliably pass.  Here's the
output diff shown by fstests in case you're not able to reproduce it:

@@ -65,7 +65,7 @@
 # Getting encryption key status
 Present (user_count=3D1, added_by_self)
 # Removing encryption key
-Removed encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
+Removed encryption key with identifier 69b2f6edeee720cce0577937eb8a6751, b=
ut files still busy
 # Getting encryption key status
 Absent
 # Verifying that the encrypted directory was "locked"

Cheers,
--=20
Lu=C3=ADs

>
> net/ceph/messenger_v2.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
> index a0ca5414b333..ab3ab130a911 100644
> --- a/net/ceph/messenger_v2.c
> +++ b/net/ceph/messenger_v2.c
> @@ -2034,6 +2034,9 @@ static int prepare_sparse_read_data(struct ceph_con=
nection *con)
>  	if (!con_secure(con))
>  		con->in_data_crc =3D -1;
>=20=20
> +	ceph_msg_data_cursor_init(&con->v2.in_cursor, con->in_msg,
> +				  con->in_msg->sparse_read_total);
> +
>  	reset_in_kvecs(con);
>  	con->v2.in_state =3D IN_S_PREPARE_SPARSE_DATA_CONT;
>  	con->v2.data_len_remain =3D data_len(msg);
> --=20
>
> 2.43.0
>


