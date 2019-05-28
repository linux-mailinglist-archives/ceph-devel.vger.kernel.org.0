Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1DDA2C5FF
	for <lists+ceph-devel@lfdr.de>; Tue, 28 May 2019 13:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726844AbfE1L7N (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 28 May 2019 07:59:13 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:43376 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726580AbfE1L7N (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 28 May 2019 07:59:13 -0400
Received: by mail-yw1-f68.google.com with SMTP id t5so7777097ywf.10
        for <ceph-devel@vger.kernel.org>; Tue, 28 May 2019 04:59:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=secV5avc5808kShQhrKP+cpoLuZhMMA6qjccO867nNQ=;
        b=ctoNlB2JzATudyyuklDqwh6JuPYVWOX5ZbekPH7w9VeYklBa4aAHz+wrOIcD7/rHBK
         LhcmMtE/6M8DFSrQsnkBtaBWBtGKWthL9Rj+FF5VN9eVU/XS6F0m5oPi4AQA/uLt8yep
         VbBQHv5MIJivt6ktRQpJ74Jce3Pi5+Pvq+iqcussK3g4b07h6ewc6Y04j9WDxZVD8n9q
         avE8fCgJwvq1zkZeKE9pwacyODb5YhVuS9xa+Jcgzvg1HIdgoMfZpG226vY6xYDHev9/
         un+A8OfGsEyu9YSmBQ4AHnBvR0gGSN5ciT9BLP6cO0C4AOodnc1qI9QSvGVL98iT/VUL
         hjtA==
X-Gm-Message-State: APjAAAXi7xJIGljnLCGo2evDMXMSfNE5yA0UCnH80/ONHQs0ro5duvH8
        /FcFYpJtHbcm3rQnSlkXyXnaTQ==
X-Google-Smtp-Source: APXvYqwcyco+oW22sym40EKiRNRA8BOR0mClbNEWRF1go2HAKaYw/ToBs2ZQ2DIkfie7ZahE2TUf7g==
X-Received: by 2002:a81:638b:: with SMTP id x133mr6045045ywb.82.1559044752113;
        Tue, 28 May 2019 04:59:12 -0700 (PDT)
Received: from tleilax.poochiereds.net (cpe-2606-A000-1100-37D-0-0-0-4F7.dyn6.twc.com. [2606:a000:1100:37d::4f7])
        by smtp.gmail.com with ESMTPSA id k205sm3447926ywc.69.2019.05.28.04.59.11
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 28 May 2019 04:59:11 -0700 (PDT)
Message-ID: <4d7e7ad4ec52122fdcf806c5787141ddfc5a091d.camel@redhat.com>
Subject: Re: [PATCH 1/2] ceph: rename struct ceph_acls_info to
 ceph_acl_sec_ctx
From:   Jeff Layton <jlayton@redhat.com>
To:     "Yan, Zheng" <zyan@redhat.com>, ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com
Date:   Tue, 28 May 2019 07:59:10 -0400
In-Reply-To: <20190527110702.3962-1-zyan@redhat.com>
References: <20190527110702.3962-1-zyan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2019-05-27 at 19:07 +0800, Yan, Zheng wrote:
> this is preparation for security label support
> 
> Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
> ---
>  fs/ceph/acl.c   | 22 +++++++---------------
>  fs/ceph/dir.c   | 28 ++++++++++++++--------------
>  fs/ceph/file.c  | 18 +++++++++---------
>  fs/ceph/super.h | 29 +++++++++++++++--------------
>  fs/ceph/xattr.c | 10 ++++++++++
>  5 files changed, 55 insertions(+), 52 deletions(-)
> 
> diff --git a/fs/ceph/acl.c b/fs/ceph/acl.c
> index bc2b89e8fd3f..07c8ab39f6c7 100644
> --- a/fs/ceph/acl.c
> +++ b/fs/ceph/acl.c
> @@ -172,7 +172,7 @@ int ceph_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>  }
>  
>  int ceph_pre_init_acls(struct inode *dir, umode_t *mode,
> -		       struct ceph_acls_info *info)
> +		       struct ceph_acl_sec_ctx *as_ctx)
>  {
>  	struct posix_acl *acl, *default_acl;
>  	size_t val_size1 = 0, val_size2 = 0;
> @@ -247,9 +247,9 @@ int ceph_pre_init_acls(struct inode *dir, umode_t *mode,
>  
>  	kfree(tmp_buf);
>  
> -	info->acl = acl;
> -	info->default_acl = default_acl;
> -	info->pagelist = pagelist;
> +	as_ctx->acl = acl;
> +	as_ctx->default_acl = default_acl;
> +	as_ctx->pagelist = pagelist;
>  	return 0;
>  
>  out_err:
> @@ -261,18 +261,10 @@ int ceph_pre_init_acls(struct inode *dir, umode_t *mode,
>  	return err;
>  }
>  
> -void ceph_init_inode_acls(struct inode* inode, struct ceph_acls_info *info)
> +void ceph_init_inode_acls(struct inode* inode, struct ceph_acl_sec_ctx *as_ctx)
>  {
>  	if (!inode)
>  		return;
> -	ceph_set_cached_acl(inode, ACL_TYPE_ACCESS, info->acl);
> -	ceph_set_cached_acl(inode, ACL_TYPE_DEFAULT, info->default_acl);
> -}
> -
> -void ceph_release_acls_info(struct ceph_acls_info *info)
> -{
> -	posix_acl_release(info->acl);
> -	posix_acl_release(info->default_acl);
> -	if (info->pagelist)
> -		ceph_pagelist_release(info->pagelist);
> +	ceph_set_cached_acl(inode, ACL_TYPE_ACCESS, as_ctx->acl);
> +	ceph_set_cached_acl(inode, ACL_TYPE_DEFAULT, as_ctx->default_acl);
>  }
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index 72efad28857c..14d795e5fa73 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -825,7 +825,7 @@ static int ceph_mknod(struct inode *dir, struct dentry *dentry,
>  	struct ceph_fs_client *fsc = ceph_sb_to_client(dir->i_sb);
>  	struct ceph_mds_client *mdsc = fsc->mdsc;
>  	struct ceph_mds_request *req;
> -	struct ceph_acls_info acls = {};
> +	struct ceph_acl_sec_ctx as_ctx = {};
>  	int err;
>  
>  	if (ceph_snap(dir) != CEPH_NOSNAP)
> @@ -836,7 +836,7 @@ static int ceph_mknod(struct inode *dir, struct dentry *dentry,
>  		goto out;
>  	}
>  
> -	err = ceph_pre_init_acls(dir, &mode, &acls);
> +	err = ceph_pre_init_acls(dir, &mode, &as_ctx);
>  	if (err < 0)
>  		goto out;
>  
> @@ -855,9 +855,9 @@ static int ceph_mknod(struct inode *dir, struct dentry *dentry,
>  	req->r_args.mknod.rdev = cpu_to_le32(rdev);
>  	req->r_dentry_drop = CEPH_CAP_FILE_SHARED | CEPH_CAP_AUTH_EXCL;
>  	req->r_dentry_unless = CEPH_CAP_FILE_EXCL;
> -	if (acls.pagelist) {
> -		req->r_pagelist = acls.pagelist;
> -		acls.pagelist = NULL;
> +	if (as_ctx.pagelist) {
> +		req->r_pagelist = as_ctx.pagelist;
> +		as_ctx.pagelist = NULL;
>  	}
>  	err = ceph_mdsc_do_request(mdsc, dir, req);
>  	if (!err && !req->r_reply_info.head->is_dentry)
> @@ -865,10 +865,10 @@ static int ceph_mknod(struct inode *dir, struct dentry *dentry,
>  	ceph_mdsc_put_request(req);
>  out:
>  	if (!err)
> -		ceph_init_inode_acls(d_inode(dentry), &acls);
> +		ceph_init_inode_acls(d_inode(dentry), &as_ctx);
>  	else
>  		d_drop(dentry);
> -	ceph_release_acls_info(&acls);
> +	ceph_release_acl_sec_ctx(&as_ctx);
>  	return err;
>  }
>  
> @@ -927,7 +927,7 @@ static int ceph_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
>  	struct ceph_fs_client *fsc = ceph_sb_to_client(dir->i_sb);
>  	struct ceph_mds_client *mdsc = fsc->mdsc;
>  	struct ceph_mds_request *req;
> -	struct ceph_acls_info acls = {};
> +	struct ceph_acl_sec_ctx as_ctx = {};
>  	int err = -EROFS;
>  	int op;
>  
> @@ -950,7 +950,7 @@ static int ceph_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
>  	}
>  
>  	mode |= S_IFDIR;
> -	err = ceph_pre_init_acls(dir, &mode, &acls);
> +	err = ceph_pre_init_acls(dir, &mode, &as_ctx);
>  	if (err < 0)
>  		goto out;
>  
> @@ -967,9 +967,9 @@ static int ceph_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
>  	req->r_args.mkdir.mode = cpu_to_le32(mode);
>  	req->r_dentry_drop = CEPH_CAP_FILE_SHARED | CEPH_CAP_AUTH_EXCL;
>  	req->r_dentry_unless = CEPH_CAP_FILE_EXCL;
> -	if (acls.pagelist) {
> -		req->r_pagelist = acls.pagelist;
> -		acls.pagelist = NULL;
> +	if (as_ctx.pagelist) {
> +		req->r_pagelist = as_ctx.pagelist;
> +		as_ctx.pagelist = NULL;
>  	}
>  	err = ceph_mdsc_do_request(mdsc, dir, req);
>  	if (!err &&
> @@ -979,10 +979,10 @@ static int ceph_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
>  	ceph_mdsc_put_request(req);
>  out:
>  	if (!err)
> -		ceph_init_inode_acls(d_inode(dentry), &acls);
> +		ceph_init_inode_acls(d_inode(dentry), &as_ctx);
>  	else
>  		d_drop(dentry);
> -	ceph_release_acls_info(&acls);
> +	ceph_release_acl_sec_ctx(&as_ctx);
>  	return err;
>  }
>  
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index b7be02dfb897..5975345753d7 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -436,7 +436,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
>  	struct ceph_mds_client *mdsc = fsc->mdsc;
>  	struct ceph_mds_request *req;
>  	struct dentry *dn;
> -	struct ceph_acls_info acls = {};
> +	struct ceph_acl_sec_ctx as_ctx = {};
>  	int mask;
>  	int err;
>  
> @@ -450,7 +450,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
>  	if (flags & O_CREAT) {
>  		if (ceph_quota_is_max_files_exceeded(dir))
>  			return -EDQUOT;
> -		err = ceph_pre_init_acls(dir, &mode, &acls);
> +		err = ceph_pre_init_acls(dir, &mode, &as_ctx);
>  		if (err < 0)
>  			return err;
>  	}
> @@ -459,16 +459,16 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
>  	req = prepare_open_request(dir->i_sb, flags, mode);
>  	if (IS_ERR(req)) {
>  		err = PTR_ERR(req);
> -		goto out_acl;
> +		goto out_ctx;
>  	}
>  	req->r_dentry = dget(dentry);
>  	req->r_num_caps = 2;
>  	if (flags & O_CREAT) {
>  		req->r_dentry_drop = CEPH_CAP_FILE_SHARED | CEPH_CAP_AUTH_EXCL;
>  		req->r_dentry_unless = CEPH_CAP_FILE_EXCL;
> -		if (acls.pagelist) {
> -			req->r_pagelist = acls.pagelist;
> -			acls.pagelist = NULL;
> +		if (as_ctx.pagelist) {
> +			req->r_pagelist = as_ctx.pagelist;
> +			as_ctx.pagelist = NULL;
>  		}
>  	}
>  
> @@ -506,7 +506,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
>  	} else {
>  		dout("atomic_open finish_open on dn %p\n", dn);
>  		if (req->r_op == CEPH_MDS_OP_CREATE && req->r_reply_info.has_create_ino) {
> -			ceph_init_inode_acls(d_inode(dentry), &acls);
> +			ceph_init_inode_acls(d_inode(dentry), &as_ctx);
>  			file->f_mode |= FMODE_CREATED;
>  		}
>  		err = finish_open(file, dentry, ceph_open);
> @@ -515,8 +515,8 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
>  	if (!req->r_err && req->r_target_inode)
>  		ceph_put_fmode(ceph_inode(req->r_target_inode), req->r_fmode);
>  	ceph_mdsc_put_request(req);
> -out_acl:
> -	ceph_release_acls_info(&acls);
> +out_ctx:
> +	ceph_release_acl_sec_ctx(&as_ctx);
>  	dout("atomic_open result=%d\n", err);
>  	return err;
>  }
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index e74867743e07..d7520ccf27e9 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -928,6 +928,14 @@ extern void __ceph_build_xattrs_blob(struct ceph_inode_info *ci);
>  extern void __ceph_destroy_xattrs(struct ceph_inode_info *ci);
>  extern const struct xattr_handler *ceph_xattr_handlers[];
>  
> +struct ceph_acl_sec_ctx {
> +#ifdef CONFIG_CEPH_FS_POSIX_ACL
> +	void *default_acl;
> +	void *acl;
> +#endif
> +	struct ceph_pagelist *pagelist;
> +};
> +
>  #ifdef CONFIG_SECURITY
>  extern bool ceph_security_xattr_deadlock(struct inode *in);
>  extern bool ceph_security_xattr_wanted(struct inode *in);
> @@ -942,21 +950,17 @@ static inline bool ceph_security_xattr_wanted(struct inode *in)
>  }
>  #endif
>  
> -/* acl.c */
> -struct ceph_acls_info {
> -	void *default_acl;
> -	void *acl;
> -	struct ceph_pagelist *pagelist;
> -};
> +void ceph_release_acl_sec_ctx(struct ceph_acl_sec_ctx *as_ctx);
>  
> +/* acl.c */
>  #ifdef CONFIG_CEPH_FS_POSIX_ACL
>  
>  struct posix_acl *ceph_get_acl(struct inode *, int);
>  int ceph_set_acl(struct inode *inode, struct posix_acl *acl, int type);
>  int ceph_pre_init_acls(struct inode *dir, umode_t *mode,
> -		       struct ceph_acls_info *info);
> -void ceph_init_inode_acls(struct inode *inode, struct ceph_acls_info *info);
> -void ceph_release_acls_info(struct ceph_acls_info *info);
> +		       struct ceph_acl_sec_ctx *as_ctx);
> +void ceph_init_inode_acls(struct inode *inode,
> +			  struct ceph_acl_sec_ctx *as_ctx);
>  
>  static inline void ceph_forget_all_cached_acls(struct inode *inode)
>  {
> @@ -969,15 +973,12 @@ static inline void ceph_forget_all_cached_acls(struct inode *inode)
>  #define ceph_set_acl NULL
>  
>  static inline int ceph_pre_init_acls(struct inode *dir, umode_t *mode,
> -				     struct ceph_acls_info *info)
> +				     struct ceph_acl_sec_ctx *as_ctx)
>  {
>  	return 0;
>  }
>  static inline void ceph_init_inode_acls(struct inode *inode,
> -					struct ceph_acls_info *info)
> -{
> -}
> -static inline void ceph_release_acls_info(struct ceph_acls_info *info)
> +					struct ceph_acl_sec_ctx *as_ctx)
>  {
>  }
>  static inline int ceph_acl_chmod(struct dentry *dentry, struct inode *inode)
> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> index 7eff619f7ac8..518a5beed58c 100644
> --- a/fs/ceph/xattr.c
> +++ b/fs/ceph/xattr.c
> @@ -1197,3 +1197,13 @@ bool ceph_security_xattr_deadlock(struct inode *in)
>  	return ret;
>  }
>  #endif
> +
> +void ceph_release_acl_sec_ctx(struct ceph_acl_sec_ctx *as_ctx)
> +{
> +#ifdef CONFIG_CEPH_FS_POSIX_ACL
> +	posix_acl_release(as_ctx->acl);
> +	posix_acl_release(as_ctx->default_acl);
> +#endif
> +	if (as_ctx->pagelist)
> +		ceph_pagelist_release(as_ctx->pagelist);
> +}

This is more than just a rename. You're also preparing this struct to
hold other info besides ACLs, which is fine, but it might be good to
point that out in the description.

Reviewed-by: Jeff Layton <jlayton@redhat.com>

