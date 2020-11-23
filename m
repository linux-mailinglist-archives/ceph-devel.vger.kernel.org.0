Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FCFC2C0E9B
	for <lists+ceph-devel@lfdr.de>; Mon, 23 Nov 2020 16:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389421AbgKWPRV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 23 Nov 2020 10:17:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:33448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732197AbgKWPRU (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 23 Nov 2020 10:17:20 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B780A20738;
        Mon, 23 Nov 2020 15:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606144640;
        bh=L07kMTMhB2vUVWxogLc8ATMTYuH0Sm78YXocfoTxkpA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kgPDAKMv/S9YpVmMNNuA3bL0BJLz1Xm6XPpc/gSovtUmJ0Q7UFrWqbTZ9gN1uCnnI
         3j1S5t/6/lFJOQJIdAZDuhcFZiBhN76p6cK92CGUDY4fBQzXIuujVn/jB0Q19P5x1u
         Oxan5zAyI94MjmfVnPpta8fPQ6xhuPkRMbriscTE=
Message-ID: <f31a7e1e483cccb045c0824fa253172f03fb13e6.camel@kernel.org>
Subject: Re: [RFC PATCH] ceph: add ceph.caps vxattr
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.de>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 23 Nov 2020 10:17:18 -0500
In-Reply-To: <20201123145311.13588-1-lhenriques@suse.de>
References: <20201123145311.13588-1-lhenriques@suse.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 (3.38.1-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2020-11-23 at 14:53 +0000, Luis Henriques wrote:
> Add a new vxattr that allows userspace to list the caps for a specific
> directory or file.
> 
> Signed-off-by: Luis Henriques <lhenriques@suse.de>
> ---
>  fs/ceph/xattr.c | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> index 197cb1234341..996512e05513 100644
> --- a/fs/ceph/xattr.c
> +++ b/fs/ceph/xattr.c
> @@ -303,6 +303,18 @@ static ssize_t ceph_vxattrcb_snap_btime(struct ceph_inode_info *ci, char *val,
>  				ci->i_snap_btime.tv_nsec);
>  }
>  
> 
> +static ssize_t ceph_vxattrcb_caps(struct ceph_inode_info *ci, char *val,
> +					size_t size)
> +{
> +	int issued;
> +
> +	spin_lock(&ci->i_ceph_lock);
> +	issued = __ceph_caps_issued(ci, NULL);
> +	spin_unlock(&ci->i_ceph_lock);
> +
> +	return ceph_fmt_xattr(val, size, "%s", ceph_cap_string(issued));
> +}
> +
>  #define CEPH_XATTR_NAME(_type, _name)	XATTR_CEPH_PREFIX #_type "." #_name
>  #define CEPH_XATTR_NAME2(_type, _name, _name2)	\
>  	XATTR_CEPH_PREFIX #_type "." #_name "." #_name2
> @@ -378,6 +390,13 @@ static struct ceph_vxattr ceph_dir_vxattrs[] = {
>  		.exists_cb = ceph_vxattrcb_snap_btime_exists,
>  		.flags = VXATTR_FLAG_READONLY,
>  	},
> +	{
> +		.name = "ceph.caps",
> +		.name_size = sizeof("ceph.caps"),
> +		.getxattr_cb = ceph_vxattrcb_caps,
> +		.exists_cb = NULL,
> +		.flags = VXATTR_FLAG_HIDDEN,
> +	},
>  	{ .name = NULL, 0 }	/* Required table terminator */
>  };
>  
> 
> @@ -403,6 +422,13 @@ static struct ceph_vxattr ceph_file_vxattrs[] = {
>  		.exists_cb = ceph_vxattrcb_snap_btime_exists,
>  		.flags = VXATTR_FLAG_READONLY,
>  	},
> +	{
> +		.name = "ceph.caps",
> +		.name_size = sizeof("ceph.caps"),
> +		.getxattr_cb = ceph_vxattrcb_caps,
> +		.exists_cb = NULL,
> +		.flags = VXATTR_FLAG_HIDDEN,
> +	},
>  	{ .name = NULL, 0 }	/* Required table terminator */
>  };
>  
> 

Looks useful! I'll plan to merge this unless anyone has objections.
-- 
Jeff Layton <jlayton@kernel.org>

