Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D11504F7CAB
	for <lists+ceph-devel@lfdr.de>; Thu,  7 Apr 2022 12:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244224AbiDGK0a (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 7 Apr 2022 06:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244222AbiDGK0V (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 7 Apr 2022 06:26:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CAE4F7F74
        for <ceph-devel@vger.kernel.org>; Thu,  7 Apr 2022 03:24:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84C9561D76
        for <ceph-devel@vger.kernel.org>; Thu,  7 Apr 2022 10:24:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F6E4C385A0;
        Thu,  7 Apr 2022 10:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649327058;
        bh=VtDjmJQdsMRpKit6Ix9eYQbYoM+G2plfqvarJ5/gYk0=;
        h=Subject:From:To:Cc:In-Reply-To:References:Date:From;
        b=bD05KfXQ26vl6n0wdneNxtBooqr2Fu1LUvu1MRAKqHOL/EhXNzCEliN+XsZbvklrJ
         M/OJ4PaZSQ/K5JbkvKSLMSmVkCBAW7laA/WSqSk7ONAuCXaHhsQJ8nAFsy9zkle53p
         lnji3/WoI5w5rMDyTtiurZaTWRAEEjk/t3lS3PEiHjGXxG06LvkVn3OJs5dM/IMuO1
         PeAcC/0KAbl1WVsYHd+q7CH/8cskezKwqEzOTzJPCH1O6YGwfc30tYiWaY5R51z3Hf
         yXPwi+wWa5btrNupTBXQ5GuzUUELc+yWAe4/yoi7wBlHSCQalex3xFjYUw8XUmUuuf
         PPwVt6mz1gsEw==
Message-ID: <39a5a060f9be3bd9e7e25db29f925a275930bf64.camel@kernel.org>
Subject: Re: [RFC PATCH] ceph: no need to invalidate the fscache twice
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
In-Reply-To: <20220407051242.692846-1-xiubli@redhat.com>
References: <20220407051242.692846-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
MIME-Version: 1.0
Date:   Thu, 07 Apr 2022 06:24:04 -0400
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
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

On Thu, 2022-04-07 at 13:12 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> [ Introduced by commit 400e1286c0ec3: "ceph: conversion to new fscache API" ]
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
> 
> Jeff, is there any reason we need to invalidate the fscache twice in
> ceph_do_invalidate_pages() ?
> 

No, that was a mistake. I'll go ahead and fold this patch into
400e1286c0ec3.

> 
>  fs/ceph/inode.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index cc1829ab497d..b721d86fb582 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -2084,7 +2084,6 @@ static void ceph_do_invalidate_pages(struct inode *inode)
>  	orig_gen = ci->i_rdcache_gen;
>  	spin_unlock(&ci->i_ceph_lock);
>  
> -	ceph_fscache_invalidate(inode, false);
>  	if (invalidate_inode_pages2(inode->i_mapping) < 0) {
>  		pr_err("invalidate_inode_pages2 %llx.%llx failed\n",
>  		       ceph_vinop(inode));

Thanks!
-- 
Jeff Layton <jlayton@kernel.org>
