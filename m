Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B54B4B8B2A
	for <lists+ceph-devel@lfdr.de>; Wed, 16 Feb 2022 15:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234878AbiBPONU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 16 Feb 2022 09:13:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234770AbiBPONT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 16 Feb 2022 09:13:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E990160426
        for <ceph-devel@vger.kernel.org>; Wed, 16 Feb 2022 06:13:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF2C8B81EDA
        for <ceph-devel@vger.kernel.org>; Wed, 16 Feb 2022 14:13:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D148C004E1;
        Wed, 16 Feb 2022 14:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645020784;
        bh=P1bj5lzyw0KCW9/HmLDMlTXPXXFY69Nf++dL6y6YldY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Fsg2UeQlTOdGMcQxSDqsr9w1pXCl17Dp4tDNVkXu8E/jmQYOBG8053igIEENGjN/c
         CMkPdqePz3o74XJcyW0u/pR/MCi4Z8gsjpTQ+hnoCwqcVP0r3U/7ie4QgbXpz0MJHi
         0FV0SFtX1E6F+911Btvulte8QT+lj6kOSsQ/3TjBpbw0NOG5f8YSJyL0ijlQkC3Ws+
         dUayvuxBnWujf1a/YkzrdzWNDCtIrbV6cUTBMLYRxGGC67P1xc6txhKOTZZQvKv8I3
         SDECpD7Gp8W96Wg5iTCWr/uK4nuaUCE2VAu3555XPTgcoe4jgaICJ15Rwn5SbdEXvk
         N8EUCkCZIslPA==
Message-ID: <6a0e0c749921548b050301c22ae8f1aeceeb064a.camel@kernel.org>
Subject: Re: [PATCH] ceph: eliminate the recursion when rebuilding the snap
 context
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
Date:   Wed, 16 Feb 2022 09:13:02 -0500
In-Reply-To: <20220216054335.32015-1-xiubli@redhat.com>
References: <20220216054335.32015-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
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

On Wed, 2022-02-16 at 13:43 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> Use a list instead of recuresion to avoid possible stack overflow.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/snap.c  | 44 +++++++++++++++++++++++++++++++++++---------
>  fs/ceph/super.h |  2 ++
>  2 files changed, 37 insertions(+), 9 deletions(-)
> 

Thanks Xiubo. This seems sane to me.

> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> index 6939307d41cb..808add7dca9e 100644
> --- a/fs/ceph/snap.c
> +++ b/fs/ceph/snap.c
> @@ -319,7 +319,8 @@ static int cmpu64_rev(const void *a, const void *b)
>   * build the snap context for a given realm.
>   */
>  static int build_snap_context(struct ceph_snap_realm *realm,
> -			      struct list_head* dirty_realms)
> +			      struct list_head *realm_queue,
> +			      struct list_head *dirty_realms)
>  {
>  	struct ceph_snap_realm *parent = realm->parent;
>  	struct ceph_snap_context *snapc;
> @@ -333,9 +334,9 @@ static int build_snap_context(struct ceph_snap_realm *realm,
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
> @@ -418,13 +419,38 @@ static int build_snap_context(struct ceph_snap_realm *realm,
>  static void rebuild_snap_realms(struct ceph_snap_realm *realm,
>  				struct list_head *dirty_realms)
>  {
> -	struct ceph_snap_realm *child;
> +	LIST_HEAD(realm_queue);
> +	int last = 0;
>  
> -	dout("%s %llx %p\n", __func__, realm->ino, realm);
> -	build_snap_context(realm, dirty_realms);
> +	list_add_tail(&realm->rebuild_item, &realm_queue);
> +
> +	while (!list_empty(&realm_queue)) {
> +		struct ceph_snap_realm *_realm, *child;
> +
> +		/*
> +		 * If the last building failed dues to memory
> +		 * issue, just empty the realm_queue and return
> +		 * to avoid infinite loop.
> +		 */
> +		if (last < 0) {
> +			list_del(&_realm->rebuild_item);
> +			continue;
> +		}

So if this ends up happening, then we'll just end up silently returning
and not report anything to the console. Should we pr_warn or something
instead? We could make rebuild_snap_realms be an int return function,
and have it trigger the pr_err in ceph_update_snap_trace. That message
is pretty cryptic though.


It seems like the realm hierarchy would be FUBAR at this point. What's
the likely effect if that happens? Are there any steps an admin could
take to try and rescue things (maybe after freeing some memory on the
box)?

> +
> +		_realm = list_first_entry(&realm_queue,
> +					  struct ceph_snap_realm,
> +					  rebuild_item);
> +		last = build_snap_context(_realm, &realm_queue, dirty_realms);
> +		dout("%s %llx %p, %s\n", __func__, _realm->ino, _realm,
> +		     last > 0 ? "is deferred" : !last ? "succeeded" : "failed");
>  
> -	list_for_each_entry(child, &realm->children, child_item)
> -		rebuild_snap_realms(child, dirty_realms);
> +		list_for_each_entry(child, &_realm->children, child_item)
> +			list_add_tail(&child->rebuild_item, &realm_queue);
> +
> +		/* last == 1 means need to build parent first */
> +		if (last <= 0)
> +			list_del(&_realm->rebuild_item);
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

I'll plan to merge this into testing branch and do some testing with it,
but I wouldn't mind a v2 or follow-on patch that clarifies what can be
done if build_snap_context fails.

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>
