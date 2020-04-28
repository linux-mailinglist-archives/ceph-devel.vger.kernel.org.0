Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00CF11BC009
	for <lists+ceph-devel@lfdr.de>; Tue, 28 Apr 2020 15:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbgD1NmH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 28 Apr 2020 09:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726798AbgD1NmH (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 28 Apr 2020 09:42:07 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70DD6C03C1A9;
        Tue, 28 Apr 2020 06:42:07 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id t3so21786970qkg.1;
        Tue, 28 Apr 2020 06:42:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=40SvGlOE0IEfpxKbtfMncI3PVEjNw5dMSinR4i3iCOw=;
        b=fZQWwv3NQ/GClOErKC1hUzhMog1m5IyoLRAU3h18l+CW8e/aKb2gQarNIoU43G+YFZ
         LoRTSQeoiPA6jtQJ4tY10DuZHhgp35Fk+qKdzWRlnQ0DK4/GfVtiLaO3V7iN3zZ/Uykp
         qFdFvm1imsc5aD+QVOQwNYJtJievHyn/WaR6txBr5FPwk2anG6lI1yvhGftQMCBjBDox
         8UEMTpjRe5UOsjNhFRNXQgTuRuE37NZk27tNwqS+apEtqnajZ3CaUN5YaSgxSpO0sAIz
         YixgoioUlkVk9logeCO9QOvV9KfUYQTstzLByLOMPQ5SsH/bx5P1zuthPoui3LdDuZSH
         hSJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=40SvGlOE0IEfpxKbtfMncI3PVEjNw5dMSinR4i3iCOw=;
        b=bn/1PoNDMPNYA1dKkNmEpE3M0cZ5AJ3FSaEtpMSDQ3kPhVCSGw9971+/QdmSqr5swT
         Hj/7q/YrZ3zGF5ZH6yOWeDU8UriOcVO3O7KW5ynVWvv+psFJaq/+yB+O28bejx529B8k
         fYLyQPbLrYnjn5yvPO89QEoG7/byPO9lmtwjngfEOo6wQnZmN4jFxgpy90BHDx5Ehr8F
         4ZyS9wSOZUmNdOxcY1GRvNGGAypxExLSLHKSHsnx8R9viDdQaYiphOmcqyzJ182ZGAj6
         gZ2mvdZbzc1KB951LW7nSZkxiZGHKQADDHDM55/yQlOxek88Rey/oW8iZHxyNnKt8A4U
         e73A==
X-Gm-Message-State: AGi0Pua40EwYMNnqp3xdaUjc6nxZiM7HCDR6dK6uUWX/Ux1KUzmMxAfY
        vbEqgl84LDAS/Gu7XoBQUvZDDwHVtVNjQwFHq0I=
X-Google-Smtp-Source: APiQypLSDVhAO3AdccM9OiKNjeTryZc/HruX0l5p1r9XPaahQ1kopW0gAi8ndd/Qy9b+GDkA3rmE78eQgTJUCQsIfqI=
X-Received: by 2002:a37:9e94:: with SMTP id h142mr26023649qke.56.1588081326668;
 Tue, 28 Apr 2020 06:42:06 -0700 (PDT)
MIME-Version: 1.0
References: <1588077962-353994-1-git-send-email-wubo40@huawei.com>
In-Reply-To: <1588077962-353994-1-git-send-email-wubo40@huawei.com>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Tue, 28 Apr 2020 21:41:55 +0800
Message-ID: <CAAM7YAnWM4oHgwBNXQWY5BOMDmZ9Pbqdd7N0DDedTO6HxQQeqg@mail.gmail.com>
Subject: Re: [PATCH] fs/ceph:fix double unlock in handle_cap_export()
To:     Wu Bo <wubo40@huawei.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        liuzhiqiang26@huawei.com, linfeilong@huawei.com
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Apr 28, 2020 at 8:50 PM Wu Bo <wubo40@huawei.com> wrote:
>
> If the ceph_mdsc_open_export_target_session() return fails,
> should add a lock to avoid twice unlocking.
> Because the lock will be released at the retry or out_unlock tag.
>

at retry label, i_ceph_lock get locked. I don't see how i_ceph_lock
can get double unlock

> Signed-off-by: Wu Bo <wubo40@huawei.com>
> ---
>  fs/ceph/caps.c | 26 ++++++++++++++------------
>  1 file changed, 14 insertions(+), 12 deletions(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 185db76..b5a62a8 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -3731,22 +3731,24 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
>
>         /* open target session */
>         tsession = ceph_mdsc_open_export_target_session(mdsc, target);
> -       if (!IS_ERR(tsession)) {
> -               if (mds > target) {
> -                       mutex_lock(&session->s_mutex);
> -                       mutex_lock_nested(&tsession->s_mutex,
> -                                         SINGLE_DEPTH_NESTING);
> -               } else {
> -                       mutex_lock(&tsession->s_mutex);
> -                       mutex_lock_nested(&session->s_mutex,
> -                                         SINGLE_DEPTH_NESTING);
> -               }
> -               new_cap = ceph_get_cap(mdsc, NULL);
> -       } else {
> +       if (IS_ERR(tsession)) {
>                 WARN_ON(1);
>                 tsession = NULL;
>                 target = -1;
> +               mutex_lock(&session->s_mutex);
> +               goto out_unlock;
> +       }
> +
> +       if (mds > target) {
> +               mutex_lock(&session->s_mutex);
> +               mutex_lock_nested(&tsession->s_mutex,
> +                                       SINGLE_DEPTH_NESTING);
> +       } else {
> +               mutex_lock(&tsession->s_mutex);
> +               mutex_lock_nested(&session->s_mutex,
> +                                       SINGLE_DEPTH_NESTING);
>         }
> +       new_cap = ceph_get_cap(mdsc, NULL);
>         goto retry;
>
>  out_unlock:
> --
> 1.8.3.1
>
