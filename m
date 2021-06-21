Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC0C93AF6FD
	for <lists+ceph-devel@lfdr.de>; Mon, 21 Jun 2021 22:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbhFUUvI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 21 Jun 2021 16:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbhFUUvG (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 21 Jun 2021 16:51:06 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EB32C061756
        for <ceph-devel@vger.kernel.org>; Mon, 21 Jun 2021 13:48:51 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id q12so5664000ilv.5
        for <ceph-devel@vger.kernel.org>; Mon, 21 Jun 2021 13:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6n97mR+LTWNTLV9sKPwfq1vMpABCEs3QKfAdDOJMDfo=;
        b=MDwUA5b+gdbSFgJkpI/UEkGHFweplMfPj34UcPOVSXHLLRN1N6t07grvtpoUtFCE0h
         SJqpCVWpMZ/BvWQsODO3qYO7oI61yHyPJSnw7G7/voaC3SJYRXYt2EB6hTQzBPrQFR5e
         mYh61hTT5O2yLK2Vqu+x7ibchnL8CHykOpSr5kEwY+Rrfy3HI4fZXzXM9DlORQpb0TCd
         MhG2O2wCXQ80+Vg4TbfYeUkYQ6d/uRWJNUXuQR8yOuugrQXwFB0GrfbPeGcgU6i4CR+n
         s4Ud5FBT5FEnbAj6NpVYT6GjXwiUQAXp7fdJrpaYvKKZETJH06Ovq9Eieijd5mbIfCpu
         8j5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6n97mR+LTWNTLV9sKPwfq1vMpABCEs3QKfAdDOJMDfo=;
        b=KkLtR23cL691Cspdee6C0jb3NnIMlWcNPIpEZBP/60QiL2Z0LTLGflHur5bi0i1UmM
         pRpMFYbX91rxY9MBJH6BVuCsLrkpjwrXAWUngfnTbn0n1YhFI/pDI6aI9/S0i1reT4ux
         d52wo1ot3/jqT/uLyi9kCnfq4O1Qz+zml0RCBaZWymI51y1R97FWlLgFCngTS1MgloCi
         3Z3er0FR4a7bhSVkCK+Q1jVdehM5D3JvsNydvYGUyhCkv07Dyt6Qchas011rwKd1wUxc
         0TyXiQzPllt7GUmWIObpR0Iuvj4g3FRyJUj/bkzwMukcuLsuHZHpsFjIILAsaFHwvNhV
         xitg==
X-Gm-Message-State: AOAM531TicCITBxD6EHxyyEnrBwpVRusDi0Lu7lcVo3PpIoUjOdY7F8L
        f4ZeHzM4WiRfAmOS5bcbUnSx96mzTE8TJUihBc3eA1mHI9O+hg==
X-Google-Smtp-Source: ABdhPJz7/Lxiwa0akAfuKM5/iyZg933kSmurWwfV2x1yycmWqVbhZh0TwDwW/AasCQbYtkek1qwkCOci7H3xjtvTNhM=
X-Received: by 2002:a05:6e02:1906:: with SMTP id w6mr69607ilu.281.1624308531033;
 Mon, 21 Jun 2021 13:48:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210603165231.110559-1-jlayton@kernel.org> <20210603165231.110559-3-jlayton@kernel.org>
In-Reply-To: <20210603165231.110559-3-jlayton@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 21 Jun 2021 22:48:39 +0200
Message-ID: <CAOi1vP83Za9rW3wK-XvOW8k=UXObczyQeQgTmrQRRXJ0yOmXsw@mail.gmail.com>
Subject: Re: [PATCH 2/3] ceph: clean up locking annotation for
 ceph_get_snap_realm and __lookup_snap_realm
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Jun 3, 2021 at 6:52 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> They both say that the snap_rwsem must be held for write, but I don't
> see any real reason for it, and it's not currently always called that
> way.
>
> The lookup is just walking the rbtree, so holding it for read should be
> fine there. The "get" is bumping the refcount and (possibly) removing
> it from the empty list. I see no need to hold the snap_rwsem for write
> for that.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/snap.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> index bc6c33d485e6..f8cac2abab3f 100644
> --- a/fs/ceph/snap.c
> +++ b/fs/ceph/snap.c
> @@ -60,12 +60,12 @@
>  /*
>   * increase ref count for the realm
>   *
> - * caller must hold snap_rwsem for write.
> + * caller must hold snap_rwsem.
>   */
>  void ceph_get_snap_realm(struct ceph_mds_client *mdsc,
>                          struct ceph_snap_realm *realm)
>  {
> -       lockdep_assert_held_write(&mdsc->snap_rwsem);
> +       lockdep_assert_held(&mdsc->snap_rwsem);
>
>         dout("get_realm %p %d -> %d\n", realm,
>              atomic_read(&realm->nref), atomic_read(&realm->nref)+1);
> @@ -139,7 +139,7 @@ static struct ceph_snap_realm *ceph_create_snap_realm(
>  /*
>   * lookup the realm rooted at @ino.
>   *
> - * caller must hold snap_rwsem for write.
> + * caller must hold snap_rwsem.
>   */
>  static struct ceph_snap_realm *__lookup_snap_realm(struct ceph_mds_client *mdsc,
>                                                    u64 ino)
> @@ -147,7 +147,7 @@ static struct ceph_snap_realm *__lookup_snap_realm(struct ceph_mds_client *mdsc,
>         struct rb_node *n = mdsc->snap_realms.rb_node;
>         struct ceph_snap_realm *r;
>
> -       lockdep_assert_held_write(&mdsc->snap_rwsem);
> +       lockdep_assert_held(&mdsc->snap_rwsem);
>
>         while (n) {
>                 r = rb_entry(n, struct ceph_snap_realm, node);
> --
> 2.31.1
>

Ah, since you are relaxing the requirement some of those lockdep
asserts from the previous patch aren't actually redundant.  This seems
fine to me: lookup definitely doesn't need the write lock and allowing
concurrent gets should be OK.  The write lock made some sense back when
get was an atomic_read followed by atomic_inc but not now.

Reviewed-by: Ilya Dryomov <idryomov@gmail.com>

Thanks,

                Ilya
