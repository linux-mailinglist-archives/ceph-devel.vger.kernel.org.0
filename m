Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9DF12106A
	for <lists+ceph-devel@lfdr.de>; Mon, 16 Dec 2019 18:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbfLPRAB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 16 Dec 2019 12:00:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:40456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725805AbfLPRAB (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 16 Dec 2019 12:00:01 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54094206D7;
        Mon, 16 Dec 2019 17:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576515600;
        bh=Ovj5NtJVKIZMcZHrLq/DmUrqCFO+7qT4dPp4dFUjVrk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kVwqdsiJaSsWet5nfRMOHnRCcJd0BHGvbIy/zDyGKRuiplAO4V+A6IVDTYhqln1RU
         s3S3ZSjZPsPnkDMROiIEUIk60B7S/e1fawpnhx+Hn74lBZCoKLQNdxoLtihLKRdG3R
         xV0gTfrfNk0Qg0KFGYH2H1n/EbhflfEldgj/ZDpA=
Message-ID: <25f84c45d05723efe48a5b5641cc16cc6e635fb5.camel@kernel.org>
Subject: Re: [PATCH] ceph: only touch the caps which have the subset mask
 requested
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Mon, 16 Dec 2019 11:59:58 -0500
In-Reply-To: <20191216051207.8667-1-xiubli@redhat.com>
References: <20191216051207.8667-1-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2019-12-16 at 00:12 -0500, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> For the caps having no any subset mask requested we shouldn't touch
> them.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/caps.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 1d7f66902b0a..b9e5960df183 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -908,7 +908,8 @@ int __ceph_caps_issued_mask(struct ceph_inode_info *ci, int mask, int touch)
>  						       ci_node);
>  					if (!__cap_is_valid(cap))
>  						continue;
> -					__touch_cap(cap);
> +					if (cap->issued & mask)
> +						__touch_cap(cap);
>  				}
>  			}
>  			return 1;

Looks correct to me. Merged.

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>

