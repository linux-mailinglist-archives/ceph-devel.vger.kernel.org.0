Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5DE152078
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Feb 2020 19:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727389AbgBDSij (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 4 Feb 2020 13:38:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:55692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727308AbgBDSij (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 4 Feb 2020 13:38:39 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBFEC2084E;
        Tue,  4 Feb 2020 18:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580841518;
        bh=uVsvLH9TXQenvUGybvB1/iqIXSFYQwyjheiTZqiQmO8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=oVa3avIAsv3VdY9X2qqm0uxw4K+oxLLp3QTRJiDr5GzUNxDU/fhhTrld35mg8qJFN
         FNh0xHcjzTgCWvWYtKAureh631lhjLJufzx62Nt018MFLXQuhfmelUy3tBcLuQDIET
         Lx7j7/q7P9DuTvkGHf3mxiNQLSUWgTEhDi1WILPo=
Message-ID: <000994726a54ff699cddf9a68ebdc7d5fd902b9d.camel@kernel.org>
Subject: Re: [PATCH resend v5 03/11] ceph: move ceph_osdc_{read,write}pages
 to ceph.ko
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com, zyan@redhat.com
Cc:     sage@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Tue, 04 Feb 2020 13:38:36 -0500
In-Reply-To: <20200129082715.5285-4-xiubli@redhat.com>
References: <20200129082715.5285-1-xiubli@redhat.com>
         <20200129082715.5285-4-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.3 (3.34.3-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2020-01-29 at 03:27 -0500, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> Since this helpers are only used by cpeh.ko, let's move it to ceph.ko
> and rename to _sync_.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/addr.c                  | 86 ++++++++++++++++++++++++++++++++-
>  include/linux/ceph/osd_client.h | 17 -------
>  net/ceph/osd_client.c           | 79 ------------------------------
>  3 files changed, 84 insertions(+), 98 deletions(-)
> 
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 29d4513eff8c..20e5ebfff389 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -182,6 +182,47 @@ static int ceph_releasepage(struct page *page, gfp_t g)
>  	return !PagePrivate(page);
>  }
>  
> +/*
> + * Read some contiguous pages.  If we cross a stripe boundary, shorten
> + * *plen.  Return number of bytes read, or error.
> + */
> +static int ceph_sync_readpages(struct ceph_fs_client *fsc,
> +			       struct ceph_vino vino,
> +			       struct ceph_file_layout *layout,
> +			       u64 off, u64 *plen,
> +			       u32 truncate_seq, u64 truncate_size,
> +			       struct page **pages, int num_pages,
> +			       int page_align)
> +{
> +	struct ceph_osd_client *osdc = &fsc->client->osdc;
> +	struct ceph_osd_request *req;
> +	int rc = 0;
> +
> +	dout("readpages on ino %llx.%llx on %llu~%llu\n", vino.ino,
> +	     vino.snap, off, *plen);
> +	req = ceph_osdc_new_request(osdc, layout, vino, off, plen, 0, 1,
> +				    CEPH_OSD_OP_READ, CEPH_OSD_FLAG_READ,
> +				    NULL, truncate_seq, truncate_size,
> +				    false);
> +	if (IS_ERR(req))
> +		return PTR_ERR(req);
> +
> +	/* it may be a short read due to an object boundary */
> +	osd_req_op_extent_osd_data_pages(req, 0,
> +				pages, *plen, page_align, false, false);
> +
> +	dout("readpages  final extent is %llu~%llu (%llu bytes align %d)\n",
> +	     off, *plen, *plen, page_align);
> +
> +	rc = ceph_osdc_start_request(osdc, req, false);
> +	if (!rc)
> +		rc = ceph_osdc_wait_request(osdc, req);
> +
> +	ceph_osdc_put_request(req);
> +	dout("readpages result %d\n", rc);
> +	return rc;
> +}
> +
>  /*
>   * read a single page, without unlocking it.
>   */
> @@ -218,7 +259,7 @@ static int ceph_do_readpage(struct file *filp, struct page *page)
>  
>  	dout("readpage inode %p file %p page %p index %lu\n",
>  	     inode, filp, page, page->index);
> -	err = ceph_osdc_readpages(&fsc->client->osdc, ceph_vino(inode),
> +	err = ceph_sync_readpages(fsc, ceph_vino(inode),
>  				  &ci->i_layout, off, &len,
>  				  ci->i_truncate_seq, ci->i_truncate_size,
>  				  &page, 1, 0);
> @@ -570,6 +611,47 @@ static u64 get_writepages_data_length(struct inode *inode,
>  	return end > start ? end - start : 0;
>  }
>  
> +/*
> + * do a synchronous write on N pages
> + */
> +static int ceph_sync_writepages(struct ceph_fs_client *fsc,
> +				struct ceph_vino vino,
> +				struct ceph_file_layout *layout,
> +				struct ceph_snap_context *snapc,
> +				u64 off, u64 len,
> +				u32 truncate_seq, u64 truncate_size,
> +				struct timespec64 *mtime,
> +				struct page **pages, int num_pages)
> +{
> +	struct ceph_osd_client *osdc = &fsc->client->osdc;
> +	struct ceph_osd_request *req;
> +	int rc = 0;
> +	int page_align = off & ~PAGE_MASK;
> +
> +	req = ceph_osdc_new_request(osdc, layout, vino, off, &len, 0, 1,
> +				    CEPH_OSD_OP_WRITE, CEPH_OSD_FLAG_WRITE,
> +				    snapc, truncate_seq, truncate_size,
> +				    true);
> +	if (IS_ERR(req))
> +		return PTR_ERR(req);
> +
> +	/* it may be a short write due to an object boundary */
> +	osd_req_op_extent_osd_data_pages(req, 0, pages, len, page_align,
> +				false, false);
> +	dout("writepages %llu~%llu (%llu bytes)\n", off, len, len);
> +
> +	req->r_mtime = *mtime;
> +	rc = ceph_osdc_start_request(osdc, req, true);
> +	if (!rc)
> +		rc = ceph_osdc_wait_request(osdc, req);
> +
> +	ceph_osdc_put_request(req);
> +	if (rc == 0)
> +		rc = len;
> +	dout("writepages result %d\n", rc);
> +	return rc;
> +}
> +
>  /*
>   * Write a single page, but leave the page locked.
>   *
> @@ -628,7 +710,7 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
>  		set_bdi_congested(inode_to_bdi(inode), BLK_RW_ASYNC);
>  
>  	set_page_writeback(page);
> -	err = ceph_osdc_writepages(&fsc->client->osdc, ceph_vino(inode),
> +	err = ceph_sync_writepages(fsc, ceph_vino(inode),
>  				   &ci->i_layout, snapc, page_off, len,
>  				   ceph_wbc.truncate_seq,
>  				   ceph_wbc.truncate_size,
> diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
> index 5a62dbd3f4c2..9d9f745b98a1 100644
> --- a/include/linux/ceph/osd_client.h
> +++ b/include/linux/ceph/osd_client.h
> @@ -509,23 +509,6 @@ int ceph_osdc_call(struct ceph_osd_client *osdc,
>  		   struct page *req_page, size_t req_len,
>  		   struct page **resp_pages, size_t *resp_len);
>  
> -extern int ceph_osdc_readpages(struct ceph_osd_client *osdc,
> -			       struct ceph_vino vino,
> -			       struct ceph_file_layout *layout,
> -			       u64 off, u64 *plen,
> -			       u32 truncate_seq, u64 truncate_size,
> -			       struct page **pages, int nr_pages,
> -			       int page_align);
> -
> -extern int ceph_osdc_writepages(struct ceph_osd_client *osdc,
> -				struct ceph_vino vino,
> -				struct ceph_file_layout *layout,
> -				struct ceph_snap_context *sc,
> -				u64 off, u64 len,
> -				u32 truncate_seq, u64 truncate_size,
> -				struct timespec64 *mtime,
> -				struct page **pages, int nr_pages);
> -
>  int ceph_osdc_copy_from(struct ceph_osd_client *osdc,
>  			u64 src_snapid, u64 src_version,
>  			struct ceph_object_id *src_oid,
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index b68b376d8c2f..8ff2856e2d52 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -5230,85 +5230,6 @@ void ceph_osdc_stop(struct ceph_osd_client *osdc)
>  	ceph_msgpool_destroy(&osdc->msgpool_op_reply);
>  }
>  
> -/*
> - * Read some contiguous pages.  If we cross a stripe boundary, shorten
> - * *plen.  Return number of bytes read, or error.
> - */
> -int ceph_osdc_readpages(struct ceph_osd_client *osdc,
> -			struct ceph_vino vino, struct ceph_file_layout *layout,
> -			u64 off, u64 *plen,
> -			u32 truncate_seq, u64 truncate_size,
> -			struct page **pages, int num_pages, int page_align)
> -{
> -	struct ceph_osd_request *req;
> -	int rc = 0;
> -
> -	dout("readpages on ino %llx.%llx on %llu~%llu\n", vino.ino,
> -	     vino.snap, off, *plen);
> -	req = ceph_osdc_new_request(osdc, layout, vino, off, plen, 0, 1,
> -				    CEPH_OSD_OP_READ, CEPH_OSD_FLAG_READ,
> -				    NULL, truncate_seq, truncate_size,
> -				    false);
> -	if (IS_ERR(req))
> -		return PTR_ERR(req);
> -
> -	/* it may be a short read due to an object boundary */
> -	osd_req_op_extent_osd_data_pages(req, 0,
> -				pages, *plen, page_align, false, false);
> -
> -	dout("readpages  final extent is %llu~%llu (%llu bytes align %d)\n",
> -	     off, *plen, *plen, page_align);
> -
> -	rc = ceph_osdc_start_request(osdc, req, false);
> -	if (!rc)
> -		rc = ceph_osdc_wait_request(osdc, req);
> -
> -	ceph_osdc_put_request(req);
> -	dout("readpages result %d\n", rc);
> -	return rc;
> -}
> -EXPORT_SYMBOL(ceph_osdc_readpages);
> -
> -/*
> - * do a synchronous write on N pages
> - */
> -int ceph_osdc_writepages(struct ceph_osd_client *osdc, struct ceph_vino vino,
> -			 struct ceph_file_layout *layout,
> -			 struct ceph_snap_context *snapc,
> -			 u64 off, u64 len,
> -			 u32 truncate_seq, u64 truncate_size,
> -			 struct timespec64 *mtime,
> -			 struct page **pages, int num_pages)
> -{
> -	struct ceph_osd_request *req;
> -	int rc = 0;
> -	int page_align = off & ~PAGE_MASK;
> -
> -	req = ceph_osdc_new_request(osdc, layout, vino, off, &len, 0, 1,
> -				    CEPH_OSD_OP_WRITE, CEPH_OSD_FLAG_WRITE,
> -				    snapc, truncate_seq, truncate_size,
> -				    true);
> -	if (IS_ERR(req))
> -		return PTR_ERR(req);
> -
> -	/* it may be a short write due to an object boundary */
> -	osd_req_op_extent_osd_data_pages(req, 0, pages, len, page_align,
> -				false, false);
> -	dout("writepages %llu~%llu (%llu bytes)\n", off, len, len);
> -
> -	req->r_mtime = *mtime;
> -	rc = ceph_osdc_start_request(osdc, req, true);
> -	if (!rc)
> -		rc = ceph_osdc_wait_request(osdc, req);
> -
> -	ceph_osdc_put_request(req);
> -	if (rc == 0)
> -		rc = len;
> -	dout("writepages result %d\n", rc);
> -	return rc;
> -}
> -EXPORT_SYMBOL(ceph_osdc_writepages);
> -
>  static int osd_req_op_copy_from_init(struct ceph_osd_request *req,
>  				     u64 src_snapid, u64 src_version,
>  				     struct ceph_object_id *src_oid,

This looks like a nice cleanup. I'll plan to merge this one after a bit
of testing.
-- 
Jeff Layton <jlayton@kernel.org>

