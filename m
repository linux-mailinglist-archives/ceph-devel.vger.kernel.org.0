Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF6F2AD98F
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Nov 2020 15:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730859AbgKJO7r (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Nov 2020 09:59:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:49684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730070AbgKJO7r (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 10 Nov 2020 09:59:47 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6958B20731;
        Tue, 10 Nov 2020 14:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605020386;
        bh=B+/L0O0vE/qQW5Xp3KNMB+KXNe9jlK9wImxxvSlMyYk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=pTtNM5DPiYK/DTigimnbwKDSO/0HewWNXbuopzNw/N35y85d+2J0S9B5j2e4We+Kd
         VHX5CQtX5r4HR1/L4WyqbPkvIjvT/kK+F1305O1pplohL4pqrtdcyAd8YO5oJsbUXg
         wYRqVIZi1lukmICRop1aV3wGsDb+GbhICDZj92tI=
Message-ID: <7818ef6eab2a24646e3547b79ff83f3d2bf1453b.camel@kernel.org>
Subject: Re: [PATCH v3 2/2] ceph: add ceph.{clusterid/clientid} vxattrs
 suppport
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com
Cc:     zyan@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Tue, 10 Nov 2020 09:59:44 -0500
In-Reply-To: <20201110141703.414211-3-xiubli@redhat.com>
References: <20201110141703.414211-1-xiubli@redhat.com>
         <20201110141703.414211-3-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 (3.38.1-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2020-11-10 at 22:17 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> These two vxattrs will only exist in local client side, with which
> we can easily know which mountpoint the file belongs to and also
> they can help locate the debugfs path quickly.
> 
> URL: https://tracker.ceph.com/issues/48057
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/xattr.c | 42 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 42 insertions(+)
> 
> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> index 0fd05d3d4399..4a41db46e191 100644
> --- a/fs/ceph/xattr.c
> +++ b/fs/ceph/xattr.c
> @@ -304,6 +304,23 @@ static ssize_t ceph_vxattrcb_snap_btime(struct ceph_inode_info *ci, char *val,
>  				ci->i_snap_btime.tv_nsec);
>  }
>  
> 
> 
> 
> +static ssize_t ceph_vxattrcb_clusterid(struct ceph_inode_info *ci,
> +				       char *val, size_t size)
> +{
> +	struct ceph_fs_client *fsc = ceph_sb_to_client(ci->vfs_inode.i_sb);
> +
> +	return ceph_fmt_xattr(val, size, "%pU", &fsc->client->fsid);
> +}
> +
> +static ssize_t ceph_vxattrcb_clientid(struct ceph_inode_info *ci,
> +				      char *val, size_t size)
> +{
> +	struct ceph_fs_client *fsc = ceph_sb_to_client(ci->vfs_inode.i_sb);
> +
> +	return ceph_fmt_xattr(val, size, "client%lld",
> +			      ceph_client_gid(fsc->client));
> +}
> +
>  #define CEPH_XATTR_NAME(_type, _name)	XATTR_CEPH_PREFIX #_type "." #_name
>  #define CEPH_XATTR_NAME2(_type, _name, _name2)	\
>  	XATTR_CEPH_PREFIX #_type "." #_name "." #_name2
> @@ -407,6 +424,24 @@ static struct ceph_vxattr ceph_file_vxattrs[] = {
>  	{ .name = NULL, 0 }	/* Required table terminator */
>  };
>  
> 
> 
> 
> +static struct ceph_vxattr ceph_vxattrs[] = {

I'm going to rename this to "ceph_common_vxattrs".

> +	{
> +		.name = "ceph.clusterid",
> +		.name_size = sizeof("ceph.clusterid"),
> +		.getxattr_cb = ceph_vxattrcb_clusterid,
> +		.exists_cb = NULL,
> +		.flags = VXATTR_FLAG_READONLY,
> +	},
> +	{
> +		.name = "ceph.clientid",
> +		.name_size = sizeof("ceph.clientid"),
> +		.getxattr_cb = ceph_vxattrcb_clientid,
> +		.exists_cb = NULL,
> +		.flags = VXATTR_FLAG_READONLY,
> +	},
> +	{ .name = NULL, 0 }	/* Required table terminator */
> +};
> +
>  static struct ceph_vxattr *ceph_inode_vxattrs(struct inode *inode)
>  {
>  	if (S_ISDIR(inode->i_mode))
> @@ -429,6 +464,13 @@ static struct ceph_vxattr *ceph_match_vxattr(struct inode *inode,
>  		}
>  	}
>  
> 
> 
> 
> +	vxattr = ceph_vxattrs;
> +	while (vxattr->name) {
> +		if (!strcmp(vxattr->name, name))
> +			return vxattr;
> +		vxattr++;
> +	}
> +
>  	return NULL;
>  }
>  
> 
> 
> 

-- 
Jeff Layton <jlayton@kernel.org>

