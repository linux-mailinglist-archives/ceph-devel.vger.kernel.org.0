Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB253B7075
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Jun 2021 12:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232995AbhF2KR0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Jun 2021 06:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232772AbhF2KRZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 29 Jun 2021 06:17:25 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B3C4C061574;
        Tue, 29 Jun 2021 03:14:57 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id b7so25880874ioq.12;
        Tue, 29 Jun 2021 03:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o3olupfoYBbGdGN20aIKZGFZjpXrw0q9mcwaNDLihWQ=;
        b=gmMJNEa7ntCAiH0osDEqdGdjSjGnhGJd105//MVNLh6SympExnZsfH3YkMf07QFoNZ
         Tx50qDjKN+wOvHO5BOOPcBQmiC/Gnia7N3n3rBXytmJSUuilnyCHpBngb9HW76uQvF+R
         ghkJXzUunW3wuHaZ7YZuWpNOml4yAleDNU/TITORvB6eUm5eRkDWpmnf+f5muNDUJujn
         SM1dJCUznSuLM4SHtHSYOo/9C6r7NnkiST3SO+vDsus4MUQj1JHmsPy/Z43fcH637zbj
         UXuylcpVsfk6bmWspaz6axcT/kL9075YsLlwTVJNpGsIZ+cMEv6OiqgkN8jTyQTTmD7N
         hRWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o3olupfoYBbGdGN20aIKZGFZjpXrw0q9mcwaNDLihWQ=;
        b=Ggqyfu6cGCzUhXn2eQxzadS4u/6UsBleZG20QJ7zQVi18qjb5/Y6v4/OFA4EDsiq0J
         ZGDnk+KfLZeHlztWE0WocdzceSnFRG//ZXE6X8t7/FNHbWBorIxzQgRmnwHZpkPRZ6BC
         dj0XUUh3ud72fKIJ22S88O7URb93XhVgsO6NE5WD47NZ7hp41+DhzB5VMhYJ0+OXBc6J
         2937ZKLxh+p9cMw1k4NdJv7p4LCMbRrGUm25mepbSvu2VuPrRSLIn5XuMYipsb1qcBa8
         VpZPXn6ZgThZgrly8/m1rz+eJl7cMebylm5ajmZjWbRAViSh4IInBEusWv6D9FsFTJrN
         vFhA==
X-Gm-Message-State: AOAM530V5rx8yr+FdR93ql71PJPiq7odtwEm6iBns0pNoNJ/EtUjGOmg
        ssIZskiygoV31MhnJSkDiZ1erqiHGPQfQBbO1sIC7OXB8R5ltQ==
X-Google-Smtp-Source: ABdhPJyF/Cmb29/Wpmau6Iw5BQgCLfuaRkk019EjQ5ALf4t1+5YLIsZFv16iONdH+I10eGYLuS40Pg5miRvOCdUmfdk=
X-Received: by 2002:a02:b393:: with SMTP id p19mr3557024jan.69.1624961696096;
 Tue, 29 Jun 2021 03:14:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210629094749.25253-1-lhenriques@suse.de> <20210629094749.25253-2-lhenriques@suse.de>
In-Reply-To: <20210629094749.25253-2-lhenriques@suse.de>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 29 Jun 2021 12:14:37 +0200
Message-ID: <CAOi1vP8_x7gEGaKvKMKdGSCzs2OSJNeXPZ_KVLqdg051wpZfYA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 1/2] ceph: allow schedule_delayed() callers to set
 delay for workqueue
To:     Luis Henriques <lhenriques@suse.de>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jun 29, 2021 at 11:47 AM Luis Henriques <lhenriques@suse.de> wrote:
>
> Allow schedule_delayed() callers to explicitly set the delay value instead
> of defaulting to a 5 secs value.
>
> Signed-off-by: Luis Henriques <lhenriques@suse.de>
> ---
>  fs/ceph/mds_client.c | 19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index e5af591d3bd4..08c76bf57fb1 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -4502,13 +4502,18 @@ void inc_session_sequence(struct ceph_mds_session *s)
>  }
>
>  /*
> - * delayed work -- periodically trim expired leases, renew caps with mds
> + * delayed work -- periodically trim expired leases, renew caps with mds.  If
> + * the @delay parameter is set to 0 or if it's more than 5 secs, the default
> + * workqueue delay value of 5 secs will be used.
>   */
> -static void schedule_delayed(struct ceph_mds_client *mdsc)
> +static void schedule_delayed(struct ceph_mds_client *mdsc, unsigned long delay)
>  {
> -       int delay = 5;
> -       unsigned hz = round_jiffies_relative(HZ * delay);
> -       schedule_delayed_work(&mdsc->delayed_work, hz);
> +       unsigned long max_delay = round_jiffies_relative(HZ * 5);
> +
> +       /* 5 secs default delay */
> +       if (!delay || (delay > max_delay))
> +               delay = max_delay;
> +       schedule_delayed_work(&mdsc->delayed_work, delay);

Hi Luis,

Is there a reason to not round the non-default delay?  Does it need to
be precise?

Thanks,

                Ilya
