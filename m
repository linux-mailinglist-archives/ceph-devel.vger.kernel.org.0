Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4699CEB3EC
	for <lists+ceph-devel@lfdr.de>; Thu, 31 Oct 2019 16:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbfJaP26 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 31 Oct 2019 11:28:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:48154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726602AbfJaP26 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 31 Oct 2019 11:28:58 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F86020873;
        Thu, 31 Oct 2019 15:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572535737;
        bh=3Fy76G15PXb8LcDmK2CX1fWHFEEza+FfjYy5AOkePTk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Rrnyxt5l5ZYI0bR9uuyL1BPMvPDN4eidQi38MY4CsARlIPik+bSdlt3qTq671WTn8
         KxXtu7vnpvLTBXiAluRcNFBTAGeVSg/6HHDP73MYk7VHDfJSMGqhIw28YdTuGJ1Bof
         I/wpmFgDGXAP35meQ34unk4P5gxI5meW500GkvFs=
Message-ID: <59ac4d5bebe67f66f072bf6d3e9fa7f0d0b38d0c.camel@kernel.org>
Subject: Re: [PATCH] ceph: don't allow copy_file_range when stripe_count != 1
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.com>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        "Yan, Zheng" <zyan@redhat.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 31 Oct 2019 11:28:55 -0400
In-Reply-To: <20191031114939.24462-1-lhenriques@suse.com>
References: <20191031114939.24462-1-lhenriques@suse.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2019-10-31 at 11:49 +0000, Luis Henriques wrote:
> copy_file_range tries to use the OSD 'copy-from' operation, which simply
> performs a full object copy.  Unfortunately, the implementation of this
> system call assumes that stripe_count is always set to 1 and doesn't take
> into account that the data may be striped across an object set.  If the
> file layout has stripe_count different from 1, then the destination file
> data will be corrupted.
> 
> For example:
> 
> Consider a 8 MiB file with 4 MiB object size, stripe_count of 2 and
> stripe_size of 2 MiB; the first half of the file will be filled with 'A's
> and the second half will be filled with 'B's:
> 
>                0      4M     8M       Obj1     Obj2
>                +------+------+       +----+   +----+
>         file:  | AAAA | BBBB |       | AA |   | AA |
>                +------+------+       |----|   |----|
>                                      | BB |   | BB |
>                                      +----+   +----+
> 
> If we copy_file_range this file into a new file (which needs to have the
> same file layout!), then it will start by copying the object starting at
> file offset 0 (Obj1).  And then it will copy the object starting at file
> offset 4M -- which is Obj1 again.
> 
> Unfortunately, the solution for this is to not allow remote object copies
> to be performed when the file layout stripe_count is not 1 and simply
> fallback to the default (VFS) copy_file_range implementation.
> 
> Signed-off-by: Luis Henriques <lhenriques@suse.com>
> ---
> Hi Jeff,
> 
> I hope my understanding of the whole file striping in CephFS is correct;
> I had to go re-read the whole thing to refresh my memory.
> 
> Anyway, I guess that this is not really the only solution to this
> problem, but it's definitely the simplest one.  copy_file_range is
> already way more complex that I had ever anticipated.  I would rather
> keep this simple solution instead of adding more complexity and cover
> more corner cases.  But yeah, we may want to revisit this in the
> future...
> 
> [OOT: files layout is probably one of the biggest headaches to sort out
>  the day we want to implement something like FIEMAP on CephFS ;-) ]
> 
> Cheers,
> --
> Luis
> 
>  fs/ceph/file.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index d277f71abe0b..3b0e6f9eb6a6 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -1957,9 +1957,12 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
>  		return -EOPNOTSUPP;
>  
>  	if ((src_ci->i_layout.stripe_unit != dst_ci->i_layout.stripe_unit) ||
> -	    (src_ci->i_layout.stripe_count != dst_ci->i_layout.stripe_count) ||
> -	    (src_ci->i_layout.object_size != dst_ci->i_layout.object_size))
> +	    (src_ci->i_layout.stripe_count != 1) ||
> +	    (dst_ci->i_layout.stripe_count != 1) ||
> +	    (src_ci->i_layout.object_size != dst_ci->i_layout.object_size)) {
> +		dout("Invalid src/dst files layout\n");
>  		return -EOPNOTSUPP;
> +	}
>  
>  	if (len < src_ci->i_layout.object_size)
>  		return -EOPNOTSUPP; /* no remote copy will be done */

I'm fine with restricting CFR to very simple cases, at least initially.
We can always expand it later once the need becomes clear.

That said, we should probably add a comment explaining why we're
excluding cases where the stripe count != 1 here. It doesn't need to
contain the whole commit log message you wrote, but anyone that does
want to improve this later might appreciate some breadcrumbs.

Maybe something like:

/*
 * Striped file layouts require that we copy partial objects,
 * but the OSD copy-from operation only supports full-object copies.
 * Limit this to non-striped file layouts for now.
 */

If that sounds ok, I'll add that in and merge this later today.

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>

