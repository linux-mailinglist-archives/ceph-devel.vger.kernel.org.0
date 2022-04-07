Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 840304F8391
	for <lists+ceph-devel@lfdr.de>; Thu,  7 Apr 2022 17:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236699AbiDGPfc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 7 Apr 2022 11:35:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232934AbiDGPfb (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 7 Apr 2022 11:35:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00EA71143
        for <ceph-devel@vger.kernel.org>; Thu,  7 Apr 2022 08:33:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CABA61486
        for <ceph-devel@vger.kernel.org>; Thu,  7 Apr 2022 15:33:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54F81C385A4;
        Thu,  7 Apr 2022 15:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649345596;
        bh=XN/gJ/xtW9ZtYrk/bdVuUB6YwjJiEhm6aUhaNRccJLM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=UxzEyLVnKzK0W+tLly7l4de0jJ9sZFrpvIK8wFHZjCqgPLDPDpilCVEBaOtgC3T9G
         2B54lRlyY+QFbc0xk69K7pdRa8wQyZStO0WqdK5n+WoAjLFd3t51NtkWvJaPvaqL0G
         yZbmtlTSPuZtIafi7+waBBROeGjNfR/6k+eanf0bwV5UWGU4ipwALShj5STzOh1yB9
         amUKNW71jb9tm7Im2JJr7+EfOJaw8iQReIV4IllpYx/tO60+GiUak9f+IqqsgjdULl
         kAUoLeLPgxqxgHsL4Xhvdkqs5PxaLCPxTv2ggU8JMRnoepxvBP+rL8Q493fNLU5/PN
         yCyijqbnU6t8A==
Message-ID: <3315c167cc44f38c4eb9ebe76685418e85c9b9f2.camel@kernel.org>
Subject: Re: [PATCH 2/2] ceph: fix coherency issue when truncating file size
 for fscrypt
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org
Date:   Thu, 07 Apr 2022 11:33:14 -0400
In-Reply-To: <20220407144112.8455-3-xiubli@redhat.com>
References: <20220407144112.8455-1-xiubli@redhat.com>
         <20220407144112.8455-3-xiubli@redhat.com>
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
> When truncating the file size the MDS will help update the last
> encrypted block, and during this we need to make sure the client
> won't fill the pagecaches.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/inode.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index f4059d73edd5..cc1829ab497d 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -2647,9 +2647,12 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
>  		req->r_num_caps = 1;
>  		req->r_stamp = attr->ia_ctime;
>  		if (fill_fscrypt) {
> +			filemap_invalidate_lock(inode->i_mapping);
>  			err = fill_fscrypt_truncate(inode, req, attr);
> -			if (err)
> +			if (err) {
> +				filemap_invalidate_unlock(inode->i_mapping);
>  				goto out;
> +			}
>  		}
>  
>  		/*
> @@ -2660,6 +2663,8 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
>  		 * it.
>  		 */
>  		err = ceph_mdsc_do_request(mdsc, NULL, req);
> +		if (fill_fscrypt)
> +			filemap_invalidate_unlock(inode->i_mapping);
>  		if (err == -EAGAIN && truncate_retry--) {
>  			dout("setattr %p result=%d (%s locally, %d remote), retry it!\n",
>  			     inode, err, ceph_cap_string(dirtied), mask);

Looks reasonable. Is there any reason we shouldn't do this in the non-
encrypted case too? I suppose it doesn't make as much difference in that
case.

I'll plan to pull this and the other patch into the wip-fscrypt branch.
Should I just fold them into your earlier patches?
-- 
Jeff Layton <jlayton@kernel.org>
