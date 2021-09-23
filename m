Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93237415F1B
	for <lists+ceph-devel@lfdr.de>; Thu, 23 Sep 2021 15:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241188AbhIWNDF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 23 Sep 2021 09:03:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:59340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241178AbhIWNDD (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 23 Sep 2021 09:03:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B754D6103D;
        Thu, 23 Sep 2021 13:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632402092;
        bh=RTqLZBlYFFOhh/hGs55y+fh2d/UxKakhNPwE3w4OREo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DLpZGuijhi8XZRxcLh0fRVpWOj2oq12NgInyYfKqpeyR3qZbaKGK5TteicQsd0RQi
         ianUFAeg9gs/UEHeegLMrEyngMrPagy9PFJkmxt7AO4BdQHo7ijm51kl36LmM6+R+D
         1zbxf8yun8+di5fktlac3enS8egS35BP9f/cVfiCoQPrSrC7jnvLDN01vwN7uAettF
         lfLS7OTPIWWIsFhHhcykkCikjmbe9K925/YdUQq5np4x8lHXY/4TILK5tGeTiinrn0
         E+MkxcpFVczywaStRjFvNC/F6r2APHlPk/nMtcgI42VqeqYVqawAfLgb/wGHzOWS0p
         oEPoM4g+V2r3A==
Message-ID: <77fa22143b63d19a462c25a47d9ae5ae8ec753b8.camel@kernel.org>
Subject: Re: [PATCH] cifs: switch to noop_direct_IO
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, Matthew Wilcox <willy@infradead.org>
Date:   Thu, 23 Sep 2021 09:01:30 -0400
In-Reply-To: <20210923115900.16587-1-jlayton@kernel.org>
References: <20210923115900.16587-1-jlayton@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2021-09-23 at 07:59 -0400, Jeff Layton wrote:
> The cifs one is identical to the noop one. Just use it instead.
> 
> Cc: Matthew Wilcox <willy@infradead.org>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/cifs/file.c | 21 +--------------------
>  1 file changed, 1 insertion(+), 20 deletions(-)
> 
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index d0216472f1c6..2406b9ddd623 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -4890,25 +4890,6 @@ void cifs_oplock_break(struct work_struct *work)
>  	cifs_done_oplock_break(cinode);
>  }
>  
> -/*
> - * The presence of cifs_direct_io() in the address space ops vector
> - * allowes open() O_DIRECT flags which would have failed otherwise.
> - *
> - * In the non-cached mode (mount with cache=none), we shunt off direct read and write requests
> - * so this method should never be called.
> - *
> - * Direct IO is not yet supported in the cached mode. 
> - */
> -static ssize_t
> -cifs_direct_io(struct kiocb *iocb, struct iov_iter *iter)
> -{
> -        /*
> -         * FIXME
> -         * Eventually need to support direct IO for non forcedirectio mounts
> -         */
> -        return -EINVAL;
> -}
> -
>  static int cifs_swap_activate(struct swap_info_struct *sis,
>  			      struct file *swap_file, sector_t *span)
>  {
> @@ -4973,7 +4954,7 @@ const struct address_space_operations cifs_addr_ops = {
>  	.write_end = cifs_write_end,
>  	.set_page_dirty = __set_page_dirty_nobuffers,
>  	.releasepage = cifs_release_page,
> -	.direct_IO = cifs_direct_io,
> +	.direct_IO = noop_direct_io,
>  	.invalidatepage = cifs_invalidate_page,
>  	.launder_page = cifs_launder_page,
>  	/*

Disregard this patch. Sent to the wrong recipients and it has a bug to
boot.
-- 
Jeff Layton <jlayton@kernel.org>

