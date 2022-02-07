Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8C64ABFDE
	for <lists+ceph-devel@lfdr.de>; Mon,  7 Feb 2022 14:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241338AbiBGNoJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 7 Feb 2022 08:44:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443459AbiBGNIG (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 7 Feb 2022 08:08:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E0DAC0401D4
        for <ceph-devel@vger.kernel.org>; Mon,  7 Feb 2022 05:08:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E4A160EB5
        for <ceph-devel@vger.kernel.org>; Mon,  7 Feb 2022 13:08:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 098DFC004E1;
        Mon,  7 Feb 2022 13:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644239283;
        bh=Bd5n16U6MCARGHks1g1be4aNJ6wW32gLwU7lvbj+004=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GZyxCz7kX3gaOnruhm3wEDcphbxEbaJispLojqcS7+8l2kWv5TszgOzXz6PnSU3iy
         sIYG9HqbhZYlZz4UiVQUIBv9ba6QO0Ps5bqDSPnw1apCMDfKWFji4o4AtFVn0TQaKC
         ulaElo6tkZ8aTOsDTTMrnPOnsnChpy2B5I9wqShALdSKT+ea7frqf/loJ3hGNP523j
         t4fB8C6W3wEClruv09vEKk55WzlZ/2VN8vIk0lKRh2U7INo2ETfUd9Zo8c5Vg7Gdx4
         k+mGvLJ1lfwR6ztwiw4tiKLgzT94lfsQ7DQazilXSaLhJ0/qtLp9DLhuCPdMO+y54M
         Kr6hy81yWMsDA==
Message-ID: <199f8e951498f261174d8c9656b6feafdcded7ad.camel@kernel.org>
Subject: Re: [PATCH] ceph: wait for async create reply before sending any
 cap messages
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>, ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, pdonnell@redhat.com
Date:   Mon, 07 Feb 2022 08:08:01 -0500
In-Reply-To: <60e4e14e-687b-7f8a-8dc9-548bd41619a4@redhat.com>
References: <20220205151705.36309-1-jlayton@kernel.org>
         <60e4e14e-687b-7f8a-8dc9-548bd41619a4@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
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

On Mon, 2022-02-07 at 14:54 +0800, Xiubo Li wrote:
> On 2/5/22 11:17 PM, Jeff Layton wrote:
> > If we haven't received a reply to an async create request, then we don't
> > want to send any cap messages to the MDS for that inode yet.
> > 
> > Just have ceph_check_caps  and __kick_flushing_caps return without doing
> > anything, and have ceph_write_inode wait for the reply if we were asked
> > to wait on the inode writeback.
> > 
> > URL: https://tracker.ceph.com/issues/54107
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >   fs/ceph/caps.c | 14 ++++++++++++++
> >   1 file changed, 14 insertions(+)
> > 
> > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > index e668cdb9c99e..f29e2dbcf8df 100644
> > --- a/fs/ceph/caps.c
> > +++ b/fs/ceph/caps.c
> > @@ -1916,6 +1916,13 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
> >   		ceph_get_mds_session(session);
> >   
> >   	spin_lock(&ci->i_ceph_lock);
> > +	if (ci->i_ceph_flags & CEPH_I_ASYNC_CREATE) {
> > +		/* Don't send messages until we get async create reply */
> > +		spin_unlock(&ci->i_ceph_lock);
> > +		ceph_put_mds_session(session);
> > +		return;
> > +	}
> > +
> >   	if (ci->i_ceph_flags & CEPH_I_FLUSH)
> >   		flags |= CHECK_CAPS_FLUSH;
> >   retry:
> > @@ -2410,6 +2417,9 @@ int ceph_write_inode(struct inode *inode, struct writeback_control *wbc)
> >   	dout("write_inode %p wait=%d\n", inode, wait);
> >   	ceph_fscache_unpin_writeback(inode, wbc);
> >   	if (wait) {
> > +		err = ceph_wait_on_async_create(inode);
> > +		if (err)
> > +			return err;
> >   		dirty = try_flush_caps(inode, &flush_tid);
> >   		if (dirty)
> >   			err = wait_event_interruptible(ci->i_cap_wq,
> > @@ -2440,6 +2450,10 @@ static void __kick_flushing_caps(struct ceph_mds_client *mdsc,
> >   	u64 first_tid = 0;
> >   	u64 last_snap_flush = 0;
> >   
> > +	/* Don't do anything until create reply comes in */
> > +	if (ci->i_ceph_flags & CEPH_I_ASYNC_CREATE)
> > +		return;
> > +
> >   	ci->i_ceph_flags &= ~CEPH_I_KICK_FLUSH;
> >   
> >   	list_for_each_entry_reverse(cf, &ci->i_cap_flush_list, i_list) {
> 
> Is it also possible in case that just after the async unlinking request 
> is submit and a flush cap request is fired ? Then in MDS side the inode 
> could be removed from the cache and then the flush cap request comes.
> 
> 
> 

Yes. I think that race should be fairly benign though. The MDS might
drop the update onto the floor when it can't find the inode, but since
the inode is already stale, I don't think we really care...

-- 
Jeff Layton <jlayton@kernel.org>
