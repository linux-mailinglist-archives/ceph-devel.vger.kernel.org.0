Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 877C32D757E
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Dec 2020 13:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395555AbgLKMYF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 11 Dec 2020 07:24:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:60050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391777AbgLKMXl (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 11 Dec 2020 07:23:41 -0500
Message-ID: <0cde2f2eecffacc754d09e1f5c2bc338ede6451f.camel@kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607689380;
        bh=8x5J0R0LH+dxx+SDxob+VZYmxyXVYyVnAAp0ftHs8YM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=RVCHvgRdWAfMqQmlRXbHAaf+5yeGi8f74xrBJ2oGm9VkUl6aCfHzHRxrL+Ml62FD0
         U8QtYTt1gzDU+d+HMzBy+seEE6OacQxxH5r20ATxVdCMg1cgzwzBecjn+MxUo7T5t7
         b3wykcL44/Eyjegfx1KPYlyX4tTtclRU95yyw/hQq7aWOJUNmy1vaCHwHayJ2ial+W
         swAsegh+S8qhsIGaMLcgF87eCAAsEyM4BJ53qlKBXjJGBvEHNtykTU9Hsm3DKEIbJp
         GziHgjFx+BpZ4CfpSntzl1Q9tI334LrOXb1CTTzxI5HM9T+PvKTYevSOHHvvQiyF+Z
         V2Ffyc3Ksogqg==
Subject: Re: [PATCH -next] fs/omfs: convert comma to semicolon
From:   Jeff Layton <jlayton@kernel.org>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>, idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        me <me@bobcopeland.com>,
        linux-karma-devel <linux-karma-devel@lists.sourceforge.net>
Date:   Fri, 11 Dec 2020 07:22:58 -0500
In-Reply-To: <20201211084013.1878-1-zhengyongjun3@huawei.com>
References: <20201211084013.1878-1-zhengyongjun3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.2 (3.38.2-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2020-12-11 at 16:40 +0800, Zheng Yongjun wrote:
> Replace a comma between expression statements by a semicolon.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---
>  fs/omfs/file.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/omfs/file.c b/fs/omfs/file.c
> index 2c7b70ee1388..fc6828f30f60 100644
> --- a/fs/omfs/file.c
> +++ b/fs/omfs/file.c
> @@ -22,8 +22,8 @@ void omfs_make_empty_table(struct buffer_head *bh, int offset)
>  	struct omfs_extent *oe = (struct omfs_extent *) &bh->b_data[offset];
>  
> 
>  	oe->e_next = ~cpu_to_be64(0ULL);
> -	oe->e_extent_count = cpu_to_be32(1),
> -	oe->e_fill = cpu_to_be32(0x22),
> +	oe->e_extent_count = cpu_to_be32(1);
> +	oe->e_fill = cpu_to_be32(0x22);
>  	oe->e_entry.e_cluster = ~cpu_to_be64(0ULL);
>  	oe->e_entry.e_blocks = ~cpu_to_be64(0ULL);
>  }

(cc'ing Bob Copeland and linux-karma mailing list)

Looks fine, but this patch isn't related to ceph in any way. See
Documentation/filesystems/omfs.rst for a description of OMFS.

Cheers,
-- 
Jeff Layton <jlayton@kernel.org>

