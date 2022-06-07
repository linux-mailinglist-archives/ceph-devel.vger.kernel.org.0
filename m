Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DAFF54027F
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Jun 2022 17:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344161AbiFGPdX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 7 Jun 2022 11:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344148AbiFGPdV (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 7 Jun 2022 11:33:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 284A5473BA;
        Tue,  7 Jun 2022 08:33:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ABDA7B81F86;
        Tue,  7 Jun 2022 15:33:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EEE4C385A5;
        Tue,  7 Jun 2022 15:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654615996;
        bh=TwsbiI7wA7yHnCSTZgnxdqHc73XDJvZAOwSMQf1AXic=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s7K7IisAH2SkbN/DYtM7Bh+2gcEHa0a6ezIaY4TPZ0Iog9ZP3OZKzlNPHO4DG2cK7
         HwWuEJMaF2uOQe23HTdqX83r/wFK5mN2exnqzh1XQk9WIOBFBLTXEB3FM2ud8DhXaV
         k1BYStyCUytdV4/S5lSfFTz4MbIvYMJvav8kqjE+3pNJYqq+fpE5hZA1REZU6dc81P
         6iwzrvR86LdZBbY5E3LPalRmdGcUSGp0wX13pxL4WQYtDpU/HaSi6t/ov7AkUo80u2
         C+eWtVuzgLN+AmEE+V4hkoDlNC6xA/zN9eZczFs9ay02nsqeD+1Dy3kRAsSOujROTK
         yQR33RhGqUZrQ==
Date:   Tue, 7 Jun 2022 08:33:15 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
Cc:     fstests@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Xiubo Li <xiubli@redhat.com>, ceph-devel@vger.kernel.org
Subject: Re: [PATCH 2/2] src/attr_replace_test: dynamically adjust the max
 xattr size
Message-ID: <Yp9vu5RIxMc+Gbgs@magnolia>
References: <20220607151513.26347-1-lhenriques@suse.de>
 <20220607151513.26347-3-lhenriques@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220607151513.26347-3-lhenriques@suse.de>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jun 07, 2022 at 04:15:13PM +0100, Luís Henriques wrote:
> CephFS doesn't had a maximum xattr size.  Instead, it imposes a maximum
> size for the full set of an inode's xattrs names+values, which by default
> is 64K but it can be changed by a cluster admin.
> 
> Test generic/486 started to fail after fixing a ceph bug where this limit
> wasn't being imposed.  Adjust dynamically the size of the xattr being set
> if the error returned is -ENOSPC.
> 
> Signed-off-by: Luís Henriques <lhenriques@suse.de>
> ---
>  src/attr_replace_test.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/src/attr_replace_test.c b/src/attr_replace_test.c
> index cca8dcf8ff60..de18e643f469 100644
> --- a/src/attr_replace_test.c
> +++ b/src/attr_replace_test.c
> @@ -62,7 +62,10 @@ int main(int argc, char *argv[])
>  
>  	/* Then, replace it with bigger one, forcing short form to leaf conversion. */
>  	memset(value, '1', size);
> -	ret = fsetxattr(fd, name, value, size, XATTR_REPLACE);
> +	do {
> +		ret = fsetxattr(fd, name, value, size, XATTR_REPLACE);
> +		size -= 256;
> +	} while ((ret < 0) && (errno == ENOSPC) && (size > 0));

Isn't @size a size_t?  Which means that it can't be less than zero?  I
wouldn't count on st_blksize (or XATTR_SIZE_MAX) always being a multiple
of 256.

--D

>  	if (ret < 0) die();
>  	close(fd);
>  
