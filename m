Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 112474BC875
	for <lists+ceph-devel@lfdr.de>; Sat, 19 Feb 2022 13:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242321AbiBSM6N (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 19 Feb 2022 07:58:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242261AbiBSM6M (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 19 Feb 2022 07:58:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E9F21D423C
        for <ceph-devel@vger.kernel.org>; Sat, 19 Feb 2022 04:57:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD51D60AD5
        for <ceph-devel@vger.kernel.org>; Sat, 19 Feb 2022 12:57:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B17C1C004E1;
        Sat, 19 Feb 2022 12:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645275472;
        bh=0vhAB4pQBvnm3Sg63AehFt+FX5KIPH4bdi8PqIVn78A=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=IEkbbm0rUECqxxmwL3/Bc6lFXcxTeXReT7Pa2nLjKZA9YrpVqBoiM2NGBj9kJxIaE
         EeQyx6AjUExX117mkoNJlmlvQs8OwQhD89L6lry+UQbuNexWyD4X/nBhXQIIkYXGM0
         UrnoGXtzCBgCTJqyNIeaSC1WNj73l/d7fPMmzr+MMEUdrpWN/gmetsR1hRuE3lLfi7
         rjNPSap4VpxC5HCKYwHMrXrpYygwo6Jh8180ub8+St+gIHWXvELeS3xehpaRl95gB6
         d6hZB4m6rSNK5AAsPzRAgYNWrZavH7aO9KgUm5vaiDDQjIs/WMJuKaMLTqBtj/WF/Y
         8db8jETKe7MUA==
Message-ID: <a60d6e77d6d16eda7b2837eff18a3c7678160d9b.camel@kernel.org>
Subject: Re: [PATCH v2] ceph: eliminate the recursion when rebuilding the
 snap context
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
Date:   Sat, 19 Feb 2022 07:57:50 -0500
In-Reply-To: <20220219065617.43718-1-xiubli@redhat.com>
References: <20220219065617.43718-1-xiubli@redhat.com>
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

On Sat, 2022-02-19 at 14:56 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> Use a list instead of recursion to avoid possible stack overflow.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
> 
> V2:
> - Do not insert the child realms when building snapc for the parents
> 
> 
>  fs/ceph/snap.c  | 57 +++++++++++++++++++++++++++++++++++++++++--------
>  fs/ceph/super.h |  2 ++
>  2 files changed, 50 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> index bc5ec72d958c..722ddd166013 100644
> --- a/fs/ceph/snap.c
> +++ b/fs/ceph/snap.c
> @@ -127,6 +127,7 @@ static struct ceph_snap_realm *ceph_create_snap_realm(
>  	INIT_LIST_HEAD(&realm->child_item);
>  	INIT_LIST_HEAD(&realm->empty_item);
>  	INIT_LIST_HEAD(&realm->dirty_item);
> +	INIT_LIST_HEAD(&realm->rebuild_item);
>  	INIT_LIST_HEAD(&realm->inodes_with_caps);
>  	spin_lock_init(&realm->inodes_with_caps_lock);
>  	__insert_snap_realm(&mdsc->snap_realms, realm);
> @@ -320,7 +321,8 @@ static int cmpu64_rev(const void *a, const void *b)
>   * build the snap context for a given realm.
>   */
>  static int build_snap_context(struct ceph_snap_realm *realm,
> -			      struct list_head* dirty_realms)
> +			      struct list_head *realm_queue,
> +			      struct list_head *dirty_realms)
>  {
>  	struct ceph_snap_realm *parent = realm->parent;
>  	struct ceph_snap_context *snapc;
> @@ -334,9 +336,9 @@ static int build_snap_context(struct ceph_snap_realm *realm,
>  	 */
>  	if (parent) {
>  		if (!parent->cached_context) {
> -			err = build_snap_context(parent, dirty_realms);
> -			if (err)
> -				goto fail;
> +			/* add to the queue head */
> +			list_add(&parent->rebuild_item, realm_queue);
> +			return 1;
>  		}
>  		num += parent->cached_context->num_snaps;
>  	}
> @@ -420,13 +422,50 @@ static int build_snap_context(struct ceph_snap_realm *realm,
>  static void rebuild_snap_realms(struct ceph_snap_realm *realm,
>  				struct list_head *dirty_realms)
>  {
> -	struct ceph_snap_realm *child;
> +	LIST_HEAD(realm_queue);
> +	int last = 0;
> +	bool skip = false;
>  
> -	dout("rebuild_snap_realms %llx %p\n", realm->ino, realm);
> -	build_snap_context(realm, dirty_realms);
> +	list_add_tail(&realm->rebuild_item, &realm_queue);
>  
> -	list_for_each_entry(child, &realm->children, child_item)
> -		rebuild_snap_realms(child, dirty_realms);
> +	while (!list_empty(&realm_queue)) {
> +		struct ceph_snap_realm *_realm, *child;
> +
> +		_realm = list_first_entry(&realm_queue,
> +					  struct ceph_snap_realm,
> +					  rebuild_item);
> +
> +		/*
> +		 * If the last building failed dues to memory
> +		 * issue, just empty the realm_queue and return
> +		 * to avoid infinite loop.
> +		 */
> +		if (last < 0) {
> +			list_del_init(&_realm->rebuild_item);
> +			continue;
> +		}
> +
> +		last = build_snap_context(_realm, &realm_queue, dirty_realms);
> +		dout("rebuild_snap_realms %llx %p, %s\n", _realm->ino, _realm,
> +		     last > 0 ? "is deferred" : !last ? "succeeded" : "failed");
> +
> +		/* is any child in the list ? */
> +		list_for_each_entry(child, &_realm->children, child_item) {
> +			if (!list_empty(&child->rebuild_item)) {
> +				skip = true;
> +				break;
> +			}
> +		}
> +
> +		if (!skip) {
> +			list_for_each_entry(child, &_realm->children, child_item)
> +				list_add_tail(&child->rebuild_item, &realm_queue);
> +		}
> +
> +		/* last == 1 means need to build parent first */
> +		if (last <= 0)
> +			list_del_init(&_realm->rebuild_item);
> +	}
>  }
>  
>  
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index a17bd01a8957..baac800a6d11 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -885,6 +885,8 @@ struct ceph_snap_realm {
>  
>  	struct list_head dirty_item;     /* if realm needs new context */
>  
> +	struct list_head rebuild_item;   /* rebuild snap realms _downward_ in hierarchy */
> +
>  	/* the current set of snaps for this realm */
>  	struct ceph_snap_context *cached_context;
>  

Looks good. I dropped the one in the testing branch and merged this one.
-- 
Jeff Layton <jlayton@kernel.org>
