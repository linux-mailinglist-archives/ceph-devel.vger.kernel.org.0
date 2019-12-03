Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 799FE110461
	for <lists+ceph-devel@lfdr.de>; Tue,  3 Dec 2019 19:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbfLCSnB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 3 Dec 2019 13:43:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:51268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726057AbfLCSnA (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 3 Dec 2019 13:43:00 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6563D2073B;
        Tue,  3 Dec 2019 18:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575398580;
        bh=JHHvMhLzY5UEWQtUdVKEpxaOuBLvMnOA14d7ng+Pk5Y=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=y8zdAlfZTCrKG4q1XCPRUuCNZzdRsvphmJ+KLR8fRAruGvh4teAzNpjlY+9s5GPPV
         mSJdEAOpaKMBlPPRfwf7RhhRVLfi5vG5nYwed89iBoXQ8U7qx7eOYeCnkwlf/6o2rH
         +amPmDLyX7m8hCuaBYL2dxnJCTuLiViN1f1HWH+I=
Message-ID: <f996cb9d63be8d78da044c6408de56ad84d2d4b5.camel@kernel.org>
Subject: Re: [PATCH] ceph: switch to global cap helper
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Tue, 03 Dec 2019 13:42:58 -0500
In-Reply-To: <20191203080051.13240-1-xiubli@redhat.com>
References: <20191203080051.13240-1-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2019-12-03 at 03:00 -0500, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> __ceph_is_any_caps is a duplicate helper.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/caps.c | 24 ++++++++++--------------
>  1 file changed, 10 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index c62e88da4fee..fafb84a2d8f5 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -1011,18 +1011,13 @@ static int __ceph_is_single_caps(struct ceph_inode_info *ci)
>  	return rb_first(&ci->i_caps) == rb_last(&ci->i_caps);
>  }
>  
> -static int __ceph_is_any_caps(struct ceph_inode_info *ci)
> -{
> -	return !RB_EMPTY_ROOT(&ci->i_caps);
> -}
> -
>  int ceph_is_any_caps(struct inode *inode)
>  {
>  	struct ceph_inode_info *ci = ceph_inode(inode);
>  	int ret;
>  
>  	spin_lock(&ci->i_ceph_lock);
> -	ret = __ceph_is_any_caps(ci);
> +	ret = __ceph_is_any_real_caps(ci);
>  	spin_unlock(&ci->i_ceph_lock);
>  
>  	return ret;
> @@ -1099,15 +1094,16 @@ void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
>  	if (removed)
>  		ceph_put_cap(mdsc, cap);
>  
> -	/* when reconnect denied, we remove session caps forcibly,
> -	 * i_wr_ref can be non-zero. If there are ongoing write,
> -	 * keep i_snap_realm.
> -	 */
> -	if (!__ceph_is_any_caps(ci) && ci->i_wr_ref == 0 && ci->i_snap_realm)
> -		drop_inode_snap_realm(ci);
> +	if (!__ceph_is_any_real_caps(ci)) {
> +		/* when reconnect denied, we remove session caps forcibly,
> +		 * i_wr_ref can be non-zero. If there are ongoing write,
> +		 * keep i_snap_realm.
> +		 */
> +		if (ci->i_wr_ref == 0 && ci->i_snap_realm)
> +			drop_inode_snap_realm(ci);
>  
> -	if (!__ceph_is_any_real_caps(ci))
>  		__cap_delay_cancel(mdsc, ci);
> +	}
>  }
>  
>  struct cap_msg_args {
> @@ -2927,7 +2923,7 @@ void ceph_put_cap_refs(struct ceph_inode_info *ci, int had)
>  				ci->i_head_snapc = NULL;
>  			}
>  			/* see comment in __ceph_remove_cap() */
> -			if (!__ceph_is_any_caps(ci) && ci->i_snap_realm)
> +			if (!__ceph_is_any_real_caps(ci) && ci->i_snap_realm)
>  				drop_inode_snap_realm(ci);
>  		}
>  	spin_unlock(&ci->i_ceph_lock);

Merged.
-- 
Jeff Layton <jlayton@kernel.org>

