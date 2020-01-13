Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B15C91391F6
	for <lists+ceph-devel@lfdr.de>; Mon, 13 Jan 2020 14:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbgAMNQ7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 13 Jan 2020 08:16:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:58128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726074AbgAMNQ7 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 13 Jan 2020 08:16:59 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D8C92081E;
        Mon, 13 Jan 2020 13:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578921417;
        bh=GGSMBKmAbtanSszS8zeQf8o4qwBgZrKkGqr25wbds8A=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=TGEj5O0GHcFM72ztxSO9ZCI6V7EtwLxo89J0nvQXBYZhHps2tYLo06L19/0nP0bVX
         Wo2IglW7zcnMpdE5sfuFDsaJW1J69L1I7DV1oVkdt/8i0LbW6vUeD519SIObhmUt5T
         TZv1CfBl+XGITOUI6vWNIZDOPSGTNS5IG71n8jOs=
Message-ID: <8e6b6139baf16153d97bf0a033cb75b3af562482.camel@kernel.org>
Subject: Re: [RFC PATCH 9/9] ceph: attempt to do async create when possible
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>, ceph-devel@vger.kernel.org
Cc:     zyan@redhat.com, sage@redhat.com, idryomov@gmail.com,
        pdonnell@redhat.com
Date:   Mon, 13 Jan 2020 08:16:55 -0500
In-Reply-To: <27d846ea-ddd6-7b2e-f761-96457bbbdb14@redhat.com>
References: <20200110205647.311023-1-jlayton@kernel.org>
         <20200110205647.311023-10-jlayton@kernel.org>
         <27d846ea-ddd6-7b2e-f761-96457bbbdb14@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2020-01-13 at 09:43 +0800, Xiubo Li wrote:
> On 2020/1/11 4:56, Jeff Layton wrote:
> > With the Octopus release, the MDS will hand out directoy create caps.
> > If we have Fxc caps on the directory, and complete directory information
> > or a known negative dentry, then we can return without waiting on the
> > reply, allowing the open() call to return very quickly to userland.
> > 
> > We use the normal ceph_fill_inode() routine to fill in the inode, so we
> > have to gin up some reply inode information with what we'd expect a
> > newly-created inode to have. The client assumes that it has a full set
> > of caps on the new inode, and that the MDS will revoke them when there
> > is conflicting access.
> > 
> > This functionality is gated on the enable_async_dirops module option,
> > along with async unlinks, and on the server supporting the Octopus
> > CephFS feature bit.
> > 
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >   fs/ceph/caps.c               |   7 +-
> >   fs/ceph/file.c               | 178 +++++++++++++++++++++++++++++++++--
> >   fs/ceph/mds_client.c         |  12 ++-
> >   fs/ceph/mds_client.h         |   3 +-
> >   fs/ceph/super.h              |   2 +
> >   include/linux/ceph/ceph_fs.h |   8 +-
> >   6 files changed, 191 insertions(+), 19 deletions(-)
> > 
> > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > index b96fb1378479..21a8a2ddc94b 100644
> > --- a/fs/ceph/caps.c
> > +++ b/fs/ceph/caps.c
> > @@ -654,6 +654,10 @@ void ceph_add_cap(struct inode *inode,
> >   		session->s_nr_caps++;
> >   		spin_unlock(&session->s_cap_lock);
> >   	} else {
> > +		/* Did an async create race with the reply? */
> > +		if (cap_id == CEPH_CAP_ID_TBD && cap->issued == issued)
> > +			return;
> > +
> >   		spin_lock(&session->s_cap_lock);
> >   		list_move_tail(&cap->session_caps, &session->s_caps);
> >   		spin_unlock(&session->s_cap_lock);
> > @@ -672,7 +676,8 @@ void ceph_add_cap(struct inode *inode,
> >   		 */
> >   		if (ceph_seq_cmp(seq, cap->seq) <= 0) {
> >   			WARN_ON(cap != ci->i_auth_cap);
> > -			WARN_ON(cap->cap_id != cap_id);
> > +			WARN_ON(cap_id != CEPH_CAP_ID_TBD &&
> > +				cap->cap_id != cap_id);
> >   			seq = cap->seq;
> >   			mseq = cap->mseq;
> >   			issued |= cap->issued;
> > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > index d4d7a277faf1..706abd71b731 100644
> > --- a/fs/ceph/file.c
> > +++ b/fs/ceph/file.c
> > @@ -450,6 +450,141 @@ copy_file_layout(struct inode *dst, struct inode *src)
> >   	spin_unlock(&cdst->i_ceph_lock);
> >   }
> >   
> > +static bool get_caps_for_async_create(struct inode *dir, struct dentry *dentry)
> > +{
> > +	struct ceph_inode_info *ci = ceph_inode(dir);
> > +	int ret, want, got;
> > +
> > +	/*
> > +	 * We can do an async create if we either have a valid negative dentry
> > +	 * or the complete contents of the directory. Do a quick check without
> > +	 * cap refs.
> > +	 */
> > +	if ((d_in_lookup(dentry) && !__ceph_dir_is_complete(ci)) ||
> > +	    !ceph_file_layout_is_valid(&ci->i_layout))
> > +		return false;
> > +
> > +	/* Try to get caps */
> > +	want = CEPH_CAP_FILE_EXCL | CEPH_CAP_DIR_CREATE;
> > +	ret = ceph_try_get_caps(dir, 0, want, true, &got);
> > +	dout("Fx on %p ret=%d got=%d\n", dir, ret, got);
> > +	if (ret != 1)
> > +		return false;
> > +	if (got != want) {
> > +		ceph_put_cap_refs(ci, got);
> > +		return false;
> > +	}
> > +
> > +	/* Check again, now that we hold cap refs */
> > +	if ((d_in_lookup(dentry) && !__ceph_dir_is_complete(ci)) ||
> > +	    !ceph_file_layout_is_valid(&ci->i_layout)) {
> > +		ceph_put_cap_refs(ci, got);
> > +		return false;
> > +	}
> > +
> > +	return true;
> > +}
> > +
> > +static void ceph_async_create_cb(struct ceph_mds_client *mdsc,
> > +                                 struct ceph_mds_request *req)
> > +{
> > +	/* If we never sent anything then nothing to clean up */
> > +	if (req->r_err == -ECHILD)
> > +		goto out;
> > +
> > +	mapping_set_error(req->r_parent->i_mapping, req->r_err);
> > +
> > +	if (req->r_target_inode) {
> > +		u64 ino = ceph_vino(req->r_target_inode).ino;
> > +
> > +		if (req->r_deleg_ino != ino)
> > +			pr_warn("%s: inode number mismatch! err=%d deleg_ino=0x%lx target=0x%llx\n",
> > +				__func__, req->r_err, req->r_deleg_ino, ino);
> > +		mapping_set_error(req->r_target_inode->i_mapping, req->r_err);
> > +	} else {
> > +		pr_warn("%s: no req->r_target_inode for 0x%lx\n", __func__,
> > +			req->r_deleg_ino);
> > +	}
> > +out:
> > +	ceph_put_cap_refs(ceph_inode(req->r_parent),
> > +			  CEPH_CAP_FILE_EXCL | CEPH_CAP_DIR_CREATE);
> > +}
> > +
> > +static int ceph_finish_async_open(struct inode *dir, struct dentry *dentry,
> > +				  struct file *file, umode_t mode,
> > +				  struct ceph_mds_request *req,
> > +				  struct ceph_acl_sec_ctx *as_ctx)
> > +{
> > +	int ret;
> > +	struct ceph_mds_reply_inode in = { };
> > +	struct ceph_mds_reply_info_in iinfo = { .in = &in };
> > +	struct ceph_inode_info *ci = ceph_inode(dir);
> > +	struct inode *inode;
> > +	struct timespec64 now;
> > +	struct ceph_vino vino = { .ino = req->r_deleg_ino,
> > +				  .snap = CEPH_NOSNAP };
> > +
> > +	ktime_get_real_ts64(&now);
> > +
> > +	inode = ceph_get_inode(dentry->d_sb, vino);
> > +	if (IS_ERR(inode))
> > +		return PTR_ERR(inode);
> > +
> > +	/* If we can't get a buffer, just carry on */
> > +	iinfo.xattr_data = kzalloc(4, GFP_NOFS);
> > +	if (iinfo.xattr_data)
> > +		iinfo.xattr_len = 4;
> > +
> > +	iinfo.inline_version = CEPH_INLINE_NONE;
> > +	iinfo.change_attr = 1;
> > +	ceph_encode_timespec64(&iinfo.btime, &now);
> > +
> > +	in.ino = cpu_to_le64(vino.ino);
> > +	in.snapid = cpu_to_le64(CEPH_NOSNAP);
> > +	in.version = cpu_to_le64(1);	// ???
> > +	in.cap.caps = in.cap.wanted = cpu_to_le32(CEPH_CAP_ALL_FILE);
> > +	in.cap.cap_id = cpu_to_le64(CEPH_CAP_ID_TBD);
> > +	in.cap.realm = cpu_to_le64(ci->i_snap_realm->ino);
> > +	in.cap.flags = CEPH_CAP_FLAG_AUTH;
> > +	in.ctime = in.mtime = in.atime = iinfo.btime;
> > +	in.mode = cpu_to_le32((u32)mode);
> > +	in.truncate_seq = cpu_to_le32(1);
> > +	in.truncate_size = cpu_to_le64(ci->i_truncate_size);
> > +	in.max_size = cpu_to_le64(ci->i_max_size);
> > +	in.xattr_version = cpu_to_le64(1);
> > +	in.uid = cpu_to_le32(from_kuid(&init_user_ns, current_fsuid()));
> > +	in.gid = cpu_to_le32(from_kgid(&init_user_ns, current_fsgid()));
> > +	in.nlink = cpu_to_le32(1);
> > +
> > +	ceph_file_layout_to_legacy(&ci->i_layout, &in.layout);
> > +
> > +	ret = ceph_fill_inode(inode, NULL, &iinfo, NULL, req->r_session,
> > +			      req->r_fmode, NULL);
> > +	if (ret) {
> > +		dout("%s failed to fill inode: %d\n", __func__, ret);
> > +		if (inode->i_state & I_NEW)
> > +			discard_new_inode(inode);
> > +	} else {
> > +		struct dentry *dn;
> > +
> > +		dout("%s d_adding new inode 0x%llx to 0x%lx/%s\n", __func__,
> > +			vino.ino, dir->i_ino, dentry->d_name.name);
> > +		ceph_dir_clear_ordered(dir);
> > +		ceph_init_inode_acls(inode, as_ctx);
> > +		if (inode->i_state & I_NEW)
> > +			unlock_new_inode(inode);
> > +		if (d_in_lookup(dentry) || d_really_is_negative(dentry)) {
> > +			if (!d_unhashed(dentry))
> > +				d_drop(dentry);
> > +			dn = d_splice_alias(inode, dentry);
> > +			WARN_ON_ONCE(dn && dn != dentry);
> > +		}
> > +		file->f_mode |= FMODE_CREATED;
> > +		ret = finish_open(file, dentry, ceph_open);
> > +	}
> > +	return ret;
> > +}
> > +
> >   /*
> >    * Do a lookup + open with a single request.  If we get a non-existent
> >    * file or symlink, return 1 so the VFS can retry.
> > @@ -462,6 +597,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
> >   	struct ceph_mds_request *req;
> >   	struct dentry *dn;
> >   	struct ceph_acl_sec_ctx as_ctx = {};
> > +	bool try_async = enable_async_dirops;
> >   	int mask;
> >   	int err;
> >   
> > @@ -486,6 +622,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
> >   		return -ENOENT;
> >   	}
> >   
> > +retry:
> >   	/* do the open */
> >   	req = prepare_open_request(dir->i_sb, flags, mode);
> >   	if (IS_ERR(req)) {
> > @@ -494,6 +631,12 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
> >   	}
> >   	req->r_dentry = dget(dentry);
> >   	req->r_num_caps = 2;
> > +	mask = CEPH_STAT_CAP_INODE | CEPH_CAP_AUTH_SHARED;
> > +	if (ceph_security_xattr_wanted(dir))
> > +		mask |= CEPH_CAP_XATTR_SHARED;
> > +	req->r_args.open.mask = cpu_to_le32(mask);
> > +	req->r_parent = dir;
> > +
> >   	if (flags & O_CREAT) {
> >   		req->r_dentry_drop = CEPH_CAP_FILE_SHARED | CEPH_CAP_AUTH_EXCL;
> >   		req->r_dentry_unless = CEPH_CAP_FILE_EXCL;
> > @@ -501,21 +644,37 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
> >   			req->r_pagelist = as_ctx.pagelist;
> >   			as_ctx.pagelist = NULL;
> >   		}
> > +		if (try_async && get_caps_for_async_create(dir, dentry)) {
> > +			set_bit(CEPH_MDS_R_DELEG_INO, &req->r_req_flags);
> > +			req->r_callback = ceph_async_create_cb;
> > +			err = ceph_mdsc_submit_request(mdsc, dir, req);
> > +			switch (err) {
> > +			case 0:
> > +				/* set up inode, dentry and return */
> > +				err = ceph_finish_async_open(dir, dentry, file,
> > +							mode, req, &as_ctx);
> > +				goto out_req;
> > +			case -ECHILD:
> > +				/* do a sync create */
> > +				try_async = false;
> > +				as_ctx.pagelist = req->r_pagelist;
> > +				req->r_pagelist = NULL;
> > +				ceph_mdsc_put_request(req);
> > +				goto retry;
> > +			default:
> > +				/* Hard error, give up */
> > +				goto out_req;
> > +			}
> > +		}
> >   	}
> >   
> > -       mask = CEPH_STAT_CAP_INODE | CEPH_CAP_AUTH_SHARED;
> > -       if (ceph_security_xattr_wanted(dir))
> > -               mask |= CEPH_CAP_XATTR_SHARED;
> > -       req->r_args.open.mask = cpu_to_le32(mask);
> > -
> > -	req->r_parent = dir;
> >   	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
> >   	err = ceph_mdsc_do_request(mdsc,
> >   				   (flags & (O_CREAT|O_TRUNC)) ? dir : NULL,
> >   				   req);
> >   	err = ceph_handle_snapdir(req, dentry, err);
> >   	if (err)
> > -		goto out_req;
> > +		goto out_fmode;
> >   
> >   	if ((flags & O_CREAT) && !req->r_reply_info.head->is_dentry)
> >   		err = ceph_handle_notrace_create(dir, dentry);
> > @@ -529,7 +688,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
> >   		dn = NULL;
> >   	}
> >   	if (err)
> > -		goto out_req;
> > +		goto out_fmode;
> >   	if (dn || d_really_is_negative(dentry) || d_is_symlink(dentry)) {
> >   		/* make vfs retry on splice, ENOENT, or symlink */
> >   		dout("atomic_open finish_no_open on dn %p\n", dn);
> > @@ -545,9 +704,10 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
> >   		}
> >   		err = finish_open(file, dentry, ceph_open);
> >   	}
> > -out_req:
> > +out_fmode:
> >   	if (!req->r_err && req->r_target_inode)
> >   		ceph_put_fmode(ceph_inode(req->r_target_inode), req->r_fmode);
> > +out_req:
> >   	ceph_mdsc_put_request(req);
> >   out_ctx:
> >   	ceph_release_acl_sec_ctx(&as_ctx);
> > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > index 9e7492b21b50..c76d6e7f8136 100644
> > --- a/fs/ceph/mds_client.c
> > +++ b/fs/ceph/mds_client.c
> > @@ -2620,14 +2620,16 @@ static int __prepare_send_request(struct ceph_mds_client *mdsc,
> >   		flags |= CEPH_MDS_FLAG_REPLAY;
> >   	if (req->r_parent)
> >   		flags |= CEPH_MDS_FLAG_WANT_DENTRY;
> > -	rhead->flags = cpu_to_le32(flags);
> > -	rhead->num_fwd = req->r_num_fwd;
> > -	rhead->num_retry = req->r_attempts - 1;
> > -	if (test_bit(CEPH_MDS_R_DELEG_INO, &req->r_req_flags))
> > +	if (test_bit(CEPH_MDS_R_DELEG_INO, &req->r_req_flags)) {
> >   		rhead->ino = cpu_to_le64(req->r_deleg_ino);
> > -	else
> > +		flags |= CEPH_MDS_FLAG_ASYNC;
> > +	} else {
> >   		rhead->ino = 0;
> > +	}
> >   
> > +	rhead->flags = cpu_to_le32(flags);
> > +	rhead->num_fwd = req->r_num_fwd;
> > +	rhead->num_retry = req->r_attempts - 1;
> >   	dout(" r_parent = %p\n", req->r_parent);
> >   	return 0;
> >   }
> > diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> > index e0b36be7c44f..49e6cd5a07a2 100644
> > --- a/fs/ceph/mds_client.h
> > +++ b/fs/ceph/mds_client.h
> > @@ -39,8 +39,7 @@ enum ceph_feature_type {
> >   	CEPHFS_FEATURE_REPLY_ENCODING,		\
> >   	CEPHFS_FEATURE_LAZY_CAP_WANTED,		\
> >   	CEPHFS_FEATURE_MULTI_RECONNECT,		\
> > -						\
> > -	CEPHFS_FEATURE_MAX,			\
> > +	CEPHFS_FEATURE_OCTOPUS,			\
> 
> We should always have the CEPHFS_FEATURE_MAX as the last element of the 
> array here, though the _MAX equals to _OCTOPUS and the _OCTOPUS will be 
> traversed twice when encoding. The _MAX here is just a guard bit when 
> counting the feature bits when encoding.
> 
> The change here should be:
> 
>          CEPHFS_FEATURE_REPLY_ENCODING,		\
>          CEPHFS_FEATURE_LAZY_CAP_WANTED,		\
>          CEPHFS_FEATURE_MULTI_RECONNECT,		\
> +       CEPHFS_FEATURE_OCTOPUS,			\
> 						\
>          CEPHFS_FEATURE_MAX,			\
> 
> Then we won't have to worry about the previous _FEATURE_ bits' order.
> 

Definitely. That was just me being sloppy. Also, it sounds like we may
need to have this on a separate bit from Octopus so this part may change
anyway.

> >   }
> >   #define CEPHFS_FEATURES_CLIENT_REQUIRED {}
> >   
> > diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> > index ec4d66d7c261..33e03fbba888 100644
> > --- a/fs/ceph/super.h
> > +++ b/fs/ceph/super.h
> > @@ -136,6 +136,8 @@ struct ceph_fs_client {
> >   #endif
> >   };
> >   
> > +/* Special placeholder value for a cap_id during an asynchronous create. */
> > +#define        CEPH_CAP_ID_TBD         -1ULL
> >   
> >   /*
> >    * File i/o capability.  This tracks shared state with the metadata
> > diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
> > index a099f60feb7b..b127563e21a1 100644
> > --- a/include/linux/ceph/ceph_fs.h
> > +++ b/include/linux/ceph/ceph_fs.h
> > @@ -444,8 +444,9 @@ union ceph_mds_request_args {
> >   	} __attribute__ ((packed)) lookupino;
> >   } __attribute__ ((packed));
> >   
> > -#define CEPH_MDS_FLAG_REPLAY        1  /* this is a replayed op */
> > -#define CEPH_MDS_FLAG_WANT_DENTRY   2  /* want dentry in reply */
> > +#define CEPH_MDS_FLAG_REPLAY		1  /* this is a replayed op */
> > +#define CEPH_MDS_FLAG_WANT_DENTRY	2  /* want dentry in reply */
> > +#define CEPH_MDS_FLAG_ASYNC		4  /* request is asynchronous */
> >   
> >   struct ceph_mds_request_head {
> >   	__le64 oldest_client_tid;
> > @@ -658,6 +659,9 @@ int ceph_flags_to_mode(int flags);
> >   #define CEPH_CAP_ANY      (CEPH_CAP_ANY_RD | CEPH_CAP_ANY_EXCL | \
> >   			   CEPH_CAP_ANY_FILE_WR | CEPH_CAP_FILE_LAZYIO | \
> >   			   CEPH_CAP_PIN)
> > +#define CEPH_CAP_ALL_FILE (CEPH_CAP_PIN | CEPH_CAP_ANY_SHARED | \
> > +			   CEPH_CAP_AUTH_EXCL | CEPH_CAP_XATTR_EXCL | \
> > +			   CEPH_CAP_ANY_FILE_RD | CEPH_CAP_ANY_FILE_WR)
> >   
> >   #define CEPH_CAP_LOCKS (CEPH_LOCK_IFILE | CEPH_LOCK_IAUTH | CEPH_LOCK_ILINK | \
> >   			CEPH_LOCK_IXATTR)
> 
> 

-- 
Jeff Layton <jlayton@kernel.org>

