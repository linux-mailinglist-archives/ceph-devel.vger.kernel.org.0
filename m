Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C87D4BC004
	for <lists+ceph-devel@lfdr.de>; Fri, 18 Feb 2022 19:56:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235302AbiBRS4e (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 18 Feb 2022 13:56:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235716AbiBRS4d (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 18 Feb 2022 13:56:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC0F124CCDB
        for <ceph-devel@vger.kernel.org>; Fri, 18 Feb 2022 10:56:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5379961715
        for <ceph-devel@vger.kernel.org>; Fri, 18 Feb 2022 18:56:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EC67C340E9;
        Fri, 18 Feb 2022 18:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645210575;
        bh=ot2uP/DNb+3gzoydT3+/vDJQP39LMBiNOfdPuZlWj4U=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=JcLep01zKOYtKhGj72Ztd1P6X/GjzQLqHsIu5OJGG5COCRKBIZpKFnIU3uFRb50L4
         67cXifM/My6QP9m7/em+ylnGSznJlqXH2V2kaxP0vy7+Huxqy75UJ1p/HNujfDVqgL
         stWGy85kBmCgNg3CQQ8TXPbcNQ9amPq0S+I2koPiNszKC3L42H7rk4NWIb7bEKW+cV
         VAlH2Z7hvnVhpWSVwX6ofwhJMAATf2Twkn+LCdy8SVOFQec8i1ZizGj2vZ7T7XpiNi
         M9cQud/8/qY0DWG+LqWuRmsy4UDWtdnaVGiM61b4Z1kpmr0UL0x1EIM4ww3gLePVVN
         Wz6c6iw82EqoQ==
Message-ID: <c00f33d0cae058087a3ee686e4df8163d2d92a3a.camel@kernel.org>
Subject: Re: [PATCH 1/3] ceph: move to a dedicated slabcache for
 ceph_cap_snap
From:   Jeff Layton <jlayton@kernel.org>
To:     =?ISO-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>,
        xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
Date:   Fri, 18 Feb 2022 13:56:13 -0500
In-Reply-To: <8735kghwnw.fsf@brahms.olymp>
References: <20220215122316.7625-1-xiubli@redhat.com>
         <20220215122316.7625-2-xiubli@redhat.com> <8735kghwnw.fsf@brahms.olymp>
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

On Fri, 2022-02-18 at 18:11 +0000, Luís Henriques wrote:
> xiubli@redhat.com writes:
> 
> > From: Xiubo Li <xiubli@redhat.com>
> > 
> > There could be huge number of capsnap queued in a short time, on
> > x86_64 it's 248 bytes, which will be rounded up to 256 bytes by
> > kzalloc. Move this to a dedicated slabcache to save 8 bytes for
> > each.
> > 
> > For the kmalloc-256 slab cache, the actual size will be 512 bytes:
> > kmalloc-256        21797  74656    512   32    4 : tunables, etc
> > 
> > For a dedicated slab cache the real size is 312 bytes:
> > ceph_cap_snap          0      0    312   52    4 : tunables, etc
> > 
> > So actually we can save 200 bytes for each.
> > 
> > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > ---
> >  fs/ceph/snap.c               | 5 +++--
> >  fs/ceph/super.c              | 7 +++++++
> >  fs/ceph/super.h              | 2 +-
> >  include/linux/ceph/libceph.h | 1 +
> >  4 files changed, 12 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> > index b41e6724c591..c787775eaf2a 100644
> > --- a/fs/ceph/snap.c
> > +++ b/fs/ceph/snap.c
> > @@ -482,7 +482,7 @@ static void ceph_queue_cap_snap(struct ceph_inode_info *ci)
> >  	struct ceph_buffer *old_blob = NULL;
> >  	int used, dirty;
> >  
> > -	capsnap = kzalloc(sizeof(*capsnap), GFP_NOFS);
> > +	capsnap = kmem_cache_alloc(ceph_cap_snap_cachep, GFP_NOFS);
> 
> Unfortunately, this is causing issues in my testing.  Looks like there are
> several fields that are assumed to be initialised to zero.  I've seen two
> BUGs so far, in functions ceph_try_drop_cap_snap (capsnap->cap_flush.tid > 0)
> and __ceph_finish_cap_snap (capsnap->writing).
> 
> I guess you'll have to either zero out all that memory, or manually
> initialise the fields (not sure which ones really require that).


Good catch. That memory is expected to be zeroed. I switched it to use
kmem_cache_zalloc in testing branch, which should fix this. Please let
me know if it doesn't.

-- 
Jeff Layton <jlayton@kernel.org>
