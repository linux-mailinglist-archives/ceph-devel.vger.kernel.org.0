Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 925B930276D
	for <lists+ceph-devel@lfdr.de>; Mon, 25 Jan 2021 17:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730008AbhAYQEa (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 25 Jan 2021 11:04:30 -0500
Received: from mx2.suse.de ([195.135.220.15]:45060 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729969AbhAYQDd (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 25 Jan 2021 11:03:33 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id EDE8DAE52;
        Mon, 25 Jan 2021 16:02:51 +0000 (UTC)
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 0717047e;
        Mon, 25 Jan 2021 16:03:44 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH v4 16/17] ceph: create symlinks with encrypted and
 base64-encoded targets
References: <20210120182847.644850-1-jlayton@kernel.org>
        <20210120182847.644850-17-jlayton@kernel.org>
Date:   Mon, 25 Jan 2021 16:03:43 +0000
In-Reply-To: <20210120182847.644850-17-jlayton@kernel.org> (Jeff Layton's
        message of "Wed, 20 Jan 2021 13:28:46 -0500")
Message-ID: <87bldd57hc.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Jeff Layton <jlayton@kernel.org> writes:

> When creating symlinks in encrypted directories, encrypt and
> base64-encode the target with the new inode's key before sending to the
> MDS.
>
> When filling a symlinked inode, base64-decode it into a buffer that
> we'll keep in ci->i_symlink. When get_link is called, decrypt the buffer
> into a new one that will hang off i_link.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/dir.c   | 50 +++++++++++++++++++++++---
>  fs/ceph/inode.c | 95 ++++++++++++++++++++++++++++++++++++++++++-------
>  2 files changed, 128 insertions(+), 17 deletions(-)
>
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index cb7ff91a243a..1721b70118b9 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -924,6 +924,40 @@ static int ceph_create(struct inode *dir, struct dentry *dentry, umode_t mode,
>  	return ceph_mknod(dir, dentry, mode, 0);
>  }
>  
> +#if IS_ENABLED(CONFIG_FS_ENCRYPTION)
> +static int prep_encrypted_symlink_target(struct ceph_mds_request *req, const char *dest)
> +{
> +	int err;
> +	int len = strlen(dest);
> +	struct fscrypt_str osd_link = FSTR_INIT(NULL, 0);
> +
> +	err = fscrypt_prepare_symlink(req->r_parent, dest, len, PATH_MAX, &osd_link);
> +	if (err)
> +		goto out;
> +
> +	err = fscrypt_encrypt_symlink(req->r_new_inode, dest, len, &osd_link);
> +	if (err)
> +		goto out;
> +
> +	req->r_path2 = kmalloc(FSCRYPT_BASE64_CHARS(osd_link.len), GFP_KERNEL);
> +	if (!req->r_path2) {
> +		err = -ENOMEM;
> +		goto out;
> +	}
> +
> +	len = fscrypt_base64_encode(osd_link.name, osd_link.len, req->r_path2);
> +	req->r_path2[len] = '\0';
> +out:
> +	fscrypt_fname_free_buffer(&osd_link);
> +	return err;
> +}
> +#else
> +static int prep_encrypted_symlink_target(struct ceph_mds_request *req, const char *dest)
> +{
> +	return -EOPNOTSUPP;
> +}
> +#endif
> +
>  static int ceph_symlink(struct inode *dir, struct dentry *dentry,
>  			    const char *dest)
>  {
> @@ -955,12 +989,18 @@ static int ceph_symlink(struct inode *dir, struct dentry *dentry,
>  		goto out_req;
>  	}
>  
> -	req->r_path2 = kstrdup(dest, GFP_KERNEL);
> -	if (!req->r_path2) {
> -		err = -ENOMEM;
> -		goto out_req;
> -	}
>  	req->r_parent = dir;
> +
> +	if (IS_ENCRYPTED(req->r_new_inode)) {
> +		err = prep_encrypted_symlink_target(req, dest);

nit: missing the error handling for this branch.

Cheers,
-- 
Luis

> 
> +	} else {
> +		req->r_path2 = kstrdup(dest, GFP_KERNEL);
> +		if (!req->r_path2) {
> +			err = -ENOMEM;
> +			goto out_req;
> +		}
> +	}
> +
>  	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
>  	req->r_dentry = dget(dentry);
>  	req->r_num_caps = 2;
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 063e492ab1da..cb8205d12607 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -35,6 +35,7 @@
>   */
>  
>  static const struct inode_operations ceph_symlink_iops;
> +static const struct inode_operations ceph_encrypted_symlink_iops;
>  
>  static void ceph_inode_work(struct work_struct *work);
>  
> @@ -602,6 +603,7 @@ void ceph_free_inode(struct inode *inode)
>  	struct ceph_inode_info *ci = ceph_inode(inode);
>  
>  	kfree(ci->i_symlink);
> +	fscrypt_free_inode(inode);
>  	kmem_cache_free(ceph_inode_cachep, ci);
>  }
>  
> @@ -801,6 +803,33 @@ void ceph_fill_file_time(struct inode *inode, int issued,
>  		     inode, time_warp_seq, ci->i_time_warp_seq);
>  }
>  
> +#if IS_ENABLED(CONFIG_FS_ENCRYPTION)
> +static int decode_encrypted_symlink(const char *encsym, int enclen, u8 **decsym)
> +{
> +	int declen;
> +	u8 *sym;
> +
> +	sym = kmalloc(enclen + 1, GFP_NOFS);
> +	if (!sym)
> +		return -ENOMEM;
> +
> +	declen = fscrypt_base64_decode(encsym, enclen, sym);
> +	if (declen < 0) {
> +		pr_err("%s: can't decode symlink (%d). Content: %.*s\n", __func__, declen, enclen, encsym);
> +		kfree(sym);
> +		return -EIO;
> +	}
> +	sym[declen + 1] = '\0';
> +	*decsym = sym;
> +	return declen;
> +}
> +#else
> +static int decode_encrypted_symlink(const char *encsym, int symlen, u8 **decsym)
> +{
> +	return -EOPNOTSUPP;
> +}
> +#endif
> +
>  /*
>   * Populate an inode based on info from mds.  May be called on new or
>   * existing inodes.
> @@ -1005,26 +1034,39 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
>  		inode->i_fop = &ceph_file_fops;
>  		break;
>  	case S_IFLNK:
> -		inode->i_op = &ceph_symlink_iops;
>  		if (!ci->i_symlink) {
>  			u32 symlen = iinfo->symlink_len;
>  			char *sym;
>  
>  			spin_unlock(&ci->i_ceph_lock);
>  
> -			if (symlen != i_size_read(inode)) {
> -				pr_err("%s %llx.%llx BAD symlink "
> -					"size %lld\n", __func__,
> -					ceph_vinop(inode),
> -					i_size_read(inode));
> +			if (IS_ENCRYPTED(inode)) {
> +				if (symlen != i_size_read(inode))
> +					pr_err("%s %llx.%llx BAD symlink size %lld\n",
> +						__func__, ceph_vinop(inode), i_size_read(inode));
> +
> +				err = decode_encrypted_symlink(iinfo->symlink, symlen, (u8 **)&sym);
> +				if (err < 0) {
> +					pr_err("%s decoding encrypted symlink failed: %d\n",
> +						__func__, err);
> +					goto out;
> +				}
> +				symlen = err;
>  				i_size_write(inode, symlen);
>  				inode->i_blocks = calc_inode_blocks(symlen);
> -			}
> +			} else {
> +				if (symlen != i_size_read(inode)) {
> +					pr_err("%s %llx.%llx BAD symlink size %lld\n",
> +						__func__, ceph_vinop(inode), i_size_read(inode));
> +					i_size_write(inode, symlen);
> +					inode->i_blocks = calc_inode_blocks(symlen);
> +				}
>  
> -			err = -ENOMEM;
> -			sym = kstrndup(iinfo->symlink, symlen, GFP_NOFS);
> -			if (!sym)
> -				goto out;
> +				err = -ENOMEM;
> +				sym = kstrndup(iinfo->symlink, symlen, GFP_NOFS);
> +				if (!sym)
> +					goto out;
> +			}
>  
>  			spin_lock(&ci->i_ceph_lock);
>  			if (!ci->i_symlink)
> @@ -1032,7 +1074,18 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
>  			else
>  				kfree(sym); /* lost a race */
>  		}
> -		inode->i_link = ci->i_symlink;
> +
> +		if (IS_ENCRYPTED(inode)) {
> +			/*
> +			 * Encrypted symlinks need to be decrypted before we can
> +			 * cache their targets in i_link. Leave it blank for now.
> +			 */
> +			inode->i_link = NULL;
> +			inode->i_op = &ceph_encrypted_symlink_iops;
> +		} else {
> +			inode->i_link = ci->i_symlink;
> +			inode->i_op = &ceph_symlink_iops;
> +		}
>  		break;
>  	case S_IFDIR:
>  		inode->i_op = &ceph_dir_iops;
> @@ -2103,6 +2156,17 @@ static void ceph_inode_work(struct work_struct *work)
>  	iput(inode);
>  }
>  
> +static const char *ceph_encrypted_get_link(struct dentry *dentry, struct inode *inode,
> +					   struct delayed_call *done)
> +{
> +	struct ceph_inode_info *ci = ceph_inode(inode);
> +
> +	if (!dentry)
> +		return ERR_PTR(-ECHILD);
> +
> +	return fscrypt_get_symlink(inode, ci->i_symlink, i_size_read(inode), done);
> +}
> +
>  /*
>   * symlinks
>   */
> @@ -2113,6 +2177,13 @@ static const struct inode_operations ceph_symlink_iops = {
>  	.listxattr = ceph_listxattr,
>  };
>  
> +static const struct inode_operations ceph_encrypted_symlink_iops = {
> +	.get_link = ceph_encrypted_get_link,
> +	.setattr = ceph_setattr,
> +	.getattr = ceph_getattr,
> +	.listxattr = ceph_listxattr,
> +};
> +
>  int __ceph_setattr(struct inode *inode, struct iattr *attr)
>  {
>  	struct ceph_inode_info *ci = ceph_inode(inode);
> -- 
>
> 2.29.2
>
