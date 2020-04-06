Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E622E19F846
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Apr 2020 16:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728795AbgDFOyC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 6 Apr 2020 10:54:02 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:35990 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728781AbgDFOyC (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 6 Apr 2020 10:54:02 -0400
Received: by mail-qt1-f194.google.com with SMTP id m33so13053262qtb.3
        for <ceph-devel@vger.kernel.org>; Mon, 06 Apr 2020 07:54:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3UUEGMwXzX4zOx0nLtk2OoLRV5RsJq7BeWNblh/QMtY=;
        b=dKj+vfJNHFGrSMc0cgWXzsUOlSgWGS/ZheUoRvlDAyj6qn87nS6+LHbF9q/SbO/lVH
         WfLuu8Ve26Evv5bDIfWU+fHn230SGjq9/IPcMX9VP+RR204EWaiioIZwOhoeYvuIo7jd
         AMD8U2vG931CcvlfwHwUwFRIIn1xBU6On0hIHY937UAhKvRcjvw/2/hJES586xP8Ockn
         ks/1FXsYJWWSxkv8TlKX1Ai8aTh2L5aEx3H9GtxYT84o2JmZY9NPVyR4C/7vt2WLkIWp
         rlxlfOfSS3SDP8MmGq4hpPtwQt7wM6a8Xx+FmGX6Aqzk3EuHIcXPOpb1oUUTbGVFUF2N
         3cIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3UUEGMwXzX4zOx0nLtk2OoLRV5RsJq7BeWNblh/QMtY=;
        b=S5FyEtCqy47IKAMewJCCwBhaRz7QizOKfcombCJUuVG6jZKWC9yXxQPMMrvxw6ho78
         odZWfBOf6p823YAoW00HNaurUuzTHWpsJv1vre0pLkI4UNNc2RZ9gvkNPoojLKoIrPW+
         6FH+Kz0tBhHMvDuW+LM9jgCq0npmG9pLJNNhdBAKlzn4lmdJcVcU+DSBgjHtQq3iNAOb
         zt8TDr7zXZ1vqcCN85zpYzW0hHOYqMAWSIwsTPUnH7unZKSB/UpZfdgOzpFIU1Mh3tAe
         dE+dXCnq6PsHt0bERgmuanvWqRF7mVDbpg3GiE+LqtyKJRBTOyz6CNTcEdmJ/DoV/iEC
         lIVQ==
X-Gm-Message-State: AGi0PuagXW7eWVUM0EB3wJQP0ntBkIHqYq0ZzduDlYORZMTHkQKQG76V
        wbqKYZ5Eq8pVIxFGPA5WC1R85cYsetCvCIhMrfmGEohDAOc=
X-Google-Smtp-Source: APiQypJ4bzdY/vVT/T14JLWM2h6FMLKj9r5DDNJldsjTowLWl8iFlLhdzm3N2qitojYzsIRm5Y6TYY5gnQ/CQagx/VA=
X-Received: by 2002:ac8:478e:: with SMTP id k14mr6513050qtq.296.1586184841601;
 Mon, 06 Apr 2020 07:54:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200403191423.40938-1-jlayton@kernel.org>
In-Reply-To: <20200403191423.40938-1-jlayton@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Mon, 6 Apr 2020 22:53:50 +0800
Message-ID: <CAAM7YAnW_20a3seYJk_yPfYt+00izT+83Y72prdOgXwwwrt25w@mail.gmail.com>
Subject: Re: [PATCH] ceph: ceph_kick_flushing_caps needs the s_mutex
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, Sage Weil <sage@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sat, Apr 4, 2020 at 3:14 AM Jeff Layton <jlayton@kernel.org> wrote:
>
> The mdsc->cap_dirty_lock is not held while walking the list in
> ceph_kick_flushing_caps, which is not safe.
>
> ceph_early_kick_flushing_caps does something similar, but the
> s_mutex is held while it's called and I think that guards against
> changes to the list.
>
> Ensure we hold the s_mutex when calling ceph_kick_flushing_caps,
> and add some clarifying comments.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/caps.c       |  2 ++
>  fs/ceph/mds_client.c |  2 ++
>  fs/ceph/mds_client.h |  4 +++-
>  fs/ceph/super.h      | 11 ++++++-----
>  4 files changed, 13 insertions(+), 6 deletions(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index ba6e11810877..f5b37842cdcd 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -2508,6 +2508,8 @@ void ceph_kick_flushing_caps(struct ceph_mds_client *mdsc,
>         struct ceph_cap *cap;
>         u64 oldest_flush_tid;
>
> +       lockdep_assert_held(session->s_mutex);
> +
>         dout("kick_flushing_caps mds%d\n", session->s_mds);
>
>         spin_lock(&mdsc->cap_dirty_lock);
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index be4ad7d28e3a..a8a5b98148ec 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -4026,7 +4026,9 @@ static void check_new_map(struct ceph_mds_client *mdsc,
>                             oldstate != CEPH_MDS_STATE_STARTING)
>                                 pr_info("mds%d recovery completed\n", s->s_mds);
>                         kick_requests(mdsc, i);
> +                       mutex_lock(&s->s_mutex);
>                         ceph_kick_flushing_caps(mdsc, s);
> +                       mutex_unlock(&s->s_mutex);
>                         wake_up_session_caps(s, RECONNECT);
>                 }
>         }
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index bd20257fb4c2..1b40f30e0a8e 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -199,8 +199,10 @@ struct ceph_mds_session {
>         struct list_head  s_cap_releases; /* waiting cap_release messages */
>         struct work_struct s_cap_release_work;
>
> -       /* both protected by s_mdsc->cap_dirty_lock */
> +       /* See ceph_inode_info->i_dirty_item. */
>         struct list_head  s_cap_dirty;        /* inodes w/ dirty caps */
> +
> +       /* See ceph_inode_info->i_flushing_item. */
>         struct list_head  s_cap_flushing;     /* inodes w/ flushing caps */
>
>         unsigned long     s_renew_requested; /* last time we sent a renew req */
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 3235c7e3bde7..b82f82d8213a 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -361,11 +361,12 @@ struct ceph_inode_info {
>          */
>         struct list_head i_dirty_item;
>
> -       /* Link to session's s_cap_flushing list. Protected by
> -        * mdsc->cap_dirty_lock.
> -        *
> -        * FIXME: this list is sometimes walked without the spinlock being
> -        *        held. What really protects it?
> +       /*
> +        * Link to session's s_cap_flushing list. Protected in a similar
> +        * fashion to i_dirty_item, but also by the s_mutex for changes. The
> +        * s_cap_flushing list can be walked while holding either the s_mutex
> +        * or msdc->cap_dirty_lock. List presence can also be checked while
> +        * holding the i_ceph_lock for this inode.
>          */
>         struct list_head i_flushing_item;
>
> --
> 2.25.1
>
Reviewed-by: "Yan, Zheng" <zyan@redhat.com>
