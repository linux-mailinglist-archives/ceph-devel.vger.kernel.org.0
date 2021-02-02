Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DFC730BE5F
	for <lists+ceph-devel@lfdr.de>; Tue,  2 Feb 2021 13:39:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbhBBMim (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 2 Feb 2021 07:38:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:48408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229632AbhBBMij (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 2 Feb 2021 07:38:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BEE464F45;
        Tue,  2 Feb 2021 12:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612269479;
        bh=je7dIPClMfEtrD5fgHTYPSeqcK3b36ynb6JnzcnLc1U=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=e0ewikM4GzYN/eYGmoXngOU7BX26Ij2Duy9cY5RBRz82KcYV4UfBwdJNtrfdo8kdG
         FE92ic6pljglF/t7+GvXGQauQ3103HjWQcaWFmCfk7dmw9W+mY7HLFpqZJiOWCSGcE
         8Kr+97CNKjFzs1VmQl3bJOMhxdvihjioKQmoYMf1m2bfGHjMZrPR+UHMxUHBWhFuXW
         AtqVtCtlpqWXqnMM5XSWOaGCKtdjGTR/yyPS2S46fMrS+TQb2hrfkhZfVvD20Wp1rr
         BQba9rezRzxVV6Os0ohFe+xM+NUHWQuIT9pxtVAwbHSwqAmAe379WIzwSHO4liR+pW
         PdBMg4awhwS7w==
Message-ID: <f0477211cafbdc24883e978ab976610333f5fb67.camel@kernel.org>
Subject: Re: [PATCH] ceph: Fix an Oops in error handling
From:   Jeff Layton <jlayton@kernel.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        David Howells <dhowells@redhat.com>
Cc:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Date:   Tue, 02 Feb 2021 07:37:57 -0500
In-Reply-To: <YBjne8A1gn0mvQtT@mwanda>
References: <YBjne8A1gn0mvQtT@mwanda>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2021-02-02 at 08:47 +0300, Dan Carpenter wrote:
> The "req" pointer is an error pointer and not NULL so this check needs
> to be fixed.
> 
> Fixes: 1cf7fdf52d5a ("ceph: convert readpage to fscache read helper")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  fs/ceph/addr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 5eec6f66fe52..fb0238a4d34f 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -273,7 +273,7 @@ static void ceph_netfs_issue_op(struct netfs_read_subrequest *subreq)
>  	if (err)
>  		iput(inode);
>  out:
> -	if (req)
> +	if (!IS_ERR_OR_NULL(req))
>  		ceph_osdc_put_request(req);
>  	if (err)
>  		netfs_subreq_terminated(subreq, err);

Good catch.

David, could you take this into your fscache-next branch?

Reviewed-by: Jeff Layton <jlayton@kernel.org>

