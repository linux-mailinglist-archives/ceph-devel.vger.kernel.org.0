Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E644B00F3
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Sep 2019 18:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbfIKQHo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 11 Sep 2019 12:07:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:56770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728794AbfIKQHn (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 11 Sep 2019 12:07:43 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30FC520838;
        Wed, 11 Sep 2019 16:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568218062;
        bh=cgtZ9n/TmyyYsxZlt4hJWzqGnmYQC40HilTRdyCXUjU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SIXf1GOEDj/RS+GqdBUQbX946ZECSod7wIlRWcb9gRo7CEExlSU5sO40F3OgqTO36
         ggSCJUscSqyi76xoaqyEihNxBdWg2nzhEbND3kERhbAC29DOgtwdzRhwaT+Q+CLh1G
         5sQ5y74VCqBCb6RTgEvtIlf1YEyotDBFhalWqfcc=
Message-ID: <7236975c5b8094d13b317ef8bd05121c5fd266a7.camel@kernel.org>
Subject: Re: [PATCH] libceph: use ceph_kvmalloc() for osdmap arrays
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Date:   Wed, 11 Sep 2019 12:07:41 -0400
In-Reply-To: <CAOi1vP9BE1R=8X2NZDCpkVHWv1WZ4sVjPbtcfZzNhrs3XByH=Q@mail.gmail.com>
References: <20190910194126.21144-1-idryomov@gmail.com>
         <6730435b5fbae66393de4b55d82891d9e7c4dd11.camel@kernel.org>
         <CAOi1vP9BE1R=8X2NZDCpkVHWv1WZ4sVjPbtcfZzNhrs3XByH=Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2019-09-11 at 17:08 +0200, Ilya Dryomov wrote:
> On Wed, Sep 11, 2019 at 4:54 PM Jeff Layton <jlayton@kernel.org> wrote:
> > On Tue, 2019-09-10 at 21:41 +0200, Ilya Dryomov wrote:
> > > osdmap has a bunch of arrays that grow linearly with the number of
> > > OSDs.  osd_state, osd_weight and osd_primary_affinity take 4 bytes per
> > > OSD.  osd_addr takes 136 bytes per OSD because of sockaddr_storage.
> > > The CRUSH workspace area also grows linearly with the number of OSDs.
> > > 
> > > Normally these arrays are allocated at client startup.  The osdmap is
> > > usually updated in small incrementals, but once in a while a full map
> > > may need to be processed.  For a cluster with 10000 OSDs, this means
> > > a bunch of 40K allocations followed by a 1.3M allocation, all of which
> > > are currently required to be physically contiguous.  This results in
> > > sporadic ENOMEM errors, hanging the client.
> > > 
> > > Go back to manually (re)allocating arrays and use ceph_kvmalloc() to
> > > fall back to non-contiguous allocation when necessary.
> > > 
> > > Link: https://tracker.ceph.com/issues/40481
> > > Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> > > ---
> > >  net/ceph/osdmap.c | 69 +++++++++++++++++++++++++++++------------------
> > >  1 file changed, 43 insertions(+), 26 deletions(-)
> > > 
> > > diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
> > > index 90437906b7bc..4e0de14f80bb 100644
> > > --- a/net/ceph/osdmap.c
> > > +++ b/net/ceph/osdmap.c
> > > @@ -973,11 +973,11 @@ void ceph_osdmap_destroy(struct ceph_osdmap *map)
> > >                                struct ceph_pg_pool_info, node);
> > >               __remove_pg_pool(&map->pg_pools, pi);
> > >       }
> > > -     kfree(map->osd_state);
> > > -     kfree(map->osd_weight);
> > > -     kfree(map->osd_addr);
> > > -     kfree(map->osd_primary_affinity);
> > > -     kfree(map->crush_workspace);
> > > +     kvfree(map->osd_state);
> > > +     kvfree(map->osd_weight);
> > > +     kvfree(map->osd_addr);
> > > +     kvfree(map->osd_primary_affinity);
> > > +     kvfree(map->crush_workspace);
> > >       kfree(map);
> > >  }
> > > 
> > > @@ -986,28 +986,41 @@ void ceph_osdmap_destroy(struct ceph_osdmap *map)
> > >   *
> > >   * The new elements are properly initialized.
> > >   */
> > > -static int osdmap_set_max_osd(struct ceph_osdmap *map, int max)
> > > +static int osdmap_set_max_osd(struct ceph_osdmap *map, u32 max)
> > >  {
> > >       u32 *state;
> > >       u32 *weight;
> > >       struct ceph_entity_addr *addr;
> > > +     u32 to_copy;
> > >       int i;
> > > 
> > > -     state = krealloc(map->osd_state, max*sizeof(*state), GFP_NOFS);
> > > -     if (!state)
> > > -             return -ENOMEM;
> > > -     map->osd_state = state;
> > > +     dout("%s old %u new %u\n", __func__, map->max_osd, max);
> > > +     if (max == map->max_osd)
> > > +             return 0;
> > > 
> > > -     weight = krealloc(map->osd_weight, max*sizeof(*weight), GFP_NOFS);
> > > -     if (!weight)
> > > +     state = ceph_kvmalloc(array_size(max, sizeof(*state)), GFP_NOFS);
> > > +     weight = ceph_kvmalloc(array_size(max, sizeof(*weight)), GFP_NOFS);
> > > +     addr = ceph_kvmalloc(array_size(max, sizeof(*addr)), GFP_NOFS);
> > 
> > Is GFP_NOFS sufficient here, given that this may be called from rbd?
> > Should we be using NOIO instead (or maybe the PF_MEMALLOC_* equivalent)?
> 
> It should be NOIO, but it has been this way forever, so I kept it
> (keeping the future conversion to scopes that I mentioned in another
> email in mind).
> 

Fair enough then. You can add my Reviewed-by:

-- 
Jeff Layton <jlayton@kernel.org>

