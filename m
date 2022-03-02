Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 132D34CA62A
	for <lists+ceph-devel@lfdr.de>; Wed,  2 Mar 2022 14:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242292AbiCBNkP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 2 Mar 2022 08:40:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242285AbiCBNkO (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 2 Mar 2022 08:40:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA6ED2716D
        for <ceph-devel@vger.kernel.org>; Wed,  2 Mar 2022 05:39:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 886C9B81F83
        for <ceph-devel@vger.kernel.org>; Wed,  2 Mar 2022 13:39:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE7C1C004E1;
        Wed,  2 Mar 2022 13:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646228369;
        bh=5MUmxvc4w6l8L6hzkGakXbp6DLV2GpV2qcBVZc1jkbY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=UTnatGN5wLAkvSCXPjPs55ZsQ2eVB0m9KYs0HUQ8sKCV4VSLiN0hhmWT3z1s9m4ln
         zdvSDf8DRGBZMtI11FxPfVQ9CGwaAD/7+7EdW7uUUrBfzaHAubMSat+AzBFbG5Lw6v
         IgqsGXYDzL27WKZ9u9hHleXdO3Rm7bbrOke7YgilUqcR2Z7/Cww+RaS9nr7pvrdWd8
         YIIuIxsiZd49U5vHlzjr9KdAYwYaSb8peuyMluo6GISgWe9j0G4UAHrCNUZ9TyO3UO
         70vsd1tjv/+phQrAABYLzricEyKRUaz+BLoitdhMK78uucQB9YaDVLAbWpza8izEqe
         YTPsZmutOsAUA==
Message-ID: <5cdc302c0e934c079dc23dc01e18be50a078c327.camel@kernel.org>
Subject: Re: [PATCH 1/2] ceph: fix inode reference leakage in
 ceph_get_snapdir()
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
Date:   Wed, 02 Mar 2022 08:39:27 -0500
In-Reply-To: <20220302085402.64740-2-xiubli@redhat.com>
References: <20220302085402.64740-1-xiubli@redhat.com>
         <20220302085402.64740-2-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2022-03-02 at 16:54 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> The ceph_get_inode() will search for or insert a new inode into the
> hash for the given vino, and return a reference to it. If new is
> non-NULL, its reference is consumed.
> 
> We should release the reference when in error handing cases.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/inode.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 8b0832271fdf..cbeba8a93a07 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -164,13 +164,13 @@ struct inode *ceph_get_snapdir(struct inode *parent)
>  	if (!S_ISDIR(parent->i_mode)) {
>  		pr_warn_once("bad snapdir parent type (mode=0%o)\n",
>  			     parent->i_mode);
> -		return ERR_PTR(-ENOTDIR);
> +		goto err;
>  	}
>  
>  	if (!(inode->i_state & I_NEW) && !S_ISDIR(inode->i_mode)) {
>  		pr_warn_once("bad snapdir inode type (mode=0%o)\n",
>  			     inode->i_mode);
> -		return ERR_PTR(-ENOTDIR);
> +		goto err;
>  	}
>  
>  	inode->i_mode = parent->i_mode;
> @@ -190,6 +190,12 @@ struct inode *ceph_get_snapdir(struct inode *parent)
>  	}
>  
>  	return inode;
> +err:
> +	if ((inode->i_state & I_NEW))
> +		discard_new_inode(inode);
> +	else
> +		iput(inode);
> +	return ERR_PTR(-ENOTDIR);
>  }
>  
>  const struct inode_operations ceph_file_iops = {

Good catch!

Reviewed-by: Jeff Layton <jlayton@kernel.org>
