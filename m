Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D029050E9D2
	for <lists+ceph-devel@lfdr.de>; Mon, 25 Apr 2022 21:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245068AbiDYUAs (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 25 Apr 2022 16:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238495AbiDYUAr (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 25 Apr 2022 16:00:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8DE06D38A
        for <ceph-devel@vger.kernel.org>; Mon, 25 Apr 2022 12:57:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5EC3DB81A2F
        for <ceph-devel@vger.kernel.org>; Mon, 25 Apr 2022 19:57:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84995C385A4;
        Mon, 25 Apr 2022 19:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650916660;
        bh=ptDvhYh5wdc8nluYoMQJUAL4LGS0qnTdDtBiqmU/nwg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=iSQSwLGp5smj/Pm0c9Jxb92347kKGEY2s8ad9Fl6zB+SDyw7tnd8b39K9vd7hvVt5
         O2/z+zzD142hkQYjTL+ObpBDTdMxSZ0K2iqp3r4N/IRpLapsUgAgEjwqI9xqsu5hZ9
         SBSJ+vZMDJ/HboC+sp5He93jIVmF7i/2PkPE8CipBS7sl2EwOFYsVqlnc8zbsJHllP
         GpJfTQxNiJazBjYxkT4c1BFpE35lTKXjhhVE1n82hTKyPP953DHd7bkjI0EY/SN942
         64cxZ/f59QIN/Doi2sIZNNm+jc1qCEnzy87HyC0vkNid0Hw/fnTRs74CxCSpTeYzyL
         SGPJFOc4IYusg==
Message-ID: <0263808c24d40c8672b17805327c585fe4b08703.camel@kernel.org>
Subject: Re: [PATCH] ceph: fix setting of xattrs on async created inodes
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org,
        John Fortin <fortinj66@gmail.com>,
        Sri Ramanujam <sri@ramanujam.io>
Date:   Mon, 25 Apr 2022 15:57:36 -0400
In-Reply-To: <20220425195427.60738-1-jlayton@kernel.org>
References: <20220425195427.60738-1-jlayton@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2022-04-25 at 15:54 -0400, Jeff Layton wrote:
> Currently when we create a file, we spin up an xattr buffer to send
> along with the create request. If we end up doing an async create
> however, then we currently pass down a zero-length xattr buffer.
> 
> Fix the code to send down the xattr buffer in req->r_pagelist. If the
> xattrs span more than a page, however give up and don't try to do an
> async create.
> 
> Fixes: 9a8d03ca2e2c ("ceph: attempt to do async create when possible")
> URL: https://bugzilla.redhat.com/show_bug.cgi?id=2063929
> Reported-by: John Fortin <fortinj66@gmail.com>
> Reported-by: Sri Ramanujam <sri@ramanujam.io>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/file.c | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 6c9e837aa1d3..8c8226c0feac 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -629,9 +629,15 @@ static int ceph_finish_async_create(struct inode *dir, struct dentry *dentry,
>  	iinfo.change_attr = 1;
>  	ceph_encode_timespec64(&iinfo.btime, &now);
>  
> -	iinfo.xattr_len = ARRAY_SIZE(xattr_buf);
> -	iinfo.xattr_data = xattr_buf;
> -	memset(iinfo.xattr_data, 0, iinfo.xattr_len);
> +	if (req->r_pagelist) {
> +		iinfo.xattr_len = req->r_pagelist->length;
> +		iinfo.xattr_data = req->r_pagelist->mapped_tail;
> +	} else {
> +		/* fake it */
> +		iinfo.xattr_len = ARRAY_SIZE(xattr_buf);
> +		iinfo.xattr_data = xattr_buf;
> +		memset(iinfo.xattr_data, 0, iinfo.xattr_len);
> +	}
>  
>  	in.ino = cpu_to_le64(vino.ino);
>  	in.snapid = cpu_to_le64(CEPH_NOSNAP);
> @@ -743,6 +749,10 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
>  		err = ceph_security_init_secctx(dentry, mode, &as_ctx);
>  		if (err < 0)
>  			goto out_ctx;
> +		/* Async create can't handle more than a page of xattrs */
> +		if (as_ctx.pagelist &&
> +		    !list_is_singular(&as_ctx.pagelist->head))
> +			try_async = false;
>  	} else if (!d_in_lookup(dentry)) {
>  		/* If it's not being looked up, it's negative */
>  		return -ENOENT;

Oh, I meant to mark this for stable as well. Xiubo, can you do that when
you merge it?

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>
