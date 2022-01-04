Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED9334846E7
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Jan 2022 18:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234683AbiADRWZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 4 Jan 2022 12:22:25 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34590 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234666AbiADRWZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 4 Jan 2022 12:22:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E00006154C
        for <ceph-devel@vger.kernel.org>; Tue,  4 Jan 2022 17:22:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B13C36AED;
        Tue,  4 Jan 2022 17:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641316943;
        bh=bjDlTsxHOWxNowCyaoWjztqd5OZTYhzRcQKWsHbbrfY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KOGTGi0daYEnzUN1YdygorImmF4VIU/vBbiqylIYrmFQCAomAOG9Fl1/dXIDHIqSL
         blwHYWHmEvpyuhHRLJjFTOsLQwvrSNFncfEaNGCKvjJyFzRnzy9m1dIEIR1PQD2WWW
         fLMs44LpLr9pTN4jpRoaFQEUAI012LTaQ3bWrzY/Q5lmGyQK9LP+Q1FhzoLc6ehb5M
         rUO8fAFwzi4qns7u9us1BzsDtYT7ZofosYVdCgY8o3JGqxYS4jMbM9HRvsFJKBF46g
         0oTU3+pDTRtJt1AiLwUNwbQaBh2b+0yKE6PAM2JJV+cuU/MZEprEua7iH+g+yXpQ6l
         8rU9BLKZaU9Ew==
Message-ID: <041afbfd171915d62ab9a93c7a35d9c9d5c5bf7b.camel@kernel.org>
Subject: Re: [PATCH 01/12] ceph: stash idmapping in mdsc request
From:   Jeff Layton <jlayton@kernel.org>
To:     Christian Brauner <brauner@kernel.org>, ceph-devel@vger.kernel.org
Cc:     Ilya Dryomov <idryomov@gmail.com>, Christoph Hellwig <hch@lst.de>,
        Christian Brauner <christian.brauner@ubuntu.com>
Date:   Tue, 04 Jan 2022 12:22:21 -0500
In-Reply-To: <20220104140414.155198-2-brauner@kernel.org>
References: <20220104140414.155198-1-brauner@kernel.org>
         <20220104140414.155198-2-brauner@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.2 (3.42.2-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2022-01-04 at 15:04 +0100, Christian Brauner wrote:
> From: Christian Brauner <christian.brauner@ubuntu.com>
> 
> When sending a mds request cephfs will send relevant data for the
> requested operation. For creation requests the caller's fs{g,u}id is
> used to set the ownership of the newly created filesystem object. For
> setattr requests the caller can pass in arbitrary {g,u}id values to
> which the relevant filesystem object is supposed to be changed.
> 
> If the caller is performing the relevant operation via an idmapped mount
> cephfs simply needs to take the idmapping into account when it sends the
> relevant mds request.
> 
> In order to support idmapped mounts for cephfs we stash the idmapping
> whenever they are relevant for the operation for the duration of the
> request. Since mds requests can be queued and performed asynchronously
> we make sure to keep the idmapping around and release it once the
> request has finished.
> 
> In follow-up patches we will use this to send correct ownership
> information over the wire. This patch just adds the basic infrastructure
> to keep the idmapping around. The actual conversion patches are all
> fairly minimal.
> 
> Cc: Jeff Layton <jlayton@kernel.org>
> Cc: Ilya Dryomov <idryomov@gmail.com>
> Cc: ceph-devel@vger.kernel.org
> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> ---
>  fs/ceph/mds_client.c | 7 +++++++
>  fs/ceph/mds_client.h | 1 +
>  2 files changed, 8 insertions(+)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index c30eefc0ac19..ae2cc4ce1d48 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -12,6 +12,7 @@
>  #include <linux/bits.h>
>  #include <linux/ktime.h>
>  #include <linux/bitmap.h>
> +#include <linux/mnt_idmapping.h>
>  
>  #include "super.h"
>  #include "mds_client.h"
> @@ -862,6 +863,8 @@ void ceph_mdsc_release_request(struct kref *kref)
>  	kfree(req->r_path1);
>  	kfree(req->r_path2);
>  	put_cred(req->r_cred);
> +	if (!initial_idmapping(req->mnt_userns))
> +		put_user_ns(req->mnt_userns);

I assume initial_idmapping returns true if it's init_user_ns ?

>  	if (req->r_pagelist)
>  		ceph_pagelist_release(req->r_pagelist);
>  	put_request_session(req);
> @@ -918,6 +921,10 @@ static void __register_request(struct ceph_mds_client *mdsc,
>  	insert_request(&mdsc->request_tree, req);
>  
>  	req->r_cred = get_current_cred();
> +	if (!req->mnt_userns)
> +		req->mnt_userns = &init_user_ns;
> +	else
> +		get_user_ns(req->mnt_userns);
>  
>  	if (mdsc->oldest_tid == 0 && req->r_op != CEPH_MDS_OP_SETFILELOCK)
>  		mdsc->oldest_tid = req->r_tid;
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index 97c7f7bfa55f..1b648645e340 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -275,6 +275,7 @@ struct ceph_mds_request {
>  	union ceph_mds_request_args r_args;
>  	int r_fmode;        /* file mode, if expecting cap */
>  	const struct cred *r_cred;
> +	struct user_namespace *mnt_userns;

Can we call this r_mnt_userns to match the other fields ?

>  	int r_request_release_offset;
>  	struct timespec64 r_stamp;
>  

-- 
Jeff Layton <jlayton@kernel.org>
