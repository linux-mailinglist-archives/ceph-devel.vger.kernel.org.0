Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D24F215BAB
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Jul 2020 18:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729539AbgGFQRd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 6 Jul 2020 12:17:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:53478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729403AbgGFQRd (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 6 Jul 2020 12:17:33 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D2B620708;
        Mon,  6 Jul 2020 16:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594052252;
        bh=J944A0I8oiqpfUG+ZYfsfNcDg+SvWJ/KhIjoRc93RwI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=vh3wN6v8LIFGHDQi/bO2iICo3L0uR/VfoqAIbun1XvyLVii6fiF28x8Mw2zQjVFNN
         QDz8WhvfLnvg+nkd0annTfcZBuY+LnE4j09jvqfv7VwCsh000nXauX7r1ahQwmtBM5
         BUtQ9r+Q2m6F4vZ0IAYbR/yqTbLVKa5xODiObiko=
Message-ID: <ae2bc42cc3434f62ea99f1df32729360a27e487c.camel@kernel.org>
Subject: Re: [PATCH] ceph: do not access the kiocb after aio reqeusts
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
Date:   Mon, 06 Jul 2020 12:17:31 -0400
In-Reply-To: <20200706125135.23511-1-xiubli@redhat.com>
References: <20200706125135.23511-1-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2020-07-06 at 08:51 -0400, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> In aio case, if the completion comes very fast just before the
> ceph_read_iter() returns to fs/aio.c, the kiocb will be freed in
> the completion callback, then if ceph_read_iter() access again
> we will potentially hit the use-after-free bug.
> 
> URL: https://tracker.ceph.com/issues/45649
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/file.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 160644ddaeed..704bae794054 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -1538,6 +1538,7 @@ static ssize_t ceph_read_iter(struct kiocb *iocb, struct iov_iter *to)
>  	struct inode *inode = file_inode(filp);
>  	struct ceph_inode_info *ci = ceph_inode(inode);
>  	struct page *pinned_page = NULL;
> +	bool direct_lock = false;

Looks good. I made a slight change to this patch and had it initialize
this variable to iocb->ki_flags & IOCB_DIRECT, and then use that rather
than setting direct_lock in the true case. Merged into testing.

Thanks!

>  	ssize_t ret;
>  	int want, got = 0;
>  	int retry_op = 0, read = 0;
> @@ -1546,10 +1547,12 @@ static ssize_t ceph_read_iter(struct kiocb *iocb, struct iov_iter *to)
>  	dout("aio_read %p %llx.%llx %llu~%u trying to get caps on %p\n",
>  	     inode, ceph_vinop(inode), iocb->ki_pos, (unsigned)len, inode);
>  
> -	if (iocb->ki_flags & IOCB_DIRECT)
> +	if (iocb->ki_flags & IOCB_DIRECT) {
>  		ceph_start_io_direct(inode);
> -	else
> +		direct_lock = true;
> +	} else {
>  		ceph_start_io_read(inode);
> +	}
>  
>  	if (fi->fmode & CEPH_FILE_MODE_LAZY)
>  		want = CEPH_CAP_FILE_CACHE | CEPH_CAP_FILE_LAZYIO;
> @@ -1603,7 +1606,7 @@ static ssize_t ceph_read_iter(struct kiocb *iocb, struct iov_iter *to)
>  	}
>  	ceph_put_cap_refs(ci, got);
>  
> -	if (iocb->ki_flags & IOCB_DIRECT)
> +	if (direct_lock)
>  		ceph_end_io_direct(inode);
>  	else
>  		ceph_end_io_read(inode);

-- 
Jeff Layton <jlayton@kernel.org>

