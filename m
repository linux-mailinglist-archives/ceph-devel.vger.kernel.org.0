Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37725549720
	for <lists+ceph-devel@lfdr.de>; Mon, 13 Jun 2022 18:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352134AbiFMPJX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 13 Jun 2022 11:09:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358007AbiFMPIw (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 13 Jun 2022 11:08:52 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B78106A62;
        Mon, 13 Jun 2022 05:21:15 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id CB3941F37C;
        Mon, 13 Jun 2022 12:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1655122873; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xW48YGIH48qGmy0d77xaxLO0TwQZdAB5mEVMvhaBs0k=;
        b=N4J2nOWZEt/2QBkCmQ8ExlE8cduOnUmS+T5yjLZuY0BQSXQ/bP4QBAXP/tPoCuqz05KE5R
        hdPbvzhOOcrYqGq72119lI43hKQ3PpI39nM3Zly5Y7Wy7w7VQ7wPB/hmzQwFt+dY0WIvf+
        A7ZY0Aj1xKYCGupAmJz98AD1S3fpZ3s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1655122873;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xW48YGIH48qGmy0d77xaxLO0TwQZdAB5mEVMvhaBs0k=;
        b=gq6HCjaHyiKCyvsRkENUSsPxVzESOgn7WkSesxUvE86/YbApvJet5DJ+8D24nP5B4W/ZG+
        7W6syEQ2Z9TBumCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 83A2713443;
        Mon, 13 Jun 2022 12:21:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 3LjKHrkrp2KiDwAAMHmgww
        (envelope-from <ddiss@suse.de>); Mon, 13 Jun 2022 12:21:13 +0000
Date:   Mon, 13 Jun 2022 14:21:12 +0200
From:   David Disseldorp <ddiss@suse.de>
To:     =?UTF-8?B?THXDrXM=?= Henriques <lhenriques@suse.de>
Cc:     fstests@vger.kernel.org, Zorro Lang <zlang@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Jeff Layton <jlayton@kernel.org>, Xiubo Li <xiubli@redhat.com>,
        ceph-devel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] generic/020: adjust max_attrval_size for ceph
Message-ID: <20220613142112.5d34e264@suse.de>
In-Reply-To: <20220613113142.4338-2-lhenriques@suse.de>
References: <20220613113142.4338-1-lhenriques@suse.de>
        <20220613113142.4338-2-lhenriques@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

On Mon, 13 Jun 2022 12:31:41 +0100, Lu=C3=ADs Henriques wrote:

> CephFS doesn't have a maximum xattr size.  Instead, it imposes a maximum
> size for the full set of xattrs names+values, which by default is 64K.
>=20
> This patch fixes the max_attrval_size for ceph so that it is takes into
> account any already existing attrs in the file.
>=20
> Signed-off-by: Lu=C3=ADs Henriques <lhenriques@suse.de>
> ---
>  tests/generic/020 | 33 +++++++++++++++++++++++++--------
>  1 file changed, 25 insertions(+), 8 deletions(-)
>=20
> diff --git a/tests/generic/020 b/tests/generic/020
> index d8648e96286e..b91bca34dcd4 100755
> --- a/tests/generic/020
> +++ b/tests/generic/020
> @@ -51,13 +51,9 @@ _attr_list()
>      fi
>  }
> =20
> -# set fs-specific max_attrs and max_attrval_size values. The parameter
> -# @max_attrval_namelen is required for filesystems which take into accou=
nt attr
> -# name lengths (including namespace prefix) when determining limits.
> +# set fs-specific max_attrs
>  _attr_get_max()
>  {
> -	local max_attrval_namelen=3D"$1"
> -
>  	# set maximum total attr space based on fs type
>  	case "$FSTYP" in
>  	xfs|udf|pvfs2|9p|ceph|nfs)
> @@ -112,6 +108,16 @@ _attr_get_max()
>  		# overhead
>  		let max_attrs=3D$BLOCK_SIZE/40
>  	esac
> +}
> +
> +# set fs-specific max_attrval_size values. The parameter @max_attrval_na=
melen is
> +# required for filesystems which take into account attr name lengths (in=
cluding
> +# namespace prefix) when determining limits; parameter @filename is requ=
ired for
> +# filesystems that need to take into account already existing attrs.
> +_attr_get_maxval_size()
> +{
> +	local max_attrval_namelen=3D"$1"
> +	local filename=3D"$2"
> =20
>  	# Set max attr value size in bytes based on fs type
>  	case "$FSTYP" in
> @@ -128,7 +134,7 @@ _attr_get_max()
>  	pvfs2)
>  		max_attrval_size=3D8192
>  		;;
> -	xfs|udf|9p|ceph)
> +	xfs|udf|9p)
>  		max_attrval_size=3D65536
>  		;;
>  	bcachefs)
> @@ -139,6 +145,15 @@ _attr_get_max()
>  		# the underlying filesystem, so just use the lowest value above.
>  		max_attrval_size=3D1024
>  		;;
> +	ceph)
> +		# CephFS does not have a maximum value for attributes.  Instead,
> +		# it imposes a maximum size for the full set of xattrs
> +		# names+values, which by default is 64K.  Compute the maximum
> +		# taking into account the already existing attributes
> +		max_attrval_size=3D$(getfattr --dump -e hex $filename 2>/dev/null | \
> +			awk -F "=3D0x" '/^user/ {len +=3D length($1) + length($2) / 2} END {p=
rint len}')
> +		max_attrval_size=3D$((65536 - $max_attrval_size - $max_attrval_namelen=
))
> +		;;
>  	*)
>  		# Assume max ~1 block of attrs
>  		BLOCK_SIZE=3D`_get_block_size $TEST_DIR`
> @@ -181,8 +196,7 @@ echo "*** remove attribute"
>  _attr -r fish $testfile
>  _attr_list $testfile
> =20
> -max_attrval_name=3D"long_attr"	# add 5 for "user." prefix
> -_attr_get_max "$(( 5 + ${#max_attrval_name} ))"
> +_attr_get_max
> =20
>  echo "*** add lots of attributes"
>  v=3D0
> @@ -226,6 +240,9 @@ done
>  _attr_list $testfile
> =20
>  echo "*** really long value"
> +max_attrval_name=3D"long_attr"	# add 5 for "user." prefix
> +_attr_get_maxval_size "$(( 5 + ${#max_attrval_name} ))" "$testfile"
> +
>  dd if=3D/dev/zero bs=3D1 count=3D$max_attrval_size 2>/dev/null \
>      | _attr -s "$max_attrval_name" $testfile >/dev/null
> =20

Looks good.
Reviewed-by: David Disseldorp <ddiss@suse.de>
