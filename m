Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14D594AB70F
	for <lists+ceph-devel@lfdr.de>; Mon,  7 Feb 2022 10:08:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbiBGIrv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 7 Feb 2022 03:47:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243479AbiBGIi2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 7 Feb 2022 03:38:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 53D8AC043181
        for <ceph-devel@vger.kernel.org>; Mon,  7 Feb 2022 00:38:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644223106;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZulZlgOr+AO4MGCtlqpdcs8b+SNDJYuFaeMaQ0R1U9E=;
        b=GoEgxIqRObUh/ZUJ7ws4NAlSk/kzhR23dYGB0PZZicXEnfQ4LBQQTr4SbS7w+AjPcotmUG
        dqHMQeCF/AXIrZW6eYxS4xfeHF7+mkcRlBxUVMvtqzrDzOSz7tuqB3FR9oYrqd0iLegjPI
        dm1IOMfyMCvt1V2jQbJOPNmZlflHI5Q=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-117-oO-UQabQMAW3w1TzIHvzUw-1; Mon, 07 Feb 2022 03:38:25 -0500
X-MC-Unique: oO-UQabQMAW3w1TzIHvzUw-1
Received: by mail-pl1-f199.google.com with SMTP id p7-20020a1709026b8700b0014a8d8fbf6fso4995609plk.23
        for <ceph-devel@vger.kernel.org>; Mon, 07 Feb 2022 00:38:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=ZulZlgOr+AO4MGCtlqpdcs8b+SNDJYuFaeMaQ0R1U9E=;
        b=0IQbfPq86ATzVgcWFTKmsatrBj82t8Jy4t9uZ/GxIFoXinpdbEjAKPEjbdA9dviGem
         +n/JUChi9YXWKQS1LlJSh5WMP9gO9qgEz8GgUNpPNuk84dTu2lKjbY4dn9UnsdXX+b+7
         ec+ayst5LtnhkNaVRcDtCLfM46nMIBoUPgdq16colJ34Uu61QK8CRIewcWBCo3hrkxas
         T9iulC3KK3YyvF3vnxqEgE43hWEPeCnqAUfpMDl3YoWPOKe0mnNHyMyz3/EehCGm1o/e
         a+nLuEht0/G+jj/oI9avwltHCFP9KKX4oQFT4GshiWl9e4i/rUR7KKc5rKn/K/B5m9Ic
         eF9Q==
X-Gm-Message-State: AOAM532z9ektKdCqXNBPdH0kxsuPbQWbdHP6Rb1eZtSj1LiOIDitRoN1
        PyU0178vvn2EWOwOWTOdVmoS1YLoi2xK7w56zr5wuaVW3cG9Ut6HDzIKHkdihGWBfB4Zm3EVTGk
        CeeEQ54ft1m/CL4uStDqaxLniA3BJS17lR6ADREZgWg5u2mLghwdeq+J1K+yWNBG6V+JM+/0=
X-Received: by 2002:a17:90a:8c4:: with SMTP id 4mr13067452pjn.201.1644223103582;
        Mon, 07 Feb 2022 00:38:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzLur3FkzgCAD9QsoS5XO3Z/VG90vAv4HK8grT2p3uu/lMldj2lhSoqPaLf6GA4ZAwKfo6ITw==
X-Received: by 2002:a17:90a:8c4:: with SMTP id 4mr13067425pjn.201.1644223103142;
        Mon, 07 Feb 2022 00:38:23 -0800 (PST)
Received: from [10.72.12.64] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k3sm11332798pfu.180.2022.02.07.00.38.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 00:38:22 -0800 (PST)
Subject: Re: [PATCH v6 1/1] ceph: add getvxattr op
To:     Milind Changire <milindchangire@gmail.com>
Cc:     Milind Changire <mchangir@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <20220127082619.85379-1-mchangir@redhat.com>
 <20220127082619.85379-2-mchangir@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <0b18ee3f-86c4-c1aa-ac65-f43577319c69@redhat.com>
Date:   Mon, 7 Feb 2022 16:36:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220127082619.85379-2-mchangir@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 1/27/22 4:26 PM, Milind Changire wrote:
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
>   fs/ceph/xattr.c              | 17 ++++++++++++
>   include/linux/ceph/ceph_fs.h |  1 +
>   7 files changed, 108 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index e3322fcb2e8d..efdce049b7f0 100644
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

Maybe this could be simplified by 's/end - *p/value_len/'


> +	  *p = end;
> +	  return info->xattr_info.xattr_value_len;

And also here just return 'value_len' instead.


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
> index fcf7dfdecf96..9a4fbe48963f 100644
> --- a/fs/ceph/xattr.c
> +++ b/fs/ceph/xattr.c
> @@ -924,6 +924,7 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
>   	struct ceph_inode_info *ci = ceph_inode(inode);
>   	struct ceph_inode_xattr *xattr;
>   	struct ceph_vxattr *vxattr = NULL;
> +	struct ceph_mds_session *session = NULL;

No need to init this.


>   	int req_mask;
>   	ssize_t err;
>   
> @@ -945,6 +946,22 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
>   				err = -ERANGE;
>   		}
>   		return err;
> +	} else {
> +		err = -ENODATA;
> +		spin_lock(&ci->i_ceph_lock);
> +		if (strncmp(name, XATTR_CEPH_PREFIX, XATTR_CEPH_PREFIX_LEN))
> +			goto out;

No need to get the 'i_ceph_lock' for the 'strncmp()' here, and could 
just return '-EINVAL' directly instead of goto out ?


> +		/* check if the auth mds supports the getvxattr feature */
> +		session = ci->i_auth_cap->session;
> +		if (!session)
> +			goto out;

In which case will the session be NULL ? If the i_auth_cap exists it 
will always set the 'session'.


> +
> +		if (test_bit(CEPHFS_FEATURE_GETVXATTR, &session->s_features)) {
> +			spin_unlock(&ci->i_ceph_lock);
> +			err = ceph_do_getvxattr(inode, name, value, size);
> +			spin_lock(&ci->i_ceph_lock);
> +		}
> +		goto out;
>   	}
>   
>   	req_mask = __get_request_mask(inode);
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

