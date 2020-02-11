Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10FA7158DED
	for <lists+ceph-devel@lfdr.de>; Tue, 11 Feb 2020 13:07:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728449AbgBKMHg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 11 Feb 2020 07:07:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:46064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727936AbgBKMHf (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 11 Feb 2020 07:07:35 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9242F206D7;
        Tue, 11 Feb 2020 12:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581422855;
        bh=/VNcQyyp12iu2xZC+axMbPkU6adrgfHMvHBZNDGt1e0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DncVi/pMh9hfpDdMVTxeEUfp/VOS337j3DWsZlApZAerroAzH7VOTD+e59hjXtbsh
         xGRDDw+FHpVzG4yGLdMO2FDuFgith7RGmotDGcSCBOUBV48kbRd6+g3I4HCgGIaDMr
         pgryJT4IA7wPQHRur0QWIDFusoM/bJ1NquxD64dc=
Message-ID: <f3ad3f84d460e0c9b69490e9d53671303f586a83.camel@kernel.org>
Subject: Re: [PATCH v2] ceph: fix posix acl couldn't be settable
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, dhowells@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Tue, 11 Feb 2020 07:07:33 -0500
In-Reply-To: <20200211065316.59091-1-xiubli@redhat.com>
References: <20200211065316.59091-1-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.3 (3.34.3-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2020-02-11 at 01:53 -0500, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> For the old mount API, the module parameters parseing function will
> be called in ceph_mount() and also just after the default posix acl
> flag set, so we can control to enable/disable it via the mount option.
> 
> But for the new mount API, it will call the module parameters
> parseing function before ceph_get_tree(), so the posix acl will always
> be enabled.
> 
> Fixes: 82995cc6c5ae ("libceph, rbd, ceph: convert to use the new mount API")
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
> 
> Changed in V2:
> - move default fc->sb_flags setting to ceph_init_fs_context().
> 
>  fs/ceph/super.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index 5fef4f59e13e..c3d9ac768cec 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -1089,10 +1089,6 @@ static int ceph_get_tree(struct fs_context *fc)
>  	if (!fc->source)
>  		return invalf(fc, "ceph: No source");
>  
> -#ifdef CONFIG_CEPH_FS_POSIX_ACL
> -	fc->sb_flags |= SB_POSIXACL;
> -#endif
> -
>  	/* create client (which we may/may not use) */
>  	fsc = create_fs_client(pctx->opts, pctx->copts);
>  	pctx->opts = NULL;
> @@ -1215,6 +1211,10 @@ static int ceph_init_fs_context(struct fs_context *fc)
>  	fsopt->max_readdir_bytes = CEPH_MAX_READDIR_BYTES_DEFAULT;
>  	fsopt->congestion_kb = default_congestion_kb();
>  
> +#ifdef CONFIG_CEPH_FS_POSIX_ACL
> +	fc->sb_flags |= SB_POSIXACL;
> +#endif
> +
>  	fc->fs_private = pctx;
>  	fc->ops = &ceph_context_ops;
>  	return 0;

Nice catch.

Reviewed-by: Jeff Layton <jlayton@kernel.org>

