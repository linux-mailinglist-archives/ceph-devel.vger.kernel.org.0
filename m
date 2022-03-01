Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D15F24C8C73
	for <lists+ceph-devel@lfdr.de>; Tue,  1 Mar 2022 14:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234981AbiCANVd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 1 Mar 2022 08:21:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232019AbiCANVb (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 1 Mar 2022 08:21:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCE6D9BBA2
        for <ceph-devel@vger.kernel.org>; Tue,  1 Mar 2022 05:20:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70AC8B818F6
        for <ceph-devel@vger.kernel.org>; Tue,  1 Mar 2022 13:20:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83A49C340F0;
        Tue,  1 Mar 2022 13:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646140848;
        bh=gumkSBzwSbEE0zPiz6fQfZwl/5DisRa0WE5jO3ZnJd0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Jg/YMG26661bNd1B+Zcn9JPXzlnsVpbO5AGFihF5iZ2XnzX1T9F83Etyk2Rt+ZrQp
         K3NNwxvBHcHQ0rMDCg5sHZvT80iPPBmbOg6Qubn27eV/bnFIi/m65B3O03B5ZPCIQ5
         5NxmQDqTFO3+ChlDCaV9BBAT1Kvpw0Y4XrmMDYiadEDHbWiv9mkSCqv9GeP1hvJ7TT
         4rBUBrjKjAVAFYhIjEMKN9pwPtYnAyCOYlh5ON/PD6JzCz5Mc8jSJkoluTHoUEElMg
         45APCrCX+OhzkZaXhScy3PPNAfxyALgUztYqd/3DP6jc4sAPi4jUsPC+t2cDVa7AUq
         Il2Mr2mxDchOA==
Message-ID: <7a75180f14638377db5917d82d0d40c2b86950c7.camel@kernel.org>
Subject: Re: [PATCH v2 1/7] ceph: fail the request when failing to decode
 dentry names
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org
Date:   Tue, 01 Mar 2022 08:20:44 -0500
In-Reply-To: <20220301113015.498041-2-xiubli@redhat.com>
References: <20220301113015.498041-1-xiubli@redhat.com>
         <20220301113015.498041-2-xiubli@redhat.com>
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

On Tue, 2022-03-01 at 19:30 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
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
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/dir.c        | 13 +++++++------
>  fs/ceph/inode.c      |  5 +++--
>  fs/ceph/mds_client.c |  2 +-
>  3 files changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index a449f4a07c07..6be0c1f793c2 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -534,6 +534,13 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
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
> @@ -542,12 +549,6 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
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
> index 8b0832271fdf..2bc2f02b84e8 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -1898,8 +1898,9 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
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


Is this really an improvement? Suppose I have one dentry with a corrupt
name. Do I want to fail a readdir request which might allow me to get at
other dentries in that directory that isn't corrupt?

Maybe we should try to emit some placeholder there?


>  		dname.name = oname.name;
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 914a6e68bb56..94b4c6508044 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -3474,7 +3474,7 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
>  	if (err == 0) {
>  		if (result == 0 && (req->r_op == CEPH_MDS_OP_READDIR ||
>  				    req->r_op == CEPH_MDS_OP_LSSNAP))
> -			ceph_readdir_prepopulate(req, req->r_session);
> +			err = ceph_readdir_prepopulate(req, req->r_session);
>  	}
>  	current->journal_info = NULL;
>  	mutex_unlock(&req->r_fill_mutex);

-- 
Jeff Layton <jlayton@kernel.org>
