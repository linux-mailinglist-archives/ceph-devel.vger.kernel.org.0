Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 151B74D1B54
	for <lists+ceph-devel@lfdr.de>; Tue,  8 Mar 2022 16:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347754AbiCHPHp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 8 Mar 2022 10:07:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231797AbiCHPHo (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 8 Mar 2022 10:07:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F8F84DF4C
        for <ceph-devel@vger.kernel.org>; Tue,  8 Mar 2022 07:06:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9500B8198C
        for <ceph-devel@vger.kernel.org>; Tue,  8 Mar 2022 15:06:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C51BC340F4;
        Tue,  8 Mar 2022 15:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646752004;
        bh=MfDt3RNsuE2cj/gK/hMJTOv35RoypHPeqJ2Sch3Y4D0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=qWm91O3m5mAwW69DG467jP+zCYAEf5ZwRuvCpaFSC3FwqVzME/962RWMBaTxjnGmB
         98UvmVqV1Yop1QI9jduUJc8QiJ7Ct1m0wphxw4c2l8FbJ9Tok9Sqj6GhEgPsdf5+60
         nbJh1nEsTKDNfSgjCRDlbi+urpZ7aoFV3U2v/CDz5JhethPVF+YuFuhK3kxsqUx768
         nGmS7nORVpqvRuLHyDl43vAVaB7DTWzc5XtqSKzX4xn/Sgl/pFIDs7pHqblEZBx1bF
         Iz47GE9wrk7VBlerNH1xPtqLmjus95SVa4JBrxU7cKaxh1vZNi+Kfw5TGosqKOhPU6
         Dm74oyrgn+Q2w==
Message-ID: <008e0b72ab9412afe8f2dcf9f47ad4f000c44228.camel@kernel.org>
Subject: Re: [PATCH v3] ceph: fix memory leakage in ceph_readdir
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
Date:   Tue, 08 Mar 2022 10:06:42 -0500
In-Reply-To: <20220305115259.1076790-1-xiubli@redhat.com>
References: <20220305115259.1076790-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sat, 2022-03-05 at 19:52 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> Reset the last_readdir at the same time.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/dir.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index 6be0c1f793c2..6df2a91af236 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -498,8 +498,11 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>  					2 : (fpos_off(rde->offset) + 1);
>  			err = note_last_dentry(dfi, rde->name, rde->name_len,
>  					       next_offset);
> -			if (err)
> +			if (err) {
> +				ceph_mdsc_put_request(dfi->last_readdir);
> +				dfi->last_readdir = NULL;
>  				goto out;
> +			}

Looks good, but this doesn't apply cleanly to the testing branch since
it still does a "return 0" there instead of "goto out". I adapted it to
work with testing branch and will do some testing with it today.


>  		} else if (req->r_reply_info.dir_end) {
>  			dfi->next_offset = 2;
>  			/* keep last name */
> @@ -552,6 +555,12 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>  		if (!dir_emit(ctx, oname.name, oname.len,
>  			      ceph_present_ino(inode->i_sb, le64_to_cpu(rde->inode.in->ino)),
>  			      le32_to_cpu(rde->inode.in->mode) >> 12)) {
> +			/*
> +			 * NOTE: Here no need to put the 'dfi->last_readdir',
> +			 * because when dir_emit stops us it's most likely
> +			 * doesn't have enough memory, etc. So for next readdir
> +			 * it will continue.
> +			 */
>  			dout("filldir stopping us...\n");
>  			err = 0;
>  			goto out;

-- 
Jeff Layton <jlayton@kernel.org>
