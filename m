Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA51439EF0
	for <lists+ceph-devel@lfdr.de>; Mon, 25 Oct 2021 21:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbhJYTIX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 25 Oct 2021 15:08:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:60554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229822AbhJYTIW (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 25 Oct 2021 15:08:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E0B960FE8;
        Mon, 25 Oct 2021 19:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635188759;
        bh=btMsKHVz8DaJxc0P9qFlxwPfHvi+L1kxxR+CJxj4itg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fninbq8rmd5JkIqib4KEEKEH4fZukm8FRsy7zEogdbnTHqdvEA5QQDsUSkIovqMp2
         Ps/vYv6cvyD/FC/7MdU04d3BU0tFIycVQY/dUWZRwIEAUImdsOTKZFJKDBoOLbKMNW
         iJnMwD867AR/ErreDpb3fAwu9GeVKTy3RBjsOO2zszyrvw+MF1fRujnmb+RYg3c6WJ
         R/MF7t4ThzZLXIMyKIO17IJ6dUhV20GAQ9/rE/klA6hG0JKCuT8FRHq9wKcPf0PGTx
         EELLn7LE8o5qwRPi0NYQVicQZmupvQ2QFjSwOcU7s8dzttkk0Lz5/dTSd7wB2VOKdH
         MYHgPxw1VPXdA==
Message-ID: <77d0ebff15e86a05d4068982830222e1aed97a6b.camel@kernel.org>
Subject: Re: [PATCH v2 3/4] ceph: return the real size readed when hit EOF
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, khiremat@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Mon, 25 Oct 2021 15:05:58 -0400
In-Reply-To: <20211020132813.543695-4-xiubli@redhat.com>
References: <20211020132813.543695-1-xiubli@redhat.com>
         <20211020132813.543695-4-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-2.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2021-10-20 at 21:28 +0800, xiubli@redhat.com wrote:
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

I'm guessing this is fixing a bug? Did you hit this in testing or did
you just notice by inspection? Should we merge this in advance of the
rest of the set?

-- 
Jeff Layton <jlayton@kernel.org>

