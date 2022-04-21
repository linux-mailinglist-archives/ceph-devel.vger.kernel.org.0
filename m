Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F193509D66
	for <lists+ceph-devel@lfdr.de>; Thu, 21 Apr 2022 12:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388254AbiDUKUE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 21 Apr 2022 06:20:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388233AbiDUKUC (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 21 Apr 2022 06:20:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D13FA13F74
        for <ceph-devel@vger.kernel.org>; Thu, 21 Apr 2022 03:17:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7ED16B823E5
        for <ceph-devel@vger.kernel.org>; Thu, 21 Apr 2022 10:17:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F7EC385AA;
        Thu, 21 Apr 2022 10:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650536225;
        bh=N7QXTyqd44/VTs3AW14/v+qPi3s+dC9x2/mrwqpRRZE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MnkeiiXuWc2qeDxaCEN+IyBaRe6Yq/pTSHajMygsFnn0R0IcFH2Jw6pgrIBv/qLqC
         NduHQMs7prVISm1ff6uqGAQp+IV6aPVukhn7Wi7tLFayOTGB+QYJQwiqKWnzZbp6Cx
         C0BxohH+hU93aWRbmhaQ4/5hVvk55Fo974E7DIcPHlPehHVxpd6gklcWnMZm2Dagec
         ucEyQ9pgm30w3SBs5mRWwgVVYAJWLeqz6QwdKYWjoJmzs2pc1mrAba8/BS2S3oP2se
         yh6DvelTRTnPGQv6bNsffEdv9RX6SNjMqtv9OW+DUoE4G7fRQ509cJ10FVc6B6O2RA
         06wrQ9nWyuiDQ==
Message-ID: <066e893bc6c101f36a712947bf33d14aaca2e01c.camel@kernel.org>
Subject: Re: [PATCH v2] ceph: try to choose the auth MDS if possible for
 getattr
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
Date:   Thu, 21 Apr 2022 06:17:03 -0400
In-Reply-To: <20220421070305.140107-1-xiubli@redhat.com>
References: <20220421070305.140107-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2022-04-21 at 15:03 +0800, Xiubo Li wrote:
> If any 'x' caps is issued we can just choose the auth MDS instead
> of the random replica MDSes. Because only when the Locker is in
> LOCK_EXEC state will the loner client could get the 'x' caps. And
> if we send the getattr requests to any replica MDS it must auth pin
> and tries to rdlock from the auth MDS, and then the auth MDS need
> to do the Locker state transition to LOCK_SYNC. And after that the
> lock state will change back.
> 
> This cost much when doing the Locker state transition and usually
> will need to revoke caps from clients.
> 
> URL: https://tracker.ceph.com/issues/55240
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/addr.c  |  4 +++-
>  fs/ceph/inode.c | 26 +++++++++++++++++++++++++-
>  fs/ceph/super.h |  1 +
>  3 files changed, 29 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 02722ac86d73..261bc8bb2ab8 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -256,6 +256,7 @@ static bool ceph_netfs_issue_op_inline(struct netfs_io_subrequest *subreq)
>  	struct iov_iter iter;
>  	ssize_t err = 0;
>  	size_t len;
> +	int mode;
>  
>  	__set_bit(NETFS_SREQ_CLEAR_TAIL, &subreq->flags);
>  	__clear_bit(NETFS_SREQ_COPY_TO_CACHE, &subreq->flags);
> @@ -264,7 +265,8 @@ static bool ceph_netfs_issue_op_inline(struct netfs_io_subrequest *subreq)
>  		goto out;
>  
>  	/* We need to fetch the inline data. */
> -	req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_GETATTR, USE_ANY_MDS);
> +	mode = ceph_try_to_choose_auth_mds(inode, CEPH_STAT_CAP_INLINE_DATA);
> +	req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_GETATTR, mode);
>  	if (IS_ERR(req)) {
>  		err = PTR_ERR(req);
>  		goto out;
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index b45f321910af..d05b91391f17 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -2260,6 +2260,30 @@ int ceph_setattr(struct user_namespace *mnt_userns, struct dentry *dentry,
>  	return err;
>  }
>  
> +int ceph_try_to_choose_auth_mds(struct inode *inode, int mask)
> +{
> +	int issued = ceph_caps_issued(ceph_inode(inode));
> +
> +	/*
> +	 * If any 'x' caps is issued we can just choose the auth MDS
> +	 * instead of the random replica MDSes. Because only when the
> +	 * Locker is in LOCK_EXEC state will the loner client could
> +	 * get the 'x' caps. And if we send the getattr requests to
> +	 * any replica MDS it must auth pin and tries to rdlock from
> +	 * the auth MDS, and then the auth MDS need to do the Locker
> +	 * state transition to LOCK_SYNC. And after that the lock state
> +	 * will change back.
> +	 *
> +	 * This cost much when doing the Locker state transition and
> +	 * usually will need to revoke caps from clients.
> +	 */
> +	if (((mask & CEPH_CAP_ANY_SHARED) && (issued & CEPH_CAP_ANY_EXCL))
> +	    || (mask & CEPH_STAT_RSTAT))
> +		return USE_AUTH_MDS;
> +	else
> +		return USE_ANY_MDS;
> +}
> +
>  /*
>   * Verify that we have a lease on the given mask.  If not,
>   * do a getattr against an mds.
> @@ -2283,7 +2307,7 @@ int __ceph_do_getattr(struct inode *inode, struct page *locked_page,
>  	if (!force && ceph_caps_issued_mask_metric(ceph_inode(inode), mask, 1))
>  			return 0;
>  
> -	mode = (mask & CEPH_STAT_RSTAT) ? USE_AUTH_MDS : USE_ANY_MDS;
> +	mode = ceph_try_to_choose_auth_mds(inode, mask);
>  	req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_GETATTR, mode);
>  	if (IS_ERR(req))
>  		return PTR_ERR(req);
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 73db7f6021f3..669036ebef1e 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -1024,6 +1024,7 @@ static inline void ceph_queue_flush_snaps(struct inode *inode)
>  	ceph_queue_inode_work(inode, CEPH_I_WORK_FLUSH_SNAPS);
>  }
>  
> +extern int ceph_try_to_choose_auth_mds(struct inode *inode, int mask);
>  extern int __ceph_do_getattr(struct inode *inode, struct page *locked_page,
>  			     int mask, bool force);
>  static inline int ceph_do_getattr(struct inode *inode, int mask, bool force)

Nice optimization.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
