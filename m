Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3F9011F00A
	for <lists+ceph-devel@lfdr.de>; Sat, 14 Dec 2019 03:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfLNCqm (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 13 Dec 2019 21:46:42 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:44235 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbfLNCqm (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 13 Dec 2019 21:46:42 -0500
Received: by mail-qv1-f65.google.com with SMTP id n8so537608qvg.11
        for <ceph-devel@vger.kernel.org>; Fri, 13 Dec 2019 18:46:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n3o7EywoAx5lCov0+XDSzgYBVJgii6VcvHYbvuBvVMw=;
        b=s2nFXGgwlHhBwt3D+8TmZBIaOonE8paojsznusatfkKY+OODp5e0UuHjZtwvpkkrQw
         10Qt2lemPUrcV93EH/fmeVxeByk3+1S1HVnnFyZmaN8WVzPs2Dh+g0DdDAZMO82BUSTA
         wRHg/VHWgGvI4hJeqL/9Ye6DYkBZ2csMSaL9lz3StQjFxQW0PU6UGV6kxPnG4RQE+YIS
         7Cm5sHZEzVFZAviQczBnAVGMcJMvDV8F7axyux7hnMUAYHNnBBG0lvlguC56EHdjRQNF
         MW0ZP5RL9w+lALgBq1UR05q84aqghIxd6EOUCvI4zldmnKf+uErkAEBoCyx4hjUAWkdX
         AQ/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n3o7EywoAx5lCov0+XDSzgYBVJgii6VcvHYbvuBvVMw=;
        b=N56H6tkZVQmplPk4XSI+qU9XmmfwLXmuTnM1r+H2EmkuqQ0v6imU7HWo94dsRNk+KZ
         Gp7yJoII8ohDbjHHUhWDhAcGe9C0KjKtSjv+W7kVhJAgYso4vDEITarwn7BEx20079O5
         XmcLw4PVwyIP/JRpnJp7dxs396JWxg3xLBmQPg0954RBcafKyuX4VChZ2+Z07An7GYsA
         s5ER/bIT/EzhotBM3pPIqFeWVwNE/97HHFAGL7uJtv9ZAB48KOcu4yEytUjTIi0vDD+e
         6/JKLcHR+IDjR/Rai2FyjrCkcP8jsaCQlWBa9HduYvmd1CEhmh8apDBHjX/Z6lL3LI0a
         waZw==
X-Gm-Message-State: APjAAAWf/WZLJRTt5JWU7KS2R5cAObxcugL+RGsxIlIJwWk4pKeeXGWQ
        0l6UHOaMAog+3B+Cp1O1cAOtt5q7q8I2OMedvIQ=
X-Google-Smtp-Source: APXvYqyKnHWXBW0TInZ7HdfWXflCukw0UXe1AUNfbRiP81AljutJxkzY+nE0YdnP0h/++3jWjRzdyWsm2/M5+CLYtg4=
X-Received: by 2002:a05:6214:18c:: with SMTP id q12mr16666581qvr.32.1576291601436;
 Fri, 13 Dec 2019 18:46:41 -0800 (PST)
MIME-Version: 1.0
References: <20191212173159.35013-1-jlayton@kernel.org>
In-Reply-To: <20191212173159.35013-1-jlayton@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Sat, 14 Dec 2019 10:46:30 +0800
Message-ID: <CAAM7YAmquOg5ESMAMa5y0gGAR-UAivYF8m+nqrJNmK=SzG6+wA@mail.gmail.com>
Subject: Re: [RFC PATCH] ceph: guard against __ceph_remove_cap races
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Dec 13, 2019 at 1:32 AM Jeff Layton <jlayton@kernel.org> wrote:
>
> I believe it's possible that we could end up with racing calls to
> __ceph_remove_cap for the same cap. If that happens, the cap->ci
> pointer will be zereoed out and we can hit a NULL pointer dereference.
>
> Once we acquire the s_cap_lock, check for the ci pointer being NULL,
> and just return without doing anything if it is.
>
> URL: https://tracker.ceph.com/issues/43272
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/caps.c | 21 ++++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)
>
> This is the only scenario that made sense to me in light of Ilya's
> analysis on the tracker above. I could be off here though -- the locking
> around this code is horrifically complex, and I could be missing what
> should guard against this scenario.
>

I think the simpler fix is,  in trim_caps_cb, check if cap-ci is
non-null before calling __ceph_remove_cap().  this should work because
__ceph_remove_cap() is always called inside i_ceph_lock

> Thoughts?
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 9d09bb53c1ab..7e39ee8eff60 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -1046,11 +1046,22 @@ static void drop_inode_snap_realm(struct ceph_inode_info *ci)
>  void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
>  {
>         struct ceph_mds_session *session = cap->session;
> -       struct ceph_inode_info *ci = cap->ci;
> -       struct ceph_mds_client *mdsc =
> -               ceph_sb_to_client(ci->vfs_inode.i_sb)->mdsc;
> +       struct ceph_inode_info *ci;
> +       struct ceph_mds_client *mdsc;
>         int removed = 0;
>
> +       spin_lock(&session->s_cap_lock);
> +       ci = cap->ci;
> +       if (!ci) {
> +               /*
> +                * Did we race with a competing __ceph_remove_cap call? If
> +                * ci is zeroed out, then just unlock and don't do anything.
> +                * Assume that it's on its way out anyway.
> +                */
> +               spin_unlock(&session->s_cap_lock);
> +               return;
> +       }
> +
>         dout("__ceph_remove_cap %p from %p\n", cap, &ci->vfs_inode);
>
>         /* remove from inode's cap rbtree, and clear auth cap */
> @@ -1058,13 +1069,12 @@ void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
>         if (ci->i_auth_cap == cap)
>                 ci->i_auth_cap = NULL;
>
> -       /* remove from session list */
> -       spin_lock(&session->s_cap_lock);
>         if (session->s_cap_iterator == cap) {
>                 /* not yet, we are iterating over this very cap */
>                 dout("__ceph_remove_cap  delaying %p removal from session %p\n",
>                      cap, cap->session);
>         } else {
> +               /* remove from session list */
>                 list_del_init(&cap->session_caps);
>                 session->s_nr_caps--;
>                 cap->session = NULL;
> @@ -1072,6 +1082,7 @@ void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
>         }
>         /* protect backpointer with s_cap_lock: see iterate_session_caps */
>         cap->ci = NULL;
> +       mdsc = ceph_sb_to_client(ci->vfs_inode.i_sb)->mdsc;
>
>         /*
>          * s_cap_reconnect is protected by s_cap_lock. no one changes
> --
> 2.23.0
>
