Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 106306FF33
	for <lists+ceph-devel@lfdr.de>; Mon, 22 Jul 2019 14:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729107AbfGVMG6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 22 Jul 2019 08:06:58 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:34391 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728266AbfGVMG6 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 22 Jul 2019 08:06:58 -0400
Received: by mail-ed1-f68.google.com with SMTP id s49so5563442edb.1
        for <ceph-devel@vger.kernel.org>; Mon, 22 Jul 2019 05:06:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=WEqA24c57DR+jeJsCxm6cVwdfSsqSalYCpKR16YGSbE=;
        b=ksdfGHVTITiIGuWKQfnHKHMi4RFkEfj95LIRjjf/jmsp/Yxll43dHHfXxRFUgpPA3N
         ZC5b5lsEIKSAlKPb8UANAW+7PdpXkuHAst8UKlvufcltu5se03KyjRHwr1TbvK27LcYk
         tV3M7EQGc5q1l+pT9j9DG+d5Z519RdUIWjSSQrtJIzfSsD80pf7586ouLDl5HhQxiADC
         +QVOgUCKXoi6JGp9eMwq9+f4cTBa73o++gRQX6uIvwya2SBcQsu/1dWSjoNPf6o5xSzx
         I1KvCNMalOWYvLyd6ubH+LbzupGQ/zUKvZ1aRlEJPGDkwRtPVr6BJfzAU92CqnjBbnfQ
         7TDw==
X-Gm-Message-State: APjAAAUO+x3WDxD7gyH0iKmcWqWW00FWS/nMCLhwpmOf8XzrEGMvtABJ
        HxOUZCdjXStIK7a2cyTXZfRRLI8kiEnd9YUxgIG76x1p
X-Google-Smtp-Source: APXvYqxZfaKS0tymxK8y/xUsu0d9y7Mu6byEYEVzy7PVrl28AHZt5qAFkEWpD2gve4KMbbTAywBMkcDDc2QotFSqosA=
X-Received: by 2002:a50:f05a:: with SMTP id u26mr60261715edl.116.1563797216405;
 Mon, 22 Jul 2019 05:06:56 -0700 (PDT)
MIME-Version: 1.0
References: <CAEbG6hHOe0Q8-dcgBxbW2GX+21BuETso9orZY-9sW37Y5rDwKQ@mail.gmail.com>
In-Reply-To: <CAEbG6hHOe0Q8-dcgBxbW2GX+21BuETso9orZY-9sW37Y5rDwKQ@mail.gmail.com>
Reply-To: dillaman@redhat.com
From:   Jason Dillaman <jdillama@redhat.com>
Date:   Mon, 22 Jul 2019 08:06:45 -0400
Message-ID: <CA+aFP1BaKeK6QNhiV3dRr9JArsH3nxOuoOY4Tjdu=k_g6PdxyQ@mail.gmail.com>
Subject: Re: [ceph-users] Failed to get omap key when mirroring of image is enabled
To:     Ajitha Robert <ajitharobert01@gmail.com>
Cc:     ceph-users <ceph-users@lists.ceph.com>,
        ceph-users <ceph-users@ceph.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sun, Jul 21, 2019 at 8:25 PM Ajitha Robert <ajitharobert01@gmail.com> wrote:
>
>  I have a rbd mirroring setup with primary and secondary clusters as peers and I have a pool enabled image mode.., In this i created a rbd image , enabled with journaling.
>
> But whenever i enable mirroring on the image,  I m getting error in osd.log. I couldnt trace it out. please guide me to solve this error.
>
> I think initially it worked fine. but after ceph process restart. these error coming
>
>
> Secondary.osd.0.log
>
> 2019-07-22 05:36:17.371771 7ffbaa0e9700  0 <cls> /build/ceph-12.2.12/src/cls/journal/cls_journal.cc:61: failed to get omap key: client_a5c76849-ba16-480a-a96b-ebfdb7f6ac65
> 2019-07-22 05:36:17.388552 7ffbaa0e9700  0 <cls> /build/ceph-12.2.12/src/cls/journal/cls_journal.cc:472: active object set earlier than minimum: 0 < 1
> 2019-07-22 05:36:17.413102 7ffbaa0e9700  0 <cls> /build/ceph-12.2.12/src/cls/journal/cls_journal.cc:61: failed to get omap key: order
> 2019-07-22 05:36:23.341490 7ffbab8ec700  0 <cls> /build/ceph-12.2.12/src/cls/rbd/cls_rbd.cc:4125: error retrieving image id for global id '9e36b9f8-238e-4a54-a055-19b19447855e': (2) No such file or directory
>
>
> primary-osd.0.log
>
> 2019-07-22 05:16:49.287769 7fae12db1700  0 log_channel(cluster) log [DBG] : 1.b deep-scrub ok
> 2019-07-22 05:16:54.078698 7fae125b0700  0 log_channel(cluster) log [DBG] : 1.1b scrub starts
> 2019-07-22 05:16:54.293839 7fae125b0700  0 log_channel(cluster) log [DBG] : 1.1b scrub ok
> 2019-07-22 05:17:04.055277 7fae12db1700  0 <cls> /build/ceph-12.2.12/src/cls/journal/cls_journal.cc:472: active object set earlier than minimum: 0 < 1
>
> 2019-07-22 05:33:21.540986 7fae135b2700  0 <cls> /build/ceph-12.2.12/src/cls/journal/cls_journal.cc:472: active object set earlier than minimum: 0 < 1
> 2019-07-22 05:35:27.447820 7fae12db1700  0 <cls> /build/ceph-12.2.12/src/cls/rbd/cls_rbd.cc:4125: error retrieving image id for global id '8a61f694-f650-4ba1-b768-c5e7629ad2e0': (2) No such file or directory

Those don't look like errors, but the log level should probably be
reduced for those OSD cls methods. If you look at your rbd-mirror
daemon log, do you see any errors? That would be the important place
to look.

>
> --
> Regards,
> Ajitha R
> _______________________________________________
> ceph-users mailing list
> ceph-users@lists.ceph.com
> http://lists.ceph.com/listinfo.cgi/ceph-users-ceph.com



-- 
Jason
