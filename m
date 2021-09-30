Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF4941DB1B
	for <lists+ceph-devel@lfdr.de>; Thu, 30 Sep 2021 15:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351483AbhI3NcK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 30 Sep 2021 09:32:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:43216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350416AbhI3NcE (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 30 Sep 2021 09:32:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12647615A2;
        Thu, 30 Sep 2021 13:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633008621;
        bh=gfsvZESXrlqebdpSYju0L9uDAc6xk6K0GXnkVl3h5KQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=pX2M1+o8aNmcbZOHiX780IYeY5OTz1Z1PEyzn/Oaw1aquXzM9/2rh16dK6Ue6JYvt
         w9/VYsIArfejDU4/WbEwMSI6LHRDBfIIjzAQqrDcO/fq/+OiXKjtEdzfIqk+q2wm/0
         Z2BXNkJoWg1HjEJ0FRne0vQXE/Gjk85kM+eQfx80mR00efJpn1xfPdBBc6Z9WJN499
         YrHwthmfQx1tc6+xGUeMbeO8Hp9v0SP4OLNVlyV4ANC1E8qGhZ7BsDCslXmehB47Yd
         Yr1FtbDegSpRL9C/j4ib4DbsiOEKx1Bi5TvtPBSGM2l4in7btkDoKcM0onm2X2JeDm
         ISNECF66IV6Gw==
Message-ID: <550e38fbacfb539f55aa66bb9241c7825c8fc446.camel@kernel.org>
Subject: Re: [PATCH] ceph: buffer the truncate when size won't change with
 Fx caps issued
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Thu, 30 Sep 2021 09:30:19 -0400
In-Reply-To: <20210925085149.429710-1-xiubli@redhat.com>
References: <20210925085149.429710-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sat, 2021-09-25 at 16:51 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> If the new size is the same with current size, the MDS will do nothing
> except changing the mtime/atime. We can just buffer the truncate in
> this case.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 03530793c969..14989b961431 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -2370,7 +2370,7 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
>  		loff_t isize = i_size_read(inode);
>  
>  		dout("setattr %p size %lld -> %lld\n", inode, isize, attr->ia_size);
> -		if ((issued & CEPH_CAP_FILE_EXCL) && attr->ia_size > isize) {
> +		if ((issued & CEPH_CAP_FILE_EXCL) && attr->ia_size >= isize) {
>  			i_size_write(inode, attr->ia_size);
>  			inode->i_blocks = calc_inode_blocks(attr->ia_size);
>  			ci->i_reported_size = attr->ia_size;

I wonder if we ought to just ignore the attr->ia_size == isize case
altogether instead? Truncating to the same size should be a no-op, so we
shouldn't even need to dirty caps or anything.

Thoughts?
-- 
Jeff Layton <jlayton@kernel.org>

