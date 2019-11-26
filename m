Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE99F109B7B
	for <lists+ceph-devel@lfdr.de>; Tue, 26 Nov 2019 10:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727648AbfKZJti (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 26 Nov 2019 04:49:38 -0500
Received: from mail-qv1-f68.google.com ([209.85.219.68]:44134 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727482AbfKZJti (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 26 Nov 2019 04:49:38 -0500
Received: by mail-qv1-f68.google.com with SMTP id d3so6978495qvs.11
        for <ceph-devel@vger.kernel.org>; Tue, 26 Nov 2019 01:49:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xN+USR4pbx17VhKwvTof5SaKGrnBiXKiw33+os/oBug=;
        b=pksjQY5tpzNRM1s1NaJUDUpP5kZZsKr+P/Dev6tlWjhIOsc8HBjrd4D2rGjf1RE8n3
         F4efs3V7eHzZR75KnzQ0d522FcNp5uIj/PN7ZpA7OWkEBxAuD7BP4SpJ2mM0bhaLkj03
         LVtiXnQ2/sRdUSQhuHYuasZjQ7sxSV61G3Fm3jmooj4ZV/wr7/SZC5qan+JUX7cQexcd
         LIPrwFTJ1TTg+yvcK3yWBvmIimFDz2+QD9/ijL8mxC8tPkrZw+9qcs+ixDigQpSRNrEb
         r5INY9s0cmzV6/t5KUPXnpvpDyzYcJK8e/O195ICRDgC5//IJzUm6eQEUWZihtWwmrz9
         7Mkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xN+USR4pbx17VhKwvTof5SaKGrnBiXKiw33+os/oBug=;
        b=OlnoCPi7tE7+rzyYOYrPVWR0Up7nBEzTVO+VCBDaI8ABSc5FjJx6p1rP3Eifh6hOtX
         fAXfd2P6xKwe/ttdr1rIVD8IxFIlwODNnaa4z1megQDBEV//UtiK3Wu0uyFdlzLgc2xq
         /yNiNHA/PEZCa0j5hCJOO7RHm5TG5CDMRhQJhdbQS/Z2BgAE7zi+v4jTM45TjeqnzNfX
         vt/hZHwnx/v9tSaE0L89kL8DnsOA5rlbgkav2Qnjz+X8NK8hhElSAYkpzi2CUcenn8V6
         hefH2ZIPAdig7u6LET2NZ9EfZ3xO1m/M5Yl9Dpykk4YNW8RdFj2fFXw4AU0gO9U4H9aA
         VSZA==
X-Gm-Message-State: APjAAAUeAE9uC8oQfc1iljbHreXgscwoIfiXQiCEFySlGKvYSQK5Qvx3
        0So6rxGJI1MWoy+nfrR14PeS006TlXvng3jNBec=
X-Google-Smtp-Source: APXvYqwGuSSXqLlyqxNVadibj51/oxDUzejJj/TEOo1Pvm2IESTmd5tE9DTyEPCRMltxdteKmteF40H7XHeYRagLfgA=
X-Received: by 2002:a0c:c604:: with SMTP id v4mr1001801qvi.110.1574761777327;
 Tue, 26 Nov 2019 01:49:37 -0800 (PST)
MIME-Version: 1.0
References: <20191126085114.40326-1-xiubli@redhat.com>
In-Reply-To: <20191126085114.40326-1-xiubli@redhat.com>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Tue, 26 Nov 2019 17:49:25 +0800
Message-ID: <CAAM7YA=SAY-DQ5iUB-837=eC-ERV46_1_6Zi4SLNdD13_x4U4A@mail.gmail.com>
Subject: Re: [PATCH] ceph: trigger the reclaim work once there has enough
 pending caps
To:     xiubli@redhat.com
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>, Zheng Yan <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Nov 26, 2019 at 4:57 PM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> The nr in ceph_reclaim_caps_nr() is very possibly larger than 1,
> so we may miss it and the reclaim work couldn't triggered as expected.
>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/mds_client.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 08b70b5ee05e..547ffe16f91c 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -2020,7 +2020,7 @@ void ceph_reclaim_caps_nr(struct ceph_mds_client *mdsc, int nr)
>         if (!nr)
>                 return;
>         val = atomic_add_return(nr, &mdsc->cap_reclaim_pending);
> -       if (!(val % CEPH_CAPS_PER_RELEASE)) {
> +       if (val / CEPH_CAPS_PER_RELEASE) {
>                 atomic_set(&mdsc->cap_reclaim_pending, 0);
>                 ceph_queue_cap_reclaim_work(mdsc);
>         }

this will call ceph_queue_cap_reclaim_work too frequently

> --
> 2.21.0
>
