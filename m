Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C32FB4F83F7
	for <lists+ceph-devel@lfdr.de>; Thu,  7 Apr 2022 17:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbiDGPsP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 7 Apr 2022 11:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345395AbiDGPrz (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 7 Apr 2022 11:47:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E69EC12D8
        for <ceph-devel@vger.kernel.org>; Thu,  7 Apr 2022 08:45:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0FDD61E38
        for <ceph-devel@vger.kernel.org>; Thu,  7 Apr 2022 15:45:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54B2CC385A0;
        Thu,  7 Apr 2022 15:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649346353;
        bh=kRJAvX754oQ8Y5v28RxvYFLg1rJXvgeLKgxQjrROFjo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=sDiPWnzbMten75Vg9n29m0N71jYcjzhU0GJ/+zc1wt1n855DhvnxKjBfQdnJcQvhR
         MGG2hQTRqJK4QAi7aSLNxlpbvaoDc6gAzdetI8LjioET5vCnAZAadRzilTVp5VcBmm
         ag6JEqOzRwX4gOjtCY/Or97/qHxkgFt55yVNWX9+QuMsPgaPkJYD4IfSEsYPaOKzEg
         t9t1lZ/Z29d56MFh11GLYYHFoWPaN5NtDjkc7HNYJRnCbHXBN3VxN4zziRajSbCcft
         Dbq7K4XNjlOtEhPBQnTCuoPmxdILLRp89+7u8elp37fQ3vKS6OJmBtu4P6s9WLKfBE
         b7+wykNRVe7Tg==
Message-ID: <1677074117b56ecfb96e2eef7b9760e6d8cde581.camel@kernel.org>
Subject: Re: [PATCH 1/2] ceph: flush small range instead of the whole map
 for truncate
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org
Date:   Thu, 07 Apr 2022 11:45:51 -0400
In-Reply-To: <20220407144112.8455-2-xiubli@redhat.com>
References: <20220407144112.8455-1-xiubli@redhat.com>
         <20220407144112.8455-2-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2022-04-07 at 22:41 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/inode.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 45ca4e598ef0..f4059d73edd5 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -2275,8 +2275,12 @@ static int fill_fscrypt_truncate(struct inode *inode,
>  	     ceph_cap_string(issued));
>  
>  	/* Try to writeback the dirty pagecaches */
> -	if (issued & (CEPH_CAP_FILE_BUFFER))
> -		filemap_write_and_wait(inode->i_mapping);
> +	if (issued & (CEPH_CAP_FILE_BUFFER)) {
> +		ret = filemap_write_and_wait_range(inode->i_mapping,
> +						   orig_pos, LLONG_MAX);
> +		if (ret < 0)
> +			goto out;
> +	}
> 
> 


Not much point in writing back blocks we're just going to truncate away
anyhow. Maybe this should be writing with this range?

    orig_pos, orig_pos + CEPH_FSCRYPT_BLOCK_SIZE - 1

>  
>  	page = __page_cache_alloc(GFP_KERNEL);
>  	if (page == NULL) {

-- 
Jeff Layton <jlayton@kernel.org>
