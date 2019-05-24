Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 814C5297D2
	for <lists+ceph-devel@lfdr.de>; Fri, 24 May 2019 14:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391299AbfEXML1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 24 May 2019 08:11:27 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:36798 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391253AbfEXML0 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 24 May 2019 08:11:26 -0400
Received: by mail-it1-f193.google.com with SMTP id e184so13482256ite.1
        for <ceph-devel@vger.kernel.org>; Fri, 24 May 2019 05:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6NfPyo83ZZTFyfnyDjUhhHoRR8SL0Wt9eMBL87a1ir0=;
        b=AWuwdSIW5G+riYgV9scAcbYqJPj3TqjSzH8Jo6Y1QN3RQwg5y0dLRvhI7j6ObGr2w5
         K3xBEep1RrpHYR0ow2Ib0LFthxudepDd5d5LA4FIP5Tkh2CWtMjBjT92Ng+uOuXztkvF
         Ef7fu3qWwXFPWRfKdCI9bZFdkFSXPNNKTCXwq6V807WYAEUloz0CTsTS/EArPDVLe/B6
         woMzOOFEukL+OqOZ/+Jy57Njf+TMmjdSZwQ8CYxHXYyxV1Dz/0RUu/O7zzdvNWTcxHMm
         krNNrXhxGHEieIw8j/pP68lGZWDrlGbYKP0J0SjjIjQyW3HtMOYF6f158rwd19OVP6Ve
         X4yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6NfPyo83ZZTFyfnyDjUhhHoRR8SL0Wt9eMBL87a1ir0=;
        b=DsWV7SogUXU2Br0vyp1KwOImv4Ovb5zWqbTDhYXxmcKP7hK9QcCW+qVha7lfmP8yWR
         8cbGjA7jbdd777exvSix2BdEIqwcRJ8t93s7FYTKHyxlYpETRXf1MjmbMupBBrnyqDiA
         /zWxlm2aFMAk8isKvMGH+JyjNoSOQQHTGZ2IwY1ut7wagfpqWqedtCkGnpQ6PrUbYTUN
         SCZ9DWrZTufRqYJ9A8Arcanz0NtnRVRy5C5+Fnh8SrcSEbv3MbIa69z/Hc3TblAMgDLd
         oMXjNwKSJMnWzAYVdMBKdYvKOWcXRLY1470Uc/4eqC1I69xUV6HDO0Mw2w8XsoU79NuC
         gdIg==
X-Gm-Message-State: APjAAAVDmeE8B6Pod+9kdzX69p++erUiUzHhu7cEPFXdgDSq+B0Hl5n0
        PRkYtZpw/KtqBG8JgkGQuEGAAhHsVzHmYcivHxY=
X-Google-Smtp-Source: APXvYqzAAuEI7FiRcurb5f++OXpCc9/Gg/jtO3e8j/Ni48Vy7ag3D0qMaFSQ6x6GMkwojuRzoslhwUwF6GqwYRcFEYk=
X-Received: by 2002:a02:ca52:: with SMTP id i18mr4267610jal.96.1558699886130;
 Fri, 24 May 2019 05:11:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190430120534.5231-1-xxhdx1985126@gmail.com> <CAOi1vP-hjCfyTgv4FtcBguTEe0Aqd-3=9KtRRx+g6mc2_zfD5w@mail.gmail.com>
 <CAJACTudXyFyqfUnofjs4QzU5wFbV27Z-1=YMypF8Adrr8-yyGw@mail.gmail.com>
In-Reply-To: <CAJACTudXyFyqfUnofjs4QzU5wFbV27Z-1=YMypF8Adrr8-yyGw@mail.gmail.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Fri, 24 May 2019 14:11:20 +0200
Message-ID: <CAOi1vP_wm+wWoKuvoD8ZVyF1SEpUrOHinUyTahhjc1Mo75wPhA@mail.gmail.com>
Subject: Re: [PATCH 1/2] cgroup: add a new group controller for cephfs
To:     Xuehan Xu <xxhdx1985126@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        "Yan, Zheng" <ukernel@gmail.com>, Xuehan Xu <xuxuehan@360.cn>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, May 24, 2019 at 1:16 PM Xuehan Xu <xxhdx1985126@gmail.com> wrote:
>
> >
> > Hi Xuehan,
> >
> > While I understand the desire to use the cgroup interface to allow for
> > easy adjustment and process granularity, I think this is unlikely to be
> > accepted in the form of a new controller.  Each controller is supposed
> > to distribute a specific resource and meta iops, data iops and data
> > band(width?) mostly fall under the realm of the existing I/O
> > controller.  Have you run this by the cgroup folks?
> >
> > Regardless, take a look at Documentation/process/coding-style.rst for
> > rules on indentation, line length, etc.  Also, the data throttle should
> > apply to rbd too, so I would change the name to "ceph".
> >
> > Thanks,
> >
> >                 Ilya
>
> Hi, Ilya, thanks for your review:-)
>
> I investigated the existing blkio controller before trying to
> implement a new controller. If I understand the code of blkio
> correctly, it's mainly dedicated to limiting the block device io and
> takes effect by cooperating with the io scheduler which ceph io path
> doesn't contain. So I think maybe a new controller should be
> appropriate. After all, network file system "io" is not real I/O,
> right?

"blkio" is the legacy name.  This controller has been renamed to "io"
precisely because it is supposed to be able to handle any I/O, whether
to a real block device or to an unnamed instance.  Writeback is wired
through backing_dev_info, which ceph instantiates like any other
network filesystem.  Grep for CGROUP_WRITEBACK and SB_I_CGROUPWB.

I don't know how many sharp edges there are or if this infrastructure
is mature enough for anything other than a simple ext4-like use case,
but I wouldn't be surprised to see Tejun and others pushing back on
a ceph-specific controller.

>
> I did submit this patch to cgroup mailling list, yesterday. But no
> response has been received. I don't quite understand the procedure
> that needs to follow to contribute to the cgroup source code. Maybe I
> didn't do it right:-(

cgroups@vger.kernel.org sounds right, give it a few working days.

Thanks,

                Ilya
