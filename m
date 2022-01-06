Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C08B486CB1
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Jan 2022 22:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231896AbiAFVtc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 6 Jan 2022 16:49:32 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51366 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244463AbiAFVtb (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 6 Jan 2022 16:49:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 476F7B8244F
        for <ceph-devel@vger.kernel.org>; Thu,  6 Jan 2022 21:49:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 660ECC36AE3;
        Thu,  6 Jan 2022 21:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641505769;
        bh=UInTysDQ5jhlLJfjKYkNzM1z5Mn/UhXDU7G6bbDupT4=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=g0iATXc889ednrEyvKuxIBV3Ch2BVMWwHC2zl+SODRqu62j/p8Z5xJlcAd1gNVFoO
         XZIiJNp6oApQAJ5QVASr6p/Dazy0J2hlJf1+/orGz9YGKNZpApYsUTC9hl6OztPKil
         XIpUb50HAK0koU8dKoRBgOBRJiraBdthe/Ci7CF56Cmuv1XOXiy4reu9X5j5ohixHL
         KSQa2/ny7TyOGICLuwCck67W7DYyPF61OZqOfvQzokUUx7a55NrlMtBQJFLEOle0/1
         TfhloY492hMLywhHJYiZZF/g9Zge0hzn0D3F+NckiclbfH5GRVb2CZdOULPeATQzgt
         Rw55j4k01zgIg==
Message-ID: <693ab77bab10b38b1ddab373211c24722e79fee2.camel@kernel.org>
Subject: Re: [PATCH] netfs: make ops->init_rreq() optional
From:   Jeff Layton <jlayton@kernel.org>
To:     Jeffle Xu <jefflexu@linux.alibaba.com>, idryomov@gmail.com,
        ceph-devel@vger.kernel.org, dhowells@redhat.com,
        linux-cachefs@redhat.com
Date:   Thu, 06 Jan 2022 16:49:27 -0500
In-Reply-To: <20211228124419.103020-1-jefflexu@linux.alibaba.com>
References: <20211228124419.103020-1-jefflexu@linux.alibaba.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.2 (3.42.2-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2021-12-28 at 20:44 +0800, Jeffle Xu wrote:
> Hi, recently I'm developing erofs over fscache for implementing
> on-demand read, and erofs also implements an empty .init_rreq()
> callback[1].
> 
> [1] https://lkml.org/lkml/2021/12/27/224
> 
> If folks don't like this cleanup and prefer empty callback in upper fs,
> I'm also fine with that.
> ---
> There's already upper fs implementing empty .init_rreq() callback, and
> thus make it optional.
> 
> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> ---
>  fs/ceph/addr.c         | 5 -----
>  fs/netfs/read_helper.c | 3 ++-
>  2 files changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index e53c8541f5b2..c3537dfd8c04 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -291,10 +291,6 @@ static void ceph_netfs_issue_op(struct netfs_read_subrequest *subreq)
>  	dout("%s: result %d\n", __func__, err);
>  }
>  
> -static void ceph_init_rreq(struct netfs_read_request *rreq, struct file *file)
> -{
> -}
> -
>  static void ceph_readahead_cleanup(struct address_space *mapping, void *priv)
>  {
>  	struct inode *inode = mapping->host;
> @@ -306,7 +302,6 @@ static void ceph_readahead_cleanup(struct address_space *mapping, void *priv)
>  }
>  
>  static const struct netfs_read_request_ops ceph_netfs_read_ops = {
> -	.init_rreq		= ceph_init_rreq,
>  	.is_cache_enabled	= ceph_is_cache_enabled,
>  	.begin_cache_operation	= ceph_begin_cache_operation,
>  	.issue_op		= ceph_netfs_issue_op,
> diff --git a/fs/netfs/read_helper.c b/fs/netfs/read_helper.c
> index 75c76cbb27cc..0befb0747c59 100644
> --- a/fs/netfs/read_helper.c
> +++ b/fs/netfs/read_helper.c
> @@ -55,7 +55,8 @@ static struct netfs_read_request *netfs_alloc_read_request(
>  		INIT_WORK(&rreq->work, netfs_rreq_work);
>  		refcount_set(&rreq->usage, 1);
>  		__set_bit(NETFS_RREQ_IN_PROGRESS, &rreq->flags);
> -		ops->init_rreq(rreq, file);
> +		if (ops->init_rreq)
> +			ops->init_rreq(rreq, file);
>  		netfs_stat(&netfs_n_rh_rreq);
>  	}
>  

This looks reasonable to me, since ceph doesn't need anything here
anyway.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
