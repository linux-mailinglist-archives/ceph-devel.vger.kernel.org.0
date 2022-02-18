Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7E494BBA87
	for <lists+ceph-devel@lfdr.de>; Fri, 18 Feb 2022 15:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235980AbiBRORy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 18 Feb 2022 09:17:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232114AbiBRORx (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 18 Feb 2022 09:17:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF3FBD1D6A
        for <ceph-devel@vger.kernel.org>; Fri, 18 Feb 2022 06:17:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76B72B8265E
        for <ceph-devel@vger.kernel.org>; Fri, 18 Feb 2022 14:17:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F825C340E9;
        Fri, 18 Feb 2022 14:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645193854;
        bh=KOxf9mDw58YTwGZNuI9RXJZkW692LLsxbmn591hYTbc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GQCw2mbvKZoLnmwUfWkXJ/afEZj0cj/pRc8OhjNmDHFcG3pF6lYfRuUpLeVqLgQ5D
         ochl+Wdc6IL068TAYomGy1JxWMMG4b1/F1PYpmUCaaeqP+g1LCrsWEkgabQErepSO4
         VSAFEYhbZudPgrOsbLZzhiTasWJPHzS/6ne5kpjAfOTF2UZjFggRgzdMPnuIMewDeV
         k2kl/u4RaF4plMjxosI/xuXBe2BXRAPjkpXrP0GauNG7c0LuHdeWgEAdX77zL1xHZk
         dUJi7M2yjlJImND2pouxkI9jNQWDznO73dj0glHpSG5ghKNaJSNxZR5Ef0amw3lJor
         A1hnx+pVAt9RA==
Message-ID: <0d3fc58f0fed7fbaed29821ad753d383f4d8a84b.camel@kernel.org>
Subject: Re: [PATCH v2] ceph: do not update snapshot context when there is
 no new snapshot
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, ukernel@gmail.com,
        ceph-devel@vger.kernel.org
Date:   Fri, 18 Feb 2022 09:17:32 -0500
In-Reply-To: <20220218024722.7952-1-xiubli@redhat.com>
References: <20220218024722.7952-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2022-02-18 at 10:47 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> We will only track the uppest parent snapshot realm from which we
> need to rebuild the snapshot contexts _downward_ in hierarchy. For
> all the others having no new snapshot we will do nothing.
> 
> This fix will avoid calling ceph_queue_cap_snap() on some inodes
> inappropriately. For example, with the code in mainline, suppose there
> are 2 directory hierarchies (with 6 directories total), like this:
> 
> /dir_X1/dir_X2/dir_X3/
> /dir_Y1/dir_Y2/dir_Y3/
> 
> Firstly, make a snapshot under /dir_X1/dir_X2/.snap/snap_X2, then make a
> root snapshot under /.snap/root_snap. Every time we make snapshots under
> /dir_Y1/..., the kclient will always try to rebuild the snap context for
> snap_X2 realm and finally will always try to queue cap snaps for dir_Y2
> and dir_Y3, which makes no sense.
> 
> That's because the snap_X2's seq is 2 and root_snap's seq is 3. So when
> creating a new snapshot under /dir_Y1/... the new seq will be 4, and
> the mds will send the kclient a snapshot backtrace in _downward_
> order: seqs 4, 3.
> 
> When ceph_update_snap_trace() is called, it will always rebuild the from
> the last realm, that's the root_snap. So later when rebuilding the snap
> context, the current logic will always cause it to rebuild the snap_X2
> realm and then try to queue cap snaps for all the inodes related in that
> realm, even though it's not necessary.
> 
> This is accompanied by a lot of these sorts of dout messages:
> 
>     "ceph:  queue_cap_snap 00000000a42b796b nothing dirty|writing"
> 
> Fix the logic to avoid this situation.
> 
> The 'invalidate' word is not precise here, acutally it will rebuild
> the snapshot existing contexts or just build none-existing ones,
> rename it to 'rebuild_snapcs'.
> 
> URL: https://tracker.ceph.com/issues/44100
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
> 
> Changed in V2:
> - Thanks Zheng's feedback and switched to Zheng's patch.
> - Rename invalidate to rebuild_snapcs.
> 
> 
> 
>  fs/ceph/snap.c | 28 +++++++++++++++++++---------
>  1 file changed, 19 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> index dbf34f212596..6d55b8ba79d8 100644
> --- a/fs/ceph/snap.c
> +++ b/fs/ceph/snap.c
> @@ -735,7 +735,8 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
>  	__le64 *prior_parent_snaps;        /* encoded */
>  	struct ceph_snap_realm *realm = NULL;
>  	struct ceph_snap_realm *first_realm = NULL;
> -	int invalidate = 0;
> +	struct ceph_snap_realm *realm_to_rebuild = NULL;
> +	int rebuild_snapcs;
>  	int err = -ENOMEM;
>  	LIST_HEAD(dirty_realms);
>  
> @@ -743,6 +744,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
>  
>  	dout("update_snap_trace deletion=%d\n", deletion);
>  more:
> +	rebuild_snapcs = 0;
>  	ceph_decode_need(&p, e, sizeof(*ri), bad);
>  	ri = p;
>  	p += sizeof(*ri);
> @@ -766,7 +768,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
>  	err = adjust_snap_realm_parent(mdsc, realm, le64_to_cpu(ri->parent));
>  	if (err < 0)
>  		goto fail;
> -	invalidate += err;
> +	rebuild_snapcs += err;
>  
>  	if (le64_to_cpu(ri->seq) > realm->seq) {
>  		dout("update_snap_trace updating %llx %p %lld -> %lld\n",
> @@ -791,22 +793,30 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
>  		if (realm->seq > mdsc->last_snap_seq)
>  			mdsc->last_snap_seq = realm->seq;
>  
> -		invalidate = 1;
> +		rebuild_snapcs = 1;
>  	} else if (!realm->cached_context) {
>  		dout("update_snap_trace %llx %p seq %lld new\n",
>  		     realm->ino, realm, realm->seq);
> -		invalidate = 1;
> +		rebuild_snapcs = 1;
>  	} else {
>  		dout("update_snap_trace %llx %p seq %lld unchanged\n",
>  		     realm->ino, realm, realm->seq);
>  	}
>  
> -	dout("done with %llx %p, invalidated=%d, %p %p\n", realm->ino,
> -	     realm, invalidate, p, e);
> +	dout("done with %llx %p, rebuild_snapcs=%d, %p %p\n", realm->ino,
> +	     realm, rebuild_snapcs, p, e);
>  
> -	/* invalidate when we reach the _end_ (root) of the trace */
> -	if (invalidate && p >= e)
> -		rebuild_snap_realms(realm, &dirty_realms);
> +	/*
> +	 * this will always track the uppest parent realm from which
> +	 * we need to rebuild the snapshot contexts _downward_ in
> +	 * hierarchy.
> +	 */
> +	if (rebuild_snapcs)
> +		realm_to_rebuild = realm;
> +
> +	/* rebuild_snapcs when we reach the _end_ (root) of the trace */
> +	if (rebuild_snapcs && p >= e)
> +		rebuild_snap_realms(realm_to_rebuild, &dirty_realms);
>  
>  	if (!first_realm)
>  		first_realm = realm;

Looks good, Xiubo. Dropped the old patch and merged this one into the
testing branch (with a little changelog cleanup).

Thanks to both you and Zheng!
-- 
Jeff Layton <jlayton@kernel.org>
