Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D67403E1C99
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Aug 2021 21:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbhHET0K (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 5 Aug 2021 15:26:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:44460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229578AbhHET0J (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 5 Aug 2021 15:26:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE8A860D07;
        Thu,  5 Aug 2021 19:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628191555;
        bh=k8L/Ltlw63soxka83qnmxC/gaq+y1TowO7Y0MWuG5h0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Hjmutc8VKaQIMGpTtCDm9S6zpTXcSnJDiB+9Rhx0w/oIjC6n4qCtYJt1qZm4Sq4h2
         gVIkqT1nDncR2y+LxKX6jY5/TV3M/WVAsfBoYd9MgsvBCXHHBz5wmCsEcchtUGVswM
         vNJalVWzjkfIXgpjx9jKwHDag4HJTIGRoYP+OetGwgb/rO6DMBmR/4nX93ZD3yVm+s
         9tVuQmUYcnjiDpj4SElNNbagybJJOoqCAEme7mtdqcDg1yUnDj6nUwwJGEqMQAnHfO
         U1SlMGQ9+RBbGopftCmChU3xG0yqAtfR5Nh4clQ63a+2btitZ+692pIoZ1m+trAqUe
         3gL2QRXCWfQ0Q==
Message-ID: <ce95d07e585ce8ff184c26c9b26c8211921f1546.camel@kernel.org>
Subject: Re: [PATCH v2] ceph: fix possible null-pointer dereference in
 ceph_mdsmap_decode()
From:   Jeff Layton <jlayton@kernel.org>
To:     Tuo Li <islituo@gmail.com>, idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        baijiaju1990@gmail.com, TOTE Robot <oslab@tsinghua.edu.cn>
Date:   Thu, 05 Aug 2021 15:25:53 -0400
In-Reply-To: <20210805151434.142619-1-islituo@gmail.com>
References: <20210805151434.142619-1-islituo@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.3 (3.40.3-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2021-08-05 at 08:14 -0700, Tuo Li wrote:
> kcalloc() is called to allocate memory for m->m_info, and if it fails,
> ceph_mdsmap_destroy() behind the label out_err will be called:
>   ceph_mdsmap_destroy(m);
> 
> In ceph_mdsmap_destroy(), m->m_info is dereferenced through:
>   kfree(m->m_info[i].export_targets);
> 
> To fix this possible null-pointer dereference, check m->m_info before the 
> for loop to free m->m_info[i].export_targets.
> 
> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> Signed-off-by: Tuo Li <islituo@gmail.com>
> ---
> v2:
> * Put an "if (m->m_info)" around the for loop in ceph_mdsmap_destroy()
> instead of freeing m and returning -ENOMEM in ceph_mdsmap_decode().
>   Thank Jeff Layton for helpful advice.
> ---
>  fs/ceph/mdsmap.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
> index abd9af7727ad..26d6fa049b44 100644
> --- a/fs/ceph/mdsmap.c
> +++ b/fs/ceph/mdsmap.c
> @@ -393,9 +393,11 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end, bool msgr2)
>  void ceph_mdsmap_destroy(struct ceph_mdsmap *m)
>  {
>  	int i;
> -
> -	for (i = 0; i < m->possible_max_rank; i++)
> -		kfree(m->m_info[i].export_targets);
> +	

This patch added some whitespace damage above. I went ahead and fixed it
up before merging.

> +	if (m->m_info) {
> +		for (i = 0; i < m->possible_max_rank; i++)
> +			kfree(m->m_info[i].export_targets);
> +	}
>  	kfree(m->m_info);

I also moved the above kfree into the if statement since we have to
check it anyway (no need to do it twice).

>  	kfree(m->m_data_pg_pools);
>  	kfree(m);

Merged! Thanks for the patch.
-- 
Jeff Layton <jlayton@kernel.org>

