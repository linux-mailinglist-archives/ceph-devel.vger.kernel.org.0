Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 088A435E0A
	for <lists+ceph-devel@lfdr.de>; Wed,  5 Jun 2019 15:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728148AbfFENiQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 5 Jun 2019 09:38:16 -0400
Received: from mail-yb1-f193.google.com ([209.85.219.193]:38185 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728143AbfFENiO (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 5 Jun 2019 09:38:14 -0400
Received: by mail-yb1-f193.google.com with SMTP id x7so6768857ybg.5
        for <ceph-devel@vger.kernel.org>; Wed, 05 Jun 2019 06:38:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=wOZHwAW4ir0OCKxdImwFzvD5KbZVBVWGD3np/zHFPPY=;
        b=NYsE+LOFU66eGIqaflWFWs724pK4LDQffKpkFtTXExyvhrjFOtGtjm/a6MJaLhHbMr
         zu6E5DY+aAtXtR/URJmedBze0krND0GEAJeqxK111aFK5dbPlcQYeLPijukbOQ/05O3f
         UT5pEaHmily4cKJcTc3gLwpBB0gOuwW1W/nx2YGFwRdZHYxiV2hbhV6fM/xuufE2UDnb
         zLNWdtAgvwQbCemo1mt+n4gomBdD5LtxqiyIQYvXra4lbpm0dM4NHHEDBk+TDNmP417s
         DqRClU+e02uLlqSY65YL8turuOFGzmFjGNNMhMzQFXKcQR+2Gi0u3Hvd45miQsp6qwio
         gXnA==
X-Gm-Message-State: APjAAAW7zfAKmeCRLz1bffKHoX/6KFtz28ZwQPSpGkZMnOXVTLfvp543
        VVeCEJQuAjYtGTb5KFkBS1/xnQ==
X-Google-Smtp-Source: APXvYqzeI07sjNURkCDCjziBxfnTlC2ciDdr6Ep0BQv0HrjndnOUmbT7rnaxzK9jRCcivvdtIdaCAg==
X-Received: by 2002:a25:2f92:: with SMTP id v140mr4968654ybv.25.1559741893115;
        Wed, 05 Jun 2019 06:38:13 -0700 (PDT)
Received: from tleilax.poochiereds.net (cpe-2606-A000-1100-37D-0-0-0-32F.dyn6.twc.com. [2606:a000:1100:37d::32f])
        by smtp.gmail.com with ESMTPSA id h3sm5235430ywj.23.2019.06.05.06.38.11
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 05 Jun 2019 06:38:12 -0700 (PDT)
Message-ID: <4c01eaabedcf03080094892b2758e680c4913810.camel@redhat.com>
Subject: Re: [PATCH] ceph: track and report error of async metadata operation
From:   Jeff Layton <jlayton@redhat.com>
To:     "Yan, Zheng" <zyan@redhat.com>, ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com
Date:   Wed, 05 Jun 2019 09:38:10 -0400
In-Reply-To: <139c7113-aea2-47ad-7a7a-d000318d2bd4@redhat.com>
References: <20190605091143.11390-1-zyan@redhat.com>
         <7a64d6e146eeeec92c8b723c5a77a12cf7beb6e4.camel@redhat.com>
         <9d546a31-af4c-42c3-66ef-4f91934906d3@redhat.com>
         <430ac1a080d833c2b41b2a9e7dece7e96c02f653.camel@redhat.com>
         <139c7113-aea2-47ad-7a7a-d000318d2bd4@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2019-06-05 at 21:22 +0800, Yan, Zheng wrote:
> On 6/5/19 8:46 PM, Jeff Layton wrote:
> > On Wed, 2019-06-05 at 20:10 +0800, Yan, Zheng wrote:
> > > On 6/5/19 7:32 PM, Jeff Layton wrote:
> > > > On Wed, 2019-06-05 at 17:11 +0800, Yan, Zheng wrote:
> > > > > Use errseq_t to track and report errors of async metadata operations,
> > > > > similar to how kernel handles errors during writeback.
> > > > > 
> > > > > If any dirty caps or any unsafe request gets dropped during session
> > > > > eviction, record -EIO in corresponding inode's i_meta_err. The error
> > > > > will be reported by subsequent fsync,
> > > > > 
> > > > > Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
> > > > > ---
> > > > >    fs/ceph/caps.c       | 10 ++++++++++
> > > > >    fs/ceph/file.c       |  6 ++++--
> > > > >    fs/ceph/inode.c      |  2 ++
> > > > >    fs/ceph/mds_client.c | 38 +++++++++++++++++++++++++-------------
> > > > >    fs/ceph/super.h      |  4 ++++
> > > > >    5 files changed, 45 insertions(+), 15 deletions(-)
> > > > > 
> > > > > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > > > > index 50409d9fdc90..ba8c976634d4 100644
> > > > > --- a/fs/ceph/caps.c
> > > > > +++ b/fs/ceph/caps.c
> > > > > @@ -2273,6 +2273,16 @@ int ceph_fsync(struct file *file, loff_t start, loff_t end, int datasync)
> > > > >    		ret = wait_event_interruptible(ci->i_cap_wq,
> > > > >    					caps_are_flushed(inode, flush_tid));
> > > > >    	}
> > > > > +
> > > > > +	if (!ret) {
> > > > > +		struct ceph_file_info *fi = file->private_data;
> > > > > +		if (errseq_check(&ci->i_meta_err, READ_ONCE(fi->meta_err))) {
> > > > > +			spin_lock(&file->f_lock);
> > > > > +			ret = errseq_check_and_advance(&ci->i_meta_err,
> > > > > +						       &fi->meta_err);
> > > > > +			spin_unlock(&file->f_lock);
> > > > > +		}
> > > > > +	}
> > > > >    out:
> > > > >    	dout("fsync %p%s result=%d\n", inode, datasync ? " datasync" : "", ret);
> > > > >    	return ret;
> > > > > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > > > > index a7080783fe20..2fe8ca7805f4 100644
> > > > > --- a/fs/ceph/file.c
> > > > > +++ b/fs/ceph/file.c
> > > > > @@ -200,6 +200,7 @@ prepare_open_request(struct super_block *sb, int flags, int create_mode)
> > > > >    static int ceph_init_file_info(struct inode *inode, struct file *file,
> > > > >    					int fmode, bool isdir)
> > > > >    {
> > > > > +	struct ceph_inode_info *ci = ceph_inode(inode);
> > > > >    	struct ceph_file_info *fi;
> > > > >    
> > > > >    	dout("%s %p %p 0%o (%s)\n", __func__, inode, file,
> > > > > @@ -210,7 +211,7 @@ static int ceph_init_file_info(struct inode *inode, struct file *file,
> > > > >    		struct ceph_dir_file_info *dfi =
> > > > >    			kmem_cache_zalloc(ceph_dir_file_cachep, GFP_KERNEL);
> > > > >    		if (!dfi) {
> > > > > -			ceph_put_fmode(ceph_inode(inode), fmode); /* clean up */
> > > > > +			ceph_put_fmode(ci, fmode); /* clean up */
> > > > >    			return -ENOMEM;
> > > > >    		}
> > > > >    
> > > > > @@ -221,7 +222,7 @@ static int ceph_init_file_info(struct inode *inode, struct file *file,
> > > > >    	} else {
> > > > >    		fi = kmem_cache_zalloc(ceph_file_cachep, GFP_KERNEL);
> > > > >    		if (!fi) {
> > > > > -			ceph_put_fmode(ceph_inode(inode), fmode); /* clean up */
> > > > > +			ceph_put_fmode(ci, fmode); /* clean up */
> > > > >    			return -ENOMEM;
> > > > >    		}
> > > > >    
> > > > > @@ -231,6 +232,7 @@ static int ceph_init_file_info(struct inode *inode, struct file *file,
> > > > >    	fi->fmode = fmode;
> > > > >    	spin_lock_init(&fi->rw_contexts_lock);
> > > > >    	INIT_LIST_HEAD(&fi->rw_contexts);
> > > > > +	fi->meta_err = errseq_sample(&ci->i_meta_err);
> > > > >    
> > > > >    	return 0;
> > > > >    }
> > > > > diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> > > > > index 6003187dd39e..8c555734f8d5 100644
> > > > > --- a/fs/ceph/inode.c
> > > > > +++ b/fs/ceph/inode.c
> > > > > @@ -512,6 +512,8 @@ struct inode *ceph_alloc_inode(struct super_block *sb)
> > > > >    
> > > > >    	ceph_fscache_inode_init(ci);
> > > > >    
> > > > > +	ci->i_meta_err = 0;
> > > > > +
> > > > >    	return &ci->vfs_inode;
> > > > >    }
> > > > >    
> > > > > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > > > > index c0a15e723f11..f2be9c74c3ae 100644
> > > > > --- a/fs/ceph/mds_client.c
> > > > > +++ b/fs/ceph/mds_client.c
> > > > > @@ -1264,6 +1264,7 @@ static void cleanup_session_requests(struct ceph_mds_client *mdsc,
> > > > >    {
> > > > >    	struct ceph_mds_request *req;
> > > > >    	struct rb_node *p;
> > > > > +	struct ceph_inode_info *ci;
> > > > >    
> > > > >    	dout("cleanup_session_requests mds%d\n", session->s_mds);
> > > > >    	mutex_lock(&mdsc->mutex);
> > > > > @@ -1272,6 +1273,14 @@ static void cleanup_session_requests(struct ceph_mds_client *mdsc,
> > > > >    				       struct ceph_mds_request, r_unsafe_item);
> > > > >    		pr_warn_ratelimited(" dropping unsafe request %llu\n",
> > > > >    				    req->r_tid);
> > > > > +		if (req->r_target_inode) {
> > > > > +			ci = ceph_inode(req->r_target_inode);
> > > > > +			errseq_set(&ci->i_meta_err, -EIO);
> > > > > +		}
> > > > > +		if (req->r_unsafe_dir) {
> > > > > +			ci = ceph_inode(req->r_unsafe_dir);
> > > > > +			errseq_set(&ci->i_meta_err, -EIO);
> > > > > +		}
> > > > >    		__unregister_request(mdsc, req);
> > > > >    	}
> > > > >    	/* zero r_attempts, so kick_requests() will re-send requests */
> > > > > @@ -1364,7 +1373,7 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
> > > > >    	struct ceph_fs_client *fsc = (struct ceph_fs_client *)arg;
> > > > >    	struct ceph_inode_info *ci = ceph_inode(inode);
> > > > >    	LIST_HEAD(to_remove);
> > > > > -	bool drop = false;
> > > > > +	bool dirty_dropped = false;
> > > > >    	bool invalidate = false;
> > > > >    
> > > > >    	dout("removing cap %p, ci is %p, inode is %p\n",
> > > > > @@ -1402,7 +1411,7 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
> > > > >    				inode, ceph_ino(inode));
> > > > >    			ci->i_dirty_caps = 0;
> > > > >    			list_del_init(&ci->i_dirty_item);
> > > > > -			drop = true;
> > > > > +			dirty_dropped = true;
> > > > >    		}
> > > > >    		if (!list_empty(&ci->i_flushing_item)) {
> > > > >    			pr_warn_ratelimited(
> > > > > @@ -1412,10 +1421,22 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
> > > > >    			ci->i_flushing_caps = 0;
> > > > >    			list_del_init(&ci->i_flushing_item);
> > > > >    			mdsc->num_cap_flushing--;
> > > > > -			drop = true;
> > > > > +			dirty_dropped = true;
> > > > >    		}
> > > > >    		spin_unlock(&mdsc->cap_dirty_lock);
> > > > >    
> > > > > +		if (dirty_dropped) {
> > > > > +			errseq_set(&ci->i_meta_err, -EIO);
> > > > > +
> > > > > +			if (ci->i_wrbuffer_ref_head == 0 &&
> > > > > +			    ci->i_wr_ref == 0 &&
> > > > > +			    ci->i_dirty_caps == 0 &&
> > > > > +			    ci->i_flushing_caps == 0) {
> > > > > +				ceph_put_snap_context(ci->i_head_snapc);
> > > > > +				ci->i_head_snapc = NULL;
> > > > > +			}
> > > > > +		}
> > > > > +
> > > > >    		if (atomic_read(&ci->i_filelock_ref) > 0) {
> > > > >    			/* make further file lock syscall return -EIO */
> > > > >    			ci->i_ceph_flags |= CEPH_I_ERROR_FILELOCK;
> > > > > @@ -1427,15 +1448,6 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
> > > > >    			list_add(&ci->i_prealloc_cap_flush->i_list, &to_remove);
> > > > >    			ci->i_prealloc_cap_flush = NULL;
> > > > >    		}
> > > > > -
> > > > > -               if (drop &&
> > > > > -                  ci->i_wrbuffer_ref_head == 0 &&
> > > > > -                  ci->i_wr_ref == 0 &&
> > > > > -                  ci->i_dirty_caps == 0 &&
> > > > > -                  ci->i_flushing_caps == 0) {
> > > > > -                      ceph_put_snap_context(ci->i_head_snapc);
> > > > > -                      ci->i_head_snapc = NULL;
> > > > > -               }
> > > > >    	}
> > > > >    	spin_unlock(&ci->i_ceph_lock);
> > > > >    	while (!list_empty(&to_remove)) {
> > > > > @@ -1449,7 +1461,7 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
> > > > >    	wake_up_all(&ci->i_cap_wq);
> > > > >    	if (invalidate)
> > > > >    		ceph_queue_invalidate(inode);
> > > > > -	if (drop)
> > > > > +	if (dirty_dropped)
> > > > >    		iput(inode);
> > > > >    	return 0;
> > > > >    }
> > > > > diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> > > > > index 98d2bafc2ee2..2e516d47052f 100644
> > > > > --- a/fs/ceph/super.h
> > > > > +++ b/fs/ceph/super.h
> > > > > @@ -393,6 +393,8 @@ struct ceph_inode_info {
> > > > >    	struct fscache_cookie *fscache;
> > > > >    	u32 i_fscache_gen;
> > > > >    #endif
> > > > > +	errseq_t i_meta_err;
> > > > > +
> > > > >    	struct inode vfs_inode; /* at end */
> > > > >    };
> > > > >    
> > > > @@ -701,6 +703,8 @@ struct ceph_file_info {
> > > > >    
> > > > >    	spinlock_t rw_contexts_lock;
> > > > >    	struct list_head rw_contexts;
> > > > > +
> > > > > +	errseq_t meta_err;
> > > > >    };
> > > > >    
> > > > >    struct ceph_dir_file_info {
> > > > 
> > > > Do we need separate errseq_t's for this? Why not just record these
> > > > errors in the standard inode->i_mapping->wb_err field and use the normal
> > > > file_write_and_wait_range to report them?
> > > > 
> > > > Since you're reporting them at fsync time like you would any writeback
> > > > error, adding an extra set of errseq_t's for metadata errors doesn't
> > > > seem to add anything over using what's already there.
> > > > 
> > > 
> > > It makes difference for fdatasync() and sync_file_range(). If there is
> > > only metadata error, these two syscalls should not return error.
> > > 
> > > 
> > 
> > Will i_meta_err ever contain an error on a regular file?
> 
> Yes. -EIO is recorded in i_meta_err if any dirty caps get dropped.
> 
> > I had assumed
> > that this was mostly to track errors in parent directories for metadata
> > operations that involve child dentrie >
> > If we do need to do this, then I think you'll probably need a bit more
> > care in ceph_fsync. If you have an error in both i_wb_err and
> > i_meta_err, then you'll need two fsync() calls to clear it with this
> > patch.
> 
> Current code already does this. ceph_fsync() check i_meta_err only when 
> there is no other error.
> 

Which I think is wrong.

When fsync is called, the expectation is that a subsequent fsync should
only report an error if one occurred since the last fsync. If
file_write_and_wait_range returns an error, then you still need to
advance the meta_err cursor before returning from fsync().

> > I think you'd want to check and advance both cursors when fsync is
> > called, either error should be able to be reported though.
> > 


-- 
Jeff Layton <jlayton@redhat.com>

