Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F42F4EFBC9
	for <lists+ceph-devel@lfdr.de>; Fri,  1 Apr 2022 22:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352608AbiDAUs6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 1 Apr 2022 16:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbiDAUs5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 1 Apr 2022 16:48:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1431B1AA481;
        Fri,  1 Apr 2022 13:47:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C10E619F4;
        Fri,  1 Apr 2022 20:47:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55574C340EC;
        Fri,  1 Apr 2022 20:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648846025;
        bh=sPjBLIoOm312lKnub3ir9KU7wXeyd1MqZRKyHSlIOiw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=u7ppwrARKkhJ61I5YHqz2LpqUFCEnw+hj+Zy5we8kt54OYHaPdgSH/JA5UEDIfZNU
         RlSeNpbpDRGGXhv52PgbJ6erfJbfUPCp+XsOwlFI4n/wKw+LcRTN5+MPxvFFtb3sAc
         sgLwLFmzNow0anxzUgGbb5UNrl8nFyUQzB3guJMQd0tUVPpvJhBTb8Pm8NI1/i+Wfk
         W6sjZxvGVlKeuz4t2w/UZPX2dldXqy/J6OnkaY2ilVkBG0bpm8HImfV2y0TCxpz+j5
         sAouAG5cA+biFgVuTCN9Wwr4jPHDxrxoRXJZEZVhil4GYOkqiV2p23cGa671HMC2nE
         9wGq5q8/KHb2A==
Message-ID: <91184ff91ad2a5dc4e537294cade1409bbb8ad39.camel@kernel.org>
Subject: Re: [PATCH] common/encrypt: allow the use of 'fscrypt:' as key
 prefix
From:   Jeff Layton <jlayton@kernel.org>
To:     =?ISO-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>,
        Eric Biggers <ebiggers@kernel.org>
Cc:     ceph-devel@vger.kernel.org, fstests@vger.kernel.org
Date:   Fri, 01 Apr 2022 16:47:03 -0400
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

For the record, without this patch in place, generic/397 hangs when
tested against the current ceph+fscrypt pile. With this, the test
passes.

Cheers,
-- 
Jeff Layton <jlayton@kernel.org>
