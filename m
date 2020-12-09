Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5632D417F
	for <lists+ceph-devel@lfdr.de>; Wed,  9 Dec 2020 12:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731123AbgLIL41 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 9 Dec 2020 06:56:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:51770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730695AbgLIL40 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 06:56:26 -0500
Message-ID: <532b2ccda1ed7d424cf7ebd9869b755a3d998c45.camel@kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607514946;
        bh=haUlJLU2WptWCa2pqD3qL6oNkEzgEZ9hxUd/e6+Lx44=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fhIQJnzFW/u2B3EYZ7zOpO+/PDhQ3Nfekl6Jl4Jqbg9vCfdnLFlg3NuARMlS6NCOP
         mdL5UrMkGqqRer5xHTlKEhhSO4Cjn+kV6jgE+pnYVzFIw9H14TVQX3geS+bnTpZOmK
         rAaRVxPRUOhXIGVfG39LsyWV4PPbidwJdSYL34pGT2X1d8i0CGmVDWPC8sJIcWRVsr
         ovk70WFYLCsGjcnLNh8yQxqQWepGcg9zd8uBlBMkQ3EInaseij0WNXwS14d7oM5y9q
         WJ9jHQYtAz57Y0uQYgK+7jbVqxn4MIHrn+aD5rXO7zuQy7Vawq5ElJlW0OaE8bWbyi
         TSdCNlrGj9R3Q==
Subject: Re: [PATCH] ceph: set osdmap epoch for setxattr.
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Wed, 09 Dec 2020 06:55:44 -0500
In-Reply-To: <20201209025220.2563698-1-xiubli@redhat.com>
References: <20201209025220.2563698-1-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 (3.38.1-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2020-12-09 at 10:52 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> When setting the file/dir layout, it may need data pool info. So
> in mds server, it needs to check the osdmap. At present, if mds
> doesn't find the data pool specified, it will try to get the latest
> osdmap. Now if pass the osd epoch for setxattr, the mds server can
> only check this epoch of osdmap.
> 
> URL: https://tracker.ceph.com/issues/48504
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/mds_client.c         | 2 +-
>  fs/ceph/xattr.c              | 3 +++
>  include/linux/ceph/ceph_fs.h | 1 +
>  3 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 4fab37d858ce..9b5e3975b3ad 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -2533,7 +2533,7 @@ static struct ceph_msg *create_request_message(struct ceph_mds_client *mdsc,
>  		goto out_free2;
>  	}
>  
> 
> -	msg->hdr.version = cpu_to_le16(2);
> +	msg->hdr.version = cpu_to_le16(3);
>  	msg->hdr.tid = cpu_to_le64(req->r_tid);
>  
> 
>  	head = msg->front.iov_base;
> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> index e89750a1f039..a8597cae0ed7 100644
> --- a/fs/ceph/xattr.c
> +++ b/fs/ceph/xattr.c
> @@ -995,6 +995,7 @@ static int ceph_sync_setxattr(struct inode *inode, const char *name,
>  	struct ceph_inode_info *ci = ceph_inode(inode);
>  	struct ceph_mds_request *req;
>  	struct ceph_mds_client *mdsc = fsc->mdsc;
> +	struct ceph_osd_client *osdc = &fsc->client->osdc;
>  	struct ceph_pagelist *pagelist = NULL;
>  	int op = CEPH_MDS_OP_SETXATTR;
>  	int err;
> @@ -1033,6 +1034,8 @@ static int ceph_sync_setxattr(struct inode *inode, const char *name,
>  
> 
>  	if (op == CEPH_MDS_OP_SETXATTR) {
>  		req->r_args.setxattr.flags = cpu_to_le32(flags);
> +		req->r_args.setxattr.osdmap_epoch =
> +			cpu_to_le32(osdc->osdmap->epoch);
>  		req->r_pagelist = pagelist;
>  		pagelist = NULL;
>  	}
> diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
> index 455e9b9e2adf..c0f1b921ec69 100644
> --- a/include/linux/ceph/ceph_fs.h
> +++ b/include/linux/ceph/ceph_fs.h
> @@ -424,6 +424,7 @@ union ceph_mds_request_args {
>  	} __attribute__ ((packed)) open;
>  	struct {
>  		__le32 flags;
> +		__le32 osdmap_epoch; /* used for setting file/dir layouts */
>  	} __attribute__ ((packed)) setxattr;
>  	struct {
>  		struct ceph_file_layout_legacy layout;

Thanks, Xiubo. Merged.
-- 
Jeff Layton <jlayton@kernel.org>

