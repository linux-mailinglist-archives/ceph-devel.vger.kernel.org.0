Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62A80296EA
	for <lists+ceph-devel@lfdr.de>; Fri, 24 May 2019 13:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391083AbfEXLQ7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 24 May 2019 07:16:59 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:37481 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390973AbfEXLQz (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 24 May 2019 07:16:55 -0400
Received: by mail-lf1-f65.google.com with SMTP id m15so6233818lfh.4
        for <ceph-devel@vger.kernel.org>; Fri, 24 May 2019 04:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4wCyXTJm2GRa7721oRpZe4Bi3StApMFAcNLBEcwlK6M=;
        b=Zh7Z4GvwUSyQD6zCRoMiYxDLcmJUpc/zO8SARewOuwq9j2Gt705L+SJa3LnD7961Wc
         imD1U2UMuIU1mADXyBSHqu7m62DHZeJN319LsHwosqK9bBj6Zqto3eF9OT/N3sAZtdgb
         toTSaswjPWkoZ/5UG/GZZNv6wnJOYyl/0xGM+oDNY+r6DgbyGzbmyLCM/gvv/2zzA9uG
         hQuxPM/l8Oy0DA4JfzJceJy6iZLyyGI+RcyE505z2UGzgwJSU/t+36M7tJ5L8NiyLOZh
         FcSWIKACz7dgZJVdTkRy3wlktYIXgpOB80AY4KGmIj91/Q82MwUXrKSY6jVNQGD8N4no
         Rayg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4wCyXTJm2GRa7721oRpZe4Bi3StApMFAcNLBEcwlK6M=;
        b=mtwgMR66W5D49o6zhZLj4TGfC0JWPPJKYub1NklXB3uaYB+ROPICAvNWmwTkGZkNqo
         ZNAxN+8jVqMIM7knFP3xpvLTzXVvQr8tUTGl7UZ9Vd9Su1GztbR3MT3QM84zIWmaPSlR
         wi/FAxJRLTFHqgjdG7zlKnL+46K+XYeJPPzw9TzlQsGyv8njRNf2ARyxYdbjmyUkfHfI
         KxN+xl6cdBUmzlthba1a4RC9uKXKPl4aBq73ednkW+9lQWUMqI7ZacivAa7SlvnAwkq8
         owLBLfFQ11U5KpDdB1x7FEenD3L5UymmllMQ14iScvkjxHfpRt4xCCNsJLW9zbS1y2yp
         l8vQ==
X-Gm-Message-State: APjAAAWlAtchUfGmwgLquBywkOsgsLbNEPQuG+9u/vFw99xeVOSjVS2o
        MIoNWLSuIyFN+cRcFuXV5TwvBnNOvmvept5NGlo=
X-Google-Smtp-Source: APXvYqwXCiSO2YUj+Q/rfoP6bCnRNfsjw0ZOzt5AXey7Px640aJWI/rMXCnVasaCYsU5tcBwwEqAhQzJTMSV5K4LjzM=
X-Received: by 2002:ac2:510e:: with SMTP id q14mr10078595lfb.135.1558696612952;
 Fri, 24 May 2019 04:16:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190430120534.5231-1-xxhdx1985126@gmail.com> <CAOi1vP-hjCfyTgv4FtcBguTEe0Aqd-3=9KtRRx+g6mc2_zfD5w@mail.gmail.com>
In-Reply-To: <CAOi1vP-hjCfyTgv4FtcBguTEe0Aqd-3=9KtRRx+g6mc2_zfD5w@mail.gmail.com>
From:   Xuehan Xu <xxhdx1985126@gmail.com>
Date:   Fri, 24 May 2019 19:16:23 +0800
Message-ID: <CAJACTudXyFyqfUnofjs4QzU5wFbV27Z-1=YMypF8Adrr8-yyGw@mail.gmail.com>
Subject: Re: [PATCH 1/2] cgroup: add a new group controller for cephfs
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        "Yan, Zheng" <ukernel@gmail.com>, Xuehan Xu <xuxuehan@360.cn>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

>
> Hi Xuehan,
>
> While I understand the desire to use the cgroup interface to allow for
> easy adjustment and process granularity, I think this is unlikely to be
> accepted in the form of a new controller.  Each controller is supposed
> to distribute a specific resource and meta iops, data iops and data
> band(width?) mostly fall under the realm of the existing I/O
> controller.  Have you run this by the cgroup folks?
>
> Regardless, take a look at Documentation/process/coding-style.rst for
> rules on indentation, line length, etc.  Also, the data throttle should
> apply to rbd too, so I would change the name to "ceph".
>
> Thanks,
>
>                 Ilya

Hi, Ilya, thanks for your review:-)

I investigated the existing blkio controller before trying to
implement a new controller. If I understand the code of blkio
correctly, it's mainly dedicated to limiting the block device io and
takes effect by cooperating with the io scheduler which ceph io path
doesn't contain. So I think maybe a new controller should be
appropriate. After all, network file system "io" is not real I/O,
right?

I did submit this patch to cgroup mailling list, yesterday. But no
response has been received. I don't quite understand the procedure
that needs to follow to contribute to the cgroup source code. Maybe I
didn't do it right:-(
