Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35FDE43367F
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Oct 2021 14:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235788AbhJSNBm (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 19 Oct 2021 09:01:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:46464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235689AbhJSNBk (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 19 Oct 2021 09:01:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5C5861074;
        Tue, 19 Oct 2021 12:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634648367;
        bh=MUUFxegcCpv2s3PCGe0oVUAbfzfl5CUl3N5emTK6q1o=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=PhF3f5rrAsokIt9b2leZ0E8MMxPrfuQAkE5koH5itJ6KtLBaVlvXQhExX9QRPCEzX
         QIizOHHNMmeEQhcwkLq/zOVJ6OIXolK6WnHcbVaory5IlJ5r5v8aupMqh1IUMyGRR+
         76+i1uqU/4NCe5zljTDFSrOZj2DrfvfOyfFUY1irvYBRnTQcYAXjDXI9DhBoclqxo+
         s8+0eJu4m9Hw+Ax7jVGE0w/stedjxx2tszz10ODbuErJHljU6YMUM5YitV+t/zdqBe
         TvRpfIiWNz91KVUIFdonkZ6cyZk6Rf6+KCCr0psLuLVuhXKiVvQAXNreMX3ZyKjTyJ
         rxyUMEOeqRFFA==
Message-ID: <23269de451786354f33adc8a8f59a48c89748ddd.camel@kernel.org>
Subject: Re: [PATCH] ceph: return the real size readed when hit EOF
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, khiremat@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
Date:   Tue, 19 Oct 2021 08:59:25 -0400
In-Reply-To: <20211019115138.414187-1-xiubli@redhat.com>
References: <20211019115138.414187-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-2.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2021-10-19 at 19:51 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> At the same time set the ki_pos to the file size.
> 

It would be good to put the comments in your follow up email into the
patch description here, so that it explains what you're fixing and why.

> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/file.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 91173d3aa161..1abc3b591740 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -847,6 +847,7 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
>  	ssize_t ret;
>  	u64 off = iocb->ki_pos;
>  	u64 len = iov_iter_count(to);
> +	u64 i_size = i_size_read(inode);
>  

Was there a reason to change where the i_size is fetched, or did you
just not see the point in fetching it on each loop? I wonder if we can
hit any races vs. truncates with this?

Oh well, all of this non-buffered I/O seems somewhat racy anyway. ;)

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
> @@ -909,7 +909,6 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
>  
>  		ceph_osdc_put_request(req);
>  
> -		i_size = i_size_read(inode);
>  		dout("sync_read %llu~%llu got %zd i_size %llu%s\n",
>  		     off, len, ret, i_size, (more ? " MORE" : ""));
>  
> @@ -954,10 +953,15 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
>  
>  	if (off > iocb->ki_pos) {
>  		if (ret >= 0 &&

Do we need to check ret here? I think that if ret < 0, then "off" must
be smaller than "i_size", no?

> -		    iov_iter_count(to) > 0 && off >= i_size_read(inode))
> +		    iov_iter_count(to) > 0 &&
> +		    off >= i_size_read(inode)) {
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
-- 
Jeff Layton <jlayton@kernel.org>

