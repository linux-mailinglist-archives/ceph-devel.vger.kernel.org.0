Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 244354CA753
	for <lists+ceph-devel@lfdr.de>; Wed,  2 Mar 2022 15:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239777AbiCBOII (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 2 Mar 2022 09:08:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242846AbiCBOIF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 2 Mar 2022 09:08:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FB20C5D84
        for <ceph-devel@vger.kernel.org>; Wed,  2 Mar 2022 06:07:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C16DC6114E
        for <ceph-devel@vger.kernel.org>; Wed,  2 Mar 2022 14:06:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA2AC004E1;
        Wed,  2 Mar 2022 14:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646230019;
        bh=uXTVj2j+T8Wgtm2FYnTLSsS8v/59kTsd+1VtEUKNeVw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XvRvY2w+pZ/CfBPk7rp3sIlVuOhwZLGkIyS5asyvv1Acss+R+4yy9hhoRXQMcRxd3
         2RTo+1FduQKVK6+ZSAGs21X7Jt/xzsNM1Yb9OS0YyrSSpJeNV9U70qUR4+kJEUOmVS
         xFpD0Ih8EBLy5IHOXtMBnI5Kk7KVZ0ggDGq3o0LE76TBL4/0NY6U2lCBtYbmd43kQg
         qPgJNQC/HpYiHtvu7sY8hEdPD7QR6EiV7qThbV90GjFSpBHOfqGA3p6y6Jy1ercYA1
         FcxjJyGmByELPRUtRXCmnRiITDtT8PaqWcqEyOblSlW5H97As22MxmFf/LkC4MD4FQ
         JImmsRgQI3DGA==
Message-ID: <18af03fd35eadc2fb34ef2df62194785f073a956.camel@kernel.org>
Subject: Re: [PATCH 2/2] ceph: fix a NULL pointer dereference in
 ceph_handle_caps()
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
Date:   Wed, 02 Mar 2022 09:06:57 -0500
In-Reply-To: <20220302085402.64740-3-xiubli@redhat.com>
References: <20220302085402.64740-1-xiubli@redhat.com>
         <20220302085402.64740-3-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2022-03-02 at 16:54 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> The ceph_find_inode() may will fail and return NULL.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/caps.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 0b36020207fd..0762b55fdbcb 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -4303,7 +4303,6 @@ void ceph_handle_caps(struct ceph_mds_session *session,
>  
>  	/* lookup ino */
>  	inode = ceph_find_inode(mdsc->fsc->sb, vino);
> -	ci = ceph_inode(inode);
>  	dout(" op %s ino %llx.%llx inode %p\n", ceph_cap_op_name(op), vino.ino,
>  	     vino.snap, inode);
>  
> @@ -4333,6 +4332,7 @@ void ceph_handle_caps(struct ceph_mds_session *session,
>  		}
>  		goto flush_cap_releases;
>  	}
> +	ci = ceph_inode(inode);
>  
>  	/* these will work even if we don't have a cap yet */
>  	switch (op) {

I don't think this is an actual bug. We're just assigning "ci" here and
that doesn't involve a dereference of inode. If "inode" is NULL, then ci
will be close to NULL, but it doesn't get used in that case.

Assigning this lower in the function is fine though, and it discourages
anyone trying to use ci when they shouldn't, so you can add my ack, but
maybe fix the patch description since there is no dereference here.

Acked-by: Jeff Layton <jlayton@kernel.org>
