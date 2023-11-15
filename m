Return-Path: <ceph-devel+bounces-90-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A80B7EC12D
	for <lists+ceph-devel@lfdr.de>; Wed, 15 Nov 2023 12:19:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B92B2281148
	for <lists+ceph-devel@lfdr.de>; Wed, 15 Nov 2023 11:19:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23047168B4;
	Wed, 15 Nov 2023 11:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="w5bN84fX";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="KdmxWKSx"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C89156DE
	for <ceph-devel@vger.kernel.org>; Wed, 15 Nov 2023 11:19:37 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F00EFA;
	Wed, 15 Nov 2023 03:19:35 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3C5E1204D9;
	Wed, 15 Nov 2023 11:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1700047172; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+JKcBtd3Scr0VoCrmkFTsmeau0WKloq0q5o3Oo5uTt4=;
	b=w5bN84fXGFKAlwfYCRgSV4mD6xmASh3F3u4cRqHmPPaaFUBwBwnG2Gm35ouoyTQlrzCGoW
	m6Hg1EhsP+oZRDuJVvm752bQHIdgcNmNmhG1kPfQxk4hNQDS36f7SIcvOTS/8w4Pdns1x6
	WXD1gXYi0M/dPdFkUp0pMD5oz7Xwb4g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1700047172;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+JKcBtd3Scr0VoCrmkFTsmeau0WKloq0q5o3Oo5uTt4=;
	b=KdmxWKSxvYCJaRugr2p2vuNiSqPxSVid824FnXcHHjYf6HHxupWcYaRhzdZWAlVVnHtvQv
	MM5uF54PVnoTbpAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C29FA13587;
	Wed, 15 Nov 2023 11:19:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id rAWcLEOpVGU0bAAAMHmgww
	(envelope-from <lhenriques@suse.de>); Wed, 15 Nov 2023 11:19:31 +0000
Received: from localhost (brahms.olymp [local])
	by brahms.olymp (OpenSMTPD) with ESMTPA id 8bc02e13;
	Wed, 15 Nov 2023 11:19:30 +0000 (UTC)
From: Luis Henriques <lhenriques@suse.de>
To: Wenchao Hao <haowenchao2@huawei.com>
Cc: Xiubo Li <xiubli@redhat.com>,  Ilya Dryomov <idryomov@gmail.com>,  Jeff
 Layton <jlayton@kernel.org>,  <ceph-devel@vger.kernel.org>,
  <linux-kernel@vger.kernel.org>,  <louhongxiang@huawei.com>
Subject: Re: [PATCH] ceph: quota: Fix invalid pointer access in
In-Reply-To: <20231114153108.1932884-1-haowenchao2@huawei.com> (Wenchao Hao's
	message of "Tue, 14 Nov 2023 23:31:08 +0800")
References: <20231114153108.1932884-1-haowenchao2@huawei.com>
Date: Wed, 15 Nov 2023 11:19:30 +0000
Message-ID: <875y238drx.fsf@suse.de>
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
X-Spam-Level: 
X-Spam-Score: -6.05
X-Spamd-Result: default: False [-6.05 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 FREEMAIL_ENVRCPT(0.00)[gmail.com];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 NEURAL_HAM_LONG(-3.00)[-1.000];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 NEURAL_HAM_SHORT(-1.00)[-1.000];
	 RCPT_COUNT_SEVEN(0.00)[7];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_LAST(0.00)[];
	 FREEMAIL_CC(0.00)[redhat.com,gmail.com,kernel.org,vger.kernel.org,huawei.com];
	 MID_RHS_MATCH_FROM(0.00)[];
	 BAYES_HAM(-1.95)[94.73%]

Wenchao Hao <haowenchao2@huawei.com> writes:

> This issue is reported by smatch, get_quota_realm() might return
> ERR_PTR, so we should using IS_ERR_OR_NULL here to check the return
> value.
>
> Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
> ---
>  fs/ceph/quota.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
> index 9d36c3532de1..c4b2929c6a83 100644
> --- a/fs/ceph/quota.c
> +++ b/fs/ceph/quota.c
> @@ -495,7 +495,7 @@ bool ceph_quota_update_statfs(struct ceph_fs_client *=
fsc, struct kstatfs *buf)
>  	realm =3D get_quota_realm(mdsc, d_inode(fsc->sb->s_root),
>  				QUOTA_GET_MAX_BYTES, true);
>  	up_read(&mdsc->snap_rwsem);
> -	if (!realm)
> +	if (IS_ERR_OR_NULL(realm))
>  		return false;
>=20=20
>  	spin_lock(&realm->inodes_with_caps_lock);
> --=20
>
> 2.32.0
>

This looks right to me, the issue was introduced by commit 0c44a8e0fc55
("ceph: quota: fix quota subdir mounts").  FWIW:

Reviewed-by: Luis Henriques <lhenriques@suse.de>

Cheers,
--=20
Lu=C3=ADs

