Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42ED2559CE5
	for <lists+ceph-devel@lfdr.de>; Fri, 24 Jun 2022 17:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233496AbiFXOwS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 24 Jun 2022 10:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233477AbiFXOv4 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 24 Jun 2022 10:51:56 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58C2E6F7BC
        for <ceph-devel@vger.kernel.org>; Fri, 24 Jun 2022 07:46:18 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 55FF51F92D;
        Fri, 24 Jun 2022 14:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1656081977; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5jFEBqJ+zDGwxTE4Uv0+bkkTYGuBNRuBQ7lUIRmA1EA=;
        b=Tot7GNfgRT57lSsf9VtOKZCLZKZJEmuY0XlYpNDvsMJUnpuqahVychfiLwbqK5fDc4FQ1n
        GkzE9r8101qTGvOjdGn/Tx5i+N5PWdyFV7G/FCxA01o2ov+nsZ/HntTxSf/FJEQeEbPTHe
        mB/KrCID3LWuDw4CN0tf4teFbzlR8ok=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1656081977;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5jFEBqJ+zDGwxTE4Uv0+bkkTYGuBNRuBQ7lUIRmA1EA=;
        b=Q7z6Ez2eU3PopEYmPJJZvlzn8Bj5cCkoFtonx0jsvUJRIT4goCZmKN+C04asrDAmsdwCqb
        wSKoY0u0z17qLpBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D024413ACA;
        Fri, 24 Jun 2022 14:46:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id df0EMDjOtWI9KgAAMHmgww
        (envelope-from <lhenriques@suse.de>); Fri, 24 Jun 2022 14:46:16 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 33ee18a3;
        Fri, 24 Jun 2022 14:47:02 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     xiubli@redhat.com
Cc:     jlayton@kernel.org, idryomov@gmail.com, vshankar@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org
Subject: Re: [PATCH 2/2] ceph: switch to 4KB block size if quota size is not
 aligned to 4MB
References: <20220624093730.8564-1-xiubli@redhat.com>
        <20220624093730.8564-3-xiubli@redhat.com>
Date:   Fri, 24 Jun 2022 15:47:02 +0100
In-Reply-To: <20220624093730.8564-3-xiubli@redhat.com> (xiubli@redhat.com's
        message of "Fri, 24 Jun 2022 17:37:30 +0800")
Message-ID: <87k096jezd.fsf@brahms.olymp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

xiubli@redhat.com writes:

> From: Xiubo Li <xiubli@redhat.com>
>
> If the quota size is larger than but not aligned to 4MB, the statfs
> will always set the block size to 4MB and round down the fragment
> size. For exmaple if the quota size is 6MB, the `df` will always
> show 4MB capacity.
>
> Make the block size to 4KB as default if quota size is set unless
> the quota size is larger than or equals to 4MB and at the same time
> it aligns to 4MB.
>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/quota.c | 31 ++++++++++++++++++++-----------
>  1 file changed, 20 insertions(+), 11 deletions(-)
>
> diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
> index 64592adfe48f..c50527151913 100644
> --- a/fs/ceph/quota.c
> +++ b/fs/ceph/quota.c
> @@ -483,6 +483,7 @@ bool ceph_quota_update_statfs(struct ceph_fs_client *=
fsc, struct kstatfs *buf)
>  	struct inode *in;
>  	u64 total =3D 0, used, free;
>  	bool is_updated =3D false;
> +	u32 block_shift =3D CEPH_4K_BLOCK_SHIFT;
>=20=20
>  	down_read(&mdsc->snap_rwsem);
>  	realm =3D get_quota_realm(mdsc, d_inode(fsc->sb->s_root),
> @@ -498,21 +499,29 @@ bool ceph_quota_update_statfs(struct ceph_fs_client=
 *fsc, struct kstatfs *buf)
>  		ci =3D ceph_inode(in);
>  		spin_lock(&ci->i_ceph_lock);
>  		if (ci->i_max_bytes) {
> -			total =3D ci->i_max_bytes >> CEPH_BLOCK_SHIFT;
> -			used =3D ci->i_rbytes >> CEPH_BLOCK_SHIFT;
> -			/* For quota size less than 4MB, use 4KB block size */
> -			if (!total) {
> -				total =3D ci->i_max_bytes >> CEPH_4K_BLOCK_SHIFT;
> -				used =3D ci->i_rbytes >> CEPH_4K_BLOCK_SHIFT;
> -	                        buf->f_frsize =3D 1 << CEPH_4K_BLOCK_SHIFT;
> -			}
> -			/* It is possible for a quota to be exceeded.
> +			/*
> +			 * Switch to 4MB block size if quota size is
> +			 * larger than or equals to 4MB and at the
> +			 * same time is aligned to 4MB.
> +			 */
> +			if (ci->i_max_bytes >=3D (1 << CEPH_BLOCK_SHIFT) &&
> +			    !(ci->i_max_bytes % (1 << CEPH_BLOCK_SHIFT)))

Maybe worth replacing this 2nd condition with the IS_ALIGNED() macro.
Other than this, these patches look good.

I do have question though: is it possible that this will behaviour may
break some user-space programs that expect more deterministic values for
these fields (buf->f_frsize and buf->f_bsize)?  Because the same
filesystem will report different values depending on which dir you mount.

Obviously, this isn't a problem with this particular patch, as this
behaviour is already present.

Cheers,
--=20
Lu=C3=ADs

> +				block_shift =3D CEPH_BLOCK_SHIFT;
> +
> +			total =3D ci->i_max_bytes >> block_shift;
> +			used =3D ci->i_rbytes >> block_shift;
> +			buf->f_frsize =3D 1 << block_shift;
> +
> +			/*
> +			 * It is possible for a quota to be exceeded.
>  			 * Report 'zero' in that case
>  			 */
>  			free =3D total > used ? total - used : 0;
> -			/* For quota size less than 4KB, report the
> +			/*
> +			 * For quota size less than 4KB, report the
>  			 * total=3Dused=3D4KB,free=3D0 when quota is full
> -			 * and total=3Dfree=3D4KB, used=3D0 otherwise */
> +			 * and total=3Dfree=3D4KB, used=3D0 otherwise
> +			 */
>  			if (!total) {
>  				total =3D 1;
>  				free =3D ci->i_max_bytes > ci->i_rbytes ? 1 : 0;
> --=20
>
> 2.36.0.rc1
>
