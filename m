Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 604F044FEA8
	for <lists+ceph-devel@lfdr.de>; Mon, 15 Nov 2021 07:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbhKOGeq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 15 Nov 2021 01:34:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30936 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229587AbhKOGep (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 15 Nov 2021 01:34:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636957909;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=c5AQjtkaxzlyRyCLDFF00dk8QfCp0BsUOmLjJHbbWjY=;
        b=H05OFxy2q9895K+20UweeU78Xwint5KH4d6Zup0oEV7iH/Ip2XxaY0r+JjlNyxB3KsU8fx
        2fHmoVROOKRd4xNVLn2iG0b5VJcis4NTdXlNkMtBCUAy5qX4xdO0mbnTQRH44UTstWr39C
        6moCGzDPeXDw4CZwUqWWs5dwiNF72p0=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-434-4DDVbS0hMMmkbhdYajMyeA-1; Mon, 15 Nov 2021 01:31:48 -0500
X-MC-Unique: 4DDVbS0hMMmkbhdYajMyeA-1
Received: by mail-lf1-f69.google.com with SMTP id c40-20020a05651223a800b004018e2f2512so6338313lfv.11
        for <ceph-devel@vger.kernel.org>; Sun, 14 Nov 2021 22:31:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c5AQjtkaxzlyRyCLDFF00dk8QfCp0BsUOmLjJHbbWjY=;
        b=KduEU9fKSjfRxlc3TINPDZ31PARxDp+2H+ePSeVPfUBuDU+pwkxcTHqSt5TOU0PprI
         L8lx0QXeOFHHu/+kj1BOw2UyjcEJv6FcCsVloq+jcIKZs6ucCimQp/1IfseZ1OksUyPw
         rA3znKNMqSBEiY5Gm+gYC4VaaTfwKYH3Kszt2hmlX9Fw2YroWF437Q+HTAUd80fuqI/V
         xz55bXi/v7YijUN0+yb027/QE7nBgpr8sjJq4ALuivOOO43V1UlCGeAb3lwh751jzjht
         WimgLvBk+M978zEViFGhcmT2W1e0fUEuvf3XurF/le3QYnvGL+yq41Yn6KGc4eByIKQu
         9GQw==
X-Gm-Message-State: AOAM530exRa8/EHLbyDr9DEFWkZfHpwpLsMQhIQJUbcGTNQ1lR20vh0z
        Ws6sxKc/z+S6lKZTtyvjMTKxS42j07/vo3tiQvq6Ju8AGiojcV58hJ/kYUFyO2FbASBLf5wljE7
        irWZVpCyNmR/pjhQxQhzZfX8PiJTKIgS/X9QD
X-Received: by 2002:a2e:9217:: with SMTP id k23mr36066938ljg.267.1636957906608;
        Sun, 14 Nov 2021 22:31:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxdVgErioBlgexLJDm5yrMSWJ52WrzMoQCcpykUliJYrwDd7k9RuHs2g6s4CgdhNuHi3ubRLn69wlb7f0jovlY=
X-Received: by 2002:a2e:9217:: with SMTP id k23mr36066927ljg.267.1636957906436;
 Sun, 14 Nov 2021 22:31:46 -0800 (PST)
MIME-Version: 1.0
References: <20211110180021.20876-1-khiremat@redhat.com> <20211110180021.20876-2-khiremat@redhat.com>
 <2bbf6340-0814-bbfa-0d35-2e1d1fff23de@redhat.com> <CAPgWtC4jv86+hjrBXfDpMm4r0b08sNspCKVsN994qwmHjQx1Ww@mail.gmail.com>
 <1afd1adb-6bda-0714-1d82-33ac4745e4c4@redhat.com>
In-Reply-To: <1afd1adb-6bda-0714-1d82-33ac4745e4c4@redhat.com>
From:   Kotresh Hiremath Ravishankar <khiremat@redhat.com>
Date:   Mon, 15 Nov 2021 12:01:35 +0530
Message-ID: <CAPgWtC5o5JbWP+F4MpO5a6G2Rs5Kr2pb+d16KErdUWxSnSo89A@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] ceph: Fix incorrect statfs report for small quota
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Venky Shankar <vshankar@redhat.com>, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Nov 15, 2021 at 11:12 AM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 11/15/21 1:30 PM, Kotresh Hiremath Ravishankar wrote:
> > On Mon, Nov 15, 2021 at 8:24 AM Xiubo Li <xiubli@redhat.com> wrote:
> >>
> >> On 11/11/21 2:00 AM, khiremat@redhat.com wrote:
> >>> From: Kotresh HR <khiremat@redhat.com>
> >>>
> >>> Problem:
> >>> The statfs reports incorrect free/available space
> >>> for quota less then CEPH_BLOCK size (4M).
> >> s/then/than/
> >>
> >>
> >>> Solution:
> >>> For quota less than CEPH_BLOCK size, smaller block
> >>> size of 4K is used. But if quota is less than 4K,
> >>> it is decided to go with binary use/free of 4K
> >>> block. For quota size less than 4K size, report the
> >>> total=used=4K,free=0 when quota is full and
> >>> total=free=4K,used=0 otherwise.
> >>>
> >>> Signed-off-by: Kotresh HR <khiremat@redhat.com>
> >>> ---
> >>>    fs/ceph/quota.c | 14 ++++++++++++++
> >>>    fs/ceph/super.h |  1 +
> >>>    2 files changed, 15 insertions(+)
> >>>
> >>> diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
> >>> index 620c691af40e..24ae13ea2241 100644
> >>> --- a/fs/ceph/quota.c
> >>> +++ b/fs/ceph/quota.c
> >>> @@ -494,10 +494,24 @@ bool ceph_quota_update_statfs(struct ceph_fs_client *fsc, struct kstatfs *buf)
> >>>                if (ci->i_max_bytes) {
> >>>                        total = ci->i_max_bytes >> CEPH_BLOCK_SHIFT;
> >>>                        used = ci->i_rbytes >> CEPH_BLOCK_SHIFT;
> >>> +                     /* For quota size less than 4MB, use 4KB block size */
> >>> +                     if (!total) {
> >>> +                             total = ci->i_max_bytes >> CEPH_4K_BLOCK_SHIFT;
> >>> +                             used = ci->i_rbytes >> CEPH_4K_BLOCK_SHIFT;
> >>> +                             buf->f_frsize = 1 << CEPH_4K_BLOCK_SHIFT;
>
> If the quota size is less than 4MB, the 'buf->f_frsize' will always be
> set here, including less than 4KB.
Yes, sorry for the confusion. I will address this.
>
>
> >>> +                     }
> >>>                        /* It is possible for a quota to be exceeded.
> >>>                         * Report 'zero' in that case
> >>>                         */
> >>>                        free = total > used ? total - used : 0;
> >>> +                     /* For quota size less than 4KB, report the
> >>> +                      * total=used=4KB,free=0 when quota is full
> >>> +                      * and total=free=4KB, used=0 otherwise */
> >>> +                     if (!total) {
> >>> +                             total = 1;
> >>> +                             free = ci->i_max_bytes > ci->i_rbytes ? 1 : 0;
> >>> +                             buf->f_frsize = 1 << CEPH_4K_BLOCK_SHIFT;
> >> The 'buf->f_frsize' has already been assigned above, this could be removed.
> >>
> > If the quota size is less than 4KB, the above assignment is not hit.
> > This is required.
> >
> >> Thanks
> >>
> >> -- Xiubo
> >>
> >>> +                     }
> >>>                }
> >>>                spin_unlock(&ci->i_ceph_lock);
> >>>                if (total) {
> >>> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> >>> index ed51e04739c4..387ee33894db 100644
> >>> --- a/fs/ceph/super.h
> >>> +++ b/fs/ceph/super.h
> >>> @@ -32,6 +32,7 @@
> >>>     * large volume sizes on 32-bit machines. */
> >>>    #define CEPH_BLOCK_SHIFT   22  /* 4 MB */
> >>>    #define CEPH_BLOCK         (1 << CEPH_BLOCK_SHIFT)
> >>> +#define CEPH_4K_BLOCK_SHIFT 12  /* 4 KB */
> >>>
> >>>    #define CEPH_MOUNT_OPT_CLEANRECOVER    (1<<1) /* auto reonnect (clean mode) after blocklisted */
> >>>    #define CEPH_MOUNT_OPT_DIRSTAT         (1<<4) /* `cat dirname` for stats */
> >
>


-- 
Thanks and Regards,
Kotresh H R

