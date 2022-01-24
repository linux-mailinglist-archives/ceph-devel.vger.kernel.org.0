Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D37D5497DD8
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Jan 2022 12:22:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237404AbiAXLWk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 24 Jan 2022 06:22:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237370AbiAXLWj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 24 Jan 2022 06:22:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 661BCC06173B
        for <ceph-devel@vger.kernel.org>; Mon, 24 Jan 2022 03:22:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05A81601B6
        for <ceph-devel@vger.kernel.org>; Mon, 24 Jan 2022 11:22:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 047AEC340E7;
        Mon, 24 Jan 2022 11:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643023358;
        bh=ELehs8w5YLfYYooflLfX42S6Hy+mt/HaRcrpgd7L7X4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XUIyf1yihJw7GLypdGJukg1k6gvaS4BMke6RsySZD8nTP0dHDz68wG59aQIA3rK0N
         v/Zb6ZMi4e8D/QCnmxEFg9fnhOeNABlxCezjN9DTL9eYEnkUZp9KdCkia0wQQxwnF3
         RNnvG2Gd2tGIISFf+W7fmrLOqr7JQZuduE2qEqWHBZGTgP8R00X0kv+oIk6zxxZJrk
         26b4r7IbRFWnw1FIdh24bQEOOFWQHamU9EEneYWmXGHYfqccXoPXI+XvBrfxzsPQQY
         BW65txlTEN/NUT2n71c+MApeEmWsSwlkA1ohu9Eko9W/bN7WnLujeGxjwOFjvdhEss
         Ls3dp+lLhMvAA==
Message-ID: <2c4b3904bba06429e6c966d6139255e844ee9b94.camel@kernel.org>
Subject: Re: [PATCH v5 1/1] ceph: add getvxattr op
From:   Jeff Layton <jlayton@kernel.org>
To:     Milind Changire <milindchangire@gmail.com>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Cc:     Milind Changire <mchangir@redhat.com>
Date:   Mon, 24 Jan 2022 06:22:36 -0500
In-Reply-To: <20220124090025.70417-2-mchangir@redhat.com>
References: <20220124090025.70417-1-mchangir@redhat.com>
         <20220124090025.70417-2-mchangir@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2022-01-24 at 09:00 +0000, Milind Changire wrote:
> Problem:
> Directory vxattr like ceph.dir.pin* may not be propagated to the
> client as frequently to keep them updated. This creates vxattr
> availability problems.
> Also, the dir and file layout xattr is not reported for dirs and
> files when a layout is not specifically set for the dir or file.
> 
> Solution:
> Adds new getvxattr op to fetch ceph.dir.pin*, ceph.dir.layout.json
> and ceph.file.layout.json vxattrs.
> If the entire layout for a dir or a file is being set, then it is
> expected that the layout be set in standard JSON format. Individual
> field value retrieval is not wrapped in JSON. The JSON format also
> applies while setting the vxattr if the entire layout is being set in
> one go.
> ceph.(dir|file).layout.(pool_name|pool_id) are also supported as new
> vxattrs to help disambiguate the pool name from pool_id when a digit
> sequence is used as a pool name instead of an alphabetic sequence.
> 
> As a temporary measure, setting a vxattr can also be done in the old
> format. The old format will be deprecated in the future.
> 
> URL: https://tracker.ceph.com/issues/51062
> Signed-off-by: Milind Changire <mchangir@redhat.com>
> ---
>  fs/ceph/inode.c              | 51 ++++++++++++++++++++++++++++++++++++
>  fs/ceph/mds_client.c         | 27 ++++++++++++++++++-
>  fs/ceph/mds_client.h         | 12 ++++++++-
>  fs/ceph/strings.c            |  1 +
>  fs/ceph/super.h              |  1 +
>  fs/ceph/xattr.c              | 41 ++++++++++++++++++++++++++++-
>  include/linux/ceph/ceph_fs.h |  1 +
>  7 files changed, 131 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index e3322fcb2e8d..efdce049b7f0 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -2291,6 +2291,57 @@ int __ceph_do_getattr(struct inode *inode, struct page *locked_page,
>  	return err;
>  }
>  
> +int ceph_do_getvxattr(struct inode *inode, const char *name, void *value,
> +		      size_t size)
> +{
> +	struct ceph_fs_client *fsc = ceph_sb_to_client(inode->i_sb);
> +	struct ceph_mds_client *mdsc = fsc->mdsc;
> +	struct ceph_mds_request *req;
> +	int mode = USE_AUTH_MDS;
> +	int err;
> +	char *xattr_value;
> +	size_t xattr_value_len;
> +
> +	req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_GETVXATTR, mode);
> +	if (IS_ERR(req)) {
> +		err = -ENOMEM;
> +		goto out;
> +	}
> +
> +	req->r_path2 = kstrdup(name, GFP_NOFS);
> +	if (!req->r_path2) {
> +		err = -ENOMEM;
> +		goto put;
> +	}
> +
> +	ihold(inode);
> +	req->r_inode = inode;
> +	err = ceph_mdsc_do_request(mdsc, NULL, req);
> +	if (err < 0)
> +		goto put;
> +
> +	xattr_value = req->r_reply_info.xattr_info.xattr_value;
> +	xattr_value_len = req->r_reply_info.xattr_info.xattr_value_len;
> +
> +	dout("do_getvxattr xattr_value_len:%zu, size:%zu\n", xattr_value_len, size);
> +
> +	err = (int)xattr_value_len;
> +	if (size == 0)
> +		goto put;
> +
> +	if (xattr_value_len > size) {
> +		err = -ERANGE;
> +		goto put;
> +	}
> +
> +	memcpy(value, xattr_value, xattr_value_len);
> +put:
> +	ceph_mdsc_put_request(req);
> +out:
> +	dout("do_getvxattr result=%d\n", err);
> +	return err;
> +}
> +
>  
>  /*
>   * Check inode permissions.  We verify we have a valid value for
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index c30eefc0ac19..a5eafc71d976 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -555,6 +555,29 @@ static int parse_reply_info_create(void **p, void *end,
>  	return -EIO;
>  }
>  
> +static int parse_reply_info_getvxattr(void **p, void *end,
> +				      struct ceph_mds_reply_info_parsed *info,
> +				      u64 features)
> +{
> +	u8 struct_v, struct_compat;
> +	u32 struct_len;
> +	u32 value_len;
> +
> +	ceph_decode_8_safe(p, end, struct_v, bad);
> +	ceph_decode_8_safe(p, end, struct_compat, bad);
> +	ceph_decode_32_safe(p, end, struct_len, bad);
> +	ceph_decode_32_safe(p, end, value_len, bad);
> +
> +	if (value_len == end - *p) {
> +	  info->xattr_info.xattr_value = *p;
> +	  info->xattr_info.xattr_value_len = end - *p;
> +	  *p = end;
> +	  return info->xattr_info.xattr_value_len;
> +	}
> +bad:
> +	return -EIO;
> +}
> +
>  /*
>   * parse extra results
>   */
> @@ -570,6 +593,8 @@ static int parse_reply_info_extra(void **p, void *end,
>  		return parse_reply_info_readdir(p, end, info, features);
>  	else if (op == CEPH_MDS_OP_CREATE)
>  		return parse_reply_info_create(p, end, info, features, s);
> +	else if (op == CEPH_MDS_OP_GETVXATTR)
> +		return parse_reply_info_getvxattr(p, end, info, features);
>  	else
>  		return -EIO;
>  }
> @@ -615,7 +640,7 @@ static int parse_reply_info(struct ceph_mds_session *s, struct ceph_msg *msg,
>  
>  	if (p != end)
>  		goto bad;
> -	return 0;
> +	return err;
>  
>  bad:
>  	err = -EIO;
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index 97c7f7bfa55f..f2a8e5af3c2e 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -29,8 +29,10 @@ enum ceph_feature_type {
>  	CEPHFS_FEATURE_MULTI_RECONNECT,
>  	CEPHFS_FEATURE_DELEG_INO,
>  	CEPHFS_FEATURE_METRIC_COLLECT,
> +	CEPHFS_FEATURE_ALTERNATE_NAME,
> +	CEPHFS_FEATURE_GETVXATTR,
>  
> -	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_METRIC_COLLECT,
> +	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_GETVXATTR,
>  };
>  
>  /*
> @@ -45,6 +47,8 @@ enum ceph_feature_type {
>  	CEPHFS_FEATURE_MULTI_RECONNECT,		\
>  	CEPHFS_FEATURE_DELEG_INO,		\
>  	CEPHFS_FEATURE_METRIC_COLLECT,		\
> +	CEPHFS_FEATURE_ALTERNATE_NAME,		\
> +	CEPHFS_FEATURE_GETVXATTR,		\
>  						\
>  	CEPHFS_FEATURE_MAX,			\
>  }
> @@ -100,6 +104,11 @@ struct ceph_mds_reply_dir_entry {
>  	loff_t			      offset;
>  };
>  
> +struct ceph_mds_reply_xattr {
> +	char *xattr_value;
> +	size_t xattr_value_len;
> +};
> +
>  /*
>   * parsed info about an mds reply, including information about
>   * either: 1) the target inode and/or its parent directory and dentry,
> @@ -115,6 +124,7 @@ struct ceph_mds_reply_info_parsed {
>  	char                          *dname;
>  	u32                           dname_len;
>  	struct ceph_mds_reply_lease   *dlease;
> +	struct ceph_mds_reply_xattr   xattr_info;
>  
>  	/* extra */
>  	union {
> diff --git a/fs/ceph/strings.c b/fs/ceph/strings.c
> index 573bb9556fb5..e36e8948e728 100644
> --- a/fs/ceph/strings.c
> +++ b/fs/ceph/strings.c
> @@ -60,6 +60,7 @@ const char *ceph_mds_op_name(int op)
>  	case CEPH_MDS_OP_LOOKUPINO:  return "lookupino";
>  	case CEPH_MDS_OP_LOOKUPNAME:  return "lookupname";
>  	case CEPH_MDS_OP_GETATTR:  return "getattr";
> +	case CEPH_MDS_OP_GETVXATTR:  return "getvxattr";
>  	case CEPH_MDS_OP_SETXATTR: return "setxattr";
>  	case CEPH_MDS_OP_SETATTR: return "setattr";
>  	case CEPH_MDS_OP_RMXATTR: return "rmxattr";
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index ac331aa07cfa..a627fa69668e 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -1043,6 +1043,7 @@ static inline bool ceph_inode_is_shutdown(struct inode *inode)
>  
>  /* xattr.c */
>  int __ceph_setxattr(struct inode *, const char *, const void *, size_t, int);
> +int ceph_do_getvxattr(struct inode *inode, const char *name, void *value, size_t size);
>  ssize_t __ceph_getxattr(struct inode *, const char *, void *, size_t);
>  extern ssize_t ceph_listxattr(struct dentry *, char *, size_t);
>  extern struct ceph_buffer *__ceph_build_xattrs_blob(struct ceph_inode_info *ci);
> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> index fcf7dfdecf96..53ab1c38f1ff 100644
> --- a/fs/ceph/xattr.c
> +++ b/fs/ceph/xattr.c
> @@ -918,6 +918,38 @@ static inline int __get_request_mask(struct inode *in) {
>  	return mask;
>  }
>  
> +/* check if the entire cluster supports the given feature */
> +static inline bool ceph_cluster_has_feature(struct inode *inode, int feature_bit)
> +{
> +	int64_t i;
> +	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(inode->i_sb);
> +	struct ceph_mds_session **sessions = NULL;
> +	int64_t num_sessions = 0;
> +	bool found = false;
> +
> +	mutex_lock(&mdsc->mutex);
> +	num_sessions = atomic_read(&mdsc->num_sessions);
> +	sessions = mdsc->sessions;
> +
> +	if (mdsc->stopping)
> +		goto unlock_out;
> +
> +	if (!sessions)
> +		goto unlock_out;
> +

I don't think we can end up with a NULL sessions pointer w/o failing
register_session(). You can probably drop this check.

> +	for (i = 0; i < num_sessions; i++) {
> +		struct ceph_mds_session *session = sessions[i];
> +		if (!session)
> +			goto unlock_out;

I think you just want to continue here if there is no session for a
particular index. This will make this return false if the client just
happens to not have a session for this MDS at this time.

> +		if (!test_bit(feature_bit, &session->s_features))
> +			goto unlock_out;
> +	}
> +	found = true;
> +unlock_out:
> +	mutex_unlock(&mdsc->mutex);
> +	return found;
> +}
> +
>  ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
>  		      size_t size)
>  {
> @@ -978,8 +1010,15 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
>  
>  	err = -ENODATA;  /* == ENOATTR */
>  	xattr = __get_xattr(ci, name);
> -	if (!xattr)
> +	if (!xattr) {
> +		if (!strncmp(name, XATTR_CEPH_PREFIX, XATTR_CEPH_PREFIX_LEN) &&
> +		    ceph_cluster_has_feature(inode, CEPHFS_FEATURE_GETVXATTR)) {
> +			spin_unlock(&ci->i_ceph_lock);
> +			err = ceph_do_getvxattr(inode, name, value, size);
> +			spin_lock(&ci->i_ceph_lock);
> +		}
>  		goto out;
> +	}

I think this is not quite the right spot to do this.

This is occurring after the client has already issued a GETATTR to the
MDS to fetch the xattr blob for the inode. However, we know that no
ceph.* xattrs will be in that blob, so that call is of no value.

I think you basically want logic like:

1/ test that the name starts with "ceph."
2/ if it does, then call ceph_match_vxattr
3/ if that doesn't match anything, then call ceph_do_getvxattr to ask
the MDS about it


>  
>  	err = -ERANGE;
>  	if (size && size < xattr->val_len)
> diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
> index 7ad6c3d0db7d..66db21ac5f0c 100644
> --- a/include/linux/ceph/ceph_fs.h
> +++ b/include/linux/ceph/ceph_fs.h
> @@ -328,6 +328,7 @@ enum {
>  	CEPH_MDS_OP_LOOKUPPARENT = 0x00103,
>  	CEPH_MDS_OP_LOOKUPINO  = 0x00104,
>  	CEPH_MDS_OP_LOOKUPNAME = 0x00105,
> +	CEPH_MDS_OP_GETVXATTR  = 0x00106,
>  
>  	CEPH_MDS_OP_SETXATTR   = 0x01105,
>  	CEPH_MDS_OP_RMXATTR    = 0x01106,

-- 
Jeff Layton <jlayton@kernel.org>
