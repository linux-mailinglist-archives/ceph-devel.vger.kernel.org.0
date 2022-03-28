Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7D994E9980
	for <lists+ceph-devel@lfdr.de>; Mon, 28 Mar 2022 16:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243799AbiC1ObC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 28 Mar 2022 10:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231512AbiC1ObB (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 28 Mar 2022 10:31:01 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FAF937BF5
        for <ceph-devel@vger.kernel.org>; Mon, 28 Mar 2022 07:29:20 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id C5AB6210EE;
        Mon, 28 Mar 2022 14:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1648477758; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1cBSmddM+oTFlxU5LQC11P6MXtti1nfhLBgC6xeFeWQ=;
        b=dbbIoYIsp6z28EVgNl3ZlIJ5xtTFmpdH1blVsDyuseKHqNfGJnXvdjHB9mPGrCt31NzFNz
        /65K2QGNmZzOrhX8+KCizD0uft/fBYYzG9Z8BO3kLRlBOAs4bVJdNTbOu/dzLkoATpEpWW
        aHvbwD+6LnL1lm9uQSlIYsGpHC6678Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1648477758;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1cBSmddM+oTFlxU5LQC11P6MXtti1nfhLBgC6xeFeWQ=;
        b=c5hNvqvh6TgS2ufwgGFoqTs5UzLqaqmyQeP8XeSUx0d1zSY2UhpI0zlTd6Aq0UgSbUcZqs
        CUuwsHjZSL5xv4BA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 784E413B08;
        Mon, 28 Mar 2022 14:29:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Yr1QGj7GQWIlMgAAMHmgww
        (envelope-from <lhenriques@suse.de>); Mon, 28 Mar 2022 14:29:18 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id f7c54e88;
        Mon, 28 Mar 2022 14:29:40 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, idryomov@gmail.com, xiubli@redhat.com
Subject: Re: [PATCH] ceph: add a has_stable_inodes operation for ceph
References: <20220325184046.236663-1-jlayton@kernel.org>
Date:   Mon, 28 Mar 2022 15:29:40 +0100
In-Reply-To: <20220325184046.236663-1-jlayton@kernel.org> (Jeff Layton's
        message of "Fri, 25 Mar 2022 14:40:46 -0400")
Message-ID: <87v8vyqhez.fsf@brahms.olymp>
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

Jeff Layton <jlayton@kernel.org> writes:

> ...and just have it return true. It should never change inode numbers
> out from under us, as they are baked into the object names.
>
> Reported-by: Lu=C3=ADs Henriques <lhenriques@suse.de>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/crypto.c | 20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)

Thanks, this looks good.  I've also tried it for a bit and seems work
fine.  Feel free to add my Reviewed-by (and Tested-by).

Cheers,
--=20
Lu=C3=ADs

>
> diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
> index 2a8f95885e7d..3a9214b1e8b3 100644
> --- a/fs/ceph/crypto.c
> +++ b/fs/ceph/crypto.c
> @@ -59,6 +59,11 @@ static int ceph_crypt_set_context(struct inode *inode,=
 const void *ctx, size_t l
>  	return ret;
>  }
>=20=20
> +static const union fscrypt_policy *ceph_get_dummy_policy(struct super_bl=
ock *sb)
> +{
> +	return ceph_sb_to_client(sb)->dummy_enc_policy.policy;
> +}
> +
>  static bool ceph_crypt_empty_dir(struct inode *inode)
>  {
>  	struct ceph_inode_info *ci =3D ceph_inode(inode);
> @@ -66,14 +71,9 @@ static bool ceph_crypt_empty_dir(struct inode *inode)
>  	return ci->i_rsubdirs + ci->i_rfiles =3D=3D 1;
>  }
>=20=20
> -void ceph_fscrypt_free_dummy_policy(struct ceph_fs_client *fsc)
> +static bool ceph_crypt_has_stable_inodes(struct super_block *sb)
>  {
> -	fscrypt_free_dummy_policy(&fsc->dummy_enc_policy);
> -}
> -
> -static const union fscrypt_policy *ceph_get_dummy_policy(struct super_bl=
ock *sb)
> -{
> -	return ceph_sb_to_client(sb)->dummy_enc_policy.policy;
> +	return true;
>  }
>=20=20
>  static struct fscrypt_operations ceph_fscrypt_ops =3D {
> @@ -82,6 +82,7 @@ static struct fscrypt_operations ceph_fscrypt_ops =3D {
>  	.set_context		=3D ceph_crypt_set_context,
>  	.get_dummy_policy	=3D ceph_get_dummy_policy,
>  	.empty_dir		=3D ceph_crypt_empty_dir,
> +	.has_stable_inodes	=3D ceph_crypt_has_stable_inodes,
>  };
>=20=20
>  void ceph_fscrypt_set_ops(struct super_block *sb)
> @@ -89,6 +90,11 @@ void ceph_fscrypt_set_ops(struct super_block *sb)
>  	fscrypt_set_ops(sb, &ceph_fscrypt_ops);
>  }
>=20=20
> +void ceph_fscrypt_free_dummy_policy(struct ceph_fs_client *fsc)
> +{
> +	fscrypt_free_dummy_policy(&fsc->dummy_enc_policy);
> +}
> +
>  int ceph_fscrypt_prepare_context(struct inode *dir, struct inode *inode,
>  				 struct ceph_acl_sec_ctx *as)
>  {
> --=20
>
> 2.35.1
>
