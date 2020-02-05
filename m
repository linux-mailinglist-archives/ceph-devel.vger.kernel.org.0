Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79D8515352C
	for <lists+ceph-devel@lfdr.de>; Wed,  5 Feb 2020 17:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727081AbgBEQZC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 5 Feb 2020 11:25:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:40188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726534AbgBEQZC (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 5 Feb 2020 11:25:02 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 657E920730;
        Wed,  5 Feb 2020 16:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580919901;
        bh=j/6MjrDg1W0Z5Wc3giwLCD7oPNPUJi04gi2SPPlDXEs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=xu50jMjukJCS1doj+S9LrFVRDYCs0WzsonGVBP3cHWIwWxJr0GxtH6hpPL+EPoCa1
         IAt3+KZlVYfncqlTFJ7rvMgLefCUTZwCkHhlrJuky1nkrd9OdDlboqEpvVfqOsT1yO
         P7Grcvs1KdnFH+Uhon43ZRLBqO0dWgGM/Gwbg0cE=
Message-ID: <06b35b716c6f158360f2a21f00c3c1c0232562cc.camel@kernel.org>
Subject: Re: [RFC PATCH] ceph: serialize the direct writes when couldn't
 submit in a single req
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com, zyan@redhat.com
Cc:     sage@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Wed, 05 Feb 2020 11:24:59 -0500
In-Reply-To: <20200204015445.4435-1-xiubli@redhat.com>
References: <20200204015445.4435-1-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.3 (3.34.3-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2020-02-03 at 20:54 -0500, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> If the direct io couldn't be submit in a single request, for multiple
> writers, they may overlap each other.
> 
> For example, with the file layout:
> ceph.file.layout="stripe_unit=4194304 stripe_count=1 object_size=4194304
> 
> fd = open(, O_DIRECT | O_WRONLY, );
> 
> Writer1:
> posix_memalign(&buffer, 4194304, SIZE);
> memset(buffer, 'T', SIZE);
> write(fd, buffer, SIZE);
> 
> Writer2:
> posix_memalign(&buffer, 4194304, SIZE);
> memset(buffer, 'X', SIZE);
> write(fd, buffer, SIZE);
> 
> From the test result, the data in the file possiblly will be:
> TTT...TTT <---> object1
> XXX...XXX <---> object2
> 
> The expected result should be all "XX.." or "TT.." in both object1
> and object2.
> 

I really don't see this as broken. If you're using O_DIRECT, I don't
believe there is any expectation that the write operations (or even read
operations) will be atomic wrt to one another.

Basically, when you do this, you're saying "I know what I'm doing", and
need to provide synchronization yourself between competing applications
and clients (typically via file locking).


> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/file.c  | 38 +++++++++++++++++++++++++++++++++++---
>  fs/ceph/inode.c |  2 ++
>  fs/ceph/super.h |  3 +++
>  3 files changed, 40 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 1cedba452a66..2741070a58a9 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -961,6 +961,8 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
>  	loff_t pos = iocb->ki_pos;
>  	bool write = iov_iter_rw(iter) == WRITE;
>  	bool should_dirty = !write && iter_is_iovec(iter);
> +	bool shared_lock = false;
> +	u64 size;
>  
>  	if (write && ceph_snap(file_inode(file)) != CEPH_NOSNAP)
>  		return -EROFS;
> @@ -977,14 +979,27 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
>  			dout("invalidate_inode_pages2_range returned %d\n", ret2);
>  
>  		flags = /* CEPH_OSD_FLAG_ORDERSNAP | */ CEPH_OSD_FLAG_WRITE;
> +
> +		/*
> +		 * If we cannot submit the whole iter in a single request we
> +		 * should block all the requests followed to avoid the data
> +		 * being overlapped by each other.
> +		 *
> +		 * But for those which could be submit in an single request
> +		 * they could excute in parallel.
> +		 *
> +		 * Hold the exclusive lock first.
> +		 */
> +		down_write(&ci->i_direct_rwsem);
>  	} else {
>  		flags = CEPH_OSD_FLAG_READ;
>  	}
>  
>  	while (iov_iter_count(iter) > 0) {
> -		u64 size = iov_iter_count(iter);
>  		ssize_t len;
>  
> +		size = iov_iter_count(iter);
> +
>  		if (write)
>  			size = min_t(u64, size, fsc->mount_options->wsize);
>  		else
> @@ -1011,9 +1026,16 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
>  			ret = len;
>  			break;
>  		}
> +
>  		if (len != size)
>  			osd_req_op_extent_update(req, 0, len);
>  
> +		if (write && pos == iocb->ki_pos && len == count) {
> +			/* Switch to shared lock */
> +			downgrade_write(&ci->i_direct_rwsem);
> +			shared_lock = true;
> +		}
> +
>  		/*
>  		 * To simplify error handling, allow AIO when IO within i_size
>  		 * or IO can be satisfied by single OSD request.
> @@ -1110,7 +1132,7 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
>  
>  		if (aio_req->num_reqs == 0) {
>  			kfree(aio_req);
> -			return ret;
> +			goto unlock;
>  		}
>  
>  		ceph_get_cap_refs(ci, write ? CEPH_CAP_FILE_WR :
> @@ -1131,13 +1153,23 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
>  				ceph_aio_complete_req(req);
>  			}
>  		}
> -		return -EIOCBQUEUED;
> +		ret = -EIOCBQUEUED;
> +		goto unlock;
>  	}
>  
>  	if (ret != -EOLDSNAPC && pos > iocb->ki_pos) {
>  		ret = pos - iocb->ki_pos;
>  		iocb->ki_pos = pos;
>  	}
> +
> +unlock:
> +	if (write) {
> +		if (shared_lock)
> +			up_read(&ci->i_direct_rwsem);
> +		else
> +			up_write(&ci->i_direct_rwsem);
> +	}
> +
>  	return ret;
>  }
>  
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index aee7a24bf1bc..e5d634acd273 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -518,6 +518,8 @@ struct inode *ceph_alloc_inode(struct super_block *sb)
>  
>  	ceph_fscache_inode_init(ci);
>  
> +	init_rwsem(&ci->i_direct_rwsem);
> +
>  	ci->i_meta_err = 0;
>  
>  	return &ci->vfs_inode;
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index ee81920bb1a4..213c11bf41be 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -409,6 +409,9 @@ struct ceph_inode_info {
>  	struct fscache_cookie *fscache;
>  	u32 i_fscache_gen;
>  #endif
> +
> +	struct rw_semaphore i_direct_rwsem;
> +
>  	errseq_t i_meta_err;
>  
>  	struct inode vfs_inode; /* at end */

-- 
Jeff Layton <jlayton@kernel.org>

