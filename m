Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 283B54B4EC9
	for <lists+ceph-devel@lfdr.de>; Mon, 14 Feb 2022 12:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351992AbiBNLfh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 14 Feb 2022 06:35:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347352AbiBNLfZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 14 Feb 2022 06:35:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D144763D7
        for <ceph-devel@vger.kernel.org>; Mon, 14 Feb 2022 03:23:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C80061151
        for <ceph-devel@vger.kernel.org>; Mon, 14 Feb 2022 11:23:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A582C340E9;
        Mon, 14 Feb 2022 11:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644837785;
        bh=/YvEFxjHQfznSziQ0hm7waNdWlJnGcc5e32/gIzfsQI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Hj8vF5SYltR8XIfMXxbO36Pgdf8MWF5DH9oQ8vZ6v5hkxEgGPmangV87Z6hX1TtwD
         DlDaX7dQqmzbkseNn7II5JNqOf/BhxX/eZ8Q++m0pa04Kkb7COnd1eCARFZj43RcPo
         SRmg1Q8TcOBpUqwHVn9zND/MLMrtR0n8jq8sQWqVy1E8awwcuhYwlBLugk7awBwOCv
         qB2CeXfFnp/eDOQA2GIMIP/GSQ4gnOKPNeyTmLkOx+xuNNhPaeIj6AXChXPYa9wpHC
         eahzhYjEpZw3lXGhjST4j3GODrHaFCyHKPQ6Z339xDyJvKAb7wo10NyrrbuIJALXqT
         tZRhS8MAFdl4w==
Message-ID: <14abbe51df65f663393e040f230f7034a860e258.camel@kernel.org>
Subject: Re: [PATCH v10 1/1] ceph: add getvxattr op
From:   Jeff Layton <jlayton@kernel.org>
To:     Milind Changire <milindchangire@gmail.com>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Cc:     Milind Changire <mchangir@redhat.com>
Date:   Mon, 14 Feb 2022 06:23:04 -0500
In-Reply-To: <20220214050101.178045-2-mchangir@redhat.com>
References: <20220214050101.178045-1-mchangir@redhat.com>
         <20220214050101.178045-2-mchangir@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2022-02-14 at 05:01 +0000, Milind Changire wrote:
> Problem:
> Some directory vxattrs (e.g. ceph.dir.pin.random) are governed by
> information that isn't necessarily shared with the client. Add support
> for the new GETVXATTR operation, which allows the client to query the
> MDS directly for vxattrs.
> 
> When the client is queried for a vxattr that doesn't have a special
> handler, have it issue a GETVXATTR to the MDS directly.
> 
> Solution:
> Adds new getvxattr op to fetch ceph.dir.pin*, ceph.dir.layout* and
> ceph.file.layout* vxattrs.
> If the entire layout for a dir or a file is being set, then it is
> expected that the layout be set in standard JSON format. Individual
> field value retrieval is not wrapped in JSON. The JSON format also
> applies while setting the vxattr if the entire layout is being set in
> one go.
> 
> As a temporary measure, setting a vxattr can also be done in the old
> format. The old format will be deprecated in the future.
> 
> URL: https://tracker.ceph.com/issues/51062
> Signed-off-by: Milind Changire <mchangir@redhat.com>
> ---
>  fs/ceph/inode.c              | 51 ++++++++++++++++++++++++++++++++++++
>  fs/ceph/mds_client.c         | 24 +++++++++++++++++
>  fs/ceph/mds_client.h         |  6 +++++
>  fs/ceph/strings.c            |  1 +
>  fs/ceph/super.h              |  1 +
>  fs/ceph/xattr.c              | 13 +++++++--
>  include/linux/ceph/ceph_fs.h |  1 +
>  7 files changed, 95 insertions(+), 2 deletions(-)
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
> index c30eefc0ac19..76bdb1943919 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -555,6 +555,28 @@ static int parse_reply_info_create(void **p, void *end,
>  	return -EIO;
>  }
>  
> +static int parse_reply_info_getvxattr(void **p, void *end,
> +				      struct ceph_mds_reply_info_parsed *info,
> +				      u64 features)
> +{
> +	u32 value_len;
> +
> +	ceph_decode_skip_8(p, end, bad); /* skip current version: 1 */
> +	ceph_decode_skip_8(p, end, bad); /* skip first version: 1 */
> +	ceph_decode_skip_32(p, end, bad); /* skip payload length */
> +
> +	ceph_decode_32_safe(p, end, value_len, bad);
> +
> +	if (value_len == end - *p) {
> +	  info->xattr_info.xattr_value = *p;
> +	  info->xattr_info.xattr_value_len = value_len;
> +	  *p = end;
> +	  return value_len;
> +	}
> +bad:
> +	return -EIO;
> +}
> +
>  /*
>   * parse extra results
>   */
> @@ -570,6 +592,8 @@ static int parse_reply_info_extra(void **p, void *end,
>  		return parse_reply_info_readdir(p, end, info, features);
>  	else if (op == CEPH_MDS_OP_CREATE)
>  		return parse_reply_info_create(p, end, info, features, s);
> +	else if (op == CEPH_MDS_OP_GETVXATTR)
> +		return parse_reply_info_getvxattr(p, end, info, features);
>  	else
>  		return -EIO;
>  }
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index 97c7f7bfa55f..4282963e4064 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -100,6 +100,11 @@ struct ceph_mds_reply_dir_entry {
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
> @@ -115,6 +120,7 @@ struct ceph_mds_reply_info_parsed {
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
> index fcf7dfdecf96..afec84088471 100644
> --- a/fs/ceph/xattr.c
> +++ b/fs/ceph/xattr.c
> @@ -923,10 +923,13 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
>  {
>  	struct ceph_inode_info *ci = ceph_inode(inode);
>  	struct ceph_inode_xattr *xattr;
> -	struct ceph_vxattr *vxattr = NULL;
> +	struct ceph_vxattr *vxattr;
>  	int req_mask;
>  	ssize_t err;
>  
> +	if (strncmp(name, XATTR_CEPH_PREFIX, XATTR_CEPH_PREFIX_LEN))
> +		goto handle_non_vxattrs;
> +
>  	/* let's see if a virtual xattr was requested */
>  	vxattr = ceph_match_vxattr(inode, name);
>  	if (vxattr) {
> @@ -945,8 +948,14 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
>  				err = -ERANGE;
>  		}
>  		return err;
> +	} else {
> +		err = ceph_do_getvxattr(inode, name, value, size);
> +		/* this would happen with a new client and old server combo */
> +		if (err == -EOPNOTSUPP)
> +			err = -ENODATA;
> +		return err;
>  	}
> -
> +handle_non_vxattrs:
>  	req_mask = __get_request_mask(inode);
>  
>  	spin_lock(&ci->i_ceph_lock);
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


Looks good -- merged into testing branch. Thanks, Milind!
-- 
Jeff Layton <jlayton@kernel.org>
