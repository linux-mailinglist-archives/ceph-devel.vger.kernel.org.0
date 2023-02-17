Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A136B69B19A
	for <lists+ceph-devel@lfdr.de>; Fri, 17 Feb 2023 18:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbjBQRJQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 17 Feb 2023 12:09:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBQRJP (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 17 Feb 2023 12:09:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D81AB6ABFF;
        Fri, 17 Feb 2023 09:09:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E054B82CA1;
        Fri, 17 Feb 2023 17:09:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAF65C4339B;
        Fri, 17 Feb 2023 17:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676653751;
        bh=RxY2sIS4CNyYCaV1BX6DaHZXNJy5VYzjRX5MH4HgS2w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GvlxwLR1+tkVoOVQrxerdRc3EQfJCvtrscm/vyVEzgdxcPT6t3zSpOg1WCAtW/EkJ
         pmWvtFztiq0ZKkV11+1WsGjwhiFWWLkW6A1ug6pOs4/tD+zf6iFttW0Q232RM3j0Y4
         TL0ZsqF7XSMuIna8rSKLh+6XoxsKQ0Ov04OqGuyA5PmcrkcKdVSYRpMLdmptJzEXq4
         LKBljG17LewQzeYRaXcf6k68cwaKnTmw1b58s0HZV5nLptAfVHrG/oDqrpRFg65Yub
         ojJIa/HgMc0nDmGCq3Siv0KxYrgMBQWoDPicu/2UHqLLc0TDkm+b1k1IVuSTnAQocx
         a9JMekY7T5CDQ==
Date:   Fri, 17 Feb 2023 09:09:11 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xiubli@redhat.com
Cc:     fstests@vger.kernel.org, david@fromorbit.com,
        ceph-devel@vger.kernel.org, vshankar@redhat.com, zlang@redhat.com
Subject: Re: [PATCH] generic/020: fix really long attr test failure for ceph
Message-ID: <Y++0t8qxK8et8fTg@magnolia>
References: <20230217124558.555027-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230217124558.555027-1-xiubli@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Feb 17, 2023 at 08:45:58PM +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> If the CONFIG_CEPH_FS_SECURITY_LABEL is enabled the kernel ceph
> itself will set the security.selinux extended attribute to MDS.
> And it will also eat some space of the total size.
> 
> Fixes: https://tracker.ceph.com/issues/58742
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  tests/generic/020 | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/tests/generic/020 b/tests/generic/020
> index be5cecad..594535b5 100755
> --- a/tests/generic/020
> +++ b/tests/generic/020
> @@ -150,9 +150,11 @@ _attr_get_maxval_size()
>  		# it imposes a maximum size for the full set of xattrs
>  		# names+values, which by default is 64K.  Compute the maximum
>  		# taking into account the already existing attributes
> -		max_attrval_size=$(getfattr --dump -e hex $filename 2>/dev/null | \
> +		size=$(getfattr --dump -e hex $filename 2>/dev/null | \
>  			awk -F "=0x" '/^user/ {len += length($1) + length($2) / 2} END {print len}')
> -		max_attrval_size=$((65536 - $max_attrval_size - $max_attrval_namelen))
> +		selinux_size=$(getfattr -n 'security.selinux' --dump -e hex $filename 2>/dev/null | \
> +			awk -F "=0x" '/^security/ {len += length($1) + length($2) / 2} END {print len}')
> +		max_attrval_size=$((65536 - $size - $selinux_size - $max_attrval_namelen))

If this is a ceph bug, then why is the change being applied to the
section for FSTYP=ext* ?  Why not create a case statement for ceph?

--D

>  		;;
>  	*)
>  		# Assume max ~1 block of attrs
> -- 
> 2.31.1
> 
