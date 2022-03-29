Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23FF64EAA5C
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Mar 2022 11:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234603AbiC2JUr (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Mar 2022 05:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234610AbiC2JUp (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 29 Mar 2022 05:20:45 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCF7E1B7AF
        for <ceph-devel@vger.kernel.org>; Tue, 29 Mar 2022 02:19:01 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 5252C1FD32;
        Tue, 29 Mar 2022 09:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1648545540; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wZgomvzikp+ZoGfc/44rJYFM17HbtMzc5apHurslBik=;
        b=1CFjRoIykW2C3/odFdZ2d/nwgNhi1sLIAy6ro375q2tXG5T6x2edyX5Gw0Fz0B5+zZxffy
        AWLFHOgYTNL4O8/2JWUba/+Mu2sTtfYw0b0zQhCQDG7kWT/X1oPvLXPgTtA52mwcC/xJ70
        8h03xMry6mfrzIsf/q7qX+5JE6w4dEk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1648545540;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wZgomvzikp+ZoGfc/44rJYFM17HbtMzc5apHurslBik=;
        b=3PI9XyMF8QSmQwpVUHxRXiHsWCzz65rM7LOyIu/6mAlbsO05AjgtUORV62Aqw19bdvHLqu
        lWNOz5F1698a5KBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 02A7813A7E;
        Tue, 29 Mar 2022 09:18:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id gNxEOQPPQmISRAAAMHmgww
        (envelope-from <lhenriques@suse.de>); Tue, 29 Mar 2022 09:18:59 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id f9b110f9;
        Tue, 29 Mar 2022 09:19:16 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, idryomov@gmail.com, xiubli@redhat.com
Subject: Re: [PATCH] ceph: set DCACHE_NOKEY_NAME in atomic open
References: <20220328203351.79603-1-jlayton@kernel.org>
Date:   Tue, 29 Mar 2022 10:19:16 +0100
In-Reply-To: <20220328203351.79603-1-jlayton@kernel.org> (Jeff Layton's
        message of "Mon, 28 Mar 2022 16:33:51 -0400")
Message-ID: <87mth9qfor.fsf@brahms.olymp>
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

> Atomic open can act as a lookup if handed a dentry that is negative on
> the MDS. Ensure that we set DCACHE_NOKEY_NAME on the dentry in
> atomic_open, if we don't have the key for the parent. Otherwise, we can
> end up validating the dentry inappropriately if someone later adds a
> key.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/file.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> Another patch for the fscrypt series.
>
> A much less heavy-handed fix for generic/580 and generic/593. I'll
> probably fold this into an earlier patch in the series since it appears
> to be a straightforward bug.

Ah!  This seems to be it, thanks Jeff.  One thing that may be worth doing
is to turn this pattern into an inline function, as it is repeated in a
few other places.  But anyway:

Reviewed-by: Lu=C3=ADs Henriques <lhenriques@suse.de>

Cheers,
--=20
Lu=C3=ADs

> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index eb04dc8f1f93..5072570c2203 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -765,8 +765,14 @@ int ceph_atomic_open(struct inode *dir, struct dentr=
y *dentry,
>  	req->r_args.open.mask =3D cpu_to_le32(mask);
>  	req->r_parent =3D dir;
>  	ihold(dir);
> -	if (IS_ENCRYPTED(dir))
> +	if (IS_ENCRYPTED(dir)) {
>  		set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
> +		if (!fscrypt_has_encryption_key(dir)) {
> +			spin_lock(&dentry->d_lock);
> +			dentry->d_flags |=3D DCACHE_NOKEY_NAME;
> +			spin_unlock(&dentry->d_lock);
> +		}
> +	}
>=20=20
>  	if (flags & O_CREAT) {
>  		struct ceph_file_layout lo;
> --=20
>
> 2.35.1
>

