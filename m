Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0C24D6754
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Mar 2022 18:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350605AbiCKRPr (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 11 Mar 2022 12:15:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234943AbiCKRPq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 11 Mar 2022 12:15:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D65A198EC8
        for <ceph-devel@vger.kernel.org>; Fri, 11 Mar 2022 09:14:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2CDFB82C88
        for <ceph-devel@vger.kernel.org>; Fri, 11 Mar 2022 17:14:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09D46C340EE;
        Fri, 11 Mar 2022 17:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647018880;
        bh=1U5zGUBxmjhxme9J5RZuV4Wyz+T0lNx0MSDnY04WI6A=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=psi20oPKWlwD+XE7l/qm/P4ntaBLg4JSj0KSpD7cWOqNFaUD6mpBkpxSxkaHcYlhf
         gkBvFPb6tp+tmugjnhkSGuT9WL+Ng3UEUvsW2pbbOQIP6Qb6lmalW1JDmYzS8sfiAa
         wz8LN+j7HjJi0hSp01YeIeEuc5Ly2mwXbXIdx+C1ZGYPyx+vyjHp1P6TvyBt4pxGAi
         PZYXT1Pdie37+k0/IpyGM0LHfWwUuPJi50vlYZxTDBEiwy38DP1ftPfPlJ8BdxGDkV
         /W/vheuGEMjEWZ3TUUqE8xPupLp08W8MPDU6dxYU8ZCFAL58yskcrQwKLGZOErarOJ
         QYJ1CQ+yrMeuA==
Message-ID: <e20170a5767809cdf82ce052d2bc09b559df0a50.camel@kernel.org>
Subject: Re: [PATCH] ceph: fix base64 encoded name's length check in
 ceph_fname_to_usr()
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org
Date:   Fri, 11 Mar 2022 12:14:38 -0500
In-Reply-To: <20220311041505.160241-1-xiubli@redhat.com>
References: <20220311041505.160241-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2022-03-11 at 12:15 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> The fname->name is based64_encoded names and the max long shouldn't
> exceed the NAME_MAX.
> 
> The FSCRYPT_BASE64URL_CHARS(NAME_MAX) will be 255 * 4 / 3.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
> 
> Note:
> 
> This patch is bansed on the wip-fscrpt branch in ceph-client repo.
> 
> 
>  fs/ceph/crypto.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
> index 5a87e7385d3f..560481b6c964 100644
> --- a/fs/ceph/crypto.c
> +++ b/fs/ceph/crypto.c
> @@ -205,7 +205,7 @@ int ceph_fname_to_usr(const struct ceph_fname *fname, struct fscrypt_str *tname,
>  	}
>  
>  	/* Sanity check that the resulting name will fit in the buffer */
> -	if (fname->name_len > FSCRYPT_BASE64URL_CHARS(NAME_MAX))
> +	if (fname->name_len > NAME_MAX || fname->ctext_len > NAME_MAX)
>  		return -EIO;
>  
>  	ret = __fscrypt_prepare_readdir(fname->dir);

Thanks, Xiubo. Merged into wip-fscrypt branch. For now I've left this as
a separate patch, but I may squash it into the patch that adds
ceph_fname_to_usr eventually.

-- 
Jeff Layton <jlayton@kernel.org>
