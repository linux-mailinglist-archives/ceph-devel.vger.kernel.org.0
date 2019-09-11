Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 619CEAFF99
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Sep 2019 17:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728198AbfIKPI1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 11 Sep 2019 11:08:27 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:46772 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbfIKPI0 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 11 Sep 2019 11:08:26 -0400
Received: by mail-io1-f68.google.com with SMTP id d17so24675359ios.13
        for <ceph-devel@vger.kernel.org>; Wed, 11 Sep 2019 08:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ffkeqxKM+UsdYMhxtgey7Fyc4qEfU6E6dQRhp50MAos=;
        b=k97bVlYma0nNURhArx+puvEoS1KgxOJc0ow7RGs46lXrX7gtnsB6lk+zNrZ3ot6cqA
         uUR6P4HAD+5isc6tO+Trh5aLovj3N33asQUbtV9xkb7W4qLYCeN0cvG/gwdeIQEdbQnv
         J1+GWUd6u1dbnTfmzdlPCRSGsEwZDhNo3PSiwOAzv3qiJFyJylJXw4r5C/KyjBF66kWr
         PeprZecHS6M59/Dq6NIgMI0EgogVtn/aAZrME1tn6AHrbDyAtQ6GlEosoq5SXn9Mb5Qn
         wv9nIRSvk2YsbwARzOYJirTiwlMoknDKCxMlKcmqRuZewkK5QjjzKPNbr2dC0msNmF3s
         upzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ffkeqxKM+UsdYMhxtgey7Fyc4qEfU6E6dQRhp50MAos=;
        b=rKXRDOsyNJbEP+JDRodBAMkUONpS8GLlzBs702kCaVFTg5SzlwiKFcR984cmICvkRU
         xx94v969mJttAB8O1UHmWV4Clt/xVKxA7XEh0gUyKTU1cSGMvDs5B7xIjB1YobB4t4Z0
         UQ5AhMDHyiJpo6mfDHkDmca2TWCM4uj3tdiMzwi5Py8qYe86MxE6SuG+JAZ2kWQb+8zx
         daHre7nFGav2rBnPcm69cOB/QW44G/93FGMwxbWx82n5VeX5l+xX7z6YhHCViaSWtUqG
         4Oy76JByXoWuK9K4ZXeo0NCwWKnKZ0JvuIh6kD+lqrGEUCEHjy6IK1zUVFYA/ZUcWCer
         cqOA==
X-Gm-Message-State: APjAAAUrszUtZmw2ASvDXgDzlEJUip03G1K8hcPFvd+GKr9XRZzBEDKH
        JhTnrosCNeBcCQJRAMU65YbMVI1tYQCuZ+f7d84=
X-Google-Smtp-Source: APXvYqzQ56r9QWzJ04Z8OOVwtH1TEGq9yZjXFmSVjehTcyMj57Aw1co7GP1N/70XK3vefTh7g6SUL8HLznz5jJZjorY=
X-Received: by 2002:a5e:d60e:: with SMTP id w14mr6753293iom.215.1568214506083;
 Wed, 11 Sep 2019 08:08:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190910194126.21144-1-idryomov@gmail.com> <6730435b5fbae66393de4b55d82891d9e7c4dd11.camel@kernel.org>
In-Reply-To: <6730435b5fbae66393de4b55d82891d9e7c4dd11.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 11 Sep 2019 17:08:17 +0200
Message-ID: <CAOi1vP9BE1R=8X2NZDCpkVHWv1WZ4sVjPbtcfZzNhrs3XByH=Q@mail.gmail.com>
Subject: Re: [PATCH] libceph: use ceph_kvmalloc() for osdmap arrays
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Sep 11, 2019 at 4:54 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Tue, 2019-09-10 at 21:41 +0200, Ilya Dryomov wrote:
> > osdmap has a bunch of arrays that grow linearly with the number of
> > OSDs.  osd_state, osd_weight and osd_primary_affinity take 4 bytes per
> > OSD.  osd_addr takes 136 bytes per OSD because of sockaddr_storage.
> > The CRUSH workspace area also grows linearly with the number of OSDs.
> >
> > Normally these arrays are allocated at client startup.  The osdmap is
> > usually updated in small incrementals, but once in a while a full map
> > may need to be processed.  For a cluster with 10000 OSDs, this means
> > a bunch of 40K allocations followed by a 1.3M allocation, all of which
> > are currently required to be physically contiguous.  This results in
> > sporadic ENOMEM errors, hanging the client.
> >
> > Go back to manually (re)allocating arrays and use ceph_kvmalloc() to
> > fall back to non-contiguous allocation when necessary.
> >
> > Link: https://tracker.ceph.com/issues/40481
> > Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> > ---
> >  net/ceph/osdmap.c | 69 +++++++++++++++++++++++++++++------------------
> >  1 file changed, 43 insertions(+), 26 deletions(-)
> >
> > diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
> > index 90437906b7bc..4e0de14f80bb 100644
> > --- a/net/ceph/osdmap.c
> > +++ b/net/ceph/osdmap.c
> > @@ -973,11 +973,11 @@ void ceph_osdmap_destroy(struct ceph_osdmap *map)
> >                                struct ceph_pg_pool_info, node);
> >               __remove_pg_pool(&map->pg_pools, pi);
> >       }
> > -     kfree(map->osd_state);
> > -     kfree(map->osd_weight);
> > -     kfree(map->osd_addr);
> > -     kfree(map->osd_primary_affinity);
> > -     kfree(map->crush_workspace);
> > +     kvfree(map->osd_state);
> > +     kvfree(map->osd_weight);
> > +     kvfree(map->osd_addr);
> > +     kvfree(map->osd_primary_affinity);
> > +     kvfree(map->crush_workspace);
> >       kfree(map);
> >  }
> >
> > @@ -986,28 +986,41 @@ void ceph_osdmap_destroy(struct ceph_osdmap *map)
> >   *
> >   * The new elements are properly initialized.
> >   */
> > -static int osdmap_set_max_osd(struct ceph_osdmap *map, int max)
> > +static int osdmap_set_max_osd(struct ceph_osdmap *map, u32 max)
> >  {
> >       u32 *state;
> >       u32 *weight;
> >       struct ceph_entity_addr *addr;
> > +     u32 to_copy;
> >       int i;
> >
> > -     state = krealloc(map->osd_state, max*sizeof(*state), GFP_NOFS);
> > -     if (!state)
> > -             return -ENOMEM;
> > -     map->osd_state = state;
> > +     dout("%s old %u new %u\n", __func__, map->max_osd, max);
> > +     if (max == map->max_osd)
> > +             return 0;
> >
> > -     weight = krealloc(map->osd_weight, max*sizeof(*weight), GFP_NOFS);
> > -     if (!weight)
> > +     state = ceph_kvmalloc(array_size(max, sizeof(*state)), GFP_NOFS);
> > +     weight = ceph_kvmalloc(array_size(max, sizeof(*weight)), GFP_NOFS);
> > +     addr = ceph_kvmalloc(array_size(max, sizeof(*addr)), GFP_NOFS);
>
> Is GFP_NOFS sufficient here, given that this may be called from rbd?
> Should we be using NOIO instead (or maybe the PF_MEMALLOC_* equivalent)?

It should be NOIO, but it has been this way forever, so I kept it
(keeping the future conversion to scopes that I mentioned in another
email in mind).

Thanks,

                Ilya
