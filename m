Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E472344C8E3
	for <lists+ceph-devel@lfdr.de>; Wed, 10 Nov 2021 20:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232690AbhKJTU6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 10 Nov 2021 14:20:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:36614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231779AbhKJTU6 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 10 Nov 2021 14:20:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A773261168;
        Wed, 10 Nov 2021 19:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636571890;
        bh=LXU/esZJGB+KQFbf9JKHpGkmH0pl4AmkQrIGTsJ3TMw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=VFD4vzXNDEFqnkkU3bGonFvBRiC4SABWFVPUIihUGLUhu+f9drPM+nozrZTLHkQ1L
         droHspDK9FJBPyuUY70VOhmA3UxZ7kgjPyNrhYH1URz3SnFK/J8opgXNbX2Fzz/6ce
         1DctIH+Yc3YwN2YpKkXBLMw1+qvSkFT9z/pj6+SaPxOrO7zO6UhRoffzKJg+s6A3iG
         u0MBZt/2rNsckDuqRRQR4CJogdjF2Wk+DtuOzVl2FG3il4GshIeqIBAgTLbNe0fsJU
         0jnZ5nmFBdAa1cl3WGgUrnEd9WXz8P8FOjwSi67ygYV1Zva0dMkf2FcXZfa3bbMRXq
         m6vktX24PcrFA==
Message-ID: <78ab5165b0db3a343e0457ec44dfdabfd68a538e.camel@kernel.org>
Subject: Re: [PATCH v2 1/1] ceph: Fix incorrect statfs report for small quota
From:   Jeff Layton <jlayton@kernel.org>
To:     khiremat@redhat.com
Cc:     pdonnell@redhat.com, idryomov@gmail.com, xiubli@redhat.com,
        vshankar@redhat.com, ceph-devel@vger.kernel.org
Date:   Wed, 10 Nov 2021 14:18:08 -0500
In-Reply-To: <20211110180021.20876-2-khiremat@redhat.com>
References: <20211110180021.20876-1-khiremat@redhat.com>
         <20211110180021.20876-2-khiremat@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2021-11-10 at 23:30 +0530, khiremat@redhat.com wrote:
> From: Kotresh HR <khiremat@redhat.com>
> 
> Problem:
> The statfs reports incorrect free/available space
> for quota less then CEPH_BLOCK size (4M).
> 
> Solution:
> For quota less than CEPH_BLOCK size, smaller block
> size of 4K is used. But if quota is less than 4K,
> it is decided to go with binary use/free of 4K
> block. For quota size less than 4K size, report the
> total=used=4K,free=0 when quota is full and
> total=free=4K,used=0 otherwise.
> 
> Signed-off-by: Kotresh HR <khiremat@redhat.com>
> ---
>  fs/ceph/quota.c | 14 ++++++++++++++
>  fs/ceph/super.h |  1 +
>  2 files changed, 15 insertions(+)
> 
> diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
> index 620c691af40e..24ae13ea2241 100644
> --- a/fs/ceph/quota.c
> +++ b/fs/ceph/quota.c
> @@ -494,10 +494,24 @@ bool ceph_quota_update_statfs(struct ceph_fs_client *fsc, struct kstatfs *buf)
>  		if (ci->i_max_bytes) {
>  			total = ci->i_max_bytes >> CEPH_BLOCK_SHIFT;
>  			used = ci->i_rbytes >> CEPH_BLOCK_SHIFT;
> +			/* For quota size less than 4MB, use 4KB block size */
> +			if (!total) {
> +				total = ci->i_max_bytes >> CEPH_4K_BLOCK_SHIFT;
> +				used = ci->i_rbytes >> CEPH_4K_BLOCK_SHIFT;
> +	                        buf->f_frsize = 1 << CEPH_4K_BLOCK_SHIFT;
> +			}
>  			/* It is possible for a quota to be exceeded.
>  			 * Report 'zero' in that case
>  			 */
>  			free = total > used ? total - used : 0;
> +			/* For quota size less than 4KB, report the
> +			 * total=used=4KB,free=0 when quota is full
> +			 * and total=free=4KB, used=0 otherwise */
> +			if (!total) {
> +				total = 1;
> +				free = ci->i_max_bytes > ci->i_rbytes ? 1 : 0;
> +	                        buf->f_frsize = 1 << CEPH_4K_BLOCK_SHIFT;
> +			}

We really ought to have the MDS establish a floor for the quota size.
<4k quota seems ridiculous.

>  		}
>  		spin_unlock(&ci->i_ceph_lock);
>  		if (total) {
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index ed51e04739c4..387ee33894db 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -32,6 +32,7 @@
>   * large volume sizes on 32-bit machines. */
>  #define CEPH_BLOCK_SHIFT   22  /* 4 MB */
>  #define CEPH_BLOCK         (1 << CEPH_BLOCK_SHIFT)
> +#define CEPH_4K_BLOCK_SHIFT 12  /* 4 KB */
>  
>  #define CEPH_MOUNT_OPT_CLEANRECOVER    (1<<1) /* auto reonnect (clean mode) after blocklisted */
>  #define CEPH_MOUNT_OPT_DIRSTAT         (1<<4) /* `cat dirname` for stats */

This looks good, Kotresh. Nice work. I'll plan to merge this into
testing in the near term.

Before we merge this into mainline though, it would be good to have a
testcase that ensures that this works like we expect with these small
quotas.

Could you write something for teuthology?

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>
