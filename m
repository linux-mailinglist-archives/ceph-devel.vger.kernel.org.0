Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87F9E4BF5A9
	for <lists+ceph-devel@lfdr.de>; Tue, 22 Feb 2022 11:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbiBVKXJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 22 Feb 2022 05:23:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230527AbiBVKXG (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 22 Feb 2022 05:23:06 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A24CD157206
        for <ceph-devel@vger.kernel.org>; Tue, 22 Feb 2022 02:22:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1D8F9CE1316
        for <ceph-devel@vger.kernel.org>; Tue, 22 Feb 2022 10:22:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A313C340E8;
        Tue, 22 Feb 2022 10:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645525357;
        bh=9iqPv3yAil6bPwe6x/eYELmxvGe4H5SP6V2BCqX6XUU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ub/K1XwC+5po8mFvMKdsYhySH+6q25tauxHvlofOObcNbRkFis4m3D/MvoWXTILT1
         2rTf/2WsQWKGI6zNo4LZdK6oeoFqUZ2uAqdMVVnPcbrb6mz7uW5erkHIRJwrddeJOt
         96nM2B9YgvmfL0g6JNOilgGb3jcDrhDKGz+KP9SaHjGNsnWdI+uwnY+famzDR6sMM6
         M35SkpissDmfKqOsSHwwpql3ynEZL2YYKGi1nJMrmNLcW1NRD+6STdvo29rUdJv5FD
         6Aq5qUciU1T4utMIDvDxZCbtY8Fe4IxbbkjXNi0PEC49uXkiiSs/zzVXzDgq/YU2jl
         uZ2Ju392bLlRA==
Message-ID: <68e565e99f10c549ceea646fd5d1dcdd6bec0be2.camel@kernel.org>
Subject: Re: [PATCH 2/2] ceph: do not release the global snaprealm until
 unmounting
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
Date:   Tue, 22 Feb 2022 05:22:35 -0500
In-Reply-To: <20220222063433.217466-3-xiubli@redhat.com>
References: <20220222063433.217466-1-xiubli@redhat.com>
         <20220222063433.217466-3-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2022-02-22 at 14:34 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> The global snaprealm would be created and then destroyed immediately
> every time when updating it.
> 

Does this cause some sort of issue, or is it just inefficient?

> URL: https://tracker.ceph.com/issues/54362
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/mds_client.c         |  2 +-
>  fs/ceph/snap.c               | 13 +++++++++++--
>  fs/ceph/super.h              |  2 +-
>  include/linux/ceph/ceph_fs.h |  3 ++-
>  4 files changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 65bd43d4cafc..325f8071a324 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -4866,7 +4866,7 @@ void ceph_mdsc_close_sessions(struct ceph_mds_client *mdsc)
>  	mutex_unlock(&mdsc->mutex);
>  
>  	ceph_cleanup_snapid_map(mdsc);
> -	ceph_cleanup_empty_realms(mdsc);
> +        ceph_cleanup_global_and_empty_realms(mdsc);

Please use tab indent.

>  
>  	cancel_work_sync(&mdsc->cap_reclaim_work);
>  	cancel_delayed_work_sync(&mdsc->delayed_work); /* cancel timer */
> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> index 66a1a92cf579..cc9097c27052 100644
> --- a/fs/ceph/snap.c
> +++ b/fs/ceph/snap.c
> @@ -121,7 +121,11 @@ static struct ceph_snap_realm *ceph_create_snap_realm(
>  	if (!realm)
>  		return ERR_PTR(-ENOMEM);
>  
> -	atomic_set(&realm->nref, 1);    /* for caller */
> +	/* Do not release the global dummy snaprealm until unmouting */
> +	if (ino == CEPH_INO_GLOBAL_SNAPREALM)
> +		atomic_set(&realm->nref, 2);
> +	else
> +		atomic_set(&realm->nref, 1);
>  	realm->ino = ino;
>  	INIT_LIST_HEAD(&realm->children);
>  	INIT_LIST_HEAD(&realm->child_item);
> @@ -261,9 +265,14 @@ static void __cleanup_empty_realms(struct ceph_mds_client *mdsc)
>  	spin_unlock(&mdsc->snap_empty_lock);
>  }
>  
> -void ceph_cleanup_empty_realms(struct ceph_mds_client *mdsc)
> +void ceph_cleanup_global_and_empty_realms(struct ceph_mds_client *mdsc)
>  {
> +	struct ceph_snap_realm *global_realm;
> +
>  	down_write(&mdsc->snap_rwsem);
> +	global_realm = __lookup_snap_realm(mdsc, CEPH_INO_GLOBAL_SNAPREALM);
> +	if (global_realm)
> +		ceph_put_snap_realm(mdsc, global_realm);
>  	__cleanup_empty_realms(mdsc);
>  	up_write(&mdsc->snap_rwsem);
>  }
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index baac800a6d11..250aefecd628 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -942,7 +942,7 @@ extern void ceph_handle_snap(struct ceph_mds_client *mdsc,
>  			     struct ceph_msg *msg);
>  extern int __ceph_finish_cap_snap(struct ceph_inode_info *ci,
>  				  struct ceph_cap_snap *capsnap);
> -extern void ceph_cleanup_empty_realms(struct ceph_mds_client *mdsc);
> +extern void ceph_cleanup_global_and_empty_realms(struct ceph_mds_client *mdsc);
>  
>  extern struct ceph_snapid_map *ceph_get_snapid_map(struct ceph_mds_client *mdsc,
>  						   u64 snap);
> diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
> index f14f9bc290e6..86bf82dbd8b8 100644
> --- a/include/linux/ceph/ceph_fs.h
> +++ b/include/linux/ceph/ceph_fs.h
> @@ -28,7 +28,8 @@
>  
>  
>  #define CEPH_INO_ROOT   1
> -#define CEPH_INO_CEPH   2       /* hidden .ceph dir */
> +#define CEPH_INO_CEPH   2            /* hidden .ceph dir */
> +#define CEPH_INO_GLOBAL_SNAPREALM  3 /* global dummy snaprealm */
>  
>  /* arbitrary limit on max # of monitors (cluster of 3 is typical) */
>  #define CEPH_MAX_MON   31
-- 
Jeff Layton <jlayton@kernel.org>
