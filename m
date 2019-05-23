Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E12428B16
	for <lists+ceph-devel@lfdr.de>; Thu, 23 May 2019 21:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387569AbfEWTyH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 23 May 2019 15:54:07 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37498 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387433AbfEWTyH (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 23 May 2019 15:54:07 -0400
Received: by mail-wr1-f66.google.com with SMTP id e15so7585873wrs.4
        for <ceph-devel@vger.kernel.org>; Thu, 23 May 2019 12:54:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=fvaAx5NJqpTjVVMzh0w4jsWxQIInujPlX/QMC91zJgU=;
        b=NPKZC1WDpFmo/3vXM/lET4L4uG7lqrLZvkAbREaeQwSISOEolOvF3KPqsTg/tfRSzf
         hDVM0riAo7FO5J3nstbwpj35O2IK1sqTHusfg+VcfxVfmYTdJ6lM60uKl59BrFHXwFns
         AELz+sJXPKBEB/GG2Q7s1ZCEN4qR3pVHQ25ZgJDZDCbFXXY/LfRiQ4bpfxLPN591T7x2
         /jZdMwgN7iSeMhLQF8da1CId+fFiWbaWoId5t/Q8hD7JBuX08AZDlfI/1sVetbkHNH8S
         rA6jHYjNBSUHX/JFDHPA/Yr9Bmb8DzRxqQmssB8iqS3z2oHehifkUDAnP7tGKfC5SE6X
         wBKA==
X-Gm-Message-State: APjAAAXyrCKqreWGkiDlYwZ5a9HFVITTvNEfjN7/XmAF2TSMvk43prdS
        IvlrG0Ku2g1ql/w9o2sdRiPs4YsnQc+Wrw==
X-Google-Smtp-Source: APXvYqyEnPF+bC8R2fZDTXwA9FJDRjY2kqANqF9A1NxyLV9FhBUVoHLLm0e3MMM/z3EX59vr6JXQ+w==
X-Received: by 2002:a5d:4b8b:: with SMTP id b11mr314084wrt.298.1558641245359;
        Thu, 23 May 2019 12:54:05 -0700 (PDT)
Received: from vulcan ([195.77.194.101])
        by smtp.gmail.com with ESMTPSA id s13sm168188wrw.17.2019.05.23.12.54.04
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 23 May 2019 12:54:04 -0700 (PDT)
Message-ID: <87adb5f621ab39ab637d83df2857a0ee307202bf.camel@redhat.com>
Subject: Re: [PATCH 1/8] ceph: fix error handling in ceph_get_caps()
From:   Jeff Layton <jlayton@redhat.com>
To:     "Yan, Zheng" <zyan@redhat.com>, ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com
Date:   Thu, 23 May 2019 21:54:03 +0200
In-Reply-To: <20190523081345.20410-1-zyan@redhat.com>
References: <20190523081345.20410-1-zyan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2019-05-23 at 16:13 +0800, Yan, Zheng wrote:
> The function return 0 even when interrupted or try_get_cap_refs()
> return error.
> 
> Introduce by commit 1199d7da2d "ceph: simplify arguments and return
> semantics of try_get_cap_refs"
> 

Should change that last paragraph to:

Fixes: 1199d7da2d ("ceph: simplify arguments and return semantics of try_get_cap_refs")

> Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
> ---
>  fs/ceph/caps.c | 22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 72f8e1311392..079d0df9650c 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -2738,15 +2738,13 @@ int ceph_get_caps(struct ceph_inode_info *ci, int need, int want,
>  		_got = 0;
>  		ret = try_get_cap_refs(ci, need, want, endoff,
>  				       false, &_got);
> -		if (ret == -EAGAIN) {
> +		if (ret == -EAGAIN)
>  			continue;
> -		} else if (!ret) {
> -			int err;
> -
> +		if (!ret) {
>  			DEFINE_WAIT_FUNC(wait, woken_wake_function);
>  			add_wait_queue(&ci->i_cap_wq, &wait);
>  
> -			while (!(err = try_get_cap_refs(ci, need, want, endoff,
> +			while (!(ret = try_get_cap_refs(ci, need, want, endoff,
>  							true, &_got))) {
>  				if (signal_pending(current)) {
>  					ret = -ERESTARTSYS;
> @@ -2756,14 +2754,16 @@ int ceph_get_caps(struct ceph_inode_info *ci, int need, int want,
>  			}
>  
>  			remove_wait_queue(&ci->i_cap_wq, &wait);
> -			if (err == -EAGAIN)
> +			if (ret == -EAGAIN)
>  				continue;
>  		}
> -		if (ret == -ESTALE) {
> -			/* session was killed, try renew caps */
> -			ret = ceph_renew_caps(&ci->vfs_inode);
> -			if (ret == 0)
> -				continue;
> +		if (ret < 0) {
> +			if (ret == -ESTALE) {
> +				/* session was killed, try renew caps */
> +				ret = ceph_renew_caps(&ci->vfs_inode);
> +				if (ret == 0)
> +					continue;
> +			}
>  			return ret;
>  		}
>  

Nice catch. The error handling in this function is really nasty. I wish
we could simplify it further. Anyway:

Reviewed-by: Jeff Layton <jlayton@redhat.com>

