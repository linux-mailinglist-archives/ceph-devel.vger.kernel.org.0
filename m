Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68D9A22B4C2
	for <lists+ceph-devel@lfdr.de>; Thu, 23 Jul 2020 19:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729991AbgGWRW7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 23 Jul 2020 13:22:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:46902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726814AbgGWRW7 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 23 Jul 2020 13:22:59 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4870920714;
        Thu, 23 Jul 2020 17:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595524978;
        bh=MoAmf1Myeg0db8BaCfPvVMD6xZai1l4bFIFtixP9k7o=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=C8K5jUGN4lm5puEmLaAeeiHc5RpxPtdHKGGgJ8tUzDsH8FWfhloAW8B24CjslBlQS
         LA8CC5WmFEvL+O/HIjVyvpoqV84OumIpPzWKGD9Z1vQGCg5fFdtztdW8aN3cAguDa1
         RMVqhpX08FKVRdRx74SyAbSlZ81lLw8qTiO8oDiQ=
Message-ID: <cba36614f44285feca178f1936fec8d1eef4b8ac.camel@kernel.org>
Subject: Re: [PATCH] ceph: super.h: delete a duplicated word
From:   Jeff Layton <jlayton@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Date:   Thu, 23 Jul 2020 13:22:56 -0400
In-Reply-To: <20200720001259.21668-1-rdunlap@infradead.org>
References: <20200720001259.21668-1-rdunlap@infradead.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sun, 2020-07-19 at 17:12 -0700, Randy Dunlap wrote:
> Drop the repeated word "the" in a comment.
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Jeff Layton <jlayton@kernel.org>
> Cc: Ilya Dryomov <idryomov@gmail.com>
> Cc: ceph-devel@vger.kernel.org
> ---
>  fs/ceph/super.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-next-20200717.orig/fs/ceph/super.h
> +++ linux-next-20200717/fs/ceph/super.h
> @@ -353,7 +353,7 @@ struct ceph_inode_info {
>  	unsigned i_dirty_caps, i_flushing_caps;     /* mask of dirtied fields */
>  
>  	/*
> -	 * Link to the the auth cap's session's s_cap_dirty list. s_cap_dirty
> +	 * Link to the auth cap's session's s_cap_dirty list. s_cap_dirty
>  	 * is protected by the mdsc->cap_dirty_lock, but each individual item
>  	 * is also protected by the inode's i_ceph_lock. Walking s_cap_dirty
>  	 * requires the mdsc->cap_dirty_lock. List presence for an item can

Thanks, merged into testing branch. If you have more of these, then it
might be good to bundle them up into a fs/ceph-wide patch. There is no
shortage of grammatical errors in fs/ceph so there could be a lot of
these.
-- 
Jeff Layton <jlayton@kernel.org>

