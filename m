Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2DA17F447
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Mar 2020 11:03:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbgCJKDF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Mar 2020 06:03:05 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:37847 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbgCJKDE (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 10 Mar 2020 06:03:04 -0400
Received: by mail-io1-f68.google.com with SMTP id k4so12153011ior.4
        for <ceph-devel@vger.kernel.org>; Tue, 10 Mar 2020 03:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Wh5xzIk+JKqhd1wUoqITL20NuTuRRxqPUNMggbywBhA=;
        b=ryOxEZfnX4iMsLoVGY/odDfpikSluEPdM2g6WtsM9kySc0xHKdKxm7EaCAYG5ITO+k
         agU7eRKIG10X6vSfKILJF7QvFkhAGxc+rk/KMUVN0255siIVRrwXF02nSvWK9YokE1jK
         lZYSOkTSDs0/h4Ye3c/X6UAKrQcAGfiA7fAK3tAsTrF9xglg9mHM4pIHeetdNFvw6mEB
         eVQyrhORGlfGveQjdWKF9Z+pNWK5WyyYA65KMxvYaq5B1A90I/dNUtEpOEhOT6xuihgJ
         8aGyDc+vrYWfe1FYlL/x7WMQBvQj/Q2XT+yBQgglAXEb7xxqrUbV6WKWWiVctnxPgfI+
         Hhzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Wh5xzIk+JKqhd1wUoqITL20NuTuRRxqPUNMggbywBhA=;
        b=cGNtXgBWq0WHl7bSeYH9jsudaEaBSqvEKy1JvsNNIxM34Z8OeSekPG50VCoLcdu7DD
         WQVMb69H3Oq1H++CTrbpRDKQYX/vcF/Rv6wACvvmYHa7qjRMedKXpUESiCvzeus8mQwq
         wsn4+jZ5cR4xTh9sm7e/Zxhp6UxeQ7cxykNZfgqIWoQFXadArJMTFDWpSgmAphOfkHaF
         ahWFpeQlib5mTK9sGHhhiNdPuN3KZZoMqV9hur1cCyCVSiMO3XD9eMkJPS7rEYpgJDPO
         V4/76JsfihubmN5LfaH+HoAhX3EGiyhpgFo/k4TAtLB7k8mTDkaIjdWHixmSLSPdE9pB
         meYw==
X-Gm-Message-State: ANhLgQ2y3iOEdqoIBnyboOIq4tLiwn6vYvi5fpRj3NqzdGOnIqvGlcSx
        AYVCjCNovkX2YvcOFQsdYVFoNmLSrIQDzMX0c/U=
X-Google-Smtp-Source: ADFU+vtG+EmJVoFUaQ2OMYxW9tfr2Nz1KojwobkqnRTvIJtp/hTI+SiRPRW4gbDKqlE5uLh5VGIn7TLivUiPQsAzV/I=
X-Received: by 2002:a02:b86:: with SMTP id 128mr5050057jad.39.1583834582991;
 Tue, 10 Mar 2020 03:03:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200310090924.49788-1-rpenyaev@suse.de>
In-Reply-To: <20200310090924.49788-1-rpenyaev@suse.de>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 10 Mar 2020 11:03:04 +0100
Message-ID: <CAOi1vP9chc5PZD8SpSKXWMec2jMgESQuoAqkwy5GpF61Qs2Uhg@mail.gmail.com>
Subject: Re: [PATCH 1/1] libceph: fix memory leak for messages allocated with CEPH_MSG_DATA_PAGES
To:     Roman Penyaev <rpenyaev@suse.de>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Mar 10, 2020 at 10:09 AM Roman Penyaev <rpenyaev@suse.de> wrote:
>
> OSD client allocates a message with a page vector for OSD_MAP, OSD_BACKOFF
> and WATCH_NOTIFY message types (see alloc_msg_with_page_vector() caller),
> but pages vector release is never called.
>
> Signed-off-by: Roman Penyaev <rpenyaev@suse.de>
> Cc: Ilya Dryomov <idryomov@gmail.com>
> Cc: Jeff Layton <jlayton@kernel.org>
> Cc: Sage Weil <sage@redhat.com>
> Cc: ceph-devel@vger.kernel.org
> ---
>  net/ceph/messenger.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
> index 5b4bd8261002..28cbd55ec2e3 100644
> --- a/net/ceph/messenger.c
> +++ b/net/ceph/messenger.c
> @@ -3248,8 +3248,15 @@ static struct ceph_msg_data *ceph_msg_data_add(struct ceph_msg *msg)
>
>  static void ceph_msg_data_destroy(struct ceph_msg_data *data)
>  {
> -       if (data->type == CEPH_MSG_DATA_PAGELIST)
> +       if (data->type == CEPH_MSG_DATA_PAGES) {
> +               int num_pages;
> +
> +               num_pages = calc_pages_for(data->alignment,
> +                                          data->length);
> +               ceph_release_page_vector(data->pages, num_pages);
> +       } else if (data->type == CEPH_MSG_DATA_PAGELIST) {
>                 ceph_pagelist_release(data->pagelist);
> +       }
>  }
>
>  void ceph_msg_data_add_pages(struct ceph_msg *msg, struct page **pages,

Hi Roman,

I don't think there is a leak here.

osdmap and backoff messages don't have data.

watch_notify message may or may not have data and this is dealt
with in handle_watch_notify().  The pages are either released in
handle_watch_notify() or transferred to ceph_osdc_notify() through
lreq.  The caller of ceph_osdc_notify() is then responsible for
them:

   * @preply_{pages,len} are initialized both on success and error.
   * The caller is responsible for:
   *
   *     ceph_release_page_vector(...)
   */
  int ceph_osdc_notify(struct ceph_osd_client *osdc,

Thanks,

                Ilya
