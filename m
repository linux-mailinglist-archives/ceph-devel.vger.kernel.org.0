Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70797354184
	for <lists+ceph-devel@lfdr.de>; Mon,  5 Apr 2021 13:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234725AbhDELav (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 5 Apr 2021 07:30:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:57698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230032AbhDELav (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 5 Apr 2021 07:30:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC15261396;
        Mon,  5 Apr 2021 11:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617622245;
        bh=644wLsiyhmsNNPlQd3aQ3jscDJhD6OAHXLXZ8TpcJAs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kpijAVEgF+ZDF8apwUfekjiL427jn4dexQI8E2MWdONaOZTDDliH1jhcud162w/bE
         r1BTNS/5ygOtw5gFBK9iGxj3WIy4NsA66MbDkYig/5GUhigFphmgrE/yGy8O7SYqVo
         dDXBZ7gtafVBlIDpoMSgomhj7EuAttg/fqq//0lWa8vrBpT0Pkh8Y8C304CaNpD7qf
         +oBOAP0WEXNDmmIXNW8W0hRJ9gSWlP+giPrVg8gslBw1XzotABAP7pNFvu+fLgpA+e
         zshRcWF/AvtGN+9ukT4VYIKwoqb2V6iYq5gcduffTDKUMqXRAbTJQ95xeDTKNWKcVa
         ib/lfh3uL64Rw==
Message-ID: <0d8435629047c4aa1820e51730273eb615a6aaa1.camel@kernel.org>
Subject: Re: [PATCH] ceph: fix a typo in comments
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Mon, 05 Apr 2021 07:30:43 -0400
In-Reply-To: <20210329045904.135183-1-xiubli@redhat.com>
References: <20210329045904.135183-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2021-03-29 at 12:59 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/addr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 57c67180ce5c..5b66f17afe0c 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -1945,7 +1945,7 @@ int ceph_pool_perm_check(struct inode *inode, int need)
>  	if (ci->i_vino.snap != CEPH_NOSNAP) {
>  		/*
>  		 * Pool permission check needs to write to the first object.
> -		 * But for snapshot, head of the first object may have alread
> +		 * But for snapshot, head of the first object may have already
>  		 * been deleted. Skip check to avoid creating orphan object.
>  		 */
>  		return 0;

In general, I don't like to merge patches that just change comments
without other substantive changes. I did make an exception in this
patch:

    [PATCH 1/2] ceph: fix kerneldoc copypasta over ceph_start_io_direct

...but that was mainly because that was generating a warning at build-
time for me. I'm going to drop this patch for now.

Cheers,
-- 
Jeff Layton <jlayton@kernel.org>

