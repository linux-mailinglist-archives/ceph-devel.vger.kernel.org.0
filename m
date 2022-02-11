Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DDA84B23E8
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Feb 2022 12:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241306AbiBKLDX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 11 Feb 2022 06:03:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234255AbiBKLDW (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 11 Feb 2022 06:03:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9223FD57
        for <ceph-devel@vger.kernel.org>; Fri, 11 Feb 2022 03:03:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F75261648
        for <ceph-devel@vger.kernel.org>; Fri, 11 Feb 2022 11:03:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B250C340E9;
        Fri, 11 Feb 2022 11:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644577400;
        bh=EUlVMOA3jHEP2GWM2ij4nubtXSzrF6v1Pyv1/bKnXmw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=qnr/rsMZ6Sn9cvafKFtm33jqit5cvpwLdVR7RBckjL3yyPBVvbTjtMcMc2DIYgSQX
         s6iZFH+2HJq6mp9cpU1dXQtNyJaUNvxhUKbFjR4kVREgDgT3Ck3VIpQyWJGHBiRCM1
         K+Pwr8iDTtqr7A9zf27gPV3qFtuH+Uk+vdd2MDEX+y2itTuXthWvHFNblZygDITbQq
         bmzr8QffVLDS6yAZ+MqdfB8yVBf6FpTyAIBUpLcDWGm/s2IIY0bJsxHDgj3VWuutCk
         j8H+PrLmqRMErnK6XEEIwr8kicUYHkgcnOcTtAQM0D4jEDJ5twD1bHKvu8P/xyRcEh
         +KsIJwWGExLrg==
Message-ID: <8e16074956200adad0f3ccf37aabc919ceb4a9c3.camel@kernel.org>
Subject: Re: [PATCH] fs/ceph: fix comments mentioning i_mutex
From:   Jeff Layton <jlayton@kernel.org>
To:     Hongnan Li <hongnan.li@linux.alibaba.com>,
        ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com
Date:   Fri, 11 Feb 2022 06:03:18 -0500
In-Reply-To: <20220211033325.126209-1-hongnan.li@linux.alibaba.com>
References: <20220211033325.126209-1-hongnan.li@linux.alibaba.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
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

On Fri, 2022-02-11 at 11:33 +0800, Hongnan Li wrote:
> From: hongnanli <hongnan.li@linux.alibaba.com>
> 
> inode->i_mutex has been replaced with inode->i_rwsem long ago. Fix
> comments still mentioning i_mutex.
> 
> Signed-off-by: hongnanli <hongnan.li@linux.alibaba.com>
> ---
>  fs/ceph/dir.c   | 6 +++---
>  fs/ceph/inode.c | 4 ++--
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index 133dbd9338e7..0cf6afe283e9 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -145,7 +145,7 @@ __dcache_find_get_entry(struct dentry *parent, u64 idx,
>  			return ERR_PTR(-EAGAIN);
>  		}
>  		/* reading/filling the cache are serialized by
> -		   i_mutex, no need to use page lock */
> +		   i_rwsem, no need to use page lock */
>  		unlock_page(cache_ctl->page);
>  		cache_ctl->dentries = kmap(cache_ctl->page);
>  	}
> @@ -155,7 +155,7 @@ __dcache_find_get_entry(struct dentry *parent, u64 idx,
>  	rcu_read_lock();
>  	spin_lock(&parent->d_lock);
>  	/* check i_size again here, because empty directory can be
> -	 * marked as complete while not holding the i_mutex. */
> +	 * marked as complete while not holding the i_rwsem. */
>  	if (ceph_dir_is_complete_ordered(dir) && ptr_pos < i_size_read(dir))
>  		dentry = cache_ctl->dentries[cache_ctl->index];
>  	else
> @@ -671,7 +671,7 @@ struct dentry *ceph_handle_snapdir(struct ceph_mds_request *req,
>  				   struct dentry *dentry)
>  {
>  	struct ceph_fs_client *fsc = ceph_sb_to_client(dentry->d_sb);
> -	struct inode *parent = d_inode(dentry->d_parent); /* we hold i_mutex */
> +	struct inode *parent = d_inode(dentry->d_parent); /* we hold i_rwsem */
>  
>  	/* .snap dir? */
>  	if (ceph_snap(parent) == CEPH_NOSNAP &&
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index ef4a980a7bf3..22adddb3d051 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -1201,7 +1201,7 @@ static void update_dentry_lease_careful(struct dentry *dentry,
>  
>  /*
>   * splice a dentry to an inode.
> - * caller must hold directory i_mutex for this to be safe.
> + * caller must hold directory i_rwsem for this to be safe.
>   */
>  static int splice_dentry(struct dentry **pdn, struct inode *in)
>  {
> @@ -1598,7 +1598,7 @@ static int fill_readdir_cache(struct inode *dir, struct dentry *dn,
>  			return idx == 0 ? -ENOMEM : 0;
>  		}
>  		/* reading/filling the cache are serialized by
> -		 * i_mutex, no need to use page lock */
> +		 * i_rwsem, no need to use page lock */
>  		unlock_page(ctl->page);
>  		ctl->dentries = kmap(ctl->page);
>  		if (idx == 0)

Merged into ceph-client/testing branch.

Thanks!
-- 
Jeff Layton <jlayton@kernel.org>
