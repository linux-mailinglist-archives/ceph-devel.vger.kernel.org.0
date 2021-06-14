Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 813CF3A66A0
	for <lists+ceph-devel@lfdr.de>; Mon, 14 Jun 2021 14:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233000AbhFNMdd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 14 Jun 2021 08:33:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:35546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232809AbhFNMdc (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 14 Jun 2021 08:33:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DBB961206;
        Mon, 14 Jun 2021 12:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623673890;
        bh=4NgS5NvCK8Mv5pHDAIab2nbKVhFjvee0lxQ2+KL/fdg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=HxjToQ7I+jWjn4S1o9wX9HVwRMxBPsfJhiPcMo8fdguMEn3D+Bm12vrt7ZqQXA290
         7du7sBxn8BnwucQnTbKlXG5m7SvVik5f3qwm/Op7x0nG2w5PKURTY7dY/YINNVr0HE
         2K3Km3UYZsMgukry+0HrE9BQVy5kHkOvh4VJ3Lh9kliBP0ey5rYsYGTlsPCeMLg9K6
         v7pbYY8Rr3zOb8MzCVfqf46kHldPzoeA5wiUqnlkqBYj5rOg2INVXES96n7ElTXPoI
         uYkfxXopgCWN9rQBNQ645ln1PGrBWAgqp1JgkfNBaWssQcyhEvmZAd9Fvc2XEq9oIs
         FQ7G6B7SQiIrg==
Message-ID: <8857915ffcdc91daea870f70e0c5914d3b979470.camel@kernel.org>
Subject: Re: [PATCH] netfs: fix test for whether we can skip read when
 writing beyond EOF
From:   Jeff Layton <jlayton@kernel.org>
To:     David Howells <dhowells@redhat.com>
Cc:     linux-cachefs@redhat.com, idryomov@gmail.com, willy@infradead.org,
        pfmeec@rit.edu, ceph-devel@vger.kernel.org,
        Andrew W Elble <aweits@rit.edu>
Date:   Mon, 14 Jun 2021 08:31:28 -0400
In-Reply-To: <398005.1623673532@warthog.procyon.org.uk>
References: <20210613233345.113565-1-jlayton@kernel.org>
         <398005.1623673532@warthog.procyon.org.uk>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.2 (3.40.2-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2021-06-14 at 13:25 +0100, David Howells wrote:
> Here's my take on Jeff's patch.
> 
> David
> ---
> commit 2821dcb8a99b5da3b914cfc57ba6010635719b12
> Author: Jeff Layton <jlayton@kernel.org>
> Date:   Sun Jun 13 19:33:45 2021 -0400
> 
>     netfs: fix test for whether we can skip read when writing beyond EOF
>     
>     It's not sufficient to skip reading when the pos is beyond the EOF.
>     There may be data at the head of the page that we need to fill in
>     before the write.
>     
>     Add a new helper function that corrects and clarifies the logic of
>     when we can skip reads, and have it only zero out the part of the page
>     that won't have data copied in for the write.
>     
>     Finally, don't set the page Uptodate after zeroing. It's not up to date
>     since the write data won't have been copied in yet.
>     
>     [DH made the following changes:
>     
>      - Prefixed the new function with "netfs_".
>     
>      - Don't call zero_user_segments() for a full-page write.
>     
>      - Altered the beyond-last-page check to avoid a DIV instruction and got
>        rid of then-redundant zero-length file check.
>     
>      - Made afs handle a short copy (didn't matter before as the page was fully
>        set up before the copy).  Now it returns 0 from afs_write_end() if the
>        page was not uptodate as commit b9de313cf05fe08fa59efaf19756ec5283af672a
>        does for ceph.
>     
>      - Made afs handle len indicating a write that extended over the end of the
>        page allocated.]
>     
>     Fixes: e1b1240c1ff5f ("netfs: Add write_begin helper")
>     Reported-by: Andrew W Elble <aweits@rit.edu>
>     Signed-off-by: Jeff Layton <jlayton@kernel.org>
>     Signed-off-by: David Howells <dhowells@redhat.com>
>     Link: https://lore.kernel.org/r/340984.1623666185@warthog.procyon.org.uk/T/#m5e9b155310973bc71cf101d3dea6aced492bfd49
> ---
>  fs/afs/write.c         |   23 ++++++++++++++++------
>  fs/netfs/read_helper.c |   50 ++++++++++++++++++++++++++++++++++++-------------
>  2 files changed, 54 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/afs/write.c b/fs/afs/write.c
> index 4e90e094d770..15fdc3f8a3ae 100644
> --- a/fs/afs/write.c
> +++ b/fs/afs/write.c
> @@ -28,7 +28,8 @@ int afs_set_page_dirty(struct page *page)
>  }
>  
>  /*
> - * prepare to perform part of a write to a page
> + * Prepare to perform part of a write to a page.  Note that len may extend
> + * beyond the end of the page.
>   */
>  int afs_write_begin(struct file *file, struct address_space *mapping,
>  		    loff_t pos, unsigned len, unsigned flags,
> @@ -55,7 +56,8 @@ int afs_write_begin(struct file *file, struct address_space *mapping,
>  		return ret;
>  
>  	index = page->index;
> -	from = pos - index * PAGE_SIZE;
> +	from = offset_in_thp(page, pos);
> +	len = min_t(size_t, len, thp_size(page) - from);
>  	to = from + len;
>  
>  try_again:
> @@ -106,7 +108,8 @@ int afs_write_begin(struct file *file, struct address_space *mapping,
>  }
>  
>  /*
> - * finalise part of a write to a page
> + * Finalise part of a write to a page.  Note that len may extend beyond the end
> + * of the page.
>   */
>  int afs_write_end(struct file *file, struct address_space *mapping,
>  		  loff_t pos, unsigned len, unsigned copied,
> @@ -115,13 +118,23 @@ int afs_write_end(struct file *file, struct address_space *mapping,
>  	struct afs_vnode *vnode = AFS_FS_I(file_inode(file));
>  	struct page *page = thp_head(subpage);
>  	unsigned long priv;
> -	unsigned int f, from = pos & (thp_size(page) - 1);
> +	unsigned int f, from = offset_in_thp(page, pos);
>  	unsigned int t, to = from + copied;
> +	unsigned int l = min_t(size_t, len, thp_size(page) - from);
>  	loff_t i_size, write_end_pos;
>  
>  	_enter("{%llx:%llu},{%lx}",
>  	       vnode->fid.vid, vnode->fid.vnode, page->index);
>  
> +	if (!PageUptodate(page)) {
> +		if (copied < l) {
> +			copied = 0;
> +			goto out;
> +		}
> +
> +		SetPageUptodate(page);
> +	}
> +
>  	if (copied == 0)
>  		goto out;
>  
> @@ -137,8 +150,6 @@ int afs_write_end(struct file *file, struct address_space *mapping,
>  		fscache_update_cookie(afs_vnode_cache(vnode), NULL, &write_end_pos);
>  	}
>  
> -	ASSERT(PageUptodate(page));
> -
>  	if (PagePrivate(page)) {
>  		priv = page_private(page);
>  		f = afs_page_dirty_from(page, priv);

AFS changes should probably go into a separate patch.

> diff --git a/fs/netfs/read_helper.c b/fs/netfs/read_helper.c
> index 725614625ed4..0c4e68ae8127 100644
> --- a/fs/netfs/read_helper.c
> +++ b/fs/netfs/read_helper.c
> @@ -1011,12 +1011,43 @@ int netfs_readpage(struct file *file,
>  }
>  EXPORT_SYMBOL(netfs_readpage);
>  
> -static void netfs_clear_thp(struct page *page)
> +/**
> + * prep_noread_page - prep a page for writing without reading first

nit: fix function name here too?

> + * @page: page being prepared
> + * @pos: starting position for the write
> + * @len: length of write
> + *
> + * In some cases, write_begin doesn't need to read at all:
> + * - full page write
> + * - file is currently zero-length
> + * - write that lies in a page that is completely beyond EOF
> + * - write that covers the the page from start to EOF or beyond it
> + *
> + * If any of these criteria are met, then zero out the unwritten parts
> + * of the page and return true. Otherwise, return false.
> + */
> +static noinline bool netfs_prep_noread_page(struct page *page, loff_t pos, size_t len)
>  {
> -	unsigned int i;
> +	struct inode *inode = page->mapping->host;
> +	loff_t i_size = i_size_read(inode);
> +	size_t offset = offset_in_thp(page, pos);
> +
> +	/* Full page write */
> +	if (offset == 0 && len >= thp_size(page))
> +		return true;
> +
> +	/* pos beyond last page in the file */
> +	if (pos - offset >= i_size)
> +		goto zero_out;
> +
> +	/* Write that covers from the start of the page  to EOF or beyond */
> +	if (offset == 0 && (pos + len) >= i_size)
> +		goto zero_out;
>  
> -	for (i = 0; i < thp_nr_pages(page); i++)
> -		clear_highpage(page + i);
> +	return false;
> +zero_out:
> +	zero_user_segments(page, 0, offset, offset + len, thp_size(page));
> +	return true;
>  }
>  
>  /**
> @@ -1024,7 +1055,7 @@ static void netfs_clear_thp(struct page *page)
>   * @file: The file to read from
>   * @mapping: The mapping to read from
>   * @pos: File position at which the write will begin
> - * @len: The length of the write in this page
> + * @len: The length of the write (may extend beyond the end of the page chosen)
>   * @flags: AOP_* flags
>   * @_page: Where to put the resultant page
>   * @_fsdata: Place for the netfs to store a cookie
> @@ -1061,8 +1092,6 @@ int netfs_write_begin(struct file *file, struct address_space *mapping,
>  	struct inode *inode = file_inode(file);
>  	unsigned int debug_index = 0;
>  	pgoff_t index = pos >> PAGE_SHIFT;
> -	int pos_in_page = pos & ~PAGE_MASK;
> -	loff_t size;
>  	int ret;
>  
>  	DEFINE_READAHEAD(ractl, file, NULL, mapping, index);
> @@ -1090,13 +1119,8 @@ int netfs_write_begin(struct file *file, struct address_space *mapping,
>  	 * within the cache granule containing the EOF, in which case we need
>  	 * to preload the granule.
>  	 */
> -	size = i_size_read(inode);
>  	if (!ops->is_cache_enabled(inode) &&
> -	    ((pos_in_page == 0 && len == thp_size(page)) ||
> -	     (pos >= size) ||
> -	     (pos_in_page == 0 && (pos + len) >= size))) {
> -		netfs_clear_thp(page);
> -		SetPageUptodate(page);
> +	    netfs_prep_noread_page(page, pos, len)) {
>  		netfs_stat(&netfs_n_rh_write_zskip);
>  		goto have_page_no_wait;
>  	}
> 

The rest looks good to me.
-- 
Jeff Layton <jlayton@kernel.org>

