Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 354293E14B5
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Aug 2021 14:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241353AbhHEM3q (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 5 Aug 2021 08:29:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:40620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232651AbhHEM3p (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 5 Aug 2021 08:29:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C51D61050;
        Thu,  5 Aug 2021 12:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628166571;
        bh=QbX56RPwAYHxN1u0IvSA+Vtv0+IoQ844PhloK/TF5Oo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=B84d0EqiDaaXgdAtSm0qC5ja3MT9Gt9L906dMU38Nspu6rT0ATEgJ8W2UOhjjGUjC
         CikiMDpPZgb9ghKtXmFAJh0zfYE/dqwwR5kHNKSCPCw+Ngk081XlbWFTQB4aX3Dlsu
         Fe1abJF7+ilTXNrGh2PlBEFE9vKZhZy17cViU0vD6GaQa0OoUX9a+uc6waZOEuOVNv
         298GFdMBkwu2MyupV5zoLpyuPEuB1vXs1bSHqgzgpnJWlQRy3SASCoC08PDIexi/WL
         IxxIT+YiVrZP6HAbckFL++/Ih6pUmKPTmqrkS8SUWyKm6ovB0EiEqstM3Qrjc4Um5j
         gxbzk81l7buHw==
Message-ID: <ea6c827bcef4a0e424641f5eae2e17b2d0d8ebbe.camel@kernel.org>
Subject: Re: [PATCH] ceph: fix possible null-pointer dereference in
 ceph_mdsmap_decode()
From:   Jeff Layton <jlayton@kernel.org>
To:     Tuo Li <islituo@gmail.com>, idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        baijiaju1990@gmail.com, TOTE Robot <oslab@tsinghua.edu.cn>
Date:   Thu, 05 Aug 2021 08:29:30 -0400
In-Reply-To: <20210805122015.129824-1-islituo@gmail.com>
References: <20210805122015.129824-1-islituo@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.3 (3.40.3-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2021-08-05 at 05:20 -0700, Tuo Li wrote:
> kcalloc() is called to allocate memory for m->m_info, and if it fails, 
> ceph_mdsmap_destroy() behind the label out_err will be called:
>   ceph_mdsmap_destroy(m);
> 
> In ceph_mdsmap_destroy(), m->m_info is dereferenced through:
>   kfree(m->m_info[i].export_targets);
> 
> To fix this possible null-pointer dereference, if memory allocation
> for m->m_info fails, free m and return -ENOMEM.
> 
> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> Signed-off-by: Tuo Li <islituo@gmail.com>
> ---
>  fs/ceph/mdsmap.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
> index abd9af7727ad..7d73e4b64b12 100644
> --- a/fs/ceph/mdsmap.c
> +++ b/fs/ceph/mdsmap.c
> @@ -166,8 +166,10 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end, bool msgr2)
>  	m->possible_max_rank = max(m->m_num_active_mds, m->m_max_mds);
>  
>  	m->m_info = kcalloc(m->possible_max_rank, sizeof(*m->m_info), GFP_NOFS);
> -	if (!m->m_info)
> -		goto nomem;
> +	if (!m->m_info) {
> +		kfree(m);
> +		return ERR_PTR(-ENOMEM);
> +	}
>  
>  	/* pick out active nodes from mds_info (state > 0) */
>  	for (i = 0; i < n; i++) {

Good catch. This function is already pretty complex. How about we
instead fix this in ceph_mdsmap_destroy and make it safe to call that
with the mdsmap in this state?

Basically, just put an "if (m->m_info)" around the for loop in that
function. Sound ok?

-- 
Jeff Layton <jlayton@kernel.org>

