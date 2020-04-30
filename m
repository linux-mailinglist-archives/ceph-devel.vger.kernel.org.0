Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32CE41BF7E4
	for <lists+ceph-devel@lfdr.de>; Thu, 30 Apr 2020 14:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgD3MIO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 30 Apr 2020 08:08:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:54864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725280AbgD3MIN (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 30 Apr 2020 08:08:13 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F5CC20757;
        Thu, 30 Apr 2020 12:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588248493;
        bh=kWOGUQ0nG1s+NuJ1r/jm6uWAthHvmvis6ImwgfOZ0Oo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=06ohClEHa8gjHByrmWUMex5YFbqSOgrWESvizUEiFusaI36u0Nz8yqPmycvRYkj2F
         uuG+zHHb2jc3mnUuKv0w9CXM6HkXWumWoSFF7Wgik+23c7dEwSA665aMObscPnjP06
         7z/6yGJLbkIkNiKkWMtWGdCY+AGEQNQgzDdM9r+Y=
Message-ID: <c6e346d75a29d05057bdabd0007b71b55b7b3bb3.camel@kernel.org>
Subject: Re: [PATCH V3] fs/ceph:fix double unlock in handle_cap_export()
From:   Jeff Layton <jlayton@kernel.org>
To:     Wu Bo <wubo40@huawei.com>, ukernel@gmail.com, sage@redhat.com,
        idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        liuzhiqiang26@huawei.com, linfeilong@huawei.com
Date:   Thu, 30 Apr 2020 08:08:11 -0400
In-Reply-To: <1588227169-83237-1-git-send-email-wubo40@huawei.com>
References: <1588227169-83237-1-git-send-email-wubo40@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.1 (3.36.1-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2020-04-30 at 14:12 +0800, Wu Bo wrote:
> If the ceph_mdsc_open_export_target_session() return fails,
> we should add mutex_lock(&session->s_mutex) on IS_ERR(tsession) block 
> to avoid twice unlocking. because the session->s_mutex will be unlock
> at the out_unlock lable.
> 
> --
> v2 -> v3:
>   - Rewrite solution, adding a mutex_lock(&session->s_mutex) 
>     to the IS_ERR(tsession) block.
>   - Modify the comment more clearly.
> v1 -> v2:
>   - add spin_lock(&ci->i_ceph_lock) before goto out_unlock lable
> 

For future reference, notes like this should go a little lower...

>      
> 
> Signed-off-by: Wu Bo <wubo40@huawei.com>
> ---
>  fs/ceph/caps.c | 1 +
>  1 file changed, 1 insertion(+)
> 

If you put the patch version notes here, they'll be stripped out when we
go to merge the patch with git-am.

> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 185db76..d27d778 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -3746,6 +3746,7 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
>  		WARN_ON(1);
>  		tsession = NULL;
>  		target = -1;
> +		mutex_lock(&session->s_mutex);
>  	}
>  	goto retry;
>  

Looks good. Merged, but I did clean up the verbiage in the changelog a
bit.

Thanks!
-- 
Jeff Layton <jlayton@kernel.org>

