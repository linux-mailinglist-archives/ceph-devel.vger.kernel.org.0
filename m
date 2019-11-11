Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF84F790F
	for <lists+ceph-devel@lfdr.de>; Mon, 11 Nov 2019 17:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbfKKQpp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 11 Nov 2019 11:45:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:52966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726857AbfKKQpp (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 11 Nov 2019 11:45:45 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3F7D20674;
        Mon, 11 Nov 2019 16:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573490744;
        bh=RBhgo9z/AfilK3UOedFccvG6QZkiFBc8bmBPpj1bUxo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=rzAydZNp45ItdHZTfXTwUB8dgzVKdZIJO4oSkQggPwRLPdaXIZO/icSJg/CwmxUHd
         yzflfTPX7Q326sqoS+iUguwGuCA9tNFQ07vFJE0OTTj6ubHVUX0pQBxBQy103CLTU7
         to8vDCz2cXSX5XLVrvK8VkGn/uVH5hyQedk4Ujuc=
Message-ID: <e5e82873c841d21c84658253d331c1ab04851dfa.camel@kernel.org>
Subject: Re: [PATCH] ceph: fix geting random mds from mdsmap
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, sage@redhat.com, idryomov@gmail.com
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Mon, 11 Nov 2019 11:45:42 -0500
In-Reply-To: <20191111115105.58758-1-xiubli@redhat.com>
References: <20191111115105.58758-1-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1 (3.34.1-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2019-11-11 at 06:51 -0500, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> For example, if we have 5 mds in the mdsmap and the states are:
> m_info[5] --> [-1, 1, -1, 1, 1]
> 
> If we get a ramdon number 1, then we should get the mds index 3 as
> expected, but actually we will get index 2, which the state is -1.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/mdsmap.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
> index ce2d00da5096..2011147f76bf 100644
> --- a/fs/ceph/mdsmap.c
> +++ b/fs/ceph/mdsmap.c
> @@ -20,7 +20,7 @@
>  int ceph_mdsmap_get_random_mds(struct ceph_mdsmap *m)
>  {
>  	int n = 0;
> -	int i;
> +	int i, j;
>  
>  	/* special case for one mds */
>  	if (1 == m->m_num_mds && m->m_info[0].state > 0)
> @@ -35,9 +35,12 @@ int ceph_mdsmap_get_random_mds(struct ceph_mdsmap *m)
>  
>  	/* pick */
>  	n = prandom_u32() % n;
> -	for (i = 0; n > 0; i++, n--)
> -		while (m->m_info[i].state <= 0)
> -			i++;
> +	for (j = 0, i = 0; i < m->m_num_mds; i++) {
> +		if (m->m_info[0].state > 0)
> +			j++;
> +		if (j > n)
> +			break;
> +	}
>  
>  	return i;
>  }

Looks good. I'll merge after some testing.

Took me a minute but the crux of the issue is that the for loop
increment gets done regardless of the outcome of the while loop test.

This looks nicer too. I don't think it's actually possible, but the
while loop _looks_ like it could walk off the end of the array.

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>

