Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE1948D640
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Jan 2022 12:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233921AbiAMLBl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 13 Jan 2022 06:01:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233884AbiAMLBi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 13 Jan 2022 06:01:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F28DC06173F
        for <ceph-devel@vger.kernel.org>; Thu, 13 Jan 2022 03:01:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D08DB82259
        for <ceph-devel@vger.kernel.org>; Thu, 13 Jan 2022 11:01:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 854EFC36AE3;
        Thu, 13 Jan 2022 11:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642071695;
        bh=AVpUJ7KJgQLrVpC4B2VDY36tUiE/s6KyU+lnRoeXe+0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=UzlKnxONvBvH6PtSQblbDhpV6TNNNHCDDU1MS9audTKb1QY26HLkB1giwSrSf/GRd
         UbXJrm7WJwBB1Pa2Mf4G+wdadjhC0vXIyoLseQcqiaMHnQHlaVw0KCV6Sz4jdVfLm/
         klEZJx6qmiaX3w5NEvGqElVMPR8IB7EmWH7ftj1tQI6HFrdUKKVuKxLKPwo61Of1nS
         mRBlnpW16PjiicVLVqpCSQWl5K4EH398mqx1O2p3HoisQIoK8P1PPHb1+JUbegqxQ2
         8EfsJSS7CzLYGQ9W6YtVMCu3BX4UNWfEnUTBXoFmdfLGq83c+pZK74BO96DVX7IUSV
         XoVtgk8KbXwyA==
Message-ID: <97635942aaf34c5b2f3a18b3fef92ff0950c2127.camel@kernel.org>
Subject: Re: [PATCH] ceph: put the requests/sessions when it fails to alloc
 memory
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
Date:   Thu, 13 Jan 2022 06:01:33 -0500
In-Reply-To: <20220112042904.8557-1-xiubli@redhat.com>
References: <20220112042904.8557-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.2 (3.42.2-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2022-01-12 at 12:29 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> When failing to allocate the sessions memory we should make sure
> the req1 and req2 and the sessions get put. And also in case the
> max_sessions decreased so when kreallocate the new memory some
> sessions maybe missed being put.
> 
> And if the max_sessions is 0 krealloc will return ZERO_SIZE_PTR,
> which will lead to a distinct access fault.
> 
> URL: https://tracker.ceph.com/issues/53819
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> Fixes: e1a4541ec0b9 ("ceph: flush the mdlog before waiting on unsafe reqs")
> ---
>  fs/ceph/caps.c | 55 +++++++++++++++++++++++++++++++++-----------------
>  1 file changed, 37 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 944b18b4e217..5c2719f66f62 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -2276,6 +2276,7 @@ static int unsafe_request_wait(struct inode *inode)
>  	struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
>  	struct ceph_inode_info *ci = ceph_inode(inode);
>  	struct ceph_mds_request *req1 = NULL, *req2 = NULL;
> +	unsigned int max_sessions;
>  	int ret, err = 0;
>  
>  	spin_lock(&ci->i_unsafe_lock);
> @@ -2293,37 +2294,45 @@ static int unsafe_request_wait(struct inode *inode)
>  	}
>  	spin_unlock(&ci->i_unsafe_lock);
>  
> +	/*
> +	 * The mdsc->max_sessions is unlikely to be changed
> +	 * mostly, here we will retry it by reallocating the
> +	 * sessions arrary memory to get rid of the mdsc->mutex
> +	 * lock.
> +	 */
> +retry:
> +	max_sessions = mdsc->max_sessions;
> +
>  	/*
>  	 * Trigger to flush the journal logs in all the relevant MDSes
>  	 * manually, or in the worst case we must wait at most 5 seconds
>  	 * to wait the journal logs to be flushed by the MDSes periodically.
>  	 */
> -	if (req1 || req2) {
> +	if ((req1 || req2) && likely(max_sessions)) {
>  		struct ceph_mds_session **sessions = NULL;
>  		struct ceph_mds_session *s;
>  		struct ceph_mds_request *req;
> -		unsigned int max;
>  		int i;
>  
> -		/*
> -		 * The mdsc->max_sessions is unlikely to be changed
> -		 * mostly, here we will retry it by reallocating the
> -		 * sessions arrary memory to get rid of the mdsc->mutex
> -		 * lock.
> -		 */
> -retry:
> -		max = mdsc->max_sessions;
> -		sessions = krealloc(sessions, max * sizeof(s), __GFP_ZERO);
> -		if (!sessions)
> -			return -ENOMEM;
> +		sessions = kzalloc(max_sessions * sizeof(s), GFP_KERNEL);
> +		if (!sessions) {
> +			err = -ENOMEM;
> +			goto out;
> +		}
>  
>  		spin_lock(&ci->i_unsafe_lock);
>  		if (req1) {
>  			list_for_each_entry(req, &ci->i_unsafe_dirops,
>  					    r_unsafe_dir_item) {
>  				s = req->r_session;
> -				if (unlikely(s->s_mds >= max)) {
> +				if (unlikely(s->s_mds >= max_sessions)) {
>  					spin_unlock(&ci->i_unsafe_lock);
> +					for (i = 0; i < max_sessions; i++) {
> +						s = sessions[i];
> +						if (s)
> +							ceph_put_mds_session(s);
> +					}
> +					kfree(sessions);
>  					goto retry;
>  				}
>  				if (!sessions[s->s_mds]) {
> @@ -2336,8 +2345,14 @@ static int unsafe_request_wait(struct inode *inode)
>  			list_for_each_entry(req, &ci->i_unsafe_iops,
>  					    r_unsafe_target_item) {
>  				s = req->r_session;
> -				if (unlikely(s->s_mds >= max)) {
> +				if (unlikely(s->s_mds >= max_sessions)) {
>  					spin_unlock(&ci->i_unsafe_lock);
> +					for (i = 0; i < max_sessions; i++) {
> +						s = sessions[i];
> +						if (s)
> +							ceph_put_mds_session(s);
> +					}
> +					kfree(sessions);
>  					goto retry;
>  				}
>  				if (!sessions[s->s_mds]) {
> @@ -2358,7 +2373,7 @@ static int unsafe_request_wait(struct inode *inode)
>  		spin_unlock(&ci->i_ceph_lock);
>  
>  		/* send flush mdlog request to MDSes */
> -		for (i = 0; i < max; i++) {
> +		for (i = 0; i < max_sessions; i++) {
>  			s = sessions[i];
>  			if (s) {
>  				send_flush_mdlog(s);
> @@ -2375,15 +2390,19 @@ static int unsafe_request_wait(struct inode *inode)
>  					ceph_timeout_jiffies(req1->r_timeout));
>  		if (ret)
>  			err = -EIO;
> -		ceph_mdsc_put_request(req1);
>  	}
>  	if (req2) {
>  		ret = !wait_for_completion_timeout(&req2->r_safe_completion,
>  					ceph_timeout_jiffies(req2->r_timeout));
>  		if (ret)
>  			err = -EIO;
> -		ceph_mdsc_put_request(req2);
>  	}
> +
> +out:
> +	if (req1)
> +		ceph_mdsc_put_request(req1);
> +	if (req2)
> +		ceph_mdsc_put_request(req2);
>  	return err;
>  }
>  

Looks good. I fixed up the minor spelling error in the comment that
Venky noticed too. Merged into testing branch.

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>
