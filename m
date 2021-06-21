Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 113113AF69B
	for <lists+ceph-devel@lfdr.de>; Mon, 21 Jun 2021 22:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231717AbhFUUIA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 21 Jun 2021 16:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbhFUUH7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 21 Jun 2021 16:07:59 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C9C1C061574
        for <ceph-devel@vger.kernel.org>; Mon, 21 Jun 2021 13:05:45 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id h2so5543704iob.11
        for <ceph-devel@vger.kernel.org>; Mon, 21 Jun 2021 13:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SOSmMtdj9IEH98Vm3+ksLkmS4cvJT3eZpQPnUZILwI0=;
        b=Qun0RMOWK6xLgWSnnzoR1cKHYnmdXZvI3h/9aIE7dopR1uNRtGNKy4s1QEcXsOhS1O
         7Q8+BwKIItNd0FgytckLSH0xQD3LtS+PbcVmC3vzgbvKa6FR2G/d2R94ZlIP58Z8l+83
         zZxGarhFfONE2tdTKUTl27SCtjH52w/rmgRUyNPwQBKyuOQx4mVUYpS8zEYviW74GitW
         idsFJ8JlRKZzDNBFOuYzx/8rasDn+JvGRbkHmoVMs6u2H4sGA3SRTMCEi55g/xMdxBVq
         /l2/wqT8XvWy4xVfC8WArwTfNRzssgyC+TRU0pxPFZWD7x8jWbNyc87l1/VIHX4jn9/l
         2A/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SOSmMtdj9IEH98Vm3+ksLkmS4cvJT3eZpQPnUZILwI0=;
        b=tPewM/uPaudGWlfRRjpLY2y60bVR5STRj2e2L0IRkPvR2vmB0ZQtIAnYBY+z3yUnu9
         sN3K0L1G/PYskEGSKTGn8kxSbpEp3/GrsT8xOH71MqzIko2fK2Fug803q6pGKHphcbA/
         9/BApdwYYAE+paeLe6TxnXKT6ho9jaATVn+jHhWlrFa9rXitJ+FpJJS2Ugee7er3XZEN
         2Ljf79kkB+2M6ekvcuhL5HFmdbfXhrBvRs7YlnBaPpegtA3F35xKACyTJOGyKS3hyMoG
         j+I4VnjNsK16X1M4sHaylTdAEeO0QekYltlG4tctliq2ehDS+S1q0RpiRBIFlSJ3kd3H
         t0Wg==
X-Gm-Message-State: AOAM533gc2EIT6bsWXmulfn/sC4vu4IeGdWjwvoqa+tDtDc8iVOLkc+u
        brEekOTUKqjMv9gt6d0Nr5AShXMudIb78oX0wIbMoIDAvtyiwA==
X-Google-Smtp-Source: ABdhPJzqam3Rfn4QBKGEwXMO94XdslXU429at7QNRgySgf8A/viUHXw3NSHbRD0CPlTdatNvvay/TOu8Iv2kPm1EiNY=
X-Received: by 2002:a05:6602:21d2:: with SMTP id c18mr30134ioc.7.1624305944788;
 Mon, 21 Jun 2021 13:05:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210603165231.110559-1-jlayton@kernel.org> <20210603165231.110559-2-jlayton@kernel.org>
In-Reply-To: <20210603165231.110559-2-jlayton@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 21 Jun 2021 22:05:32 +0200
Message-ID: <CAOi1vP9eGNxfS5suHGeBpK5H9jdWphoioutwT25=jKSw8u5UmA@mail.gmail.com>
Subject: Re: [PATCH 1/3] ceph: add some lockdep assertions around snaprealm handling
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Jun 3, 2021 at 6:52 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> Turn some comments into lockdep asserts.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/snap.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>
> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> index 2a63fb37778b..bc6c33d485e6 100644
> --- a/fs/ceph/snap.c
> +++ b/fs/ceph/snap.c
> @@ -65,6 +65,8 @@
>  void ceph_get_snap_realm(struct ceph_mds_client *mdsc,
>                          struct ceph_snap_realm *realm)
>  {
> +       lockdep_assert_held_write(&mdsc->snap_rwsem);
> +
>         dout("get_realm %p %d -> %d\n", realm,
>              atomic_read(&realm->nref), atomic_read(&realm->nref)+1);
>         /*
> @@ -113,6 +115,8 @@ static struct ceph_snap_realm *ceph_create_snap_realm(
>  {
>         struct ceph_snap_realm *realm;
>
> +       lockdep_assert_held_write(&mdsc->snap_rwsem);
> +
>         realm = kzalloc(sizeof(*realm), GFP_NOFS);
>         if (!realm)
>                 return ERR_PTR(-ENOMEM);
> @@ -143,6 +147,8 @@ static struct ceph_snap_realm *__lookup_snap_realm(struct ceph_mds_client *mdsc,
>         struct rb_node *n = mdsc->snap_realms.rb_node;
>         struct ceph_snap_realm *r;
>
> +       lockdep_assert_held_write(&mdsc->snap_rwsem);
> +
>         while (n) {
>                 r = rb_entry(n, struct ceph_snap_realm, node);
>                 if (ino < r->ino)
> @@ -176,6 +182,8 @@ static void __put_snap_realm(struct ceph_mds_client *mdsc,
>  static void __destroy_snap_realm(struct ceph_mds_client *mdsc,
>                                  struct ceph_snap_realm *realm)
>  {
> +       lockdep_assert_held_write(&mdsc->snap_rwsem);
> +
>         dout("__destroy_snap_realm %p %llx\n", realm, realm->ino);
>
>         rb_erase(&realm->node, &mdsc->snap_realms);
> @@ -198,6 +206,8 @@ static void __destroy_snap_realm(struct ceph_mds_client *mdsc,
>  static void __put_snap_realm(struct ceph_mds_client *mdsc,
>                              struct ceph_snap_realm *realm)
>  {
> +       lockdep_assert_held_write(&mdsc->snap_rwsem);

This one appears to be redundant since the only caller is
__destroy_snap_realm().

> +
>         dout("__put_snap_realm %llx %p %d -> %d\n", realm->ino, realm,
>              atomic_read(&realm->nref), atomic_read(&realm->nref)-1);
>         if (atomic_dec_and_test(&realm->nref))
> @@ -236,6 +246,8 @@ static void __cleanup_empty_realms(struct ceph_mds_client *mdsc)
>  {
>         struct ceph_snap_realm *realm;
>
> +       lockdep_assert_held_write(&mdsc->snap_rwsem);

This too since it boils down to calling __destroy_snap_realm().

> +
>         spin_lock(&mdsc->snap_empty_lock);
>         while (!list_empty(&mdsc->snap_empty)) {
>                 realm = list_first_entry(&mdsc->snap_empty,
> @@ -269,6 +281,8 @@ static int adjust_snap_realm_parent(struct ceph_mds_client *mdsc,
>  {
>         struct ceph_snap_realm *parent;
>
> +       lockdep_assert_held_write(&mdsc->snap_rwsem);

And this since ceph_lookup_snap_realm() is called right away.

> +
>         if (realm->parent_ino == parentino)
>                 return 0;
>
> @@ -696,6 +710,8 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
>         int err = -ENOMEM;
>         LIST_HEAD(dirty_realms);
>
> +       lockdep_assert_held_write(&mdsc->snap_rwsem);

Ditto.

Thanks,

                Ilya
