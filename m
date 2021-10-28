Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41FC843E83F
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Oct 2021 20:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbhJ1SYQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 28 Oct 2021 14:24:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:42810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230325AbhJ1SYP (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 28 Oct 2021 14:24:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98D77610E5;
        Thu, 28 Oct 2021 18:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635445308;
        bh=dvGx/BhKAi6s/TKqAMGevmJl2QCkg4OHGcFT79Goedo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=n6pXs1A9ffp+k7yH5YbjNq71W8j1WxSy3IM4BsYYlc3AsuZYoi4nQr2tqfRcDWddl
         0M7so4Z4dPJ3mTVUz+xXQVGocPvn4bo9a8Seg4DitqudRWyHBJ75AVmX8pbEB/fnk/
         4NUBtoRELZL4W2z6VEZIT6eIPaoj7yhdb2zDSgsuDIaEUcAcB9iafBYWTLjsCGfG4n
         d9P6HsikFkiLXOFlmdYL5mR1ge6LjmJ9DvSQljlKbzjdqRXKa1s6m+1pvybEhtpBmV
         o0hiIHYjL/c2C5wiPA8IQDhy3X9NrVSK84JU7DTYtLYn2dQ8IPZa6hOBiKB+eGDFzu
         2UG5V/B1iPGAw==
Message-ID: <c824c92834ebcb01867a4fbc4d4bb0cbce95a8ad.camel@kernel.org>
Subject: Re: [PATCH v3 2/4] ceph: add __ceph_sync_read helper support
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org
Date:   Thu, 28 Oct 2021 14:21:46 -0400
In-Reply-To: <20211028091438.21402-3-xiubli@redhat.com>
References: <20211028091438.21402-1-xiubli@redhat.com>
         <20211028091438.21402-3-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-2.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2021-10-28 at 17:14 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/file.c  | 31 +++++++++++++++++++++----------
>  fs/ceph/super.h |  2 ++
>  2 files changed, 23 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 6e677b40410e..74db403a4c35 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -901,20 +901,17 @@ static inline void fscrypt_adjust_off_and_len(struct inode *inode, u64 *off, u64
>   * If we get a short result from the OSD, check against i_size; we need to
>   * only return a short read to the caller if we hit EOF.
>   */
> -static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
> -			      int *retry_op)
> +ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
> +			 struct iov_iter *to, int *retry_op)
>  {
> -	struct file *file = iocb->ki_filp;
> -	struct inode *inode = file_inode(file);
>  	struct ceph_inode_info *ci = ceph_inode(inode);
>  	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
>  	struct ceph_osd_client *osdc = &fsc->client->osdc;
>  	ssize_t ret;
> -	u64 off = iocb->ki_pos;
> +	u64 off = *ki_pos;
>  	u64 len = iov_iter_count(to);
>  
> -	dout("sync_read on file %p %llu~%u %s\n", file, off, (unsigned)len,
> -	     (file->f_flags & O_DIRECT) ? "O_DIRECT" : "");
> +	dout("sync_read on inode %p %llu~%u\n", inode, *ki_pos, (unsigned)len);
>  
>  	if (!len)
>  		return 0;
> @@ -1058,18 +1055,32 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
>  			break;
>  	}
>  
> -	if (off > iocb->ki_pos) {
> +	if (off > *ki_pos) {
>  		if (ret >= 0 &&
>  		    iov_iter_count(to) > 0 && off >= i_size_read(inode))
>  			*retry_op = CHECK_EOF;
> -		ret = off - iocb->ki_pos;
> -		iocb->ki_pos = off;
> +		ret = off - *ki_pos;
> +		*ki_pos = off;
>  	}
>  out:
>  	dout("sync_read result %zd retry_op %d\n", ret, *retry_op);
>  	return ret;
>  }
>  
> +static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
> +			      int *retry_op)
> +{
> +	struct file *file = iocb->ki_filp;
> +	struct inode *inode = file_inode(file);
> +
> +	dout("sync_read on file %p %llu~%u %s\n", file, iocb->ki_pos,
> +	     (unsigned)iov_iter_count(to),
> +	     (file->f_flags & O_DIRECT) ? "O_DIRECT" : "");
> +
> +	return __ceph_sync_read(inode, &iocb->ki_pos, to, retry_op);
> +
> +}
> +
>  struct ceph_aio_request {
>  	struct kiocb *iocb;
>  	size_t total_len;
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 027d5f579ba0..57bc952c54e1 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -1235,6 +1235,8 @@ extern int ceph_renew_caps(struct inode *inode, int fmode);
>  extern int ceph_open(struct inode *inode, struct file *file);
>  extern int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
>  			    struct file *file, unsigned flags, umode_t mode);
> +extern ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
> +				struct iov_iter *to, int *retry_op);
>  extern int ceph_release(struct inode *inode, struct file *filp);
>  extern void ceph_fill_inline_data(struct inode *inode, struct page *locked_page,
>  				  char *data, size_t len);

I went ahead and picked this patch too since #3 had a dependency on it.
If we decide we want #3 for stable though, then we probably ought to
respin these to avoid it.
-- 
Jeff Layton <jlayton@kernel.org>

