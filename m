Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE114865CB
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Jan 2022 15:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239939AbiAFOIB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 6 Jan 2022 09:08:01 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36302 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbiAFOIA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 6 Jan 2022 09:08:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 36C2761C4F
        for <ceph-devel@vger.kernel.org>; Thu,  6 Jan 2022 14:08:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F5BDC36AE0;
        Thu,  6 Jan 2022 14:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641478079;
        bh=ZOqEHCc9kY1yIZQZlnd1EzGKSn2QzFZO41wcUuwSwP8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=LN/UdIla1OX020rNsYxUsmYKPb5XhwEU56jCK2nb0mPGbK5Vm6HWIquSiEmnXTGTB
         yQT2zHmBpZPdGSBMniF/XUamJ6v6FU1pmqV3kM29WSUujBgkfSFtjq73SWlnMBH2dr
         Ky8rhgietH2WJ973tQfS6d0s4FUWacNEvHkgf8eYeMsHHabKIxbhxEUg0BgWe8sfCv
         Z/jtJeKytJOxfU2NdQmJDdbdqDQkrIcSIH+JFsjOgot6Zv0FmzqBIA7Q+spOuD3PtE
         eJHNlAvuWgoruoJTGhousTxBUit65/kkIV7RCPtbYNYjY5VTa6WlyNzm3os+t7qK64
         zItDmob9/zP8A==
Message-ID: <9b257302ab29dcf50a45ac25f51ac314fec493c7.camel@kernel.org>
Subject: Re: [PATCH] ceph: remove redundant Lsx caps check
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
Date:   Thu, 06 Jan 2022 09:07:58 -0500
In-Reply-To: <20220106013552.1141633-1-xiubli@redhat.com>
References: <20220106013552.1141633-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.2 (3.42.2-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2022-01-06 at 09:35 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> The newcaps has already included the Ls, no need to check it again.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/caps.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 1f1a1c6987ce..d68f04ec147d 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -3451,8 +3451,7 @@ static void handle_cap_grant(struct inode *inode,
>  	if ((newcaps & CEPH_CAP_LINK_SHARED) &&
>  	    (extra_info->issued & CEPH_CAP_LINK_EXCL) == 0) {
>  		set_nlink(inode, le32_to_cpu(grant->nlink));
> -		if (inode->i_nlink == 0 &&
> -		    (newcaps & (CEPH_CAP_LINK_SHARED | CEPH_CAP_LINK_EXCL)))
> +		if (inode->i_nlink == 0)
>  			deleted_inode = true;
>  	}
>  

Good catch. Merged into testing branch. It should make v5.17.

Thanks!
-- 
Jeff Layton <jlayton@kernel.org>
