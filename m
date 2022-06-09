Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46034544ED8
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Jun 2022 16:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245548AbiFIOV4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 Jun 2022 10:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343734AbiFIOVO (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 9 Jun 2022 10:21:14 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 199112E29A2;
        Thu,  9 Jun 2022 07:21:12 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id C369721F87;
        Thu,  9 Jun 2022 14:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654784470; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SdrQPsA8JJdVB7vlQ9eIzJmzz4sN89CbqNqwaCgZoYE=;
        b=nBeRHoCjRq6aKRieGf6FHAVyxlRROtZYaJALZs7QIrGHkFKXSs0gDHY7KTGkCd4yPqqQtL
        m337XL1fi4QbVkijv8Xm9wG5mxoUQuINBG7CsbW74c/oRqxFPwRcrV5W4gXJCbXjQASDrn
        rMsLjOYLnH1hEVmKa7gVnNuYUgFTE18=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654784470;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SdrQPsA8JJdVB7vlQ9eIzJmzz4sN89CbqNqwaCgZoYE=;
        b=2ptDzbVZfIb2Whhc+rjYl1jipb4mQKt11vnyZsAZShhEClUhG1GPNnHhE8PXic9mSzuowW
        JzEpyU8hQvu3gQCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 830C113A8C;
        Thu,  9 Jun 2022 14:21:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id N3laHtYBomI1bgAAMHmgww
        (envelope-from <ddiss@suse.de>); Thu, 09 Jun 2022 14:21:10 +0000
Date:   Thu, 9 Jun 2022 16:21:09 +0200
From:   David Disseldorp <ddiss@suse.de>
To:     =?UTF-8?B?THXDrXM=?= Henriques <lhenriques@suse.de>
Cc:     fstests@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Jeff Layton <jlayton@kernel.org>, Xiubo Li <xiubli@redhat.com>,
        ceph-devel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] generic/020: adjust max_attrval_size for ceph
Message-ID: <20220609162109.23883b71@suse.de>
In-Reply-To: <20220609105343.13591-2-lhenriques@suse.de>
References: <20220609105343.13591-1-lhenriques@suse.de>
        <20220609105343.13591-2-lhenriques@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Lu=C3=ADs,

On Thu,  9 Jun 2022 11:53:42 +0100, Lu=C3=ADs Henriques wrote:

> CephFS doesn't have a maximum xattr size.  Instead, it imposes a maximum
> size for the full set of xattrs names+values, which by default is 64K.
>=20
> This patch fixes the max_attrval_size so that it is slightly < 64K in
> order to accommodate any already existing xattrs in the file.
>=20
> Signed-off-by: Lu=C3=ADs Henriques <lhenriques@suse.de>
> ---
>  tests/generic/020 | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>=20
> diff --git a/tests/generic/020 b/tests/generic/020
> index d8648e96286e..76f13220fe85 100755
> --- a/tests/generic/020
> +++ b/tests/generic/020
> @@ -128,7 +128,7 @@ _attr_get_max()
>  	pvfs2)
>  		max_attrval_size=3D8192
>  		;;
> -	xfs|udf|9p|ceph)
> +	xfs|udf|9p)
>  		max_attrval_size=3D65536
>  		;;
>  	bcachefs)
> @@ -139,6 +139,14 @@ _attr_get_max()
>  		# the underlying filesystem, so just use the lowest value above.
>  		max_attrval_size=3D1024
>  		;;
> +	ceph)
> +		# CephFS does not have a maximum value for attributes.  Instead,
> +		# it imposes a maximum size for the full set of xattrs
> +		# names+values, which by default is 64K.  Set this to a value
> +		# that is slightly smaller than 64K so that it can accommodate
> +		# already existing xattrs.
> +		max_attrval_size=3D65000
> +		;;

I take it a more exact calculation would be something like:
(64K - $max_attrval_namelen - sizeof(user.snrub=3D"fish2\012"))?

Perhaps you could calculate this on the fly for CephFS by passing in the
filename and subtracting the `getfattr -d $filename` results... That
said, it'd probably get a bit ugly, expecially if encoding needs to be
taken into account.

Reviewed-by: David Disseldorp <ddiss@suse.de>

Cheers, David
