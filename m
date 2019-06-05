Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4333F35FC4
	for <lists+ceph-devel@lfdr.de>; Wed,  5 Jun 2019 16:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728492AbfFEO7g (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 5 Jun 2019 10:59:36 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:36467 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726442AbfFEO7g (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 5 Jun 2019 10:59:36 -0400
Received: by mail-yw1-f68.google.com with SMTP id t126so456567ywf.3
        for <ceph-devel@vger.kernel.org>; Wed, 05 Jun 2019 07:59:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=r2dhvxrOM9oLOgBmZoe1bd4USvqhGkirw3pL1S1jay8=;
        b=f2OEPq4qnMCkc+XWcyu2q9RuV5dyLOBSxbpr1skPZDjyiYsfLB/3EaAcT/RczRfVGf
         6Gi9FFxBJnObyfusvn5jLKw8O5c49lylV7b2oXkEUajx/W6TyOPao1bvGyEw+7jaTxgm
         /lP/sw+GIXigFhZ87kUke+Ko1yakDLIrmNyMP3e7o5RRdmlFXnG0pKhcKgSUM1ENbxjI
         MBBHudB1gboG77nA6Wq9QDD9GXTJR0a0Eo3eqzn2siTgwHdu0s4fzC4oZyuKA76/tmEL
         Tljpq+DTDicYvb4vbrl7tIk3YKY9hHCDDxz0BR3SpcvRujHFC38UnqKnyRlRuQJitgF9
         /aXg==
X-Gm-Message-State: APjAAAWSiUZCcJWujmDIYTrluYvXt3JWdaua+sUxVdyBv80a/WF7m7tN
        W0Oi4U9Mq5mAe288YEOco7V4sA==
X-Google-Smtp-Source: APXvYqwCaupSRwzWki+aFJ08TvzNuu102DCRp/2O4lDEyK+2JQiWhBeBZfb6/aobBDeb1tkZBQwrEA==
X-Received: by 2002:a81:8982:: with SMTP id z124mr20232913ywf.322.1559746775473;
        Wed, 05 Jun 2019 07:59:35 -0700 (PDT)
Received: from tleilax.poochiereds.net (cpe-2606-A000-1100-37D-0-0-0-32F.dyn6.twc.com. [2606:a000:1100:37d::32f])
        by smtp.gmail.com with ESMTPSA id n62sm313212ywe.82.2019.06.05.07.59.34
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 05 Jun 2019 07:59:34 -0700 (PDT)
Message-ID: <71320d12612fbef74df6d1f94feb98e0a70992e6.camel@redhat.com>
Subject: Re: [PATCH V2] ceph: track and report error of async metadata
 operation
From:   Jeff Layton <jlayton@redhat.com>
To:     "Yan, Zheng" <zyan@redhat.com>, ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com
Date:   Wed, 05 Jun 2019 10:59:33 -0400
In-Reply-To: <20190605142717.10423-1-zyan@redhat.com>
References: <20190605142717.10423-1-zyan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2019-06-05 at 22:27 +0800, Yan, Zheng wrote:
> Use errseq_t to track and report errors of async metadata operations,
> similar to how kernel handles errors during writeback.
> 
> If any dirty caps or any unsafe request gets dropped during session
> eviction, record -EIO in corresponding inode's i_meta_err. The error
> will be reported by subsequent fsync,
> 
> Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
> ---
>  fs/ceph/caps.c       | 16 ++++++++++++++--
>  fs/ceph/file.c       |  6 ++++--
>  fs/ceph/inode.c      |  2 ++
>  fs/ceph/mds_client.c | 38 +++++++++++++++++++++++++-------------
>  fs/ceph/super.h      |  4 ++++
>  5 files changed, 49 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 50409d9fdc90..fd9ab97c7f4e 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -2244,6 +2244,7 @@ static int unsafe_request_wait(struct inode *inode)
>  
>  int ceph_fsync(struct file *file, loff_t start, loff_t end, int datasync)
>  {
> +	struct ceph_file_info *fi = file->private_data;
>  	struct inode *inode = file->f_mapping->host;
>  	struct ceph_inode_info *ci = ceph_inode(inode);
>  	u64 flush_tid;
> @@ -2253,11 +2254,11 @@ int ceph_fsync(struct file *file, loff_t start, loff_t end, int datasync)
>  	dout("fsync %p%s\n", inode, datasync ? " datasync" : "");
>  
>  	ret = file_write_and_wait_range(file, start, end);
> -	if (ret < 0)
> -		goto out;
>  
>  	if (datasync)
>  		goto out;
> +	if (ret < 0)
> +		goto check_meta_err;
>  
>  	dirty = try_flush_caps(inode, &flush_tid);
>  	dout("fsync dirty caps are %s\n", ceph_cap_string(dirty));
> @@ -2273,6 +2274,17 @@ int ceph_fsync(struct file *file, loff_t start, loff_t end, int datasync)
>  		ret = wait_event_interruptible(ci->i_cap_wq,
>  					caps_are_flushed(inode, flush_tid));
>  	}
> +
> +check_meta_err:
> +	if (errseq_check(&ci->i_meta_err, READ_ONCE(fi->meta_err))) {
> +		int err;
> +		spin_lock(&file->f_lock);
> +		err = errseq_check_and_advance(&ci->i_meta_err,
> +					       &fi->meta_err);
> +		spin_unlock(&file->f_lock);
> +		if (err)
> +			ret = err;
> +	}

Do we care which error takes precedence in the event that ret is non-
zero here? I tend to think not, but it may be worth a comment there that
i_meta_err taking precedence over i_wb_err is arbitrary and that we may
need to revisit that at some point in the future.

>  out:
>  	dout("fsync %p%s result=%d\n", inode, datasync ? " datasync" : "", ret);
>  	return ret;
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index a7080783fe20..2fe8ca7805f4 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -200,6 +200,7 @@ prepare_open_request(struct super_block *sb, int flags, int create_mode)
>  static int ceph_init_file_info(struct inode *inode, struct file *file,
>  					int fmode, bool isdir)
>  {
> +	struct ceph_inode_info *ci = ceph_inode(inode);
>  	struct ceph_file_info *fi;
>  
>  	dout("%s %p %p 0%o (%s)\n", __func__, inode, file,
> @@ -210,7 +211,7 @@ static int ceph_init_file_info(struct inode *inode, struct file *file,
>  		struct ceph_dir_file_info *dfi =
>  			kmem_cache_zalloc(ceph_dir_file_cachep, GFP_KERNEL);
>  		if (!dfi) {
> -			ceph_put_fmode(ceph_inode(inode), fmode); /* clean up */
> +			ceph_put_fmode(ci, fmode); /* clean up */
>  			return -ENOMEM;
>  		}
>  
> @@ -221,7 +222,7 @@ static int ceph_init_file_info(struct inode *inode, struct file *file,
>  	} else {
>  		fi = kmem_cache_zalloc(ceph_file_cachep, GFP_KERNEL);
>  		if (!fi) {
> -			ceph_put_fmode(ceph_inode(inode), fmode); /* clean up */
> +			ceph_put_fmode(ci, fmode); /* clean up */
>  			return -ENOMEM;
>  		}
>  
> @@ -231,6 +232,7 @@ static int ceph_init_file_info(struct inode *inode, struct file *file,
>  	fi->fmode = fmode;
>  	spin_lock_init(&fi->rw_contexts_lock);
>  	INIT_LIST_HEAD(&fi->rw_contexts);
> +	fi->meta_err = errseq_sample(&ci->i_meta_err);
>  
>  	return 0;
>  }
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 6003187dd39e..8c555734f8d5 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -512,6 +512,8 @@ struct inode *ceph_alloc_inode(struct super_block *sb)
>  
>  	ceph_fscache_inode_init(ci);
>  
> +	ci->i_meta_err = 0;
> +
>  	return &ci->vfs_inode;
>  }
>  
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index c0a15e723f11..f2be9c74c3ae 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -1264,6 +1264,7 @@ static void cleanup_session_requests(struct ceph_mds_client *mdsc,
>  {
>  	struct ceph_mds_request *req;
>  	struct rb_node *p;
> +	struct ceph_inode_info *ci;
>  
>  	dout("cleanup_session_requests mds%d\n", session->s_mds);
>  	mutex_lock(&mdsc->mutex);
> @@ -1272,6 +1273,14 @@ static void cleanup_session_requests(struct ceph_mds_client *mdsc,
>  				       struct ceph_mds_request, r_unsafe_item);
>  		pr_warn_ratelimited(" dropping unsafe request %llu\n",
>  				    req->r_tid);
> +		if (req->r_target_inode) {
> +			ci = ceph_inode(req->r_target_inode);
> +			errseq_set(&ci->i_meta_err, -EIO);
> +		}
> +		if (req->r_unsafe_dir) {
> +			ci = ceph_inode(req->r_unsafe_dir);
> +			errseq_set(&ci->i_meta_err, -EIO);
> +		}

Do we really want to set this on both inodes?

When we talk about async metadata operations here, we're really talking
about operations that change a directory's namespace. When those fail,
it's somewhat analogous to the situation on a blockdev-based filesystem
when writeback of an in-memory directory fails.

To quote the fsync(2) manpage:

       Calling  fsync() does not necessarily ensure that the
       entry in the directory containing the file  has  also
       reached disk.  For that an explicit fsync() on a file
       descriptor for the directory is also needed.

So if I'm doing namespace operations in a directory on a local fs, and
issue an fsync on that dir that fails, then I will probably need to
assume that previous namespace operations may have failed.

It's unlikely though that that filesystem would record a writeback error
in the dentry->d_inode that was the target of (e.g.) an unlink in that
case.

That's the behavior I think we'd want to shoot for here, so I'd just
record the error in the r_unsafe_dir inode.

>  		__unregister_request(mdsc, req);
>  	}
>  	/* zero r_attempts, so kick_requests() will re-send requests */
> @@ -1364,7 +1373,7 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
>  	struct ceph_fs_client *fsc = (struct ceph_fs_client *)arg;
>  	struct ceph_inode_info *ci = ceph_inode(inode);
>  	LIST_HEAD(to_remove);
> -	bool drop = false;
> +	bool dirty_dropped = false;
>  	bool invalidate = false;
>  
>  	dout("removing cap %p, ci is %p, inode is %p\n",
> @@ -1402,7 +1411,7 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
>  				inode, ceph_ino(inode));
>  			ci->i_dirty_caps = 0;
>  			list_del_init(&ci->i_dirty_item);
> -			drop = true;
> +			dirty_dropped = true;
>  		}
>  		if (!list_empty(&ci->i_flushing_item)) {
>  			pr_warn_ratelimited(
> @@ -1412,10 +1421,22 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
>  			ci->i_flushing_caps = 0;
>  			list_del_init(&ci->i_flushing_item);
>  			mdsc->num_cap_flushing--;
> -			drop = true;
> +			dirty_dropped = true;
>  		}
>  		spin_unlock(&mdsc->cap_dirty_lock);
>  
> +		if (dirty_dropped) {
> +			errseq_set(&ci->i_meta_err, -EIO);
> +
> +			if (ci->i_wrbuffer_ref_head == 0 &&
> +			    ci->i_wr_ref == 0 &&
> +			    ci->i_dirty_caps == 0 &&
> +			    ci->i_flushing_caps == 0) {
> +				ceph_put_snap_context(ci->i_head_snapc);
> +				ci->i_head_snapc = NULL;
> +			}
> +		}
> +
>  		if (atomic_read(&ci->i_filelock_ref) > 0) {
>  			/* make further file lock syscall return -EIO */
>  			ci->i_ceph_flags |= CEPH_I_ERROR_FILELOCK;
> @@ -1427,15 +1448,6 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
>  			list_add(&ci->i_prealloc_cap_flush->i_list, &to_remove);
>  			ci->i_prealloc_cap_flush = NULL;
>  		}
> -
> -               if (drop &&
> -                  ci->i_wrbuffer_ref_head == 0 &&
> -                  ci->i_wr_ref == 0 &&
> -                  ci->i_dirty_caps == 0 &&
> -                  ci->i_flushing_caps == 0) {
> -                      ceph_put_snap_context(ci->i_head_snapc);
> -                      ci->i_head_snapc = NULL;
> -               }
>  	}
>  	spin_unlock(&ci->i_ceph_lock);
>  	while (!list_empty(&to_remove)) {
> @@ -1449,7 +1461,7 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
>  	wake_up_all(&ci->i_cap_wq);
>  	if (invalidate)
>  		ceph_queue_invalidate(inode);
> -	if (drop)
> +	if (dirty_dropped)
>  		iput(inode);
>  	return 0;
>  }
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 98d2bafc2ee2..2e516d47052f 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -393,6 +393,8 @@ struct ceph_inode_info {
>  	struct fscache_cookie *fscache;
>  	u32 i_fscache_gen;
>  #endif
> +	errseq_t i_meta_err;
> +
>  	struct inode vfs_inode; /* at end */
>  };
>  
> @@ -701,6 +703,8 @@ struct ceph_file_info {
>  
>  	spinlock_t rw_contexts_lock;
>  	struct list_head rw_contexts;
> +
> +	errseq_t meta_err;
>  };
>  
>  struct ceph_dir_file_info {



