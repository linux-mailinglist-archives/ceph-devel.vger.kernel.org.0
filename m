Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 938D44C8CB4
	for <lists+ceph-devel@lfdr.de>; Tue,  1 Mar 2022 14:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235051AbiCANdl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 1 Mar 2022 08:33:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234601AbiCANdk (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 1 Mar 2022 08:33:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C00E2457A4
        for <ceph-devel@vger.kernel.org>; Tue,  1 Mar 2022 05:32:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62800B818F9
        for <ceph-devel@vger.kernel.org>; Tue,  1 Mar 2022 13:32:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F985C340EE;
        Tue,  1 Mar 2022 13:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646141577;
        bh=WIppM7P+V1CnwSMDlwkNJ7K/36TyHuSnAWb8CGDfvV8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lOVHmSjRCG3n0xQ6gmg+z/RS01KeVo+dlRSvhLXiu9VPQcSyrKg2HNkQ33ahHSCkA
         4BTpzw1vd0Tz2RkxYdbuHC59JBEkOI+uPwg0wYPAp658Ck/991Q/BTrimbvy/V7Gqw
         Z0QF1sOetRTrMXQdcSftvzaQUYy3er0QTydtTCB1A+8SSIEMGUMOoObehR0Odx7y04
         KrYHVEN85MGBzKI6h6eHbwHFpFsDPycVjdXQYBqBMJRaxN3pOfWci3NbsIHTSI1Yl0
         /Jett4rhkrl6d3e2ZeDYqSYiOmlnAu4Dp0KgiuQ1/LIs+Jb1L7m2DLxl+4lcCECcGw
         PYTBOLyR9dLDg==
Message-ID: <47503f447a0269583612f141f09568899b2b2e1d.camel@kernel.org>
Subject: Re: [PATCH v2] ceph: fix memory leakage in ceph_readdir
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
Date:   Tue, 01 Mar 2022 08:32:55 -0500
In-Reply-To: <20220301131726.439070-1-xiubli@redhat.com>
References: <20220301131726.439070-1-xiubli@redhat.com>
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

On Tue, 2022-03-01 at 21:17 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> Reviewed-by: Jeff Layton <jlayton@kernel.org>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/dir.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index 0cf6afe283e9..bf69678d6434 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -478,8 +478,10 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>  					2 : (fpos_off(rde->offset) + 1);
>  			err = note_last_dentry(dfi, rde->name, rde->name_len,
>  					       next_offset);
> -			if (err)
> +			if (err) {
> +				ceph_mdsc_put_request(dfi->last_readdir);
>  				return err;
> +			}
>  		} else if (req->r_reply_info.dir_end) {
>  			dfi->next_offset = 2;
>  			/* keep last name */
> @@ -521,6 +523,7 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>  			      ceph_present_ino(inode->i_sb, le64_to_cpu(rde->inode.in->ino)),
>  			      le32_to_cpu(rde->inode.in->mode) >> 12)) {
>  			dout("filldir stopping us...\n");
> +			ceph_mdsc_put_request(dfi->last_readdir);
>  			return 0;
>  		}
>  		ctx->pos++;

Reviewed-by: Jeff Layton <jlayton@kernel.org>
