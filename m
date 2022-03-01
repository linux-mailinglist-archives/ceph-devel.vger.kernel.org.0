Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 134C04C8BFB
	for <lists+ceph-devel@lfdr.de>; Tue,  1 Mar 2022 13:50:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232414AbiCAMuk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 1 Mar 2022 07:50:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234840AbiCAMug (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 1 Mar 2022 07:50:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A919398B
        for <ceph-devel@vger.kernel.org>; Tue,  1 Mar 2022 04:49:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4C5661161
        for <ceph-devel@vger.kernel.org>; Tue,  1 Mar 2022 12:49:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B508EC340EE;
        Tue,  1 Mar 2022 12:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646138994;
        bh=aLbyrbD9fqzktrnDTTBqJQppFBIEupJpdjtztdwONWY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Rn6IxzOdR9S2qUc/Z34ponWLH7UWSZaKNNUnm1fh/l+rDB1JfyT5xIsIHQUYGnR9C
         0N092OQa3uG4CZHhvK8JPWSgTIobbFppGZyJZV5XqMvC4PMQxc8+uVRFSG84f4sjao
         Cx0f1SNokoaXmqHjrR39we8Nsvt0PJfagKheWKiAHKno/wUtkOogTBwoFUalD2FmKb
         hZ4efNXygpe/nknk3/HpSkfCLkZkRK048JBzw1hGq/yzfXtIBdP9vXFgmznaf1hAVy
         42JosuXiqQpZGI1jPWKaAjWgnbW+K8Fhy7vdtmOdM+VgCzDH9dq2ubIoNPo64MGdU9
         n9ExySlDSHgIw==
Message-ID: <baa7c5eaa9304c60aa87f5304faa84d5ce0ea038.camel@kernel.org>
Subject: Re: [PATCH] ceph: fix memory leakage in ceph_readdir
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
Date:   Tue, 01 Mar 2022 07:49:52 -0500
In-Reply-To: <20220301055915.425624-1-xiubli@redhat.com>
References: <20220301055915.425624-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2022-03-01 at 13:59 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/dir.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index 0cf6afe283e9..6184cf123fa2 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -521,6 +521,7 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>  			      ceph_present_ino(inode->i_sb, le64_to_cpu(rde->inode.in->ino)),
>  			      le32_to_cpu(rde->inode.in->mode) >> 12)) {
>  			dout("filldir stopping us...\n");
> +			ceph_mdsc_put_request(dfi->last_readdir);
>  			return 0;
>  		}
>  		ctx->pos++;

Good catch!

It looks like there is another missing put around line 482 after the
note_last_dentry call. Could you fix that one up in the same patch? 


Reviewed-by: Jeff Layton <jlayton@kernel.org>
