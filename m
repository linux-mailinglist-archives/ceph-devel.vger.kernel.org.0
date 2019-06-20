Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3DA4D1C4
	for <lists+ceph-devel@lfdr.de>; Thu, 20 Jun 2019 17:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731891AbfFTPMC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 20 Jun 2019 11:12:02 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:41115 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726512AbfFTPMC (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 20 Jun 2019 11:12:02 -0400
Received: by mail-yb1-f194.google.com with SMTP id d2so1360332ybh.8
        for <ceph-devel@vger.kernel.org>; Thu, 20 Jun 2019 08:12:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=vzm5L8LbaE5LSgznEFXWKvVaLm+iasYXMyY2Uer9g1w=;
        b=uAPSnZha3x8FROoDQtsuHqnT00xJ/2E2cZjD87lkywIYR0LRm9+H676gRSyLfD7Dp7
         5MXsAR6HNl79NrdY/AlxFiPafHBce3U1/575MmgprRaDr3wTKKPg3vjEbTySJO0hP2JX
         jiu3g0pP9H4XJqVPJCz6fFxeuN0JLj9AdR37uyJW5GBGvjPN0i2y84C294EYsNUIpHeQ
         lXNx+s0WkqXSps8jvxgGBYylKJJz4jG3gKfOzH+QnVkm7a1Lo9iO6IQ4ZnqWx+9XeXLy
         u7FND9VYkMpDVOqLeekT5XMM4BhJzdsRNESHvS7B8Ced3if1o1BGx9Cc4KmN1gp6YwqB
         2fqQ==
X-Gm-Message-State: APjAAAX/Z3IxRkm+Y/ez1Jh9JsxkYovVYr2YuTzh2Tj2e3qQrzyNOz+c
        Cjs8jvDgqvNjLWFVLnWQGYSMdg==
X-Google-Smtp-Source: APXvYqx0o25RXMnhT/vRj/av/hzpj++Ozf/XH6JDsov1+23gdujnfnpEuxmT3n1r9AatsF68oTco5g==
X-Received: by 2002:a25:8743:: with SMTP id e3mr24594006ybn.25.1561043521156;
        Thu, 20 Jun 2019 08:12:01 -0700 (PDT)
Received: from tleilax.poochiereds.net (cpe-2606-A000-1100-37D-0-0-0-5C3.dyn6.twc.com. [2606:a000:1100:37d::5c3])
        by smtp.gmail.com with ESMTPSA id e14sm1942131ywa.23.2019.06.20.08.12.00
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 20 Jun 2019 08:12:00 -0700 (PDT)
Message-ID: <33a2c6208857401c406a398bc41d22228e9a3fc4.camel@redhat.com>
Subject: Re: [PATCH 2/3] ceph: kick flushing and flush snaps before sending
 normal cap message
From:   Jeff Layton <jlayton@redhat.com>
To:     "Yan, Zheng" <zyan@redhat.com>, ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com
Date:   Thu, 20 Jun 2019 11:11:58 -0400
In-Reply-To: <20190620132821.7814-2-zyan@redhat.com>
References: <20190620132821.7814-1-zyan@redhat.com>
         <20190620132821.7814-2-zyan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2019-06-20 at 21:28 +0800, Yan, Zheng wrote:
> Othweise client may send cap flush messages in wrong order.
> 

"Otherwise"

> Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
> ---
>  fs/ceph/caps.c | 18 ++++++++++++++----
>  1 file changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index cd946bca4792..82cfb153d0f3 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -2119,6 +2119,7 @@ static int try_flush_caps(struct inode *inode, u64 *ptid)
>  
>  retry:
>  	spin_lock(&ci->i_ceph_lock);
> +retry_locked:
>  	if (ci->i_ceph_flags & CEPH_I_NOFLUSH) {
>  		spin_unlock(&ci->i_ceph_lock);
>  		dout("try_flush_caps skipping %p I_NOFLUSH set\n", inode);
> @@ -2126,8 +2127,6 @@ static int try_flush_caps(struct inode *inode, u64 *ptid)
>  	}
>  	if (ci->i_dirty_caps && ci->i_auth_cap) {
>  		struct ceph_cap *cap = ci->i_auth_cap;
> -		int used = __ceph_caps_used(ci);
> -		int want = __ceph_caps_wanted(ci);
>  		int delayed;
>  
>  		if (!session || session != cap->session) {
> @@ -2143,13 +2142,24 @@ static int try_flush_caps(struct inode *inode, u64 *ptid)
>  			goto out;
>  		}
>  
> +		if (ci->i_ceph_flags &
> +		    (CEPH_I_KICK_FLUSH | CEPH_I_FLUSH_SNAPS)) {
> +			if (ci->i_ceph_flags & CEPH_I_KICK_FLUSH)
> +				__kick_flushing_caps(mdsc, session, ci, 0);
> +			if (ci->i_ceph_flags & CEPH_I_FLUSH_SNAPS)
> +				__ceph_flush_snaps(ci, session);
> +			goto retry_locked;
> +		}
> +
>  		flushing = __mark_caps_flushing(inode, session, true,
>  						&flush_tid, &oldest_flush_tid);
>  
>  		/* __send_cap drops i_ceph_lock */
>  		delayed = __send_cap(mdsc, cap, CEPH_CAP_OP_FLUSH, true,
> -				used, want, (cap->issued | cap->implemented),
> -				flushing, flush_tid, oldest_flush_tid);
> +				     __ceph_caps_used(ci),
> +				     __ceph_caps_wanted(ci),
> +				     (cap->issued | cap->implemented),
> +				     flushing, flush_tid, oldest_flush_tid);
>  
>  		if (delayed) {
>  			spin_lock(&ci->i_ceph_lock);

This set looks good to me (aside from typo in the commit message in this
patch). You can add this to all 3:

Reviewed-by: Jeff Layton <jlayton@redhat.com>

