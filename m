Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62F762C10FC
	for <lists+ceph-devel@lfdr.de>; Mon, 23 Nov 2020 17:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390175AbgKWQnG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 23 Nov 2020 11:43:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:60414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388042AbgKWQnF (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 23 Nov 2020 11:43:05 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 799092100A;
        Mon, 23 Nov 2020 16:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606149785;
        bh=48yrGgOJSfFiFwXNjJgUxD28dU09ZoQpitv1nN78NfY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=OOdwg3X7qtb0xLRx4ZMFOFyVEDbz8DDxZVb6YXRTLrprTD+7S0iIgIlMRYYtt2O/s
         ZFj+93FLN3Uu68QtJpuddpAhykPUyqzryxUGKAPo42C+MJTq8S4vnUVZbwLHOCd6F1
         O7Izr6WqdKFlAH4IJrTIj8LTeYJ1UHQEH3j9dztc=
Message-ID: <a12a732b67245cc02344405f7dd9fef4f3b47fbc.camel@kernel.org>
Subject: Re: [RFC PATCH] ceph: add ceph.caps vxattr
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.de>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 23 Nov 2020 11:43:03 -0500
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

I wonder if we ought to print a numerical (hex) representation of the
cap set here in addition to the ceph_cap_string. A main use-case for
this will be in testcases, and determining whether (e.g.) Fs is in the
mask may be easier to do with a bitwise AND rather than having to parse
a string of text.

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
> 
> 

-- 
Jeff Layton <jlayton@kernel.org>

