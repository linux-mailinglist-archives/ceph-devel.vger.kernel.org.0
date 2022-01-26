Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19DD049D292
	for <lists+ceph-devel@lfdr.de>; Wed, 26 Jan 2022 20:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244449AbiAZTiY (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 26 Jan 2022 14:38:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244467AbiAZTiX (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 26 Jan 2022 14:38:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2403BC06161C
        for <ceph-devel@vger.kernel.org>; Wed, 26 Jan 2022 11:38:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D35C4B81AC2
        for <ceph-devel@vger.kernel.org>; Wed, 26 Jan 2022 19:38:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 183C4C340E3;
        Wed, 26 Jan 2022 19:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643225900;
        bh=FFmfBgKrrY2lEfL2pwsunkKPKpesu88dLTtbdXY9poI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uyyWZyD+yEznWTMV7qIRtWbimYZQrAWkR/ae3eU1rhX5kOCFO8mthmdBUTFe+8QhM
         KP1U+naV/3AMsBdxhPbF+AM0HCXQWR678vDbHmGK9IFC7wpXwKcgFQXSUs7BPTMOth
         QkrxoPFf2ApJn0kWWY13JKrby7XKcnoFwKSCXw1AKxOv7q4tySAjg+U3jVnVdnrvBH
         Qpta5iF5Kt4q0YwZu60ELumy0ikJQJ5sgRkrHsZkiwZ/nQNkx6ke1QiGD/zOBZgv/5
         LxaC2AqDc/NqV7pTp2fYlZggBhwi36SE7ikKbouSIDyx1FH9JElHBxE6A7itAvEQJx
         yhJ5bYE3zxClA==
Message-ID: <89e55c2ec14427830209e05c748e7599d41bc00c.camel@kernel.org>
Subject: Re: [PATCH v2] ceph: set pool_ns in new inode layout for async
 creates
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Dan van der Ster <dan@vanderster.com>
Date:   Wed, 26 Jan 2022 14:38:18 -0500
In-Reply-To: <CAOi1vP8vpnF09H42wCSNNRnfziUSnB6-7BrOjNQ98yVso23rrQ@mail.gmail.com>
References: <20220126173649.163500-1-jlayton@kernel.org>
         <CAOi1vP8vpnF09H42wCSNNRnfziUSnB6-7BrOjNQ98yVso23rrQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2022-01-26 at 20:10 +0100, Ilya Dryomov wrote:
> On Wed, Jan 26, 2022 at 6:36 PM Jeff Layton <jlayton@kernel.org> wrote:
> > 
> > Dan reported that he was unable to write to files that had been
> > asynchronously created when the client's OSD caps are restricted to a
> > particular namespace.
> > 
> > The issue is that the layout for the new inode is only partially being
> > filled. Ensure that we populate the pool_ns_data and pool_ns_len in the
> > iinfo before calling ceph_fill_inode.
> > 
> > URL: https://tracker.ceph.com/issues/54013
> > Reported-by: Dan van der Ster <dan@vanderster.com>
> > Fixes: 9a8d03ca2e2c ("ceph: attempt to do async create when possible")
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/ceph/file.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > v2: don't take extra reference, just use rcu_dereference_raw
> > 
> > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > index cbe4d5a5cde5..22ca724aef36 100644
> > --- a/fs/ceph/file.c
> > +++ b/fs/ceph/file.c
> > @@ -599,6 +599,7 @@ static int ceph_finish_async_create(struct inode *dir, struct dentry *dentry,
> >         struct ceph_inode_info *ci = ceph_inode(dir);
> >         struct inode *inode;
> >         struct timespec64 now;
> > +       struct ceph_string *pool_ns;
> >         struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(dir->i_sb);
> >         struct ceph_vino vino = { .ino = req->r_deleg_ino,
> >                                   .snap = CEPH_NOSNAP };
> > @@ -648,6 +649,12 @@ static int ceph_finish_async_create(struct inode *dir, struct dentry *dentry,
> >         in.max_size = cpu_to_le64(lo->stripe_unit);
> > 
> >         ceph_file_layout_to_legacy(lo, &in.layout);
> > +       /* lo is private, so pool_ns can't change */
> > +       pool_ns = rcu_dereference_raw(lo->pool_ns);
> > +       if (pool_ns) {
> > +               iinfo.pool_ns_len = pool_ns->len;
> > +               iinfo.pool_ns_data = pool_ns->str;
> > +       }
> > 
> >         down_read(&mdsc->snap_rwsem);
> >         ret = ceph_fill_inode(inode, NULL, &iinfo, NULL, req->r_session,
> > --
> > 2.34.1
> > 
> 
> There seems to be a gap in nowsync coverage -- do we have a ticket for
> adding a test case for namespace-constrained caps or someone is already
> on it?
> 
> Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
> 

Yeah, I was planning to look into that as part of the tracker that Dan
opened.

We do test both wsync and nowsync with the kclient, but apparently we
don't test namespace-constrained caps with them? Or maybe we just got
unlucky with some of the randomness involved?

I'm not sure either way, but this configuration is essentially what
"ceph fs subvolume authorize" does, so we need to ensure that we are
testing it regularly.
-- 
Jeff Layton <jlayton@kernel.org>
