Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25DB046D70F
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Dec 2021 16:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236146AbhLHPhS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Dec 2021 10:37:18 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41920 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236156AbhLHPhR (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 8 Dec 2021 10:37:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 560EBB8169E
        for <ceph-devel@vger.kernel.org>; Wed,  8 Dec 2021 15:33:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5DC4C00446;
        Wed,  8 Dec 2021 15:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638977623;
        bh=1TjVJBEsE1Sjr22zWEiE2qxpJlWr1BNh+BVLzPCNwQA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nUxeXPopjkiH/Pjziokt2AQZXnKBBtCRVWSQU9pVgRR2ifZQ2LF6wAKX+D8NNpT5e
         0+1uvNtietMepLA+r798ky+Bq49XsGUbcs2wc1GaEYfRcOkJ1w+N9/S9j8uGt0thGi
         k23NMFQ71I34aMjMig9jvpEAOnNj6wCOAwbXSqurdocybvP5pyecyQjMhlFFHD76A/
         SueDeYKedympwXSXYSfunjyCTZbY4HDtE+o9mH7Xylv/j3pO8AZn77fl2+V2U3O72e
         0YPqTn6WLONyMNSSmPXVGpwT1ne12cJuEGrvq0DCr+5TGcit1lx+PmfdyG8qCBwVJ5
         j03nMZx97YJjw==
Message-ID: <2f46a421f943b5686ba175bd564821f39fb177d7.camel@kernel.org>
Subject: Re: [PATCH v7 8/9] ceph: add object version support for sync read
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, khiremat@redhat.com,
        ceph-devel@vger.kernel.org
Date:   Wed, 08 Dec 2021 10:33:41 -0500
In-Reply-To: <20211208124528.679831-2-xiubli@redhat.com>
References: <20211208124528.679831-1-xiubli@redhat.com>
         <20211208124528.679831-2-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2021-12-08 at 20:45 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> Always return the last object's version.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/file.c  | 8 ++++++--
>  fs/ceph/super.h | 3 ++-
>  2 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index b42158c9aa16..9279b8642add 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -883,7 +883,8 @@ enum {
>   * only return a short read to the caller if we hit EOF.
>   */
>  ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
> -			 struct iov_iter *to, int *retry_op)
> +			 struct iov_iter *to, int *retry_op,
> +			 u64 *last_objver)
>  {
>  	struct ceph_inode_info *ci = ceph_inode(inode);
>  	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
> @@ -950,6 +951,9 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
>  					 req->r_end_latency,
>  					 len, ret);
>  
> +		if (last_objver)
> +			*last_objver = req->r_version;
> +

Much better! That said, this might be unreliable if (say) the first OSD
read was successful and then the second one failed on a long read that
spans objects. We'd want to return a short read in that case, but the
last_objver would end up being set to 0.

I think you shouldn't set last_objver unless the call is going to return
>0, and then you want to set it to the object version of the last
successful read in the series.




>  		ceph_osdc_put_request(req);
>  
>  		i_size = i_size_read(inode);
> @@ -1020,7 +1024,7 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
>  	     (unsigned)iov_iter_count(to),
>  	     (file->f_flags & O_DIRECT) ? "O_DIRECT" : "");
>  
> -	return __ceph_sync_read(inode, &iocb->ki_pos, to, retry_op);
> +	return __ceph_sync_read(inode, &iocb->ki_pos, to, retry_op, NULL);
>  }
>  
>  struct ceph_aio_request {
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 84fec46308b0..a7bdb28af595 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -1258,7 +1258,8 @@ extern int ceph_open(struct inode *inode, struct file *file);
>  extern int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
>  			    struct file *file, unsigned flags, umode_t mode);
>  extern ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
> -				struct iov_iter *to, int *retry_op);
> +				struct iov_iter *to, int *retry_op,
> +				u64 *last_objver);
>  extern int ceph_release(struct inode *inode, struct file *filp);
>  extern void ceph_fill_inline_data(struct inode *inode, struct page *locked_page,
>  				  char *data, size_t len);

-- 
Jeff Layton <jlayton@kernel.org>
