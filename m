Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB4C53EBEA
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Jun 2022 19:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234271AbiFFKPu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 6 Jun 2022 06:15:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233865AbiFFKOg (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 6 Jun 2022 06:14:36 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A035E10552
        for <ceph-devel@vger.kernel.org>; Mon,  6 Jun 2022 03:12:14 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id DB65421A4E;
        Mon,  6 Jun 2022 10:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654510332; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RufSOfOk22nSu2XOLesbSkA024O4T4UZDmEHLPb4NKw=;
        b=TH22Cjyxxh9DUmuMLeuYmkmXZECSGRkK2Z4IBzSsut06x40OmH7mVjF+di04WaTM5LIMLC
        Kdeu2HRNJBanbN7uQqrN6dAinKwsrc4FbrAd02PZuuRMOsWozLmZif1V9Hj8sn8dBpXEAQ
        B15lwnwMmve6u8atKT3orB63u3lwYWQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654510332;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RufSOfOk22nSu2XOLesbSkA024O4T4UZDmEHLPb4NKw=;
        b=qTHocmW+gG7UA5WI4SnSBfgGLRfX2ObFo01uVi6LZjzQk58b6UH1dV7LYXYmNQNqW+q9u4
        c06+wFCFHph0ArAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7E4ED139F5;
        Mon,  6 Jun 2022 10:12:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id v4vQG/zSnWK9EAAAMHmgww
        (envelope-from <lhenriques@suse.de>); Mon, 06 Jun 2022 10:12:12 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 92dd19dc;
        Mon, 6 Jun 2022 10:12:54 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     xiubli@redhat.com, idryomov@gmail.com, ceph-devel@vger.kernel.org
Subject: Re: [PATCH] ceph: don't leak snap_rwsem in handle_cap_grant
References: <20220603203957.55337-1-jlayton@kernel.org>
Date:   Mon, 06 Jun 2022 11:12:54 +0100
In-Reply-To: <20220603203957.55337-1-jlayton@kernel.org> (Jeff Layton's
        message of "Fri, 3 Jun 2022 16:39:57 -0400")
Message-ID: <87fski2j89.fsf@brahms.olymp>
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

> When handle_cap_grant is called on an IMPORT op, then the snap_rwsem is
> held and the function is expected to release it before returning. It
> currently fails to do that in all cases which could lead to a deadlock.
>
> URL: https://tracker.ceph.com/issues/55857

This looks good.  Maybe it could have here a 'Fixes: e8a4d26771547'.
Otherwise:

Reviewed-by: Lu=C3=ADs Henriques <lhenriques@suse.de>

Cheers,
--=20
Lu=C3=ADs


> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/caps.c | 27 +++++++++++++--------------
>  1 file changed, 13 insertions(+), 14 deletions(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 258093e9074d..0a48bf829671 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -3579,24 +3579,23 @@ static void handle_cap_grant(struct inode *inode,
>  			fill_inline =3D true;
>  	}
>=20=20
> -	if (ci->i_auth_cap =3D=3D cap &&
> -	    le32_to_cpu(grant->op) =3D=3D CEPH_CAP_OP_IMPORT) {
> -		if (newcaps & ~extra_info->issued)
> -			wake =3D true;
> +	if (le32_to_cpu(grant->op) =3D=3D CEPH_CAP_OP_IMPORT) {
> +		if (ci->i_auth_cap =3D=3D cap) {
> +			if (newcaps & ~extra_info->issued)
> +				wake =3D true;
> +
> +			if (ci->i_requested_max_size > max_size ||
> +			    !(le32_to_cpu(grant->wanted) & CEPH_CAP_ANY_FILE_WR)) {
> +				/* re-request max_size if necessary */
> +				ci->i_requested_max_size =3D 0;
> +				wake =3D true;
> +			}
>=20=20
> -		if (ci->i_requested_max_size > max_size ||
> -		    !(le32_to_cpu(grant->wanted) & CEPH_CAP_ANY_FILE_WR)) {
> -			/* re-request max_size if necessary */
> -			ci->i_requested_max_size =3D 0;
> -			wake =3D true;
> +			ceph_kick_flushing_inode_caps(session, ci);
>  		}
> -
> -		ceph_kick_flushing_inode_caps(session, ci);
> -		spin_unlock(&ci->i_ceph_lock);
>  		up_read(&session->s_mdsc->snap_rwsem);
> -	} else {
> -		spin_unlock(&ci->i_ceph_lock);
>  	}
> +	spin_unlock(&ci->i_ceph_lock);
>=20=20
>  	if (fill_inline)
>  		ceph_fill_inline_data(inode, NULL, extra_info->inline_data,
> --=20
>
> 2.36.1
>

