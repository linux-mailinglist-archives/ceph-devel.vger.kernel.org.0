Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 370343AF6FF
	for <lists+ceph-devel@lfdr.de>; Mon, 21 Jun 2021 22:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbhFUUxj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 21 Jun 2021 16:53:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:35192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229890AbhFUUxj (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 21 Jun 2021 16:53:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1F4061245;
        Mon, 21 Jun 2021 20:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624308684;
        bh=sxc3ohlV0y3X2N+PcNktVf8fwzesS9D4bgj7xo7NCiE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=M2ORE1BnQSqREcna1/RZh54TVtYoyQW4qP6UrhYTq0LRrJOgxu5m/DnXJ97yMcdDr
         FGcmt2RgMfT7isNoiCdDp/gfd8Ti4+gKW8mhWpPwhgV2lEStn4cxctoH9u2ETiKFv1
         nwFWkcw3L6E5rpjCa8iqVqausSX0c1Mmml6S9b/173PIoN0qvHJQDoTzQFObaK+gFX
         9s4yggE5Z1cksKxdVO9/731x0c++yxBPoUDRUDzYqQ84s0t1pphE90vqFmZjkK/kln
         DcXrwGH8xUlJLF/8uLXu1wE20uRV7NYUE8CHGv9DMvTr+OEMwX2LPr9IIvepybE1U9
         mZsgh/A0No+sQ==
Message-ID: <4d985178b5b5b95d324054928d291bd65c3f56fe.camel@kernel.org>
Subject: Re: [PATCH 1/3] ceph: add some lockdep assertions around snaprealm
 handling
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Date:   Mon, 21 Jun 2021 16:51:22 -0400
In-Reply-To: <CAOi1vP9eGNxfS5suHGeBpK5H9jdWphoioutwT25=jKSw8u5UmA@mail.gmail.com>
References: <20210603165231.110559-1-jlayton@kernel.org>
         <20210603165231.110559-2-jlayton@kernel.org>
         <CAOi1vP9eGNxfS5suHGeBpK5H9jdWphoioutwT25=jKSw8u5UmA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.2 (3.40.2-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2021-06-21 at 22:05 +0200, Ilya Dryomov wrote:
> On Thu, Jun 3, 2021 at 6:52 PM Jeff Layton <jlayton@kernel.org> wrote:
> > 
> > Turn some comments into lockdep asserts.
> > 
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/ceph/snap.c | 16 ++++++++++++++++
> >  1 file changed, 16 insertions(+)
> > 
> > diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> > index 2a63fb37778b..bc6c33d485e6 100644
> > --- a/fs/ceph/snap.c
> > +++ b/fs/ceph/snap.c
> > @@ -65,6 +65,8 @@
> >  void ceph_get_snap_realm(struct ceph_mds_client *mdsc,
> >                          struct ceph_snap_realm *realm)
> >  {
> > +       lockdep_assert_held_write(&mdsc->snap_rwsem);
> > +
> >         dout("get_realm %p %d -> %d\n", realm,
> >              atomic_read(&realm->nref), atomic_read(&realm->nref)+1);
> >         /*
> > @@ -113,6 +115,8 @@ static struct ceph_snap_realm *ceph_create_snap_realm(
> >  {
> >         struct ceph_snap_realm *realm;
> > 
> > +       lockdep_assert_held_write(&mdsc->snap_rwsem);
> > +
> >         realm = kzalloc(sizeof(*realm), GFP_NOFS);
> >         if (!realm)
> >                 return ERR_PTR(-ENOMEM);
> > @@ -143,6 +147,8 @@ static struct ceph_snap_realm *__lookup_snap_realm(struct ceph_mds_client *mdsc,
> >         struct rb_node *n = mdsc->snap_realms.rb_node;
> >         struct ceph_snap_realm *r;
> > 
> > +       lockdep_assert_held_write(&mdsc->snap_rwsem);
> > +
> >         while (n) {
> >                 r = rb_entry(n, struct ceph_snap_realm, node);
> >                 if (ino < r->ino)
> > @@ -176,6 +182,8 @@ static void __put_snap_realm(struct ceph_mds_client *mdsc,
> >  static void __destroy_snap_realm(struct ceph_mds_client *mdsc,
> >                                  struct ceph_snap_realm *realm)
> >  {
> > +       lockdep_assert_held_write(&mdsc->snap_rwsem);
> > +
> >         dout("__destroy_snap_realm %p %llx\n", realm, realm->ino);
> > 
> >         rb_erase(&realm->node, &mdsc->snap_realms);
> > @@ -198,6 +206,8 @@ static void __destroy_snap_realm(struct ceph_mds_client *mdsc,
> >  static void __put_snap_realm(struct ceph_mds_client *mdsc,
> >                              struct ceph_snap_realm *realm)
> >  {
> > +       lockdep_assert_held_write(&mdsc->snap_rwsem);
> 
> This one appears to be redundant since the only caller is
> __destroy_snap_realm().
> 
> > +
> >         dout("__put_snap_realm %llx %p %d -> %d\n", realm->ino, realm,
> >              atomic_read(&realm->nref), atomic_read(&realm->nref)-1);
> >         if (atomic_dec_and_test(&realm->nref))
> > @@ -236,6 +246,8 @@ static void __cleanup_empty_realms(struct ceph_mds_client *mdsc)
> >  {
> >         struct ceph_snap_realm *realm;
> > 
> > +       lockdep_assert_held_write(&mdsc->snap_rwsem);
> 
> This too since it boils down to calling __destroy_snap_realm().
> 
> > +
> >         spin_lock(&mdsc->snap_empty_lock);
> >         while (!list_empty(&mdsc->snap_empty)) {
> >                 realm = list_first_entry(&mdsc->snap_empty,
> > @@ -269,6 +281,8 @@ static int adjust_snap_realm_parent(struct ceph_mds_client *mdsc,
> >  {
> >         struct ceph_snap_realm *parent;
> > 
> > +       lockdep_assert_held_write(&mdsc->snap_rwsem);
> 
> And this since ceph_lookup_snap_realm() is called right away.
> 
> > +
> >         if (realm->parent_ino == parentino)
> >                 return 0;
> > 
> > @@ -696,6 +710,8 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
> >         int err = -ENOMEM;
> >         LIST_HEAD(dirty_realms);
> > 
> > +       lockdep_assert_held_write(&mdsc->snap_rwsem);
> 
> Ditto.
> 
> Thanks,
> 
>                 Ilya

Some of these calls may be redundant, but I'd still like to keep them.

The locking in this code is a mess, and this is the most reliable way
I've found to approach cleaning it up. These all compile out unless
you're running with lockdep enabled anyway.

-- 
Jeff Layton <jlayton@kernel.org>

