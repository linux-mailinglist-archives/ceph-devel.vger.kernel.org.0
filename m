Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68E6B4B283B
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Feb 2022 15:48:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350998AbiBKOsb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 11 Feb 2022 09:48:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235874AbiBKOsa (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 11 Feb 2022 09:48:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403A6FE
        for <ceph-devel@vger.kernel.org>; Fri, 11 Feb 2022 06:48:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB79EB829EF
        for <ceph-devel@vger.kernel.org>; Fri, 11 Feb 2022 14:48:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FA4CC340E9;
        Fri, 11 Feb 2022 14:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644590906;
        bh=nHSZ+/qkyjnL5qX1A5BvE1fklFhxqEAaa5b4rdbDqnw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=d/qQKCoSiuqgJLelEss0QE9z4FcFfoZg9xQqPkTZ1BlQqD7deb8so9OhQhhYo03a/
         SR2k8tAM7ifncHlXnbt6rlVIaHVExR5e0DcFdVbTdD4nbvDiI6f3rvqXSebsHlBRxy
         ynvpfiGTUDhOBmFdRFHkfdlRw/Nxx1pKTJXuhfe9UQAZhrz7S/Nn0hPwm8tSsCeHKf
         9WTEPcR3RDK1FPssN5rtc86qI1l2bTVJHzlmbF+cTYIdEy4NfBUxMR2Nkujh/Xz8ny
         b935lCw/gnYYVQBeM9QF4l1L8VgDCfx2K7jUgl6GSDF64yaol57Ry4Jt1IFemlINCZ
         m/YmCy8lQqowQ==
Message-ID: <947b779b98be8ceed96c8483a7a2b168f9b6c599.camel@kernel.org>
Subject: Re: [PATCH v9 1/1] ceph: add getvxattr op
From:   Jeff Layton <jlayton@kernel.org>
To:     Milind Changire <milindchangire@gmail.com>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Cc:     Milind Changire <mchangir@redhat.com>
Date:   Fri, 11 Feb 2022 09:48:25 -0500
In-Reply-To: <20220211121217.166680-2-mchangir@redhat.com>
References: <20220211121217.166680-1-mchangir@redhat.com>
         <20220211121217.166680-2-mchangir@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2022-02-11 at 12:12 +0000, Milind Changire wrote:
> Problem:
> Directory vxattrs like ceph.dir.pin* and ceph.dir.layout* may not be
> propagated to the client as frequently to keep them updated. This
> creates vxattr availability problems.
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
>  fs/ceph/mds_client.c         | 25 ++++++++++++++++++
>  fs/ceph/mds_client.h         |  6 +++++
>  fs/ceph/strings.c            |  1 +
>  fs/ceph/super.h              |  1 +
>  fs/ceph/xattr.c              |  9 +++++--
>  include/linux/ceph/ceph_fs.h |  1 +
>  7 files changed, 92 insertions(+), 2 deletions(-)
> 


Looks good, Milind. We're getting closer now. :)

The patch description doesn't seem to describe the actual problem
though, and the info about JSON is superfluous. How about this instead:

----------------8<----------------------
Some directory vxattrs (e.g. ceph.dir.pin.random) are governed by
information that isn't necessarily shared with the client. Add support
for the new GETVXATTR operation, which allows the client to query the
MDS directly for vxattrs.

When the client is queried for a vxattr that doesn't have a special
handler, have it issue a GETVXATTR to the MDS directly.
----------------8<----------------------

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
> index c30eefc0ac19..467817cb7309 100644
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
> +	  info->xattr_info.xattr_value_len = value_len;
> +	  *p = end;
> +	  return value_len;
> +	}
> +bad:
> +	return -EIO;
> +}
> +


Also, I'll suggest the following code change, which should silence some
compiler warnings. Since we aren't doing anything with those variables
we can just skip over them instead of decoding them:

----------------8<-----------------------
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index ca47611f7bde..f4f30583482d 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -623,13 +623,11 @@ static int parse_reply_info_getvxattr(void **p, void *end,
                                      struct ceph_mds_reply_info_parsed *info,
                                      u64 features)
 {
-       u8 struct_v, struct_compat;
-       u32 struct_len;
        u32 value_len;
 
-       ceph_decode_8_safe(p, end, struct_v, bad);
-       ceph_decode_8_safe(p, end, struct_compat, bad);
-       ceph_decode_32_safe(p, end, struct_len, bad);
+       ceph_decode_skip_8(p, end, bad);
+       ceph_decode_skip_8(p, end, bad);
+       ceph_decode_skip_32(p, end, bad);
        ceph_decode_32_safe(p, end, value_len, bad);
 
        if (value_len == end - *p) {
----------------8<-----------------------

...maybe also add some comments that say what the fields you're skipping
represent. If we ever rev the version of this call, we'll need to start
parsing that info.

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
> index fcf7dfdecf96..4860f1660b82 100644
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
> @@ -945,8 +948,10 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
>  				err = -ERANGE;
>  		}
>  		return err;
> +	} else {
> +		return ceph_do_getvxattr(inode, name, value, size);


You probably need to massage the error code here a bit. If the MDS is
old and returns -EOPNOTSUPP, I think that we'd want to translate that
into -ENODATA.

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

-- 
Jeff Layton <jlayton@kernel.org>
