Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 546504EED3F
	for <lists+ceph-devel@lfdr.de>; Fri,  1 Apr 2022 14:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345907AbiDAMjC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 1 Apr 2022 08:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344160AbiDAMjB (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 1 Apr 2022 08:39:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D341725AEEE;
        Fri,  1 Apr 2022 05:37:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80D22B824BC;
        Fri,  1 Apr 2022 12:37:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CC60C2BBE4;
        Fri,  1 Apr 2022 12:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648816629;
        bh=s9PC8y76IC+IQpYEhdjrGxMwhcvGSv1qbKOPlfwp0Hc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=hMBPmE7igzWMh5a+tYXTAaXYzvVBuebU6D20lk4E4hMlp7fMLAeKRxhJNgrzG8R5A
         5CW5eF3r++EmIztq2p0EpZ4t0TkoLYTO6fYasAzGUfRSv8NxY9IiRjESfZDtqTScZj
         gyD4+iVuilN6vNH/cjtHm9m8ODNbm4UJ1JpTTHNps75TL/+KjFm4gXu1PHqUb3+HFK
         x3St2T7E6PF3j1VHN75No2X3GImyTpFjAKxsb5SkXXmEMnBB7MkigGBapOCHjgmMQd
         xJmxC60akEtkfi+6GbZJetjhbXD+q4zoTD6DXsNFWbg7gZ+jo0d0Ty0FsI/3hydeXa
         2JKDuqBD4g9qg==
Message-ID: <ccf063a8153d37cee480b020db389e4099d2bcad.camel@kernel.org>
Subject: Re: [PATCH] common/encrypt: allow the use of 'fscrypt:' as key
 prefix
From:   Jeff Layton <jlayton@kernel.org>
To:     =?ISO-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>,
        Eric Biggers <ebiggers@kernel.org>
Cc:     ceph-devel@vger.kernel.org, fstests@vger.kernel.org
Date:   Fri, 01 Apr 2022 08:37:07 -0400
In-Reply-To: <20220401104553.32036-1-lhenriques@suse.de>
References: <20220401104553.32036-1-lhenriques@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2022-04-01 at 11:45 +0100, Luís Henriques wrote:
> fscrypt keys have used the $FSTYP as prefix.  However this format is being
> deprecated -- newer kernels already allow the usage of the generic
> 'fscrypt:' prefix for ext4 and f2fs.  This patch allows the usage of this
> new prefix for testing filesystems that have never supported the old
> format, but keeping the $FSTYP prefix for filesystems that support it, so
> that old kernels can be tested.
> 
> Signed-off-by: Luís Henriques <lhenriques@suse.de>
> ---
>  common/encrypt | 38 +++++++++++++++++++++++++++-----------
>  1 file changed, 27 insertions(+), 11 deletions(-)
> 
> diff --git a/common/encrypt b/common/encrypt
> index f90c4ef05a3f..897c97e0f6fa 100644
> --- a/common/encrypt
> +++ b/common/encrypt
> @@ -250,6 +250,27 @@ _num_to_hex()
>  	fi
>  }
>  
> +# Keys are named $FSTYP:KEYDESC where KEYDESC is the 16-character key descriptor
> +# hex string.  Newer kernels (ext4 4.8 and later, f2fs 4.6 and later) also allow
> +# the common key prefix "fscrypt:" in addition to their filesystem-specific key
> +# prefix ("ext4:", "f2fs:").  It would be nice to use the common key prefix, but
> +# for now use the filesystem- specific prefix for these 2 filesystems to make it
> +# possible to test older kernels, and the "fscrypt" prefix for anything else.
> +_get_fs_keyprefix()
> +{
> +	local prefix=""
> +
> +	case $FSTYP in
> +	ext4|f2fs|ubifs)
> +		prefix="$FSTYP"
> +		;;
> +	*)
> +		prefix="fscrypt"
> +		;;
> +	esac
> +	echo $prefix
> +}
> +
>  # Add the specified raw encryption key to the session keyring, using the
>  # specified key descriptor.
>  _add_session_encryption_key()
> @@ -268,18 +289,11 @@ _add_session_encryption_key()
>  	#	};
>  	#
>  	# The kernel ignores 'mode' but requires that 'size' be 64.
> -	#
> -	# Keys are named $FSTYP:KEYDESC where KEYDESC is the 16-character key
> -	# descriptor hex string.  Newer kernels (ext4 4.8 and later, f2fs 4.6
> -	# and later) also allow the common key prefix "fscrypt:" in addition to
> -	# their filesystem-specific key prefix ("ext4:", "f2fs:").  It would be
> -	# nice to use the common key prefix, but for now use the filesystem-
> -	# specific prefix to make it possible to test older kernels...
> -	#
>  	local mode=$(_num_to_hex 0 4)
>  	local size=$(_num_to_hex 64 4)
> +	local prefix=$(_get_fs_keyprefix)
>  	echo -n -e "${mode}${raw}${size}" |
> -		$KEYCTL_PROG padd logon $FSTYP:$keydesc @s >>$seqres.full
> +		$KEYCTL_PROG padd logon $prefix:$keydesc @s >>$seqres.full
>  }
>  
>  #
> @@ -302,7 +316,8 @@ _generate_session_encryption_key()
>  _unlink_session_encryption_key()
>  {
>  	local keydesc=$1
> -	local keyid=$($KEYCTL_PROG search @s logon $FSTYP:$keydesc)
> +	local prefix=$(_get_fs_keyprefix)
> +	local keyid=$($KEYCTL_PROG search @s logon $prefix:$keydesc)
>  	$KEYCTL_PROG unlink $keyid >>$seqres.full
>  }
>  
> @@ -310,7 +325,8 @@ _unlink_session_encryption_key()
>  _revoke_session_encryption_key()
>  {
>  	local keydesc=$1
> -	local keyid=$($KEYCTL_PROG search @s logon $FSTYP:$keydesc)
> +	local prefix=$(_get_fs_keyprefix)
> +	local keyid=$($KEYCTL_PROG search @s logon $prefix:$keydesc)
>  	$KEYCTL_PROG revoke $keyid >>$seqres.full
>  }
>  

Reviewed-by: Jeff Layton <jlayton@kernel.org>
