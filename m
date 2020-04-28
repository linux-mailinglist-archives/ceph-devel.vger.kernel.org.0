Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 814D01BC1A9
	for <lists+ceph-devel@lfdr.de>; Tue, 28 Apr 2020 16:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbgD1OsN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 28 Apr 2020 10:48:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:44580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727079AbgD1OsM (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 28 Apr 2020 10:48:12 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6680D206B9;
        Tue, 28 Apr 2020 14:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588085292;
        bh=wwPgZNGUMJkBXCHDH1r/tigwDvRty2wH177V7+Ns0W4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Dgod49VSlqxpGshicvovMDfREGpxLC1t6lGRgtZtVHNWglRXLB5qLra42dNrYfBEU
         ebFx9zt28jyyst+DqdIBOZ1AhHY6tDsmF4h7qPSvJgFwLC3asQpUHq07vzjY4t0mDS
         hhq+cfprMCwe7JSaj+rDTDVw0b/+B1bEwr3hFANs=
Message-ID: <e89bd817c69422c85f1945041dd83fbe8d534805.camel@kernel.org>
Subject: Re: [PATCH V2] fs/ceph:fix double unlock in handle_cap_export()
From:   Jeff Layton <jlayton@kernel.org>
To:     Wu Bo <wubo40@huawei.com>, sage@redhat.com, idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        liuzhiqiang26@huawei.com, linfeilong@huawei.com
Date:   Tue, 28 Apr 2020 10:48:10 -0400
In-Reply-To: <1588079622-423774-1-git-send-email-wubo40@huawei.com>
References: <1588079622-423774-1-git-send-email-wubo40@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.1 (3.36.1-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2020-04-28 at 21:13 +0800, Wu Bo wrote:
> if the ceph_mdsc_open_export_target_session() return fails,
> should add a lock to avoid twice unlocking.
> Because the lock will be released at the retry or out_unlock tag.
> 

The problem looks real, but...

> --
> v1 -> v2:
> add spin_lock(&ci->i_ceph_lock) before goto out_unlock tag. 
> 
> Signed-off-by: Wu Bo <wubo40@huawei.com>
> ---
>  fs/ceph/caps.c | 27 +++++++++++++++------------
>  1 file changed, 15 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 185db76..414c0e2 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -3731,22 +3731,25 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
>  
>  	/* open target session */
>  	tsession = ceph_mdsc_open_export_target_session(mdsc, target);
> -	if (!IS_ERR(tsession)) {
> -		if (mds > target) {
> -			mutex_lock(&session->s_mutex);
> -			mutex_lock_nested(&tsession->s_mutex,
> -					  SINGLE_DEPTH_NESTING);
> -		} else {
> -			mutex_lock(&tsession->s_mutex);
> -			mutex_lock_nested(&session->s_mutex,
> -					  SINGLE_DEPTH_NESTING);
> -		}
> -		new_cap = ceph_get_cap(mdsc, NULL);
> -	} else {
> +	if (IS_ERR(tsession)) {
>  		WARN_ON(1);
>  		tsession = NULL;
>  		target = -1;
> +		mutex_lock(&session->s_mutex);
> +		spin_lock(&ci->i_ceph_lock);
> +		goto out_unlock;

Why did you make this case goto out_unlock instead of retrying as it did
before?

> +	}
> +
> +	if (mds > target) {
> +		mutex_lock(&session->s_mutex);
> +		mutex_lock_nested(&tsession->s_mutex,
> +					SINGLE_DEPTH_NESTING);
> +	} else {
> +		mutex_lock(&tsession->s_mutex);
> +		mutex_lock_nested(&session->s_mutex,
> +					SINGLE_DEPTH_NESTING);
>  	}
> +	new_cap = ceph_get_cap(mdsc, NULL);
>  	goto retry;
>  
>  out_unlock:

-- 
Jeff Layton <jlayton@kernel.org>

