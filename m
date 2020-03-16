Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C646A186B59
	for <lists+ceph-devel@lfdr.de>; Mon, 16 Mar 2020 13:48:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731003AbgCPMsZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 16 Mar 2020 08:48:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:35758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730919AbgCPMsZ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 16 Mar 2020 08:48:25 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 931AA205ED;
        Mon, 16 Mar 2020 12:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584362904;
        bh=k7iCNTJvdVtnEzrS8mMMaFQRDep6AouW0U28JLox75s=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=GoebwdmEM91jyEMHR2dF5WSIfs4upnvOEYlAvq11vdg0VAG/G3OyzwgBXlLu68h27
         VGVjfyHWVICjqE7jh9Kc6pajvAmJI4o2QOwI5rupKnj32BQdzSsWKTtaau/QTcApR9
         wWCiAaZdxRGI9mGzChteQsaSMdks5i2Xwl6DGyfg=
Message-ID: <25eaece7ad299eef0e7418f2b9acce900460baed.camel@kernel.org>
Subject: Re: [PATCH 1/4] ceph: cleanup return error of try_get_cap_refs()
From:   Jeff Layton <jlayton@kernel.org>
To:     "Yan, Zheng" <zyan@redhat.com>, ceph-devel@vger.kernel.org
Date:   Mon, 16 Mar 2020 08:48:23 -0400
In-Reply-To: <20200310113421.174873-2-zyan@redhat.com>
References: <20200310113421.174873-1-zyan@redhat.com>
         <20200310113421.174873-2-zyan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2020-03-10 at 19:34 +0800, Yan, Zheng wrote:
> Returns 0 if caps were not able to be acquired (yet), 1 if succeed,
> or a negative error code. There are 3 speical error codes:
> 
> -EAGAIN: need to sleep but non-blocking is specified
> -EFBIG:  ask caller to call check_max_size() and try again.
> -ESTALE: ask caller to call ceph_renew_caps() and try again.
> 
> Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
> ---
>  fs/ceph/caps.c | 25 ++++++++++++++-----------
>  1 file changed, 14 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 342a32c74c64..804f4c65251a 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -2530,10 +2530,11 @@ void ceph_take_cap_refs(struct ceph_inode_info *ci, int got,
>   * Note that caller is responsible for ensuring max_size increases are
>   * requested from the MDS.
>   *
> - * Returns 0 if caps were not able to be acquired (yet), a 1 if they were,
> - * or a negative error code.
> - *
> - * FIXME: how does a 0 return differ from -EAGAIN?
> + * Returns 0 if caps were not able to be acquired (yet), 1 if succeed,
> + * or a negative error code. There are 3 speical error codes:
> + *  -EAGAIN: need to sleep but non-blocking is specified
> + *  -EFBIG:  ask caller to call check_max_size() and try again.
> + *  -ESTALE: ask caller to call ceph_renew_caps() and try again.
>   */
>  enum {
>  	/* first 8 bits are reserved for CEPH_FILE_MODE_FOO */
> @@ -2581,7 +2582,7 @@ static int try_get_cap_refs(struct inode *inode, int need, int want,
>  			dout("get_cap_refs %p endoff %llu > maxsize %llu\n",
>  			     inode, endoff, ci->i_max_size);
>  			if (endoff > ci->i_requested_max_size)
> -				ret = -EAGAIN;
> +				ret = -EFBIG;
>  			goto out_unlock;
>  		}
>  		/*
> @@ -2743,7 +2744,10 @@ int ceph_try_get_caps(struct inode *inode, int need, int want,
>  		flags |= NON_BLOCKING;
>  
>  	ret = try_get_cap_refs(inode, need, want, 0, flags, got);
> -	return ret == -EAGAIN ? 0 : ret;
> +	/* three special error codes */
> +	if (ret == -EAGAIN || ret == -EFBIG || ret == -EAGAIN)
> +		ret = 0;
> +	return ret;
>  }
>  
>  /*
> @@ -2771,17 +2775,12 @@ int ceph_get_caps(struct file *filp, int need, int want,
>  	flags = get_used_fmode(need | want);
>  
>  	while (true) {
> -		if (endoff > 0)
> -			check_max_size(inode, endoff);
> -
>  		flags &= CEPH_FILE_MODE_MASK;
>  		if (atomic_read(&fi->num_locks))
>  			flags |= CHECK_FILELOCK;
>  		_got = 0;
>  		ret = try_get_cap_refs(inode, need, want, endoff,
>  				       flags, &_got);
> -		if (ret == -EAGAIN)
> -			continue;

Ok, so I guess we don't expect to see this error here since we didn't
set NON_BLOCKING. The error returns from try_get_cap_refs are pretty
complex, and I worry a little about future changes subtly breaking some
of these assumptions.

Maybe a WARN_ON_ONCE(ret == -EAGAIN) here would be good? 

>  		if (!ret) {
>  			struct ceph_mds_client *mdsc = fsc->mdsc;
>  			struct cap_wait cw;
> @@ -2829,6 +2828,10 @@ int ceph_get_caps(struct file *filp, int need, int want,
>  		}
>  
>  		if (ret < 0) {
> +			if (ret == -EFBIG) {
> +				check_max_size(inode, endoff);
> +				continue;
> +			}
>  			if (ret == -ESTALE) {
>  				/* session was killed, try renew caps */
>  				ret = ceph_renew_caps(inode, flags);

-- 
Jeff Layton <jlayton@kernel.org>

