Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2C6A48D4D9
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Jan 2022 10:49:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234015AbiAMJMG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 13 Jan 2022 04:12:06 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:60236 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233822AbiAMJLf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 13 Jan 2022 04:11:35 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0V1jPsaR_1642065092;
Received: from 30.225.24.62(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0V1jPsaR_1642065092)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 13 Jan 2022 17:11:33 +0800
Message-ID: <b3982eb6-a8a9-a5f7-be93-a4fca68f25f1@linux.alibaba.com>
Date:   Thu, 13 Jan 2022 17:11:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH] netfs: Make ops->init_rreq() optional
Content-Language: en-US
To:     David Howells <dhowells@redhat.com>
Cc:     jlayton@kernel.org, idryomov@gmail.com, ceph-devel@vger.kernel.org,
        linux-cachefs@redhat.com
References: <20211228124419.103020-1-jefflexu@linux.alibaba.com>
 <1483070.1642062179@warthog.procyon.org.uk>
From:   JeffleXu <jefflexu@linux.alibaba.com>
In-Reply-To: <1483070.1642062179@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org



On 1/13/22 4:22 PM, David Howells wrote:
> Hi Jeffle,
> 
> I've altered your patch commit message, if you could take a look?
> 
> David
> ---
> From: Jeffle Xu <jefflexu@linux.alibaba.com>
> 
> netfs: Make ops->init_rreq() optional
> 
> Make the ops->init_rreq() callback optional.  This isn't required for the
> erofs changes I'm implementing to do on-demand read through fscache[1].
> Further, ceph has an empty init_rreq method that can then be removed and
> it's marked optional in the documentation.
> 
> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Reviewed-by: Jeff Layton <jlayton@kernel.org>
> Link: https://lore.kernel.org/r/20211227125444.21187-1-jefflexu@linux.alibaba.com/ [1]
> Link: https://lore.kernel.org/r/20211228124419.103020-1-jefflexu@linux.alibaba.com
> ---

LGTM. Thanks.


>  fs/ceph/addr.c         |    5 -----
>  fs/netfs/read_helper.c |    3 ++-
>  2 files changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index b3d9459c9bbd..c98e5238a1b6 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -297,10 +297,6 @@ static void ceph_netfs_issue_op(struct netfs_read_subrequest *subreq)
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
> @@ -312,7 +308,6 @@ static void ceph_readahead_cleanup(struct address_space *mapping, void *priv)
>  }
>  
>  static const struct netfs_read_request_ops ceph_netfs_read_ops = {
> -	.init_rreq		= ceph_init_rreq,
>  	.is_cache_enabled	= ceph_is_cache_enabled,
>  	.begin_cache_operation	= ceph_begin_cache_operation,
>  	.issue_op		= ceph_netfs_issue_op,
> diff --git a/fs/netfs/read_helper.c b/fs/netfs/read_helper.c
> index 6169659857b3..501da990c259 100644
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
> 

-- 
Thanks,
Jeffle
