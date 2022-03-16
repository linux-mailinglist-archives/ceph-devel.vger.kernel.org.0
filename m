Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA21E4DAF1E
	for <lists+ceph-devel@lfdr.de>; Wed, 16 Mar 2022 12:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350892AbiCPLvv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 16 Mar 2022 07:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345724AbiCPLvu (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 16 Mar 2022 07:51:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F03705C871
        for <ceph-devel@vger.kernel.org>; Wed, 16 Mar 2022 04:50:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 844D8616F4
        for <ceph-devel@vger.kernel.org>; Wed, 16 Mar 2022 11:50:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B626C340E9;
        Wed, 16 Mar 2022 11:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647431434;
        bh=vFUqGn1MyDOfCmh5q8VS/a9z4GSXOGh3Eg+OYJXgxvs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=UXo1rBZWuB92QbiXKGeyyWN37jkhQwECDXAE60+YvEXqFpqM4UoPVi+42DUwp/kh/
         Bit3ctdozp98d864dLcsz4m/yTiQ0CfEz6bQvo4bMpRPoQWpgM3dSIba95KAd4hR/n
         8M08sOpbOQsXUEIehXbTdzk3ll5DEYxfviqtyqx6C5Mt74eiISt2Xii/pUgEPwOc4h
         O+ZRxn71bLkvkgl9xjv/bu1FnGxmxaOoLOSV3pdnIGwcYpWN1pfPqXtNzKXEA3+p97
         OO9fdwVaihUXN0QhTS4X+XUd+7H+PaRjA7kTk+nntaclajWLY9C9rRPaN3LVSvbCRd
         znEIlyaQMT76A==
Message-ID: <8ee63a9ada6574932a66821b11eb91c491543754.camel@kernel.org>
Subject: Re: [PATCH] ceph: fix the buf size and use NAME_SIZE instead
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org
Date:   Wed, 16 Mar 2022 07:50:33 -0400
In-Reply-To: <20220316035100.68406-1-xiubli@redhat.com>
References: <20220316035100.68406-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2022-03-16 at 11:51 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> Since the base64_encrypted file name shouldn't exceed the NAME_SIZE,
> no need to allocate a buffer from the stack that long.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
> 
> Jeff, you can just squash this into the previous commit.
> 
> 
>  fs/ceph/mds_client.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index c51b07ec72cf..cd0c780a6f84 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -2579,7 +2579,7 @@ char *ceph_mdsc_build_path(struct dentry *dentry, int *plen, u64 *pbase, int for
>  			parent = dget_parent(cur);
>  		} else {
>  			int len, ret;
> -			char buf[FSCRYPT_BASE64URL_CHARS(NAME_MAX)];
> +			char buf[NAME_MAX];
>  
>  			/*
>  			 * Proactively copy name into buf, in case we need to present

Thanks Xiubo. I folded this into:

    ceph: add encrypted fname handling to ceph_mdsc_build_path

...and merged in the other patches you sent earlier today.

I also went ahead and squashed down the readdir patches that you sent
yesterday, so that we could get rid of the interim readdir handling that
I had originally written.

It might need a bit more cleanup -- some of the deltas in the merged
patch probably belong in earlier commits, but it should be ok for now.

Please take a look and make sure I didn't miss anything there.
-- 
Jeff Layton <jlayton@kernel.org>
