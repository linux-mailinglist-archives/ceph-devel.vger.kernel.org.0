Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12B0F4BA45A
	for <lists+ceph-devel@lfdr.de>; Thu, 17 Feb 2022 16:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242474AbiBQP2q (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 17 Feb 2022 10:28:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242467AbiBQP2p (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 17 Feb 2022 10:28:45 -0500
Received: from mail-ua1-x932.google.com (mail-ua1-x932.google.com [IPv6:2607:f8b0:4864:20::932])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 626EC2B0B2D
        for <ceph-devel@vger.kernel.org>; Thu, 17 Feb 2022 07:28:30 -0800 (PST)
Received: by mail-ua1-x932.google.com with SMTP id d22so2853444uaw.2
        for <ceph-devel@vger.kernel.org>; Thu, 17 Feb 2022 07:28:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uITQhHhbHpmobcrDHIOHBss+LDfp35e2NW2ZE5OLZnI=;
        b=R5Z1VNy5z5SD+8yTf1fc5uPHd6pj8X5BJDl109AlQUdxrxvLPeH83WcxhedUbCfVzV
         oWRQerRLDXqxTqblU+dYwddVTwFMyoo0mcbnOctV4ic6fnUh4fChp6uYL+8owuChonqX
         0S6nXgptH+0rWeRvOUYpyvTtI7kW8x3wbVzDRDU9Ng2eoAcNaPZQWa1f0+BkaudxXZ6G
         g9V7jnnUmkzJSX3exPW2iTxnxNAJtlvj8laEoF7SzyK1NU0KLsUwgy1kVqwJAv3UeIj8
         OVfK6PtXMl6Vt7iX1oDhmCMp1txiccSiWkXb63pBb4TDb3HUSwoyEk2XSnlLNW/3da85
         vxQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uITQhHhbHpmobcrDHIOHBss+LDfp35e2NW2ZE5OLZnI=;
        b=TUo7T9olm3UY0CNu8xrsoup2NJoXacgoh1kzczt3zLWRBIu3ipJBnULO6kfHSnvl7Y
         MMytTuNf1Gl953m22OclL8gDmOS9ROziRZqqKo6J/vda8hHvByn6eZSO1nStARhLLM0R
         3Zig0AMCZ54M2fUwnePpeM7Llg+k7yGBJlC970waGG74Gw4J3nTfUCDp2fPSg6COtVCS
         xQYvTG1JMCAqY5dutwejw17z1OgKas/10n8VrvjlywQDDpWu0gygUh3z7fkxC33dyarB
         alcZr34YmQJ5kuM/pQd3gOpxofmmhbBS07Rd+Bxtp5JXF1n2/RpzfTX2JuYe5WZczeb7
         DIQw==
X-Gm-Message-State: AOAM532mV7pAlltnIry0t8vYgLg6lY1USuPOHlfgU8gtRhYMM1+Ngp4y
        I6BW8Le5Ol8Kgr4uEArHIMfGEHlvncXtdkmFFgg=
X-Google-Smtp-Source: ABdhPJznrkOI6l8AmACLtkscziXM+ZpXeFn3mC+DO6d22z4ZQRpRWrmzLxxHlYkdst3piwzZUjXCbMgrrxKX63eIDDU=
X-Received: by 2002:ab0:849:0:b0:341:77e6:5883 with SMTP id
 b9-20020ab00849000000b0034177e65883mr845885uaf.67.1645111709373; Thu, 17 Feb
 2022 07:28:29 -0800 (PST)
MIME-Version: 1.0
References: <20220215122316.7625-1-xiubli@redhat.com> <20220215122316.7625-4-xiubli@redhat.com>
 <CAAM7YAn8QtZZORXbczE4cLdvGrrEW=AeaAM22f9EK4YNopo+qg@mail.gmail.com> <896b780d82a37a04e0533b69049c0112d4327055.camel@kernel.org>
In-Reply-To: <896b780d82a37a04e0533b69049c0112d4327055.camel@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Thu, 17 Feb 2022 23:28:18 +0800
Message-ID: <CAAM7YAnfs0eiJKGoHv_UjDi9D7U1vc3oEFuujeviCfAf_DXjfQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] ceph: do no update snapshot context when there is no
 new snapshot
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        Venky Shankar <vshankar@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Feb 17, 2022 at 6:55 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Thu, 2022-02-17 at 11:03 +0800, Yan, Zheng wrote:
> > On Tue, Feb 15, 2022 at 11:04 PM <xiubli@redhat.com> wrote:
> > >
> > > From: Xiubo Li <xiubli@redhat.com>
> > >
> > > No need to update snapshot context when any of the following two
> > > cases happens:
> > > 1: if my context seq matches realm's seq and realm has no parent.
> > > 2: if my context seq equals or is larger than my parent's, this
> > >    works because we rebuild_snap_realms() works _downward_ in
> > >    hierarchy after each update.
> > >
> > > This fix will avoid those inodes which accidently calling
> > > ceph_queue_cap_snap() and make no sense, for exmaple:
> > >
> > > There have 6 directories like:
> > >
> > > /dir_X1/dir_X2/dir_X3/
> > > /dir_Y1/dir_Y2/dir_Y3/
> > >
> > > Firstly, make a snapshot under /dir_X1/dir_X2/.snap/snap_X2, then
> > > make a root snapshot under /.snap/root_snap. And every time when
> > > we make snapshots under /dir_Y1/..., the kclient will always try
> > > to rebuild the snap context for snap_X2 realm and finally will
> > > always try to queue cap snaps for dir_Y2 and dir_Y3, which makes
> > > no sense.
> > >
> > > That's because the snap_X2's seq is 2 and root_snap's seq is 3.
> > > So when creating a new snapshot under /dir_Y1/... the new seq
> > > will be 4, and then the mds will send kclient a snapshot backtrace
> > > in _downward_ in hierarchy: seqs 4, 3. Then in ceph_update_snap_trace()
> > > it will always rebuild the from the last realm, that's the root_snap.
> > > So later when rebuilding the snap context it will always rebuild
> > > the snap_X2 realm and then try to queue cap snaps for all the inodes
> > > related in snap_X2 realm, and we are seeing the logs like:
> > >
> > > "ceph:  queue_cap_snap 00000000a42b796b nothing dirty|writing"
> > >
> > > URL: https://tracker.ceph.com/issues/44100
> > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > ---
> > >  fs/ceph/snap.c | 16 +++++++++-------
> > >  1 file changed, 9 insertions(+), 7 deletions(-)
> > >
> > > diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> > > index d075d3ce5f6d..1f24a5de81e7 100644
> > > --- a/fs/ceph/snap.c
> > > +++ b/fs/ceph/snap.c
> > > @@ -341,14 +341,16 @@ static int build_snap_context(struct ceph_snap_realm *realm,
> > >                 num += parent->cached_context->num_snaps;
> > >         }
> > >
> > > -       /* do i actually need to update?  not if my context seq
> > > -          matches realm seq, and my parents' does to.  (this works
> > > -          because we rebuild_snap_realms() works _downward_ in
> > > -          hierarchy after each update.) */
> > > +       /* do i actually need to update? No need when any of the following
> > > +        * two cases:
> > > +        * #1: if my context seq matches realm's seq and realm has no parent.
> > > +        * #2: if my context seq equals or is larger than my parent's, this
> > > +        *     works because we rebuild_snap_realms() works _downward_ in
> > > +        *     hierarchy after each update.
> > > +        */
> > >         if (realm->cached_context &&
> > > -           realm->cached_context->seq == realm->seq &&
> > > -           (!parent ||
> > > -            realm->cached_context->seq >= parent->cached_context->seq)) {
> > > +           ((realm->cached_context->seq == realm->seq && !parent) ||
> > > +            (parent && realm->cached_context->seq >= parent->cached_context->seq))) {
> >
> > With this change. When you mksnap on  /dir_Y1/, its snap context keeps
> > unchanged. In ceph_update_snap_trace, reset the 'invalidate' variable
> > for each realm should fix this issue.
> >
>
> This comment is terribly vague. "invalidate" is a local variable in that
> function and isn't set on a per-realm basis.
>
> Could you suggest a patch on top of Xiubo's patch instead?
>

something like this (not tested)

diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index af502a8245f0..6ef41764008b 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -704,7 +704,8 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
        __le64 *prior_parent_snaps;        /* encoded */
        struct ceph_snap_realm *realm = NULL;
        struct ceph_snap_realm *first_realm = NULL;
-       int invalidate = 0;
+       struct ceph_snap_realm *realm_to_inval = NULL;
+       int invalidate;
        int err = -ENOMEM;
        LIST_HEAD(dirty_realms);

@@ -712,6 +713,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,

        dout("update_snap_trace deletion=%d\n", deletion);
 more:
+       invalidate = 0;
        ceph_decode_need(&p, e, sizeof(*ri), bad);
        ri = p;
        p += sizeof(*ri);
@@ -774,8 +776,10 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
             realm, invalidate, p, e);

        /* invalidate when we reach the _end_ (root) of the trace */
-       if (invalidate && p >= e)
-               rebuild_snap_realms(realm, &dirty_realms);
+       if (invalidate)
+               realm_to_inval = realm;
+       if (realm_to_inval && p >= e)
+               rebuild_snap_realms(realm_to_inval, &dirty_realms);

        if (!first_realm)
                first_realm = realm;



>
> > >                 dout("build_snap_context %llx %p: %p seq %lld (%u snaps),
> > >                      " (unchanged)\n",
> > >                      realm->ino, realm, realm->cached_context,
> > > --
> > > 2.27.0
> > >
>
> --
> Jeff Layton <jlayton@kernel.org>
