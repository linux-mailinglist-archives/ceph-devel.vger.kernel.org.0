Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C17AF26C9B0
	for <lists+ceph-devel@lfdr.de>; Wed, 16 Sep 2020 21:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbgIPTQo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 16 Sep 2020 15:16:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:37096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727770AbgIPTQW (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 16 Sep 2020 15:16:22 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B84EC20738;
        Wed, 16 Sep 2020 19:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600283781;
        bh=GE+dIe/fbWeiy6DB34gLpxyfqpLWzl9aljdVnJxiYvg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lrhM9K2C9R2tluEU19vZ8wz8xR6zZC42NaT2dFn6zlQQb9JmMJE4R+tY3rux1OX0S
         45QkNDJDpDnxCMGSnMCh6WbCCsafMN9/W9Ng11VWDKUI8ZeKe3FGQzGEfJkMnE4rhh
         AFs4j1M1xb8em2xGXI5QjhvvbaMbLz6ssUXt9l+M=
Message-ID: <7817f98d3b2daafe113bf8290cc8c7adbb86fe99.camel@kernel.org>
Subject: Re: [PATCH 5/5] ceph: fold ceph_update_writeable_page into
 ceph_write_begin
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     ukernel@gmail.com, idryomov@gmail.com
Date:   Wed, 16 Sep 2020 15:16:19 -0400
In-Reply-To: <20200916173854.330265-6-jlayton@kernel.org>
References: <20200916173854.330265-1-jlayton@kernel.org>
         <20200916173854.330265-6-jlayton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2020-09-16 at 13:38 -0400, Jeff Layton wrote:
> ...and reorganize the loop for better clarity.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/addr.c | 148 ++++++++++++++++++++++---------------------------
>  1 file changed, 65 insertions(+), 83 deletions(-)
> 
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index a6c54cfc3fea..89c4d8a9a5eb 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -1251,6 +1251,8 @@ static int context_is_writeable_or_written(struct inode *inode,
>   * @inode: inode associated with page
>   * @page: page being dirtied
>   *
> + * We are only allowed to write into/dirty the page if the page is
> + * clean, or already dirty within the same snap context.
>   * Returns NULL on success, negative error code on error, and a snapc ref that should be
>   * waited on otherwise.
>   */
> @@ -1307,104 +1309,84 @@ ceph_find_incompatible(struct inode *inode, struct page *page)
>  /*
>   * We are only allowed to write into/dirty the page if the page is
>   * clean, or already dirty within the same snap context.
> - *
> - * called with page locked.
> - * return success with page locked,
> - * or any failure (incl -EAGAIN) with page unlocked.
>   */
> -static int ceph_update_writeable_page(struct file *file,
> -			    loff_t pos, unsigned len,
> -			    struct page *page)
> +static int ceph_write_begin(struct file *file, struct address_space *mapping,
> +			    loff_t pos, unsigned len, unsigned flags,
> +			    struct page **pagep, void **fsdata)
>  {
>  	struct inode *inode = file_inode(file);
>  	struct ceph_inode_info *ci = ceph_inode(inode);
>  	struct ceph_snap_context *snapc;
> -	loff_t page_off = pos & PAGE_MASK;
> +	struct page *page = NULL;
> +	pgoff_t index = pos >> PAGE_SHIFT;
>  	int pos_in_page = pos & ~PAGE_MASK;
> -	int end_in_page = pos_in_page + len;
> -	loff_t i_size;
> -	int r;
> +	int r = 0;
>  
> -retry_locked:
> -	snapc = ceph_find_incompatible(inode, page);
> -	if (snapc) {
> -		if (IS_ERR(snapc)) {
> -			r = PTR_ERR(snapc);
> -			goto fail_unlock;
> +	dout("write_begin file %p inode %p page %p %d~%d\n", file, inode, page, (int)pos, (int)len);
> +
> +	for (;;) {
> +		page = grab_cache_page_write_begin(mapping, index, 0);
> +		if (!page) {
> +			r = -ENOMEM;
> +			break;
>  		}
> -		unlock_page(page);
> -		ceph_queue_writeback(inode);
> -		r = wait_event_killable(ci->i_cap_wq,
> -					context_is_writeable_or_written(inode, snapc));
> -		ceph_put_snap_context(snapc);
> -		return -EAGAIN;
> -	}
>  
> -	if (PageUptodate(page)) {
> -		dout(" page %p already uptodate\n", page);
> -		return 0;
> -	}
> +		snapc = ceph_find_incompatible(inode, page);
> +		if (snapc) {
> +			if (IS_ERR(snapc)) {
> +				r = PTR_ERR(snapc);
> +				break;
> +			}
> +			unlock_page(page);
> +			ceph_queue_writeback(inode);
> +			r = wait_event_killable(ci->i_cap_wq,
> +						context_is_writeable_or_written(inode, snapc));
> +			ceph_put_snap_context(snapc);
> +			put_page(page);
> +			page = NULL;

Now that I look a bit more, there is probably no need to hold the page
reference across this wait. I'll change that to put it after unlocking
and re-test.

> +			if (r != 0)
> +				break;
> +			continue;
> +		}
>  
> -	/* full page? */
> -	if (pos_in_page == 0 && len == PAGE_SIZE)
> -		return 0;
> +		if (PageUptodate(page)) {
> +			dout(" page %p already uptodate\n", page);
> +			break;
> +		}
>  
> -	/* past end of file? */
> -	i_size = i_size_read(inode);
> -
> -	if (page_off >= i_size ||
> -	    (pos_in_page == 0 && (pos+len) >= i_size &&
> -	     end_in_page - pos_in_page != PAGE_SIZE)) {
> -		dout(" zeroing %p 0 - %d and %d - %d\n",
> -		     page, pos_in_page, end_in_page, (int)PAGE_SIZE);
> -		zero_user_segments(page,
> -				   0, pos_in_page,
> -				   end_in_page, PAGE_SIZE);
> -		return 0;
> -	}
> +		/*
> +		 * In some cases we don't need to read at all:
> +		 * - full page write
> +		 * - write that lies completely beyond EOF
> +		 * - write that covers the the page from start to EOF or beyond it
> +		 */
> +		if ((pos_in_page == 0 && len == PAGE_SIZE) ||
> +		    (pos >= i_size_read(inode)) ||
> +		    (pos_in_page == 0 && (pos + len) >= i_size_read(inode))) {
> +			zero_user_segments(page, 0, pos_in_page,
> +					   pos_in_page + len, PAGE_SIZE);
> +			break;
> +		}
>  
> -	/* we need to read it. */
> -	r = ceph_do_readpage(file, page);
> -	if (r < 0) {
> -		if (r == -EINPROGRESS)
> -			return -EAGAIN;
> -		goto fail_unlock;
> +		/*
> +		 * We need to read it. If we get back -EINPROGRESS, then the page was
> +		 * handed off to fscache and it will be unlocked when the read completes.
> +		 * Refind the page in that case so we can reacquire the page lock. Otherwise
> +		 * we got a hard error or the read was completed synchronously.
> +		 */
> +		r = ceph_do_readpage(file, page);
> +		if (r != -EINPROGRESS)
> +			break;
>  	}
> -	goto retry_locked;
> -fail_unlock:
> -	unlock_page(page);
> -	return r;
> -}
>  
> -/*
> - * We are only allowed to write into/dirty the page if the page is
> - * clean, or already dirty within the same snap context.
> - */
> -static int ceph_write_begin(struct file *file, struct address_space *mapping,
> -			    loff_t pos, unsigned len, unsigned flags,
> -			    struct page **pagep, void **fsdata)
> -{
> -	struct inode *inode = file_inode(file);
> -	struct page *page;
> -	pgoff_t index = pos >> PAGE_SHIFT;
> -	int r;
> -
> -	do {
> -		/* get a page */
> -		page = grab_cache_page_write_begin(mapping, index, 0);
> -		if (!page)
> -			return -ENOMEM;
> -
> -		dout("write_begin file %p inode %p page %p %d~%d\n", file,
> -		     inode, page, (int)pos, (int)len);
> -
> -		r = ceph_update_writeable_page(file, pos, len, page);
> -		if (r < 0)
> +	if (r < 0) {
> +		if (page) {
> +			unlock_page(page);
>  			put_page(page);
> -		else
> -			*pagep = page;
> -	} while (r == -EAGAIN);
> -
> +		}
> +	} else {
> +		*pagep = page;
> +	}
>  	return r;
>  }
>  

-- 
Jeff Layton <jlayton@kernel.org>

