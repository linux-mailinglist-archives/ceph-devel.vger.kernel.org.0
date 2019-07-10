Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 918BC64BD3
	for <lists+ceph-devel@lfdr.de>; Wed, 10 Jul 2019 20:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727548AbfGJSDY (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 10 Jul 2019 14:03:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:41496 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727063AbfGJSDX (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 10 Jul 2019 14:03:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 17558AE91;
        Wed, 10 Jul 2019 18:03:22 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, zyan@redhat.com, idryomov@gmail.com,
        sage@redhat.com
Subject: Re: [PATCH 3/3] ceph: fix potential races in ceph_uninline_data
References: <20190710161154.26125-1-jlayton@kernel.org>
        <20190710161154.26125-4-jlayton@kernel.org>
Date:   Wed, 10 Jul 2019 19:03:21 +0100
In-Reply-To: <20190710161154.26125-4-jlayton@kernel.org> (Jeff Layton's
        message of "Wed, 10 Jul 2019 12:11:54 -0400")
Message-ID: <87k1cpdaxi.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Jeff Layton <jlayton@kernel.org> writes:

> The current code will do the uninlining but it relies on the caller to
> set the i_inline_version appropriately afterward. There are several
> potential races here.
>
> Protect against competing uninlining attempts by having the callers
> take the i_truncate_mutex and then have them update the version
> themselves before dropping it.
>
> Other callers can then re-check the i_inline_version after acquiring the
> mutex and if it has changed to CEPH_INLINE_NONE, they can just drop it
> and do nothing.
>
> Finally since we are doing a lockless check first in all cases, just
> move that into ceph_uninline_data as well, and have the callers call
> it unconditionally.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/addr.c | 33 ++++++++++++++++++++++++---------
>  fs/ceph/file.c | 18 ++++++------------
>  2 files changed, 30 insertions(+), 21 deletions(-)
>
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 5f1e2b6577fb..e9700c997d12 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -1541,11 +1541,9 @@ static vm_fault_t ceph_page_mkwrite(struct vm_fault *vmf)
>  
>  	ceph_block_sigs(&oldset);
>  
> -	if (ci->i_inline_version != CEPH_INLINE_NONE) {
> -		err = ceph_uninline_data(inode, off == 0 ? page : NULL);
> -		if (err < 0)
> -			goto out_free;
> -	}
> +	err = ceph_uninline_data(inode, off == 0 ? page : NULL);
> +	if (err < 0)
> +		goto out_free;
>  
>  	if (off + PAGE_SIZE <= size)
>  		len = PAGE_SIZE;
> @@ -1593,7 +1591,6 @@ static vm_fault_t ceph_page_mkwrite(struct vm_fault *vmf)
>  	    ci->i_inline_version != CEPH_INLINE_NONE) {
>  		int dirty;
>  		spin_lock(&ci->i_ceph_lock);
> -		ci->i_inline_version = CEPH_INLINE_NONE;
>  		dirty = __ceph_mark_dirty_caps(ci, CEPH_CAP_FILE_WR,
>  					       &prealloc_cf);
>  		spin_unlock(&ci->i_ceph_lock);
> @@ -1656,6 +1653,10 @@ void ceph_fill_inline_data(struct inode *inode, struct page *locked_page,
>  	}
>  }
>  
> +/*
> + * We borrow the i_truncate_mutex to serialize callers that may be racing to
> + * uninline the data.
> + */
>  int ceph_uninline_data(struct inode *inode, struct page *page)
>  {
>  	struct ceph_inode_info *ci = ceph_inode(inode);
> @@ -1665,15 +1666,23 @@ int ceph_uninline_data(struct inode *inode, struct page *page)
>  	int err = 0;
>  	bool from_pagecache = false;
>  
> -	spin_lock(&ci->i_ceph_lock);
> -	inline_version = ci->i_inline_version;
> -	spin_unlock(&ci->i_ceph_lock);
> +	/* Do a lockless check first -- paired with i_ceph_lock for changes */
> +	inline_version = READ_ONCE(ci->i_inline_version);
>  
>  	dout("uninline_data %p %llx.%llx inline_version %llu\n",
>  	     inode, ceph_vinop(inode), inline_version);
>  
>  	if (inline_version == 1 || /* initial version, no data */
>  	    inline_version == CEPH_INLINE_NONE)
> +		return 0;

We may need to do the unlock_page(page) before returning.

> + + mutex_lock(&ci->i_truncate_mutex); + + /* Double check the version
> after taking mutex */ + spin_lock(&ci->i_ceph_lock); + inline_version
> = ci->i_inline_version; + spin_unlock(&ci->i_ceph_lock); + if
> (inline_version == CEPH_INLINE_NONE) goto out;
>  
>  	if (page) {
> @@ -1770,11 +1779,17 @@ int ceph_uninline_data(struct inode *inode, struct page *page)
>  	err = ceph_osdc_start_request(&fsc->client->osdc, req, false);
>  	if (!err)
>  		err = ceph_osdc_wait_request(&fsc->client->osdc, req);
> +	if (!err) {
> +		spin_lock(&ci->i_ceph_lock);
> +		inline_version = CEPH_INLINE_NONE;

Shouldn't this be ci->i_inline_version = CEPH_INLINE_NONE ?  Or maybe
both since the dout() below uses inline_version.

Cheers,
-- 
Luis

> +		spin_unlock(&ci->i_ceph_lock);
> +	}
>  out_put:
>  	ceph_osdc_put_request(req);
>  	if (err == -ECANCELED)
>  		err = 0;
>  out:
> +	mutex_unlock(&ci->i_truncate_mutex);
>  	if (page) {
>  		unlock_page(page);
>  		if (from_pagecache)
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 7bb090fa99d3..3ff83135562c 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -1438,11 +1438,9 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
>  
>  	inode_inc_iversion_raw(inode);
>  
> -	if (ci->i_inline_version != CEPH_INLINE_NONE) {
> -		err = ceph_uninline_data(inode, NULL);
> -		if (err < 0)
> -			goto out;
> -	}
> +	err = ceph_uninline_data(inode, NULL);
> +	if (err < 0)
> +		goto out;
>  
>  	/* FIXME: not complete since it doesn't account for being at quota */
>  	if (ceph_osdmap_flag(&fsc->client->osdc, CEPH_OSDMAP_FULL)) {
> @@ -1513,7 +1511,6 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
>  		int dirty;
>  
>  		spin_lock(&ci->i_ceph_lock);
> -		ci->i_inline_version = CEPH_INLINE_NONE;
>  		dirty = __ceph_mark_dirty_caps(ci, CEPH_CAP_FILE_WR,
>  					       &prealloc_cf);
>  		spin_unlock(&ci->i_ceph_lock);
> @@ -1762,11 +1759,9 @@ static long ceph_fallocate(struct file *file, int mode,
>  		goto unlock;
>  	}
>  
> -	if (ci->i_inline_version != CEPH_INLINE_NONE) {
> -		ret = ceph_uninline_data(inode, NULL);
> -		if (ret < 0)
> -			goto unlock;
> -	}
> +	ret = ceph_uninline_data(inode, NULL);
> +	if (ret < 0)
> +		goto unlock;
>  
>  	size = i_size_read(inode);
>  
> @@ -1790,7 +1785,6 @@ static long ceph_fallocate(struct file *file, int mode,
>  
>  	if (!ret) {
>  		spin_lock(&ci->i_ceph_lock);
> -		ci->i_inline_version = CEPH_INLINE_NONE;
>  		dirty = __ceph_mark_dirty_caps(ci, CEPH_CAP_FILE_WR,
>  					       &prealloc_cf);
>  		spin_unlock(&ci->i_ceph_lock);
