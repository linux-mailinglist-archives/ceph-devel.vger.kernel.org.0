Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D004441AF5
	for <lists+ceph-devel@lfdr.de>; Mon,  1 Nov 2021 12:58:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232209AbhKAMBE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 1 Nov 2021 08:01:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:50396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231693AbhKAMBD (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 1 Nov 2021 08:01:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C38B860FE8;
        Mon,  1 Nov 2021 11:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635767910;
        bh=2FvAzbOp9zAqnowlpLlT2fKn0d1710JiqdP+jgkSHoQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=PKSJ9wCQ1iWorElwEi1N4WBUvkRuMx3lJ0YB6qjivyFgGEwXSSBsLXWTzeuhrMu6T
         K6MaWJ9Y4FQyTA4hX3QGXUBn+VcrweQdZOJyqdOBqx63TE12czoVrmSu4kqCqj3YVD
         MpuT3tIp/bPWakC2PEuR3OoTGUtGyvk6TJvzQLNZX3n1HMNTI45KT8wWMD0MZa/ekU
         7X7bzipe+FAUhAFJkMtI7XvsaH9YXRAZPTDZ6mEn4QmdNG/jD5CH6fTmCITe5fG50H
         qTE8tZO7vLyMc9RhliVOjmqKDU01gjKUwAqxZsAKqbmQcgcOudN69kQZ4l2o7xf1ar
         LjSHqWfQcczdA==
Message-ID: <d33fc96c42be28d8e1aa330b6624c6dbc6ba788b.camel@kernel.org>
Subject: Re: [PATCH v4] ceph: return the real size read when we it hits EOF
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org
Date:   Mon, 01 Nov 2021 07:58:28 -0400
In-Reply-To: <20211030051640.2402573-1-xiubli@redhat.com>
References: <20211030051640.2402573-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-2.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sat, 2021-10-30 at 13:16 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> Currently, if we end up reading more from the last object in the file
> than the i_size indicates then we'll end up returning the wrong length.
> Ensure that we cap the returned length and pos at the EOF.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
> 
> Changed in V4:
> - move the i_size_read() into the while loop and use the lastest i_size
>   read to do the check at the end of ceph_sync_read().
> 
> 
>  fs/ceph/file.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 91173d3aa161..6005b430f6f7 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -847,6 +847,7 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
>  	ssize_t ret;
>  	u64 off = iocb->ki_pos;
>  	u64 len = iov_iter_count(to);
> +	u64 i_size;
>  
>  	dout("sync_read on file %p %llu~%u %s\n", file, off, (unsigned)len,
>  	     (file->f_flags & O_DIRECT) ? "O_DIRECT" : "");
> @@ -870,7 +871,6 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
>  		struct page **pages;
>  		int num_pages;
>  		size_t page_off;
> -		u64 i_size;
>  		bool more;
>  		int idx;
>  		size_t left;
> @@ -953,11 +953,14 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
>  	}
>  
>  	if (off > iocb->ki_pos) {
> -		if (ret >= 0 &&
> -		    iov_iter_count(to) > 0 && off >= i_size_read(inode))
> +		if (off >= i_size) {
>  			*retry_op = CHECK_EOF;
> -		ret = off - iocb->ki_pos;
> -		iocb->ki_pos = off;
> +			ret = i_size - iocb->ki_pos;
> +			iocb->ki_pos = i_size;
> +		} else {
> +			ret = off - iocb->ki_pos;
> +			iocb->ki_pos = off;
> +		}
>  	}
>  
>  	dout("sync_read result %zd retry_op %d\n", ret, *retry_op);

Thanks, looks good. I dropped the two patches I had merged for this on
Friday and merged this one instead.
-- 
Jeff Layton <jlayton@kernel.org>

