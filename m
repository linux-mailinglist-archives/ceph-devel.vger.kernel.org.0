Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD944F89B2
	for <lists+ceph-devel@lfdr.de>; Fri,  8 Apr 2022 00:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbiDGUn0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 7 Apr 2022 16:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbiDGUnS (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 7 Apr 2022 16:43:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59264396AC8
        for <ceph-devel@vger.kernel.org>; Thu,  7 Apr 2022 13:32:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C65FCB8298A
        for <ceph-devel@vger.kernel.org>; Thu,  7 Apr 2022 20:32:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D10C385A0;
        Thu,  7 Apr 2022 20:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649363575;
        bh=evX+IlyBFJBbvyf3l754MV1VJYssd+VekpcdJMO1Cc4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cwjVUyeYgUhzstaY6BPmdvpZT3KEtKAm04j9+BRDy4cV9ZnogKNaOzcSaW4ZitkQU
         kQf51peHgetoaMbp2zoZFgNTpDg6rIVNEUAnvghvZC+98LGQvZTHqYaERs3zidHKEn
         jc6sAotEMnwOvIfuScpxqLK4vAhNS1zFrBMQBJi05QOdtzI7FX49xf9auSsJ+aR5pc
         jnCIR9X8WeeeGjkz8IdA6Dnd9hJn5jmU7jgWNvF8AqYa76fv7gPoI7tT1TlaOeZTgy
         oeco/vNVLZb+1eFAluzgKO8AvBQim3HBDT36JxL3w3oFsSMKacRpRr7Ob4fuNwR6CY
         El0HTgjds8LWQ==
Message-ID: <11456415d8729639ff7de083e833d49461d3c50c.camel@kernel.org>
Subject: Re: [PATCH 2/2] ceph: fix coherency issue when truncating file size
 for fscrypt
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org
Date:   Thu, 07 Apr 2022 16:32:53 -0400
In-Reply-To: <fd37ed30-b066-ce4d-ba99-1a85d593c5d3@redhat.com>
References: <20220407144112.8455-1-xiubli@redhat.com>
         <20220407144112.8455-3-xiubli@redhat.com>
         <3315c167cc44f38c4eb9ebe76685418e85c9b9f2.camel@kernel.org>
         <6439751daf27285f77239172a9bb5d5f0f80eede.camel@kernel.org>
         <fd37ed30-b066-ce4d-ba99-1a85d593c5d3@redhat.com>
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

On Fri, 2022-04-08 at 03:14 +0800, Xiubo Li wrote:
> On 4/7/22 11:38 PM, Jeff Layton wrote:
> > On Thu, 2022-04-07 at 11:33 -0400, Jeff Layton wrote:
> > > On Thu, 2022-04-07 at 22:41 +0800, xiubli@redhat.com wrote:
> > > > From: Xiubo Li <xiubli@redhat.com>
> > > > 
> > > > When truncating the file size the MDS will help update the last
> > > > encrypted block, and during this we need to make sure the client
> > > > won't fill the pagecaches.
> > > > 
> > > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > > ---
> > > >   fs/ceph/inode.c | 7 ++++++-
> > > >   1 file changed, 6 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> > > > index f4059d73edd5..cc1829ab497d 100644
> > > > --- a/fs/ceph/inode.c
> > > > +++ b/fs/ceph/inode.c
> > > > @@ -2647,9 +2647,12 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
> > > >   		req->r_num_caps = 1;
> > > >   		req->r_stamp = attr->ia_ctime;
> > > >   		if (fill_fscrypt) {
> > > > +			filemap_invalidate_lock(inode->i_mapping);
> > > >   			err = fill_fscrypt_truncate(inode, req, attr);
> > > > -			if (err)
> > > > +			if (err) {
> > > > +				filemap_invalidate_unlock(inode->i_mapping);
> > > >   				goto out;
> > > > +			}
> > > >   		}
> > > >   
> > > >   		/*
> > > > @@ -2660,6 +2663,8 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
> > > >   		 * it.
> > > >   		 */
> > > >   		err = ceph_mdsc_do_request(mdsc, NULL, req);
> > > > +		if (fill_fscrypt)
> > > > +			filemap_invalidate_unlock(inode->i_mapping);
> > > >   		if (err == -EAGAIN && truncate_retry--) {
> > > >   			dout("setattr %p result=%d (%s locally, %d remote), retry it!\n",
> > > >   			     inode, err, ceph_cap_string(dirtied), mask);
> > > Looks reasonable. Is there any reason we shouldn't do this in the non-
> > > encrypted case too? I suppose it doesn't make as much difference in that
> > > case.
> 
> We only need this in encrypted case, which will do the RMW for the last 
> block.
> 
> 
> > > I'll plan to pull this and the other patch into the wip-fscrypt branch.
> > > Should I just fold them into your earlier patches?
> Yeah, certainly.
> > OTOH...do we really need this? I'm not sure I understand the race you're
> > trying to prevent. Can you lay it out for me?
> 
> I am thinking during the RMW for the last block, the page fault still 
> could happen because the page fault function doesn't prevent that.
> 
> And we should prevent it during the RMW is going on.
> 

Right, but the RMW is being done using an anonymous page, and at this
point in the process we haven't really touched the pagecache yet. That
doesn't happen until __ceph_do_pending_vmtruncate.

Most of the callers for filemap_invalidate_lock/_unlock are in the hole
punching codepaths, and not so much in truncate. What outcome are you
trying to prevent with this? Can you lay out the potential race and why
it would be harmful?

-- 
Jeff Layton <jlayton@kernel.org>
