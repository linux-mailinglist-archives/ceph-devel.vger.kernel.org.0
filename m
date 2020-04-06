Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6381A19F855
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Apr 2020 16:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728801AbgDFOz0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 6 Apr 2020 10:55:26 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:45390 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728776AbgDFOzZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 6 Apr 2020 10:55:25 -0400
Received: by mail-qk1-f196.google.com with SMTP id o18so13586901qko.12
        for <ceph-devel@vger.kernel.org>; Mon, 06 Apr 2020 07:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RHkzy7Iby94ptDNu2PvEMOlJ4MVcKSEK2UBUQuozWxM=;
        b=KgwiD/wUpPD/43lciH+bb96kJM3XhyxFC070R1pDehK8gKWMBgSHqNT5L8CBnnRbEw
         wLisMbQ21xYlJlopCnv+ECsxgMmlvDA9RWIWJbEgHcdQPI8eC9iIsMoaq97aZYkcytPZ
         dd/PXiQ8GYqMOSe+OexDSXIvnu8snMdMi3Pp3GptwINBGOdWzh0/IYRVX56EsU7JEcyQ
         UC+hjwEJeAZpbIW5B1apnocglOMHmZA+22OKbwv3oXdCeqtm1M3usVJkerg5SSpnXCaf
         CvtL2nFQ8OkOR4y7a80xadmNqALhpHVGX9EwV05XArZO12G6vbZN6zzR5QSaJIodo3em
         xteA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RHkzy7Iby94ptDNu2PvEMOlJ4MVcKSEK2UBUQuozWxM=;
        b=AKxVp8Fn0nmQ9jNV2KjnObe4bLZjdOroSmUKuVyo5LiA+0SCbnFlYKeMJt9OwYt6oR
         yoGFdpJEW/otXlPLr3bK0UNkRcZkYZWjwFr1NU08z1Rs9RgyeEQZDjCiBxiz4vFzHG6Q
         cqDuos0SjDn/J0v8LMp5e5l9dCaU5Q54zhJL2vX6iUfQNnbPgOErvTbHcroSgUFFTMvL
         66kFFjmKNAsFbmmU673G7cNNHczUL9pUMqKjylP7bH46i+iuf3uMiFBQXIqNri0Q06YU
         lH0rdE4b/zE5VSv67RfSUIdtLFttnQbFPQdLPVLrZ1yINtT+Hc8deJ5ggsOSUqChn34j
         tlVQ==
X-Gm-Message-State: AGi0PuY83yjAo0gS76NeAu4EerUD804BRdcLatEtWotI8wsNTI8d/V+8
        l+BeQO3rBo5h9v5/TWQjlwOn5Tmfobxjh/ucYvU=
X-Google-Smtp-Source: APiQypJvAkpmt5/yf4mcwFMrg98riUs6pu5NFrji3APwlmwoqp1N6BpvNd4xaVmpXXoFXRi6qpFLhpklUv6xnsSCipE=
X-Received: by 2002:a37:a2d7:: with SMTP id l206mr21662403qke.141.1586184924943;
 Mon, 06 Apr 2020 07:55:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200403144751.23977-1-jlayton@kernel.org>
In-Reply-To: <20200403144751.23977-1-jlayton@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Mon, 6 Apr 2020 22:55:13 +0800
Message-ID: <CAAM7YAnrw9B1dqXsNCZKGb-AwjmCTc7O2=XBEjB91kcWxAyy8Q@mail.gmail.com>
Subject: Re: [PATCH] ceph: unify i_dirty_item and i_flushing_item handling
 when auth caps change
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, Sage Weil <sage@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Apr 3, 2020 at 10:47 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> Suggested-by: "Yan, Zheng" <zyan@redhat.com>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/caps.c | 47 +++++++++++++++++++++++++----------------------
>  1 file changed, 25 insertions(+), 22 deletions(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index eb190e4e203c..b3460d52a305 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -3700,6 +3700,27 @@ static bool handle_cap_trunc(struct inode *inode,
>         return queue_trunc;
>  }
>
> +/**
> + * transplant_auth_cap - move inode to appropriate lists when auth caps change
> + * @ci: inode to be moved
> + * @session: new auth caps session
> + */
> +static void transplant_auth_ses(struct ceph_inode_info *ci,
> +                               struct ceph_mds_session *session)
> +{
> +       lockdep_assert_held(&ci->i_ceph_lock);
> +
> +       if (list_empty(&ci->i_dirty_item) && list_empty(&ci->i_flushing_item))
> +               return;
> +
> +       spin_lock(&session->s_mdsc->cap_dirty_lock);
> +       if (!list_empty(&ci->i_dirty_item))
> +               list_move(&ci->i_dirty_item, &session->s_cap_dirty);
> +       if (!list_empty(&ci->i_flushing_item))
> +               list_move_tail(&ci->i_flushing_item, &session->s_cap_flushing);
> +       spin_unlock(&session->s_mdsc->cap_dirty_lock);
> +}
> +
>  /*
>   * Handle EXPORT from MDS.  Cap is being migrated _from_ this mds to a
>   * different one.  If we are the most recent migration we've seen (as
> @@ -3771,22 +3792,9 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
>                         tcap->issue_seq = t_seq - 1;
>                         tcap->issued |= issued;
>                         tcap->implemented |= issued;
> -                       if (cap == ci->i_auth_cap)
> +                       if (cap == ci->i_auth_cap) {
>                                 ci->i_auth_cap = tcap;
> -
> -                       if (!list_empty(&ci->i_dirty_item)) {
> -                               spin_lock(&mdsc->cap_dirty_lock);
> -                               list_move(&ci->i_dirty_item,
> -                                         &tcap->session->s_cap_dirty);
> -                               spin_unlock(&mdsc->cap_dirty_lock);
> -                       }
> -
> -                       if (!list_empty(&ci->i_cap_flush_list) &&
> -                           ci->i_auth_cap == tcap) {
> -                               spin_lock(&mdsc->cap_dirty_lock);
> -                               list_move_tail(&ci->i_flushing_item,
> -                                              &tcap->session->s_cap_flushing);
> -                               spin_unlock(&mdsc->cap_dirty_lock);
> +                               transplant_auth_ses(ci, tcap->session);
>                         }
>                 }
>                 __ceph_remove_cap(cap, false);
> @@ -3798,13 +3806,8 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
>                 ceph_add_cap(inode, tsession, t_cap_id, issued, 0,
>                              t_seq - 1, t_mseq, (u64)-1, flag, &new_cap);
>
> -               if (!list_empty(&ci->i_cap_flush_list) &&
> -                   ci->i_auth_cap == tcap) {
> -                       spin_lock(&mdsc->cap_dirty_lock);
> -                       list_move_tail(&ci->i_flushing_item,
> -                                      &tcap->session->s_cap_flushing);
> -                       spin_unlock(&mdsc->cap_dirty_lock);
> -               }
> +               if (ci->i_auth_cap == tcap)
> +                       transplant_auth_ses(ci, tcap->session);
>

why not call transplant_auth_ses() inside ceph_add_cap() (replace code
added by "ceph: convert mdsc->cap_dirty to a per-session list")

>                 __ceph_remove_cap(cap, false);
>                 goto out_unlock;
> --
> 2.25.1
>
