Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 344FA2B051B
	for <lists+ceph-devel@lfdr.de>; Thu, 12 Nov 2020 13:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbgKLMnV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 12 Nov 2020 07:43:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727646AbgKLMnU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 12 Nov 2020 07:43:20 -0500
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B507C0613D1;
        Thu, 12 Nov 2020 04:43:20 -0800 (PST)
Received: by mail-il1-x142.google.com with SMTP id l12so5131823ilo.1;
        Thu, 12 Nov 2020 04:43:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MlAb6y3L6B0gxC6J89zHhiEG7zWhwPlcRccdjczsJQM=;
        b=BeQ3u9i5t4j3EBMrMQ568M97r+HOLRmBcawXlcoPLGjkaPcV2U5sR3UfeZOPfvMmUT
         WRpJqeiDJuq1QWqgqqMxDqOBZwYK/Tz/zQO2BSEd5FKx+FFXf/zbeML8rqLFhD+fSJZQ
         0HVQrcwjSsaNHTtz6gq2ImGd3xM8uX181oRiERikIxs0GVv4whWJLZehTh3LA5HYDeOk
         2KXMqGgZxvaGSRZsakidh43HktnA9MRpsD+DHqWsZDj00/MEcS+t7Sf779UecPA+uhRi
         3vhB9UH1zVMMsoTRVpHEzhm4wSQa3//4s+M80deRGtUi6xUji+via2ezAmfqLrNsoCVD
         3dpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MlAb6y3L6B0gxC6J89zHhiEG7zWhwPlcRccdjczsJQM=;
        b=TMRiXJ2OXDCBE6n8D7Yt9/goy2Bd1yxHTygJBERPXsOvT5zSNSH9StJDJrtFXDNJLq
         /Yfr5dPPcJm9lbK1H9IkmMbLU8uHs8lcnbzr1pKeIe/T1zN9uMwHK7YtvT7IZswEs+N1
         jJmPtFvOHf0nfD+0E0KeGjj73xxAq1y57XPBhH21Bxpp2TK4LKWjjLGQ6CqIT2P9B3yW
         XcqOdsRxtXQZ0SsOLFK83cLomh1lZ/p0yN0588nq/NqbgOmjBInquRqanF8mZr+surPS
         KvdflWEOMOuixMhs6k8sv1uqhgavX9Vh6Bl5cf0ZeLsgzh3j1sTFR05NYjC4iO0PtvX7
         wRbQ==
X-Gm-Message-State: AOAM532wKmX6jrIZ2kWd0B9Mcch6kMXfjecOpRL//BZjA7pHNOpF9p0A
        KdKI0RIci/vXegjqFjZ59mdZ+9wwJdhh9yl47Yk=
X-Google-Smtp-Source: ABdhPJwAwbdiOCs/u+Tl9UCmTvdqxWJDeGCgkBq1ryhxZY6Brx/+eB+NKznGziTJea8lSdYcR6nnGgPxpILwtixBYAg=
X-Received: by 2002:a92:c7c6:: with SMTP id g6mr24377195ilk.230.1605185000074;
 Thu, 12 Nov 2020 04:43:20 -0800 (PST)
MIME-Version: 1.0
References: <20201112104512.17472-1-lhenriques@suse.de>
In-Reply-To: <20201112104512.17472-1-lhenriques@suse.de>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Thu, 12 Nov 2020 20:43:08 +0800
Message-ID: <CAAM7YA=eO-1AdgPJk6-3=FbDFtHJ9e_Rydo+7LDHqVwxtk1-jA@mail.gmail.com>
Subject: Re: [PATCH] ceph: fix race in concurrent __ceph_remove_cap invocations
To:     Luis Henriques <lhenriques@suse.de>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Nov 12, 2020 at 6:48 PM Luis Henriques <lhenriques@suse.de> wrote:
>
> A NULL pointer dereference may occur in __ceph_remove_cap with some of the
> callbacks used in ceph_iterate_session_caps, namely trim_caps_cb and
> remove_session_caps_cb.  These aren't protected against the concurrent
> execution of __ceph_remove_cap.
>

they are protected by session mutex, never get executed concurrently

> Since the callers of this function hold the i_ceph_lock, the fix is simply
> a matter of returning immediately if caps->ci is NULL.
>
> Based on a patch from Jeff Layton.
>
> Cc: stable@vger.kernel.org
> URL: https://tracker.ceph.com/issues/43272
> Link: https://www.spinics.net/lists/ceph-devel/msg47064.html
> Signed-off-by: Luis Henriques <lhenriques@suse.de>
> ---
>  fs/ceph/caps.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index ded4229c314a..443f164760d5 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -1140,12 +1140,19 @@ void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
>  {
>         struct ceph_mds_session *session = cap->session;
>         struct ceph_inode_info *ci = cap->ci;
> -       struct ceph_mds_client *mdsc =
> -               ceph_sb_to_client(ci->vfs_inode.i_sb)->mdsc;
> +       struct ceph_mds_client *mdsc;
>         int removed = 0;
>
> +       /* 'ci' being NULL means he remove have already occurred */
> +       if (!ci) {
> +               dout("%s: cap inode is NULL\n", __func__);
> +               return;
> +       }
> +
>         dout("__ceph_remove_cap %p from %p\n", cap, &ci->vfs_inode);
>
> +       mdsc = ceph_inode_to_client(&ci->vfs_inode)->mdsc;
> +
>         /* remove from inode's cap rbtree, and clear auth cap */
>         rb_erase(&cap->ci_node, &ci->i_caps);
>         if (ci->i_auth_cap == cap) {
