Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB05A4B9EE0
	for <lists+ceph-devel@lfdr.de>; Thu, 17 Feb 2022 12:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239920AbiBQLhH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 17 Feb 2022 06:37:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239885AbiBQLhD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 17 Feb 2022 06:37:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 463F924BF9
        for <ceph-devel@vger.kernel.org>; Thu, 17 Feb 2022 03:36:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77840B81E15
        for <ceph-devel@vger.kernel.org>; Thu, 17 Feb 2022 11:36:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3CB0C340E8;
        Thu, 17 Feb 2022 11:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645097802;
        bh=qMGt9bEqOvlNp6WmqAhPNxu4p+5tTF+sAvntsN62zTo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=BArc1uZo697ixGsSs4GBF+EhOoFyaER67RFk4+BQRSGiInDTy5ToxGSZiiiRCZ/zF
         gfd74CVA/PIm4cScXOuwftfwUstsS3K3nWIUPpjsw/7ZnLRYfnTa6g674Gt/ZOzj+f
         IGc5aZ0O/3jxRh6uZ7tD954TRuC3i5yG8yh+NkrLR3ANybmZeQsGlASnjGqnN5Coy4
         3Gqt6LLOhLoy1zS5SXHQbW/XanQAqKQyIpmIg+bMi/BYCPeFXb77/7PokU16cVuXYL
         j3EWvIHkp/bnnxukNKkns46b0Bz86jK+7jR4K+kLu27BzBfRMB+AZuecpc4qKZrYXP
         vAlDqBGyJKd/w==
Message-ID: <dca5b7266df95ecd112023328da936d6724da53b.camel@kernel.org>
Subject: Re: [PATCH] ceph: zero the dir_entries memory when allocating it
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
Date:   Thu, 17 Feb 2022 06:36:40 -0500
In-Reply-To: <20220217081542.21182-1-xiubli@redhat.com>
References: <20220217081542.21182-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2022-02-17 at 16:15 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> This potentially will cause bug in future if using the old ceph
> version and some members may skipped initialized in handle_reply.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/mds_client.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 93e5e3c4ba64..c3b1e73c5fbf 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -2286,7 +2286,8 @@ int ceph_alloc_readdir_reply_buffer(struct ceph_mds_request *req,
>  	order = get_order(size * num_entries);
>  	while (order >= 0) {
>  		rinfo->dir_entries = (void*)__get_free_pages(GFP_KERNEL |
> -							     __GFP_NOWARN,
> +							     __GFP_NOWARN |
> +							     __GFP_ZERO,
>  							     order);
>  		if (rinfo->dir_entries)
>  			break;

Thanks Xiubo. Merged into testing branch.
-- 
Jeff Layton <jlayton@kernel.org>
