Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0BBD4EF994
	for <lists+ceph-devel@lfdr.de>; Fri,  1 Apr 2022 20:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244348AbiDASOK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 1 Apr 2022 14:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345818AbiDASOJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 1 Apr 2022 14:14:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B4E315D052;
        Fri,  1 Apr 2022 11:12:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0EF2B824FA;
        Fri,  1 Apr 2022 18:12:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68DE5C340F3;
        Fri,  1 Apr 2022 18:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648836735;
        bh=grIjrsg6ZaNJWlQOiis/6gjq6uV+6k53H9SWQ4iaHnw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AJaUXeZat8fgS1zapL9Zl3sD5SO/nfEw5iFuKZEub3pcMaxR2uauMzmcpxj0pD/4j
         poT20TXqfYrBo0ozzCHAFWTZ4IESFrJ8EMht5fIvReT+j/9hcIUYkP6k1h3xgyVNLY
         iF7T0OgWkUej0nU452Ser4Usa1yXA4THW6bDGyFFozzqGxshwVHBDrKWzXideORlIy
         ucXZC7iyBTLDFeFZxP6ZdnAd2UcL18phPtiEyIBH4kg3xB4JZgK+TClB4fVTa/cAeg
         X8Tx8hHkCWPku6KWTTOJSs5J9ZdiqbwuUjy4w2suKcFzgd5vdVhBghgnPK+yLbHscK
         tFMz0A3wecHCg==
Date:   Fri, 1 Apr 2022 18:12:14 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
Cc:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH] common/encrypt: allow the use of 'fscrypt:' as key prefix
Message-ID: <YkdAfpN/YzAm18pl@gmail.com>
References: <20220401104553.32036-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220401104553.32036-1-lhenriques@suse.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Apr 01, 2022 at 11:45:53AM +0100, Luís Henriques wrote:
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

ubifs can use the "fscrypt" prefix, since there was never a kernel that
supported ubifs encryption but not the "fscrypt" prefix.  Also, the "prefix"
local variable is unnecessary.  So:

	case $FSTYP in
	ext4|f2fs)
		echo $FSTYP
		;;
	*)
		echo fscrypt
		;;
	esac

Otherwise, this patch looks fine if we want to keep supporting testing kernels
older than 4.8.  However, since 4.4 is no longer a supported LTS kernel, perhaps
this is no longer needed and we could just always use "fscrypt"?  I'm not sure
what xfstests's policy on old kernels is.

- Eric
