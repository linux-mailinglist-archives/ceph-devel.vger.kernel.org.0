Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22E6A3805AC
	for <lists+ceph-devel@lfdr.de>; Fri, 14 May 2021 10:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbhENI6X (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 14 May 2021 04:58:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbhENI6X (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 14 May 2021 04:58:23 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8040EC061574
        for <ceph-devel@vger.kernel.org>; Fri, 14 May 2021 01:57:11 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id w13so13082705ilv.11
        for <ceph-devel@vger.kernel.org>; Fri, 14 May 2021 01:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PPDCcxeZWtIZDWSttvSY1A0fhzXnaOqfgXekaqvC+6g=;
        b=J1HJ06jMAtiHDu7OuVVZ81CKZ+6naVoUoChUQv4ZYciuOpBAEZLJB47P/mT6NqdSsg
         XqnfpFvIckbwqrW+KcFvdC8Hm1ofmwjamikRk7SkcNZVgm0QVn3FhG1bgkg2KZdyNyuy
         4uOyQDcWYPF9mnbtth1V53I7eyjO9TtnXsnczfyLApDvP7UEdM0An62WDQnMPLxOE0Md
         QWVGaJ0FuuOCAxcbEaJjxpcuhTJgI5zqSW7DVsVF4LTBMeSmF8KNiH5aD/SqdkeFM4hK
         nkH+OQj9vIA4sJ9fTdjlGAt+FRtgnnU/JMklZNX+rQgY++DyKHPsY37dOwLX0PoHjb+A
         1xYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PPDCcxeZWtIZDWSttvSY1A0fhzXnaOqfgXekaqvC+6g=;
        b=EDT1NzjYEkZL2PyqBKRvadvhbmJOWq9xg9ExPVGMhEw3Ym37MlBpcuWMNlpnaB328s
         cSD1LQVpseG33ILLTMC55stkuVmqivUzaSETMGr44LMSPfX95Ue6h/Kq7qhV72D2xGmb
         YNy/fW13+i44gO2PTegb1YgK6P9bkO+oAfYoF4Nfbhkevus8eTx9QAbbMy0Nl7QeF7Lv
         0MSm7w0LKZtnJMp7m/oyGhRZVYa6YMN/oWiQw3oQnP1iA1iAKJA1J15Q8GRa0WBb5YiP
         Xqz/5E2ORopLvS7D5ZXDl7SpwDWYzQaOOHRpzBi6xgVSr6K1wJ4fa99HBGPx0LU5KmIi
         bkIg==
X-Gm-Message-State: AOAM530UoJx5XPo+0FixYDxzJQ6rqCV/1MiQ8m1vZfNdMiTseTVoMNhU
        /z/eBsXE0P5IC3AaHiebc8dNJGd+AFKBhVtRmRk=
X-Google-Smtp-Source: ABdhPJw+QSKQGkUp0Qaqw01a0dH/HxCKXsxOyZwJm2XrWfJerdmNCcYwKgn0WGRIhNaa0yuV5q3KqlsGtxuiX3MxTq8=
X-Received: by 2002:a05:6e02:eac:: with SMTP id u12mr40376450ilj.177.1620982631044;
 Fri, 14 May 2021 01:57:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210513014053.81346-1-xiubli@redhat.com> <89def1a8e65e443ba7aca7c4ff138e6c6041a5df.camel@kernel.org>
 <70554cca-9985-338c-de04-4053a4a04872@redhat.com>
In-Reply-To: <70554cca-9985-338c-de04-4053a4a04872@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Fri, 14 May 2021 10:57:20 +0200
Message-ID: <CAOi1vP-dpSUO5F_cyhzBycvuCp6N2cRPifJPAZ1Ybws+T=pGcA@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] ceph: send io size metrics to mds daemon
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>,
        "Yan, Zheng" <ukernel@gmail.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, May 14, 2021 at 2:47 AM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 5/13/21 7:30 PM, Jeff Layton wrote:
> > On Thu, 2021-05-13 at 09:40 +0800, xiubli@redhat.com wrote:
> >> From: Xiubo Li <xiubli@redhat.com>
> >>
> >> V2:
> >> - change the patch order
> >> - replace the fixed 10 with sizeof(struct ceph_metric_header)
> >>
> >> Xiubo Li (2):
> >>    ceph: simplify the metrics struct
> >>    ceph: send the read/write io size metrics to mds
> >>
> >>   fs/ceph/metric.c | 90 ++++++++++++++++++++++++++++++------------------
> >>   fs/ceph/metric.h | 79 +++++++++++++++++-------------------------
> >>   2 files changed, 89 insertions(+), 80 deletions(-)
> >>
> > Thanks Xiubo,
> >
> > These look good. I'll do some testing with them and plan to merge these
> > into the testing branch later today.
>
> Sure, take your time.

FYI I squashed "ceph: send the read/write io size metrics to mds" into
"ceph: add IO size metrics support".

Thanks,

                Ilya
