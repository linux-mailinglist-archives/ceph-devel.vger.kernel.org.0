Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85F633AF75C
	for <lists+ceph-devel@lfdr.de>; Mon, 21 Jun 2021 23:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231452AbhFUV3m (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 21 Jun 2021 17:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231234AbhFUV3j (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 21 Jun 2021 17:29:39 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E821C061574
        for <ceph-devel@vger.kernel.org>; Mon, 21 Jun 2021 14:27:23 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id a6so8918226ioe.0
        for <ceph-devel@vger.kernel.org>; Mon, 21 Jun 2021 14:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UKUPeWQVqMr+udebrKvSqI/ln5NTfG/adzcfNyJQY8s=;
        b=P6xOAI6BkS4Goe4tTfSd2aHDlI880W3C14b2weAJe0XNl/ibY0VqmjDf2t/JmPzICW
         rk34VgbglanM7cbl8JG3ggcEXAdvn97skcQDNb3ZoWVCqdfGc7hwvC+y85KSSctrKvsc
         w7aGQaOugA+08nuqHpEV1X50dRKKZ76i11Yous9VfwDKFXKdk6uHW5h9ivy0Vm5arlgm
         6PSqhRxGk9b36sEjHl4O5X44pylNYFLsTHl2FQO+GFHvlXbIrtOWc9Ri6r5OBiv+64DG
         TxT2ysjnyeSAcs3CbDBZWchVzwVC9DaDkcYLWkzIuy3jluKib5zIsu/pIjvfbqe+35xW
         RsKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UKUPeWQVqMr+udebrKvSqI/ln5NTfG/adzcfNyJQY8s=;
        b=QloHf6+lwATjN0H3+54wcLxivKN9dShL7Za4wK5Vcv+2SukKpaegRQXL5mfq3tZu8w
         rGu1AXrZ9h7G86yBdWN8+AbkmvEhSk9UCKHGD9GJcnmsafTxkJyXpq4XXUGxu9AegWIo
         +MYDDCzKECA4rnzl6Fj/JEu4kdzYOHB13PoI315qX2LjHMIRPHoUsc+J6O5Simu/P19+
         P4s/JfWifoYlmAiSgAAgcOt+IUVfrjkhFom9mwdrW05HhrCcuromQXzWi7DlvOyHkEon
         w/kqhXZOZQPCctRTAzPuR9wGpNqwWWYmhg8vb3Kjp0tOYYQGqfBSPLHuvfHF8TFaWwHL
         HBfA==
X-Gm-Message-State: AOAM532dja3ebbVmYVVeA4Rc1K9UA56lrlNInB2DKoqvCluVAWy7PBSU
        YvFU28cZ7HYNR5Xu144LZPsU1ap99oQcjD95t0s=
X-Google-Smtp-Source: ABdhPJzf1XhqP1MQDocp5fcf+s/cbuVDV9HnKYyQOsAzPB/JpZLCpvnSU8qdOiN2M5kR9jwsNgXrHtwOvh/9mdd9vnU=
X-Received: by 2002:a6b:8f83:: with SMTP id r125mr64647iod.123.1624310842980;
 Mon, 21 Jun 2021 14:27:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210603165231.110559-1-jlayton@kernel.org> <20210603165231.110559-2-jlayton@kernel.org>
 <CAOi1vP9eGNxfS5suHGeBpK5H9jdWphoioutwT25=jKSw8u5UmA@mail.gmail.com> <4d985178b5b5b95d324054928d291bd65c3f56fe.camel@kernel.org>
In-Reply-To: <4d985178b5b5b95d324054928d291bd65c3f56fe.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 21 Jun 2021 23:27:11 +0200
Message-ID: <CAOi1vP861+yBMDFrdkX7O18jNzhKwMWi=suvWCPEZJaYq7MzhQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] ceph: add some lockdep assertions around snaprealm handling
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jun 21, 2021 at 10:51 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Mon, 2021-06-21 at 22:05 +0200, Ilya Dryomov wrote:
> > On Thu, Jun 3, 2021 at 6:52 PM Jeff Layton <jlayton@kernel.org> wrote:
> > >
> > > Turn some comments into lockdep asserts.
> > >
> > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > ---
> > >  fs/ceph/snap.c | 16 ++++++++++++++++
> > >  1 file changed, 16 insertions(+)
> > >
> > > diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> > > index 2a63fb37778b..bc6c33d485e6 100644
> > > --- a/fs/ceph/snap.c
> > > +++ b/fs/ceph/snap.c
> > > @@ -65,6 +65,8 @@
> > >  void ceph_get_snap_realm(struct ceph_mds_client *mdsc,
> > >                          struct ceph_snap_realm *realm)
> > >  {
> > > +       lockdep_assert_held_write(&mdsc->snap_rwsem);
> > > +
> > >         dout("get_realm %p %d -> %d\n", realm,
> > >              atomic_read(&realm->nref), atomic_read(&realm->nref)+1);
> > >         /*
> > > @@ -113,6 +115,8 @@ static struct ceph_snap_realm *ceph_create_snap_realm(
> > >  {
> > >         struct ceph_snap_realm *realm;
> > >
> > > +       lockdep_assert_held_write(&mdsc->snap_rwsem);
> > > +
> > >         realm = kzalloc(sizeof(*realm), GFP_NOFS);
> > >         if (!realm)
> > >                 return ERR_PTR(-ENOMEM);
> > > @@ -143,6 +147,8 @@ static struct ceph_snap_realm *__lookup_snap_realm(struct ceph_mds_client *mdsc,
> > >         struct rb_node *n = mdsc->snap_realms.rb_node;
> > >         struct ceph_snap_realm *r;
> > >
> > > +       lockdep_assert_held_write(&mdsc->snap_rwsem);
> > > +
> > >         while (n) {
> > >                 r = rb_entry(n, struct ceph_snap_realm, node);
> > >                 if (ino < r->ino)
> > > @@ -176,6 +182,8 @@ static void __put_snap_realm(struct ceph_mds_client *mdsc,
> > >  static void __destroy_snap_realm(struct ceph_mds_client *mdsc,
> > >                                  struct ceph_snap_realm *realm)
> > >  {
> > > +       lockdep_assert_held_write(&mdsc->snap_rwsem);
> > > +
> > >         dout("__destroy_snap_realm %p %llx\n", realm, realm->ino);
> > >
> > >         rb_erase(&realm->node, &mdsc->snap_realms);
> > > @@ -198,6 +206,8 @@ static void __destroy_snap_realm(struct ceph_mds_client *mdsc,
> > >  static void __put_snap_realm(struct ceph_mds_client *mdsc,
> > >                              struct ceph_snap_realm *realm)
> > >  {
> > > +       lockdep_assert_held_write(&mdsc->snap_rwsem);
> >
> > This one appears to be redundant since the only caller is
> > __destroy_snap_realm().
> >
> > > +
> > >         dout("__put_snap_realm %llx %p %d -> %d\n", realm->ino, realm,
> > >              atomic_read(&realm->nref), atomic_read(&realm->nref)-1);
> > >         if (atomic_dec_and_test(&realm->nref))
> > > @@ -236,6 +246,8 @@ static void __cleanup_empty_realms(struct ceph_mds_client *mdsc)
> > >  {
> > >         struct ceph_snap_realm *realm;
> > >
> > > +       lockdep_assert_held_write(&mdsc->snap_rwsem);
> >
> > This too since it boils down to calling __destroy_snap_realm().
> >
> > > +
> > >         spin_lock(&mdsc->snap_empty_lock);
> > >         while (!list_empty(&mdsc->snap_empty)) {
> > >                 realm = list_first_entry(&mdsc->snap_empty,
> > > @@ -269,6 +281,8 @@ static int adjust_snap_realm_parent(struct ceph_mds_client *mdsc,
> > >  {
> > >         struct ceph_snap_realm *parent;
> > >
> > > +       lockdep_assert_held_write(&mdsc->snap_rwsem);
> >
> > And this since ceph_lookup_snap_realm() is called right away.
> >
> > > +
> > >         if (realm->parent_ino == parentino)
> > >                 return 0;
> > >
> > > @@ -696,6 +710,8 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
> > >         int err = -ENOMEM;
> > >         LIST_HEAD(dirty_realms);
> > >
> > > +       lockdep_assert_held_write(&mdsc->snap_rwsem);
> >
> > Ditto.
> >
> > Thanks,
> >
> >                 Ilya
>
> Some of these calls may be redundant, but I'd still like to keep them.
>
> The locking in this code is a mess, and this is the most reliable way
> I've found to approach cleaning it up. These all compile out unless
> you're running with lockdep enabled anyway.

Reviewed-by: Ilya Dryomov <idryomov@gmail.com>

Thanks,

                Ilya
