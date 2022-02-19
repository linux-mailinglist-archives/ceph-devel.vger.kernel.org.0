Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA69C4BC870
	for <lists+ceph-devel@lfdr.de>; Sat, 19 Feb 2022 13:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242238AbiBSM4F (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 19 Feb 2022 07:56:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233494AbiBSM4E (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 19 Feb 2022 07:56:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF8F11CB756
        for <ceph-devel@vger.kernel.org>; Sat, 19 Feb 2022 04:55:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57E1360AC9
        for <ceph-devel@vger.kernel.org>; Sat, 19 Feb 2022 12:55:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BEEEC004E1;
        Sat, 19 Feb 2022 12:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645275344;
        bh=4/VBZF6I6fLjxPiehz0zNSC3eoA1yZaGMvSxcURlgUI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=JMTD9Nl4XrZNCGIdml8a45Lr4b3898YpkyCo2u6Dyeau8kz1uZz2AQNVDy4ld3NHL
         GnX0HB5Cdx1YHcU6QvckzbcC9qGqPY81Pq7rJVrzqOq7aTKmwf1j0+0EWwzzUkG3cd
         wlOmngFpRi9rY28PMmxJjBxO18OA16cId1nV5F+PPHGYigIC8/SBudzJLOgxQzmB4l
         B0wZHd6TkMIfqoZIZJ4voc+6uhmmYHDjboj5fBgJ2Q4fzWV4oLoZ8VuKYjwS0i930r
         zZZ0dXafrH6SVQ5tFz5g78bMGN1ujC6Ie8GtvwJHmBFsPIi/UoPAL49M5Ljve1C31S
         UeaamqI/5JtwA==
Message-ID: <c2157fcd5c837c1101c58a4a7fe3c49a773640f4.camel@kernel.org>
Subject: Re: [PATCH v3] ceph: do not update snapshot context when there is
 no new snapshot
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
Date:   Sat, 19 Feb 2022 07:55:42 -0500
In-Reply-To: <20220219062833.30192-1-xiubli@redhat.com>
References: <20220219062833.30192-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sat, 2022-02-19 at 14:28 +0800, xiubli@redhat.com wrote:
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
> Also, the 'invalidate' word is not precise here. In actuality, it will
> cause a rebuild of the existing snapshot contexts or just build
> non-existant ones. Rename it to 'rebuild_snapcs'.
> 
> URL: https://tracker.ceph.com/issues/44100
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
> 
> 
> 
> V3:
> - Fixed the crash issue reproduced by Luís.
> 
> 
> 
> 
>  fs/ceph/snap.c | 28 +++++++++++++++++++---------
>  1 file changed, 19 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> index 32e246138793..25a29304b74d 100644
> --- a/fs/ceph/snap.c
> +++ b/fs/ceph/snap.c
> @@ -736,7 +736,8 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
>  	__le64 *prior_parent_snaps;        /* encoded */
>  	struct ceph_snap_realm *realm = NULL;
>  	struct ceph_snap_realm *first_realm = NULL;
> -	int invalidate = 0;
> +	struct ceph_snap_realm *realm_to_rebuild = NULL;
> +	int rebuild_snapcs;
>  	int err = -ENOMEM;
>  	LIST_HEAD(dirty_realms);
>  
> @@ -744,6 +745,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
>  
>  	dout("update_snap_trace deletion=%d\n", deletion);
>  more:
> +	rebuild_snapcs = 0;
>  	ceph_decode_need(&p, e, sizeof(*ri), bad);
>  	ri = p;
>  	p += sizeof(*ri);
> @@ -767,7 +769,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
>  	err = adjust_snap_realm_parent(mdsc, realm, le64_to_cpu(ri->parent));
>  	if (err < 0)
>  		goto fail;
> -	invalidate += err;
> +	rebuild_snapcs += err;
>  
>  	if (le64_to_cpu(ri->seq) > realm->seq) {
>  		dout("update_snap_trace updating %llx %p %lld -> %lld\n",
> @@ -792,22 +794,30 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
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
> +	if (realm_to_rebuild && p >= e)
> +		rebuild_snap_realms(realm_to_rebuild, &dirty_realms);
>  
>  	if (!first_realm)
>  		first_realm = realm;

Looks good, Xiubo. Dropped v2 and merged this one.

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>
