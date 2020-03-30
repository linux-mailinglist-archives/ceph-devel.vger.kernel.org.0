Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3E0197DBC
	for <lists+ceph-devel@lfdr.de>; Mon, 30 Mar 2020 16:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727745AbgC3OA3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 30 Mar 2020 10:00:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:44398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727302AbgC3OA3 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 30 Mar 2020 10:00:29 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29A122073B;
        Mon, 30 Mar 2020 14:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585576828;
        bh=C5UOHYTPtQC4wf7VzjYLglquqcA/A4NbYmKMIw9ilzc=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=XJ4zFnEcnYz7v12faP+yWuqbKMvBpXMO4D9MkYFFIHWOEvv7QvyE8sQsdZVW2nfp/
         Js5zzUOkRT0p5ufTvuoGfsQh9g/6sOg1RvUtG+N5Ayrr0yP1/5OzVhpxxhxcbh2lL3
         jGv4eSVkDj07Vy5d0sv3ezrjwR97M7JJxcvyOng8=
Message-ID: <49fe2d9a5956346af46fb4ce37ccc0c8c35185e2.camel@kernel.org>
Subject: Re: [PATCH] ceph: reset i_requested_max_size if file write is not
 wanted
From:   Jeff Layton <jlayton@kernel.org>
To:     "Yan, Zheng" <zyan@redhat.com>, ceph-devel@vger.kernel.org
Date:   Mon, 30 Mar 2020 10:00:26 -0400
In-Reply-To: <20200330115637.31019-1-zyan@redhat.com>
References: <20200330115637.31019-1-zyan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2020-03-30 at 19:56 +0800, Yan, Zheng wrote:
> write can stuck at waiting for larger max_size in following sequence of
> events:
> 
> - client opens a file and writes to position 'A' (larger than unit of
>   max size increment)
> - client closes the file handle and updates wanted caps (not wanting
>   file write caps)
> - client opens and truncates the file, writes to position 'A' again.
> 
> At the 1st event, client set inode's requested_max_size to 'A'. At the
> 2nd event, mds removes client's writable range, but client does not reset
> requested_max_size. At the 3rd event, client does not request max size
> because requested_max_size is already larger than 'A'.
> 
> Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
> ---
>  fs/ceph/caps.c | 29 +++++++++++++++++++----------
>  1 file changed, 19 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index f8b51d0c8184..61808793e0c0 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -1363,8 +1363,12 @@ static void __prep_cap(struct cap_msg_args *arg, struct ceph_cap *cap,
>  	arg->size = inode->i_size;
>  	ci->i_reported_size = arg->size;
>  	arg->max_size = ci->i_wanted_max_size;
> -	if (cap == ci->i_auth_cap)
> -		ci->i_requested_max_size = arg->max_size;
> +	if (cap == ci->i_auth_cap) {
> +		if (want & CEPH_CAP_ANY_FILE_WR)
> +			ci->i_requested_max_size = arg->max_size;
> +		else
> +			ci->i_requested_max_size = 0;
> +	}
>  
>  	if (flushing & CEPH_CAP_XATTR_EXCL) {
>  		arg->old_xattr_buf = __ceph_build_xattrs_blob(ci);
> @@ -3343,10 +3347,6 @@ static void handle_cap_grant(struct inode *inode,
>  				ci->i_requested_max_size = 0;
>  			}
>  			wake = true;
> -		} else if (ci->i_wanted_max_size > ci->i_max_size &&
> -			   ci->i_wanted_max_size > ci->i_requested_max_size) {
> -			/* CEPH_CAP_OP_IMPORT */
> -			wake = true;
>  		}
>  	}
>  
> @@ -3422,9 +3422,18 @@ static void handle_cap_grant(struct inode *inode,
>  			fill_inline = true;
>  	}
>  
> -	if (le32_to_cpu(grant->op) == CEPH_CAP_OP_IMPORT) {
> +	if (ci->i_auth_cap == cap &&
> +	    le32_to_cpu(grant->op) == CEPH_CAP_OP_IMPORT) {
>  		if (newcaps & ~extra_info->issued)
>  			wake = true;
> +
> +		if (ci->i_requested_max_size > max_size ||
> +		    !(le32_to_cpu(grant->wanted) & CEPH_CAP_ANY_FILE_WR)) {
> +			/* re-request max_size if necessary */
> +			ci->i_requested_max_size = 0;
> +			wake = true;
> +		}
> +
>  		ceph_kick_flushing_inode_caps(session, ci);
>  		spin_unlock(&ci->i_ceph_lock);
>  		up_read(&session->s_mdsc->snap_rwsem);
> @@ -3882,9 +3891,6 @@ static void handle_cap_import(struct ceph_mds_client *mdsc,
>  		__ceph_remove_cap(ocap, (ph->flags & CEPH_CAP_FLAG_RELEASE));
>  	}
>  
> -	/* make sure we re-request max_size, if necessary */
> -	ci->i_requested_max_size = 0;
> -
>  	*old_issued = issued;
>  	*target_cap = cap;
>  }
> @@ -4318,6 +4324,9 @@ int ceph_encode_inode_release(void **p, struct inode *inode,
>  				cap->issued &= ~drop;
>  				cap->implemented &= ~drop;
>  				cap->mds_wanted = wanted;
> +				if (cap == ci->i_auth_cap &&
> +				    !(wanted & CEPH_CAP_ANY_FILE_WR))
> +					ci->i_requested_max_size = 0;
>  			} else {
>  				dout("encode_inode_release %p cap %p %s"
>  				     " (force)\n", inode, cap,

Thanks Zheng. I assume this is a regression in the "don't request caps
for idle open files" series? If so, is there a commit that definitively
broke it? It'd be good to add a Fixes: tag for that if we can to help
backporters.

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>

