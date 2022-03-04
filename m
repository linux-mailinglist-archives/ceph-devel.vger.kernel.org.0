Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C49704CDBB2
	for <lists+ceph-devel@lfdr.de>; Fri,  4 Mar 2022 19:03:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240615AbiCDSEd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 4 Mar 2022 13:04:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238201AbiCDSEd (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 4 Mar 2022 13:04:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A440B1A
        for <ceph-devel@vger.kernel.org>; Fri,  4 Mar 2022 10:03:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AAF8360C77
        for <ceph-devel@vger.kernel.org>; Fri,  4 Mar 2022 18:03:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E699C340E9;
        Fri,  4 Mar 2022 18:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646417024;
        bh=fzhOCPKJ6lo/XKt1dO0j45Z5slsT1URegLNHyfEP+OQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=j1ZScUCKfqBQLKwTKfyWa7MK1wnvsAQV+LNNrRTamoIt2hLsll2M1HEfEavQyxBfM
         WLBwgVFDPTw9i1T1KD3fo1yUd1dxCjh68SBoqjpC6oaBbBXLc6E8t9/PNA1nik9+QP
         DQO68jKgYo/48C89rXBbxNTQQ+XeCm37F72BTxP+X4PmMRI8o+A4jPpeRTpD7wuJzn
         ZrLt0cq2hWydDL1bu3/IZB+DMsdfQbVxytKORjIamK8KR0nzcDCL3tFbtftkz/YB5X
         1UeLOCpyumIiIvyec0BaoDs5cXHS0vS39MCSWtTTRKo/ZScMXtsu08+PrCF7b0FxSv
         nIy2pxV1AL7nQ==
Message-ID: <1b73d7b28145002aac50dff707ec4b0e20ec12d8.camel@kernel.org>
Subject: Re: [PATCH v4 1/2] ceph: fail the request when failing to decode
 dentry names
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org
Date:   Fri, 04 Mar 2022 13:03:42 -0500
In-Reply-To: <20220303032640.521999-2-xiubli@redhat.com>
References: <20220303032640.521999-1-xiubli@redhat.com>
         <20220303032640.521999-2-xiubli@redhat.com>
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

On Thu, 2022-03-03 at 11:26 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> If we just skip the corrupt dentry names without setting the rde's
> offset it will crash in ceph_readdir():
> 
> ------------[ cut here ]------------
> kernel BUG at fs/ceph/dir.c:537!
> invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
> CPU: 16 PID: 21641 Comm: ls Tainted: G            E     5.17.0-rc2+ #92
> Hardware name: Red Hat RHEV Hypervisor, BIOS 1.11.0-2.el7 04/01/2014
> 
> The corresponding code in ceph_readdir() is:
> 
> 	BUG_ON(rde->offset < ctx->pos);
> 
> For now let's just fail the readdir request since it's nasty to
> handle it and will do better error handling later in future.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/dir.c        | 13 +++++++------
>  fs/ceph/inode.c      |  5 +++--
>  fs/ceph/mds_client.c |  2 +-
>  3 files changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index bdd757690a11..4da59810b036 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -537,6 +537,13 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>  					    .ctext_len	= rde->altname_len };
>  		u32 olen = oname.len;
>  
> +		err = ceph_fname_to_usr(&fname, &tname, &oname, NULL);
> +		if (err) {
> +			pr_err("%s unable to decode %.*s, got %d\n", __func__,
> +			       rde->name_len, rde->name, err);
> +			goto out;
> +		}
> +
>  		BUG_ON(rde->offset < ctx->pos);
>  		BUG_ON(!rde->inode.in);
>  
> @@ -545,12 +552,6 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>  		     i, rinfo->dir_nr, ctx->pos,
>  		     rde->name_len, rde->name, &rde->inode.in);
>  
> -		err = ceph_fname_to_usr(&fname, &tname, &oname, NULL);
> -		if (err) {
> -			dout("Unable to decode %.*s. Skipping it.\n", rde->name_len, rde->name);
> -			continue;
> -		}
> -
>  		if (!dir_emit(ctx, oname.name, oname.len,
>  			      ceph_present_ino(inode->i_sb, le64_to_cpu(rde->inode.in->ino)),
>  			      le32_to_cpu(rde->inode.in->mode) >> 12)) {
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index d842ccb15667..e5a9838981ba 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -1897,8 +1897,9 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
>  
>  		err = ceph_fname_to_usr(&fname, &tname, &oname, &is_nokey);
>  		if (err) {
> -			dout("Unable to decode %.*s. Skipping it.", rde->name_len, rde->name);
> -			continue;
> +			pr_err("%s unable to decode %.*s, got %d\n", __func__,
> +			       rde->name_len, rde->name, err);
> +			goto out;
>  		}
>  
>  		dname.name = oname.name;
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 34fc7c226b0d..f0d2442187a3 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -3449,7 +3449,7 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
>  	if (err == 0) {
>  		if (result == 0 && (req->r_op == CEPH_MDS_OP_READDIR ||
>  				    req->r_op == CEPH_MDS_OP_LSSNAP))
> -			ceph_readdir_prepopulate(req, req->r_session);
> +			err = ceph_readdir_prepopulate(req, req->r_session);
>  	}
>  	current->journal_info = NULL;
>  	mutex_unlock(&req->r_fill_mutex);


Reviewed-by: Jeff Layton <jlayton@kernel.org>
