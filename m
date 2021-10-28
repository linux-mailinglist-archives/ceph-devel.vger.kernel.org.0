Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56CBB43E813
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Oct 2021 20:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbhJ1SON (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 28 Oct 2021 14:14:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:37448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230342AbhJ1SOM (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 28 Oct 2021 14:14:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C5DD610E5;
        Thu, 28 Oct 2021 18:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635444705;
        bh=2YVEaXE/v+/STs6MvQw1LcdSV4OQiM4ygzm1JbABHT0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lxYNRVAHrzehZs8z0Z31UBVOD3y7mKTJjg9qsZE98Qf2YZ8rxXYdmNqhWZxeRCaya
         po66sKquirdX/AATqweek0Xa3GGup5E/D9G2GrxFiL3J5yh7T3MtUOFGxdoGQQkSOP
         /E9zo5epB6RpzqQIP1iGaUPZL0PwfZzpt+O2T78HSCvhpCWzNiTfTd0XJ7KnuFbvSh
         G+Fr/e+hPCjLnLasamw+TNDcH9BBHtMNkQ/jZzBlX578WLIcyIPr+XedIjg2OU3Pne
         wdVUHIuDRMZJunAcKCKLCSlXrHdtf/cEvBN6MXqHNchxI8RU6wWpVgoaZCs1Fzo/rZ
         lYXW+DTV3tZ+A==
Message-ID: <22c0b605e1423cd0e884d87a8538278902dc91c1.camel@kernel.org>
Subject: Re: [PATCH v3 3/4] ceph: return the real size readed when hit EOF
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org
Date:   Thu, 28 Oct 2021 14:11:43 -0400
In-Reply-To: <20211028091438.21402-4-xiubli@redhat.com>
References: <20211028091438.21402-1-xiubli@redhat.com>
         <20211028091438.21402-4-xiubli@redhat.com>
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
>  fs/ceph/file.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 74db403a4c35..1988e75ad4a2 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -910,6 +910,7 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
>  	ssize_t ret;
>  	u64 off = *ki_pos;
>  	u64 len = iov_iter_count(to);
> +	u64 i_size = i_size_read(inode);
>  
>  	dout("sync_read on inode %p %llu~%u\n", inode, *ki_pos, (unsigned)len);
>  
> @@ -933,7 +934,6 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
>  		struct page **pages;
>  		int num_pages;
>  		size_t page_off;
> -		u64 i_size;
>  		bool more;
>  		int idx;
>  		size_t left;
> @@ -980,7 +980,6 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
>  
>  		ceph_osdc_put_request(req);
>  
> -		i_size = i_size_read(inode);

I wonder a little about removing this i_size fetch. Then again, the
i_size could change any time after we fetch it so it doesn't seem
worthwhile to do so.

>  		dout("sync_read %llu~%llu got %zd i_size %llu%s\n",
>  		     off, len, ret, i_size, (more ? " MORE" : ""));
>  
> @@ -1056,11 +1055,14 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
>  	}
>  
>  	if (off > *ki_pos) {
> -		if (ret >= 0 &&
> -		    iov_iter_count(to) > 0 && off >= i_size_read(inode))
> +		if (off >= i_size) {
>  			*retry_op = CHECK_EOF;
> -		ret = off - *ki_pos;
> -		*ki_pos = off;
> +			ret = i_size - *ki_pos;
> +			*ki_pos = i_size;
> +		} else {
> +			ret = off - *ki_pos;
> +			*ki_pos = off;
> +		}
>  	}
>  out:
>  	dout("sync_read result %zd retry_op %d\n", ret, *retry_op);

I think I'll go ahead and pull this patch into the testing branch, since
it seems to be correct.

Thanks!
-- 
Jeff Layton <jlayton@kernel.org>

