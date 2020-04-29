Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 532121BE2DD
	for <lists+ceph-devel@lfdr.de>; Wed, 29 Apr 2020 17:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgD2Ph1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 29 Apr 2020 11:37:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:56902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726456AbgD2Ph1 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 29 Apr 2020 11:37:27 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C4B5206F0;
        Wed, 29 Apr 2020 15:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588174647;
        bh=OC/uuBry5MdIo9PpQACpMz2esvnupqKlJxtQqhDFs7I=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=hC/poJiU62MLjpG2Eb7UzqyClM21ktkHjXXUTqANwMhgAZ6imhdwolsLl1CoYYafR
         RVkWZyH0JNJmhEvjL2wOxfe0kPAJ85NTi1en9Kghb+R2miMtWserT85WcD1Riis999
         zxUzOy04iwTXsSChHZfXUZswXEc6saoeCpBTwIL4=
Message-ID: <591b050483a0326bbcaf075254a69bfefc77550f.camel@kernel.org>
Subject: Re: [PATCH] fs/ceph:fix speical error code in ceph_try_get_caps()
From:   Jeff Layton <jlayton@kernel.org>
To:     Wu Bo <wubo40@huawei.com>, sage@redhat.com, idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        liuzhiqiang26@huawei.com, linfeilong@huawei.com
Date:   Wed, 29 Apr 2020 11:37:25 -0400
In-Reply-To: <1588125715-188363-1-git-send-email-wubo40@huawei.com>
References: <1588125715-188363-1-git-send-email-wubo40@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.1 (3.36.1-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2020-04-29 at 10:01 +0800, Wu Bo wrote:
> There are 3 speical error codes: -EAGAIN/-EFBIG/-ESTALE.
> After call try_get_cap_refs function, judge the same 
> error code -EAGAIN twice. So corrected the error code of judgment 
> from -EAGAIN to -ESTAE.
> 
> Signed-off-by: Wu Bo <wubo40@huawei.com>
> ---
>  fs/ceph/caps.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 185db76..1a8e20e 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -2749,7 +2749,7 @@ int ceph_try_get_caps(struct inode *inode, int need, int want,
>  
>  	ret = try_get_cap_refs(inode, need, want, 0, flags, got);
>  	/* three special error codes */
> -	if (ret == -EAGAIN || ret == -EFBIG || ret == -EAGAIN)
> +	if (ret == -EAGAIN || ret == -EFBIG || ret == -ESTALE)
>  		ret = 0;
>  	return ret;
>  }

Good catch! Merged into testing branch.
-- 
Jeff Layton <jlayton@kernel.org>

