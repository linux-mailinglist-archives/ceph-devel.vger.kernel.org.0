Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6430453E986
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Jun 2022 19:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233534AbiFFKPy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 6 Jun 2022 06:15:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233646AbiFFKOl (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 6 Jun 2022 06:14:41 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B18C41E175F
        for <ceph-devel@vger.kernel.org>; Mon,  6 Jun 2022 03:12:22 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 4CF8621A5D;
        Mon,  6 Jun 2022 10:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654510340; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SPCKBr5UzBx3ZJVjeAgA4nVGDVRvt/3GW5+QXXNPeFs=;
        b=a5TWkRwrEP9+4nr+bduBE1uYGaFdJUpWpzi3a68eklnPUO3oQGENw5iIpqnCWLmt29BPuJ
        sVPWNnb37g+I13WSKGtfayoki6By8tpkfVipNY4vuBErR1GEwaPSzFoeiruH7OZ5+A+XmV
        x/vILUvAC5Tdux+pKdaZOCKEeKHrMz8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654510340;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SPCKBr5UzBx3ZJVjeAgA4nVGDVRvt/3GW5+QXXNPeFs=;
        b=kRht9HU+qcIWYKX3TDW43POBf8U3Rf8UKMCja6zu+H0rPvQoBsUJ0XNdB4HtgVHBCPbx8I
        bNCww/M00+wdeFAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E540F139F5;
        Mon,  6 Jun 2022 10:12:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 8KfYNAPTnWK9EAAAMHmgww
        (envelope-from <lhenriques@suse.de>); Mon, 06 Jun 2022 10:12:19 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id d2c224b0;
        Mon, 6 Jun 2022 10:13:01 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     jlayton@kernel.org, idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org
Subject: Re: [PATCH] ceph: fix incorrectly assigning random values to peer's
 members
References: <20220606072835.302935-1-xiubli@redhat.com>
Date:   Mon, 06 Jun 2022 11:13:01 +0100
In-Reply-To: <20220606072835.302935-1-xiubli@redhat.com> (Xiubo Li's message
        of "Mon, 6 Jun 2022 15:28:35 +0800")
Message-ID: <87ee022j82.fsf@brahms.olymp>
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

Xiubo Li <xiubli@redhat.com> writes:

> For export the peer is empty in ceph.
>
> URL: https://tracker.ceph.com/issues/55857
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/caps.c | 15 +++++----------
>  1 file changed, 5 insertions(+), 10 deletions(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 0a48bf829671..8efa46ff4282 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -4127,16 +4127,11 @@ void ceph_handle_caps(struct ceph_mds_session *se=
ssion,
>  		p +=3D flock_len;
>  	}
>=20=20
> -	if (msg_version >=3D 3) {
> -		if (op =3D=3D CEPH_CAP_OP_IMPORT) {
> -			if (p + sizeof(*peer) > end)
> -				goto bad;
> -			peer =3D p;
> -			p +=3D sizeof(*peer);
> -		} else if (op =3D=3D CEPH_CAP_OP_EXPORT) {
> -			/* recorded in unused fields */
> -			peer =3D (void *)&h->size;
> -		}
> +	if (msg_version >=3D 3 && op =3D=3D CEPH_CAP_OP_IMPORT) {
> +		if (p + sizeof(*peer) > end)
> +			goto bad;
> +		peer =3D p;
> +		p +=3D sizeof(*peer);
>  	}
>=20=20
>  	if (msg_version >=3D 4) {
> --=20
>
> 2.36.0.rc1
>

Are you sure this isn't breaking anything?  Looking at MClientCaps.h, it
seems to be doing something similar, i.e. for the CAP_OP_EXPORT, the
'peer' is encoded where the 'size', 'max_size', 'truncate_size',...  are
for the CAP_OP_IMPORT.  This is definitely confusing and messy, but not
sure if your change isn't breaking something.

Cheers,
--=20
Lu=C3=ADs
