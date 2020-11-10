Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7278A2AD0EB
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Nov 2020 09:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729312AbgKJILi (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Nov 2020 03:11:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726690AbgKJILh (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 10 Nov 2020 03:11:37 -0500
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63FAEC0613CF
        for <ceph-devel@vger.kernel.org>; Tue, 10 Nov 2020 00:11:37 -0800 (PST)
Received: by mail-il1-x143.google.com with SMTP id g7so10993539ilr.12
        for <ceph-devel@vger.kernel.org>; Tue, 10 Nov 2020 00:11:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EJVaSJ5kMyukHt+bJE49sy5V/qFfM9iH9lga5SNp5G8=;
        b=dJKVi8wlQzN9CNJaE6FijsQ8JC1VluNLbHaA8j9DurAg4GeT4wOJp1vu9uZP1glRvQ
         sdrxkkcaA9UjH44DUvt4OAqosKlRzsiwTMnW+q5FLQFObJl+LWx7x/uzjGoyQBaFPQu1
         QTu/+46cpdL8NxF5KJpgFsJQXd8rtUIL1pTlc46WgZNYkfpvD0+pU6orGvX1ac9Asifs
         2MPQF0sGfR52+BSG/d0qgSb+ko7lyUuD9zyRZ4wKYtZDn253fpFld4k162VY0kJaLYxu
         DXEdLJNwyEXmGYRAlOgqnZdNM90/e0p0CHdE0zbUHN0posvirCMxLH6QOsx91J9qT3hq
         8aNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EJVaSJ5kMyukHt+bJE49sy5V/qFfM9iH9lga5SNp5G8=;
        b=QHoQsdsu5dZ26NHijAdMpsImh+zLTqE1uMMGOmtDZ6c5hdcpRL2N8BvfjajNZeObJ2
         R6uiGQuQfb+qiFSxOGP/ZmJ//uBw540uqYQud/R5nIXeIdjBf5E1pI002I/uqaD7HTfk
         fQNOxT4N2w+yRBKeGwPqojzD7QaqGgEK5VoQr1oMbSJzzXFX/9SNJF/oI0O1fLhpiBCm
         puAEzXurwBa0oXeYd16IIb4YKGV5awGVKlT3NaJe+v9FFxOPI2nfVIzf4U3uPX6fmiOe
         xfj7s2kRY+GIpAE6yFlJNE4ZPie726X9F/lbHdIsl3BLcien28Z0e9rvb0SWRBf3zUxK
         PHSA==
X-Gm-Message-State: AOAM532l+vOeTXDlaX4VB1gDb7IoBIZD8thRjEQZUJeI4HfBJofZtZmF
        7Za4GpSs8PcCV5SDthbjFt3WqFsbZl2cww/wcbc=
X-Google-Smtp-Source: ABdhPJwXg6VfdkzecQwFdJllNnnGO4W9SY7htcqY5S9XHJ1uthyfKhXHrBVcpGueX7tX/6TawuK5ABnKURFppZkfsGU=
X-Received: by 2002:a92:d90c:: with SMTP id s12mr14118366iln.100.1604995896815;
 Tue, 10 Nov 2020 00:11:36 -0800 (PST)
MIME-Version: 1.0
References: <20201110020051.118461-1-xiubli@redhat.com>
In-Reply-To: <20201110020051.118461-1-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 10 Nov 2020 09:11:36 +0100
Message-ID: <CAOi1vP_QnxYX-cLu_-UPbYAYa14e6KHnujAaNG5dW0iWHMfaZg@mail.gmail.com>
Subject: Re: [PATCH] libceph: add osd op counter metric support
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>, "Yan, Zheng" <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Nov 10, 2020 at 3:01 AM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> The logic is the same with osdc/Objecter.cc in ceph in user space.
>
> URL: https://tracker.ceph.com/issues/48053
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  include/linux/ceph/osd_client.h |  46 ++++++
>  net/ceph/debugfs.c              |  51 +++++++
>  net/ceph/osd_client.c           | 249 +++++++++++++++++++++++++++++++-
>  3 files changed, 343 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
> index 83fa08a06507..9ff9ceed7cb5 100644
> --- a/include/linux/ceph/osd_client.h
> +++ b/include/linux/ceph/osd_client.h
> @@ -339,6 +339,50 @@ struct ceph_osd_backoff {
>         struct ceph_hobject_id *end;
>  };
>
> +struct ceph_osd_metric {
> +       struct percpu_counter op_ops;
> +       struct percpu_counter op_oplen_avg;
> +       struct percpu_counter op_send;
> +       struct percpu_counter op_send_bytes;
> +       struct percpu_counter op_resend;
> +       struct percpu_counter op_reply;
> +
> +       struct percpu_counter op_rmw;
> +       struct percpu_counter op_r;
> +       struct percpu_counter op_w;
> +       struct percpu_counter op_pgop;
> +
> +       struct percpu_counter op_stat;
> +       struct percpu_counter op_create;
> +       struct percpu_counter op_read;
> +       struct percpu_counter op_write;
> +       struct percpu_counter op_writefull;
> +       struct percpu_counter op_append;
> +       struct percpu_counter op_zero;
> +       struct percpu_counter op_truncate;
> +       struct percpu_counter op_delete;
> +       struct percpu_counter op_mapext;
> +       struct percpu_counter op_sparse_read;
> +       struct percpu_counter op_clonerange;
> +       struct percpu_counter op_getxattr;
> +       struct percpu_counter op_setxattr;
> +       struct percpu_counter op_cmpxattr;
> +       struct percpu_counter op_rmxattr;
> +       struct percpu_counter op_resetxattrs;
> +       struct percpu_counter op_call;
> +       struct percpu_counter op_watch;
> +       struct percpu_counter op_notify;
> +
> +       struct percpu_counter op_omap_rd;
> +       struct percpu_counter op_omap_wr;
> +       struct percpu_counter op_omap_del;
> +
> +       struct percpu_counter op_linger_active;
> +       struct percpu_counter op_linger_send;
> +       struct percpu_counter op_linger_resend;
> +       struct percpu_counter op_linger_ping;

Many of these ops aren't supported by the kernel client.  Let's trim
this down to what your use case actually needs.  If it's just reads and
writes, aren't they already surfaced through the new filesystem metrics
framework?

Thanks,

                Ilya
