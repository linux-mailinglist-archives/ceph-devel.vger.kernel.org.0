Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F94B4902E0
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Jan 2022 08:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235101AbiAQHTw (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 17 Jan 2022 02:19:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25544 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235040AbiAQHTv (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 17 Jan 2022 02:19:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642403991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DYhqI4x1UQG+Eskvb9gWnDuaasY9xd99CAHsf2tet2g=;
        b=NWIlJumGmtTgGBVD7wQrovyI6yafbwZkX7IVTE0tl1qgT0TkyxzGKOiBNOXPnWKL89Y1CR
        0SZXmF5WFrWSDdybqXxxMylqKsn4feFpkEfjAOjX5HXU5aaats9u6tbZ6HjpI/TvZXXr8N
        PJB9ZyVr4hsLIZjAQGUiW/GkFfc5Kqg=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-64-QV9GGucBO1CgepIr9ai89A-1; Mon, 17 Jan 2022 02:19:49 -0500
X-MC-Unique: QV9GGucBO1CgepIr9ai89A-1
Received: by mail-pj1-f70.google.com with SMTP id d92-20020a17090a6f6500b001b35ac5f393so10372413pjk.7
        for <ceph-devel@vger.kernel.org>; Sun, 16 Jan 2022 23:19:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=DYhqI4x1UQG+Eskvb9gWnDuaasY9xd99CAHsf2tet2g=;
        b=2xPwLVukhOTLLfk6+/Oh+ZOOnU6A6Tj08exOJHuEwTOXDdxhCwg+BQ9fYu/JfF5+6d
         +gmsUW0e00A4cl92qwfbz3mFdHurqHOyzjtwGyZ1T8uWMJTIYWWWQ+kQEcVnF8rZfy/A
         zgCGZPWVMCS2+tTM1Y6Z3sBBUEfiYqDTNAcJoUBjgYx2+7NnB31yE+pc+Xek6oW5HqIi
         SlERQBU+6nyJBvFHGvzcw7UmOSP6toGLNvCN+o1hLx1gCjEPgREljqSDLLTZ82AYrvpD
         ng/xNKMJyB6CfZLUDvtfMBjm+UaytVVY7T9xl02VBR2QTVfkEy2e+3KZLJRfpRKZv/SV
         Ighw==
X-Gm-Message-State: AOAM531bLNnxIFJ+k7SfodOB/JLcVN7V7R0tTRs/Z/sUX8j4SinNxs+t
        zOCQm7kWtonSGfX/FiPZy++9vSRW2T0yv78T/U9pY3qABYwRSe9nT5yTq36QgUfcZ0AXaZ6SCUb
        QHvVrKXr5RB0O6DbZU01QUg==
X-Received: by 2002:a63:4d17:: with SMTP id a23mr18010818pgb.179.1642403988498;
        Sun, 16 Jan 2022 23:19:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz2hJa7ErBIrPXS1mpRlMc4dWBo2IxXPG3L1pouLEknBgsOXhTKqdUk9Bj3025Mqt0RCWSoXw==
X-Received: by 2002:a63:4d17:: with SMTP id a23mr18010802pgb.179.1642403988164;
        Sun, 16 Jan 2022 23:19:48 -0800 (PST)
Received: from [10.72.12.81] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h21sm12069616pfo.38.2022.01.16.23.19.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Jan 2022 23:19:47 -0800 (PST)
Subject: Re: [PATCH v3 1/1] ceph: add getvxattr op
To:     Milind Changire <milindchangire@gmail.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Cc:     Milind Changire <mchangir@redhat.com>
References: <20220117035946.22442-1-mchangir@redhat.com>
 <20220117035946.22442-2-mchangir@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <c6263a9a-e761-85f6-8c61-aaa706730639@redhat.com>
Date:   Mon, 17 Jan 2022 15:19:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220117035946.22442-2-mchangir@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 1/17/22 11:59 AM, Milind Changire wrote:
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
> As a temporary measure, setting a vxattr can also be done in the old
> format. The old format will be deprecated in the future.
>
> URL: https://tracker.ceph.com/issues/51062
> Signed-off-by: Milind Changire <mchangir@redhat.com>
> ---
>   fs/ceph/inode.c              | 51 ++++++++++++++++++++++++++++++++++++
>   fs/ceph/mds_client.c         | 27 ++++++++++++++++++-
>   fs/ceph/mds_client.h         | 12 ++++++++-
>   fs/ceph/strings.c            |  1 +
>   fs/ceph/super.h              |  1 +
>   fs/ceph/xattr.c              | 34 ++++++++++++++++++++++++
>   include/linux/ceph/ceph_fs.h |  1 +
>   7 files changed, 125 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index e3322fcb2e8d..b63746a7a0e0 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -2291,6 +2291,57 @@ int __ceph_do_getattr(struct inode *inode, struct page *locked_page,
>   	return err;
>   }
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
> +	dout("do_getvxattr xattr_value_len:%u, size:%u\n", xattr_value_len, size);
> +
> +	err = xattr_value_len;
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
>   /*
>    * Check inode permissions.  We verify we have a valid value for
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index c30eefc0ac19..a5eafc71d976 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -555,6 +555,29 @@ static int parse_reply_info_create(void **p, void *end,
>   	return -EIO;
>   }
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
>   /*
>    * parse extra results
>    */
> @@ -570,6 +593,8 @@ static int parse_reply_info_extra(void **p, void *end,
>   		return parse_reply_info_readdir(p, end, info, features);
>   	else if (op == CEPH_MDS_OP_CREATE)
>   		return parse_reply_info_create(p, end, info, features, s);
> +	else if (op == CEPH_MDS_OP_GETVXATTR)
> +		return parse_reply_info_getvxattr(p, end, info, features);
>   	else
>   		return -EIO;
>   }
> @@ -615,7 +640,7 @@ static int parse_reply_info(struct ceph_mds_session *s, struct ceph_msg *msg,
>   
>   	if (p != end)
>   		goto bad;
> -	return 0;
> +	return err;
>   
>   bad:
>   	err = -EIO;
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index 97c7f7bfa55f..f2a8e5af3c2e 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -29,8 +29,10 @@ enum ceph_feature_type {
>   	CEPHFS_FEATURE_MULTI_RECONNECT,
>   	CEPHFS_FEATURE_DELEG_INO,
>   	CEPHFS_FEATURE_METRIC_COLLECT,
> +	CEPHFS_FEATURE_ALTERNATE_NAME,
> +	CEPHFS_FEATURE_GETVXATTR,
>   
> -	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_METRIC_COLLECT,
> +	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_GETVXATTR,
>   };
>   
>   /*
> @@ -45,6 +47,8 @@ enum ceph_feature_type {
>   	CEPHFS_FEATURE_MULTI_RECONNECT,		\
>   	CEPHFS_FEATURE_DELEG_INO,		\
>   	CEPHFS_FEATURE_METRIC_COLLECT,		\
> +	CEPHFS_FEATURE_ALTERNATE_NAME,		\
> +	CEPHFS_FEATURE_GETVXATTR,		\
>   						\
>   	CEPHFS_FEATURE_MAX,			\
>   }
> @@ -100,6 +104,11 @@ struct ceph_mds_reply_dir_entry {
>   	loff_t			      offset;
>   };
>   
> +struct ceph_mds_reply_xattr {
> +	char *xattr_value;
> +	size_t xattr_value_len;
> +};
> +
>   /*
>    * parsed info about an mds reply, including information about
>    * either: 1) the target inode and/or its parent directory and dentry,
> @@ -115,6 +124,7 @@ struct ceph_mds_reply_info_parsed {
>   	char                          *dname;
>   	u32                           dname_len;
>   	struct ceph_mds_reply_lease   *dlease;
> +	struct ceph_mds_reply_xattr   xattr_info;
>   
>   	/* extra */
>   	union {
> diff --git a/fs/ceph/strings.c b/fs/ceph/strings.c
> index 573bb9556fb5..e36e8948e728 100644
> --- a/fs/ceph/strings.c
> +++ b/fs/ceph/strings.c
> @@ -60,6 +60,7 @@ const char *ceph_mds_op_name(int op)
>   	case CEPH_MDS_OP_LOOKUPINO:  return "lookupino";
>   	case CEPH_MDS_OP_LOOKUPNAME:  return "lookupname";
>   	case CEPH_MDS_OP_GETATTR:  return "getattr";
> +	case CEPH_MDS_OP_GETVXATTR:  return "getvxattr";
>   	case CEPH_MDS_OP_SETXATTR: return "setxattr";
>   	case CEPH_MDS_OP_SETATTR: return "setattr";
>   	case CEPH_MDS_OP_RMXATTR: return "rmxattr";
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index ac331aa07cfa..a627fa69668e 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -1043,6 +1043,7 @@ static inline bool ceph_inode_is_shutdown(struct inode *inode)
>   
>   /* xattr.c */
>   int __ceph_setxattr(struct inode *, const char *, const void *, size_t, int);
> +int ceph_do_getvxattr(struct inode *inode, const char *name, void *value, size_t size);
>   ssize_t __ceph_getxattr(struct inode *, const char *, void *, size_t);
>   extern ssize_t ceph_listxattr(struct dentry *, char *, size_t);
>   extern struct ceph_buffer *__ceph_build_xattrs_blob(struct ceph_inode_info *ci);
> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> index fcf7dfdecf96..dc32876a541a 100644
> --- a/fs/ceph/xattr.c
> +++ b/fs/ceph/xattr.c
> @@ -918,6 +918,30 @@ static inline int __get_request_mask(struct inode *in) {
>   	return mask;
>   }
>   
> +/* check if the entire cluster supports the given feature */
> +static inline bool ceph_cluster_has_feature(struct inode *inode, int feature_bit)
> +{
> +	int64_t i;
> +	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
> +	struct ceph_mds_session **sessions = fsc->mdsc->sessions;
> +	int64_t num_sessions = atomic_read(&fsc->mdsc->num_sessions);
> +
> +	if (fsc->mdsc->stopping)
> +		return false;
> +
> +	if (!sessions)
> +		return false;
> +
> +	for (i = 0; i < num_sessions; i++) {
> +		struct ceph_mds_session *session = sessions[i];
> +		if (!session)
> +			return false;
> +		if (!test_bit(feature_bit, &session->s_features))

This will be possibly cause crash because, and you should put the whole 
for loop and 'fsc->mdsc->xxx' above under the 'mdsc->mutex'.


> +			return false;
> +	}
> +	return true;
> +}
> +
>   ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
>   		      size_t size)
>   {
> @@ -927,6 +951,16 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
>   	int req_mask;
>   	ssize_t err;
>   
> +	if (!strncmp(name, XATTR_CEPH_PREFIX, XATTR_CEPH_PREFIX_LEN) &&
> +	    ceph_cluster_has_feature(inode, CEPHFS_FEATURE_GETVXATTR)) {
> +		err = ceph_do_getvxattr(inode, name, value, size);
> +		/* if cluster doesn't support xattr, we try to service it
> +		 * locally
> +		 */
> +		if (err >= 0)
> +			return err;
> +	}
> +

If the 'Fa' or 'Fr' caps is issued to kclient, could we get this vxattr 
locally instead of getting it from MDS every time ?



>   	/* let's see if a virtual xattr was requested */
>   	vxattr = ceph_match_vxattr(inode, name);
>   	if (vxattr) {
> diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
> index 7ad6c3d0db7d..66db21ac5f0c 100644
> --- a/include/linux/ceph/ceph_fs.h
> +++ b/include/linux/ceph/ceph_fs.h
> @@ -328,6 +328,7 @@ enum {
>   	CEPH_MDS_OP_LOOKUPPARENT = 0x00103,
>   	CEPH_MDS_OP_LOOKUPINO  = 0x00104,
>   	CEPH_MDS_OP_LOOKUPNAME = 0x00105,
> +	CEPH_MDS_OP_GETVXATTR  = 0x00106,
>   
>   	CEPH_MDS_OP_SETXATTR   = 0x01105,
>   	CEPH_MDS_OP_RMXATTR    = 0x01106,

