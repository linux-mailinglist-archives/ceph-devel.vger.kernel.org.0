Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D69723B7328
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Jun 2021 15:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233889AbhF2N1u (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Jun 2021 09:27:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:54268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233740AbhF2N1u (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 29 Jun 2021 09:27:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED21461D7B;
        Tue, 29 Jun 2021 13:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624973123;
        bh=GvsjLXdLCdqCdqtTxJoaAriKlSn1nKUs0ZLgC059164=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lqI3b2PNnz93RuMK8ky+CzT2ttspVrINboFZxl7+w/xCtKRvkG5UK4PLyOBZVfmFf
         q3lq+A29DXbL2TzO8zqEbx1Z6J8R6j59LiXMtugMx08grTAcfacwuDDqjdsWjfkv4g
         uhUzSjW1lOuTOr1poUAb+vSF6ZUXstRW0p6PnEI+djhN2fw3TGJfdCVIZCcm9jL1ud
         vv7Nr3Hp0wOFWv+uCW5shVsLKPUp8WluStEd8YfE7BMw4Lgwyfn0OyN/FTvtRqJpBV
         Sd5Wh07sJEp2EABPcEOTrSULnQYywQnr7ttinaZRR4YYEeTQT29mxkwsgOqLY3jo76
         5faGeTMYV3p0w==
Message-ID: <b531585184df099e633a4b92e3be23b4b8384253.camel@kernel.org>
Subject: Re: [PATCH 4/5] ceph: flush the mdlog before waiting on unsafe reqs
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Tue, 29 Jun 2021 09:25:21 -0400
In-Reply-To: <20210629044241.30359-5-xiubli@redhat.com>
References: <20210629044241.30359-1-xiubli@redhat.com>
         <20210629044241.30359-5-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.2 (3.40.2-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2021-06-29 at 12:42 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> For the client requests who will have unsafe and safe replies from
> MDS daemons, in the MDS side the MDS daemons won't flush the mdlog
> (journal log) immediatelly, because they think it's unnecessary.
> That's true for most cases but not all, likes the fsync request.
> The fsync will wait until all the unsafe replied requests to be
> safely replied.
> 
> Normally if there have multiple threads or clients are running, the
> whole mdlog in MDS daemons could be flushed in time if any request
> will trigger the mdlog submit thread. So usually we won't experience
> the normal operations will stuck for a long time. But in case there
> has only one client with only thread is running, the stuck phenomenon
> maybe obvious and the worst case it must wait at most 5 seconds to
> wait the mdlog to be flushed by the MDS's tick thread periodically.
> 
> This patch will trigger to flush the mdlog in all the MDSes manually
> just before waiting the unsafe requests to finish.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/caps.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index c6a3352a4d52..6e80e4649c7a 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -2286,6 +2286,7 @@ static int caps_are_flushed(struct inode *inode, u64 flush_tid)
>   */
>  static int unsafe_request_wait(struct inode *inode)
>  {
> +	struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
>  	struct ceph_inode_info *ci = ceph_inode(inode);
>  	struct ceph_mds_request *req1 = NULL, *req2 = NULL;
>  	int ret, err = 0;
> @@ -2305,6 +2306,14 @@ static int unsafe_request_wait(struct inode *inode)
>  	}
>  	spin_unlock(&ci->i_unsafe_lock);
>  
> +	/*
> +	 * Trigger to flush the journal logs in all the MDSes manually,
> +	 * or in the worst case we must wait at most 5 seconds to wait
> +	 * the journal logs to be flushed by the MDSes periodically.
> +	 */
> +	if (req1 || req2)
> +		flush_mdlog(mdsc);
> +

So this is called on fsync(). Do we really need to flush all of the mds
logs on every fsync? That sounds like it might have some performance
impact. Would it be possible to just flush the mdslog on the MDS that's
authoritative for this inode?

>  	dout("unsafe_request_wait %p wait on tid %llu %llu\n",
>  	     inode, req1 ? req1->r_tid : 0ULL, req2 ? req2->r_tid : 0ULL);
>  	if (req1) {

-- 
Jeff Layton <jlayton@kernel.org>

