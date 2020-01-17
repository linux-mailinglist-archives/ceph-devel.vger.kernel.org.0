Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92BC9140AB2
	for <lists+ceph-devel@lfdr.de>; Fri, 17 Jan 2020 14:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727011AbgAQN2X (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 17 Jan 2020 08:28:23 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:34762 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726329AbgAQN2X (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 17 Jan 2020 08:28:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579267701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nn/fYvc2FGsW1G7Xlop7rfGHRCr7kkVWLQHXhSy8wnI=;
        b=XrYbEcwddwU0pjNbjInagzKhIeN5NMjNNVMCO5as922Se0YJfyaVRTNbfKNK7s3T3JUXeQ
        4q08BLElfn/7scuLrjz8iiVGZIoIv0zi64LZpVcT9bc3iyZbNx0yZwJDShhS+w0wc2J9qK
        J7nM4XD/OPlmtGvLhXgp65zt2TtnTvU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-U_ip5cEnPdCGygRSFWd5Ug-1; Fri, 17 Jan 2020 08:28:20 -0500
X-MC-Unique: U_ip5cEnPdCGygRSFWd5Ug-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8EF6E992C6;
        Fri, 17 Jan 2020 13:28:19 +0000 (UTC)
Received: from [10.72.12.24] (ovpn-12-24.pek2.redhat.com [10.72.12.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BD4D389E63;
        Fri, 17 Jan 2020 13:28:12 +0000 (UTC)
Subject: Re: [RFC PATCH v2 10/10] ceph: attempt to do async create when
 possible
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, pdonnell@redhat.com,
        xiubli@redhat.com
References: <20200115205912.38688-1-jlayton@kernel.org>
 <20200115205912.38688-11-jlayton@kernel.org>
From:   "Yan, Zheng" <zyan@redhat.com>
Message-ID: <05265520-30e8-1d88-c2f1-863308de31d1@redhat.com>
Date:   Fri, 17 Jan 2020 21:28:11 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200115205912.38688-11-jlayton@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 1/16/20 4:59 AM, Jeff Layton wrote:
> With the Octopus release, the MDS will hand out directory create caps.
> 
> If we have Fxc caps on the directory, and complete directory information
> or a known negative dentry, then we can return without waiting on the
> reply, allowing the open() call to return very quickly to userland.
> 
> We use the normal ceph_fill_inode() routine to fill in the inode, so we
> have to gin up some reply inode information with what we'd expect the
> newly-created inode to have. The client assumes that it has a full set
> of caps on the new inode, and that the MDS will revoke them when there
> is conflicting access.
> 
> This functionality is gated on the enable_async_dirops module option,
> along with async unlinks, and on the server supporting the necessary
> CephFS feature bit.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/file.c               | 196 +++++++++++++++++++++++++++++++++--
>   include/linux/ceph/ceph_fs.h |   3 +
>   2 files changed, 190 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index b44ccbc85fe4..2742417fa5ec 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -448,6 +448,169 @@ cache_file_layout(struct inode *dst, struct inode *src)
>   	spin_unlock(&cdst->i_ceph_lock);
>   }
>   
> +/*
> + * Try to set up an async create. We need caps, a file layout, and inode number,
> + * and either a lease on the dentry or complete dir info. If any of those
> + * criteria are not satisfied, then return false and the caller can go
> + * synchronous.
> + */
> +static bool try_prep_async_create(struct inode *dir, struct dentry *dentry,
> +				  struct ceph_file_layout *lo,
> +				  unsigned long *pino)
> +{
> +	struct ceph_inode_info *ci = ceph_inode(dir);
> +	bool ret = false;
> +	unsigned long ino;
> +
> +	spin_lock(&ci->i_ceph_lock);
> +	/* No auth cap means no chance for Dc caps */
> +	if (!ci->i_auth_cap)
> +		goto no_async;
> +
> +	/* Any delegated inos? */
> +	if (xa_empty(&ci->i_auth_cap->session->s_delegated_inos))
> +		goto no_async;
> +
> +	if (!ceph_file_layout_is_valid(&ci->i_cached_layout))
> +		goto no_async;
> +
> +	/* Use LOOKUP_RCU since we're under i_ceph_lock */
> +	if (!__ceph_dir_is_complete(ci) &&
> +	    !dentry_lease_is_valid(dentry, LOOKUP_RCU))
> +		goto no_async;

dentry_lease_is_valid() checks dentry lease. When directory inode has
Fsx caps, mds does not issue lease for individual dentry. Check here 
should be something like dir_lease_is_valid()

> +
> +	if (!(__ceph_caps_issued(ci, NULL) &
> +	      (CEPH_CAP_FILE_EXCL | CEPH_CAP_DIR_CREATE)))
> +		goto no_async;
> +
> +	ino = ceph_get_deleg_ino(ci->i_auth_cap->session);
> +	if (!ino)
> +		goto no_async;
> +
> +	*pino = ino;
> +	ceph_take_cap_refs(ci, CEPH_CAP_FILE_EXCL | CEPH_CAP_DIR_CREATE, false);
> +	memcpy(lo, &ci->i_cached_layout, sizeof(*lo));
> +	rcu_assign_pointer(lo->pool_ns,
> +			   ceph_try_get_string(ci->i_cached_layout.pool_ns));
> +	ret = true;
> +no_async:
> +	spin_unlock(&ci->i_ceph_lock);
> +	return ret;
> +}
> +
> +static void ceph_async_create_cb(struct ceph_mds_client *mdsc,
> +                                 struct ceph_mds_request *req)
> +{
> +	mapping_set_error(req->r_parent->i_mapping, req->r_err);
> +
> +	if (req->r_target_inode) {
> +		struct ceph_inode_info *ci = ceph_inode(req->r_target_inode);
> +		u64 ino = ceph_vino(req->r_target_inode).ino;
> +
> +		if (req->r_deleg_ino != ino)
> +			pr_warn("%s: inode number mismatch! err=%d deleg_ino=0x%lx target=0x%llx\n",
> +				__func__, req->r_err, req->r_deleg_ino, ino);
> +		mapping_set_error(req->r_target_inode->i_mapping, req->r_err);
> +
> +		spin_lock(&ci->i_ceph_lock);
> +		if (ci->i_ceph_flags & CEPH_I_ASYNC_CREATE) {
> +			ci->i_ceph_flags &= ~CEPH_I_ASYNC_CREATE;
> +			wake_up_bit(&ci->i_ceph_flags, CEPH_ASYNC_CREATE_BIT);
> +		}
> +		spin_unlock(&ci->i_ceph_lock);
> +	} else {
> +		pr_warn("%s: no req->r_target_inode for 0x%lx\n", __func__,
> +			req->r_deleg_ino);
> +	}
> +	ceph_put_cap_refs(ceph_inode(req->r_parent),
> +			  CEPH_CAP_FILE_EXCL | CEPH_CAP_DIR_CREATE);
> +}
> +
> +static int ceph_finish_async_create(struct inode *dir, struct dentry *dentry,
> +				    struct file *file, umode_t mode,
> +				    struct ceph_mds_request *req,
> +				    struct ceph_acl_sec_ctx *as_ctx,
> +				    struct ceph_file_layout *lo)
> +{
> +	int ret;
> +	char xattr_buf[4];
> +	struct ceph_mds_reply_inode in = { };
> +	struct ceph_mds_reply_info_in iinfo = { .in = &in };
> +	struct ceph_inode_info *ci = ceph_inode(dir);
> +	struct inode *inode;
> +	struct timespec64 now;
> +	struct ceph_vino vino = { .ino = req->r_deleg_ino,
> +				  .snap = CEPH_NOSNAP };
> +
> +	ktime_get_real_ts64(&now);
> +
> +	inode = ceph_get_inode(dentry->d_sb, vino);
> +	if (IS_ERR(inode))
> +		return PTR_ERR(inode);
> +
> +	iinfo.inline_version = CEPH_INLINE_NONE;
> +	iinfo.change_attr = 1;
> +	ceph_encode_timespec64(&iinfo.btime, &now);
> +
> +	iinfo.xattr_len = ARRAY_SIZE(xattr_buf);
> +	iinfo.xattr_data = xattr_buf;
> +	memset(iinfo.xattr_data, 0, iinfo.xattr_len);
> +
> +	in.ino = cpu_to_le64(vino.ino);
> +	in.snapid = cpu_to_le64(CEPH_NOSNAP);
> +	in.version = cpu_to_le64(1);	// ???
> +	in.cap.caps = in.cap.wanted = cpu_to_le32(CEPH_CAP_ALL_FILE);
> +	in.cap.cap_id = cpu_to_le64(1);
> +	in.cap.realm = cpu_to_le64(ci->i_snap_realm->ino);
> +	in.cap.flags = CEPH_CAP_FLAG_AUTH;
> +	in.ctime = in.mtime = in.atime = iinfo.btime;
> +	in.mode = cpu_to_le32((u32)mode);
> +	in.truncate_seq = cpu_to_le32(1);
> +	in.truncate_size = cpu_to_le64(-1ULL);
> +	in.xattr_version = cpu_to_le64(1);
> +	in.uid = cpu_to_le32(from_kuid(&init_user_ns, current_fsuid()));
> +	in.gid = cpu_to_le32(from_kgid(&init_user_ns, dir->i_mode & S_ISGID ?
> +				dir->i_gid : current_fsgid()));
> +	in.nlink = cpu_to_le32(1);
> +	in.max_size = cpu_to_le64(lo->stripe_unit);
> +
> +	ceph_file_layout_to_legacy(lo, &in.layout);
> +
> +	ret = ceph_fill_inode(inode, NULL, &iinfo, NULL, req->r_session,
> +			      req->r_fmode, NULL);
> +	if (ret) {
> +		dout("%s failed to fill inode: %d\n", __func__, ret);
> +		if (inode->i_state & I_NEW)
> +			discard_new_inode(inode);
> +	} else {
> +		struct dentry *dn;
> +
> +		dout("%s d_adding new inode 0x%llx to 0x%lx/%s\n", __func__,
> +			vino.ino, dir->i_ino, dentry->d_name.name);
> +		ceph_dir_clear_ordered(dir);
> +		ceph_init_inode_acls(inode, as_ctx);
> +		if (inode->i_state & I_NEW) {
> +			/*
> +			 * If it's not I_NEW, then someone created this before
> +			 * we got here. Assume the server is aware of it at
> +			 * that point and don't worry about setting
> +			 * CEPH_I_ASYNC_CREATE.
> +			 */
> +			ceph_inode(inode)->i_ceph_flags = CEPH_I_ASYNC_CREATE;
> +			unlock_new_inode(inode);
> +		}
> +		if (d_in_lookup(dentry) || d_really_is_negative(dentry)) {
> +			if (!d_unhashed(dentry))
> +				d_drop(dentry);
> +			dn = d_splice_alias(inode, dentry);
> +			WARN_ON_ONCE(dn && dn != dentry);
> +		}
> +		file->f_mode |= FMODE_CREATED;
> +		ret = finish_open(file, dentry, ceph_open);
> +	}
> +	return ret;
> +}
> +
>   /*
>    * Do a lookup + open with a single request.  If we get a non-existent
>    * file or symlink, return 1 so the VFS can retry.
> @@ -460,6 +623,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
>   	struct ceph_mds_request *req;
>   	struct dentry *dn;
>   	struct ceph_acl_sec_ctx as_ctx = {};
> +	bool try_async = enable_async_dirops;
>   	int mask;
>   	int err;
>   
> @@ -492,28 +656,41 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
>   	}
>   	req->r_dentry = dget(dentry);
>   	req->r_num_caps = 2;
> +	mask = CEPH_STAT_CAP_INODE | CEPH_CAP_AUTH_SHARED;
> +	if (ceph_security_xattr_wanted(dir))
> +		mask |= CEPH_CAP_XATTR_SHARED;
> +	req->r_args.open.mask = cpu_to_le32(mask);
> +	req->r_parent = dir;
> +
>   	if (flags & O_CREAT) {
> +		struct ceph_file_layout lo;
> +
>   		req->r_dentry_drop = CEPH_CAP_FILE_SHARED | CEPH_CAP_AUTH_EXCL;
>   		req->r_dentry_unless = CEPH_CAP_FILE_EXCL;
>   		if (as_ctx.pagelist) {
>   			req->r_pagelist = as_ctx.pagelist;
>   			as_ctx.pagelist = NULL;
>   		}
> +		if (try_async && try_prep_async_create(dir, dentry, &lo,
> +						       &req->r_deleg_ino)) {
> +			set_bit(CEPH_MDS_R_ASYNC, &req->r_req_flags);
> +			req->r_callback = ceph_async_create_cb;
> +			err = ceph_mdsc_submit_request(mdsc, dir, req);
> +			if (!err)
> +				err = ceph_finish_async_create(dir, dentry,
> +							file, mode, req,
> +							&as_ctx, &lo);
> +			goto out_req;
> +		}
>   	}
>   
> -       mask = CEPH_STAT_CAP_INODE | CEPH_CAP_AUTH_SHARED;
> -       if (ceph_security_xattr_wanted(dir))
> -               mask |= CEPH_CAP_XATTR_SHARED;
> -       req->r_args.open.mask = cpu_to_le32(mask);
> -
> -	req->r_parent = dir;
>   	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
>   	err = ceph_mdsc_do_request(mdsc,
>   				   (flags & (O_CREAT|O_TRUNC)) ? dir : NULL,
>   				   req);
>   	err = ceph_handle_snapdir(req, dentry, err);
>   	if (err)
> -		goto out_req;
> +		goto out_fmode;
>   
>   	if ((flags & O_CREAT) && !req->r_reply_info.head->is_dentry)
>   		err = ceph_handle_notrace_create(dir, dentry);
> @@ -527,7 +704,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
>   		dn = NULL;
>   	}
>   	if (err)
> -		goto out_req;
> +		goto out_fmode;
>   	if (dn || d_really_is_negative(dentry) || d_is_symlink(dentry)) {
>   		/* make vfs retry on splice, ENOENT, or symlink */
>   		dout("atomic_open finish_no_open on dn %p\n", dn);
> @@ -543,9 +720,10 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
>   		}
>   		err = finish_open(file, dentry, ceph_open);
>   	}
> -out_req:
> +out_fmode:
>   	if (!req->r_err && req->r_target_inode)
>   		ceph_put_fmode(ceph_inode(req->r_target_inode), req->r_fmode);
> +out_req:
>   	ceph_mdsc_put_request(req);
>   out_ctx:
>   	ceph_release_acl_sec_ctx(&as_ctx);
> diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
> index 91d09cf37649..e035c5194005 100644
> --- a/include/linux/ceph/ceph_fs.h
> +++ b/include/linux/ceph/ceph_fs.h
> @@ -659,6 +659,9 @@ int ceph_flags_to_mode(int flags);
>   #define CEPH_CAP_ANY      (CEPH_CAP_ANY_RD | CEPH_CAP_ANY_EXCL | \
>   			   CEPH_CAP_ANY_FILE_WR | CEPH_CAP_FILE_LAZYIO | \
>   			   CEPH_CAP_PIN)
> +#define CEPH_CAP_ALL_FILE (CEPH_CAP_PIN | CEPH_CAP_ANY_SHARED | \
> +			   CEPH_CAP_AUTH_EXCL | CEPH_CAP_XATTR_EXCL | \
> +			   CEPH_CAP_ANY_FILE_RD | CEPH_CAP_ANY_FILE_WR)
>   
>   #define CEPH_CAP_LOCKS (CEPH_LOCK_IFILE | CEPH_LOCK_IAUTH | CEPH_LOCK_ILINK | \
>   			CEPH_LOCK_IXATTR)
> 

