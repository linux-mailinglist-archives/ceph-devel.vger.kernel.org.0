Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6FEF8128D
	for <lists+ceph-devel@lfdr.de>; Mon,  5 Aug 2019 08:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbfHEGw4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 5 Aug 2019 02:52:56 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:46023 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbfHEGw4 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 5 Aug 2019 02:52:56 -0400
Received: by mail-qt1-f193.google.com with SMTP id x22so6551506qtp.12
        for <ceph-devel@vger.kernel.org>; Sun, 04 Aug 2019 23:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZuxvZEMI9UZvAkfhciiNlpcRsFpNQRFBbAPRZ3tHnPA=;
        b=FAOii2CxvqDUoJHXapvNqzv8oaVKz2B+TK9VULeweEsdj1lWGX8uEyJu66aJmlbMjK
         8B15LTNtxovi194z0nOCpW4C6te4enWybudbi7m8LIrGjxUz0HiCbSOY+PSJe/72w7fG
         akWh/RknyAzDWsQ4cPxqRb+U+TP4PNhFCRhkOo+WDTSbNSixar/qzOog+Eki0tkSko1m
         vgab8gZBBHAXAZXAjH1XvT0nWYHFyAu6XVLw50TERp0cYG4Wsjng6SW6yMwT8DWmrNTp
         Hrq7UdvCdmkxF0h5wnaqslRnQDLIv9jcBxCJYJcbbregPnbJzf9w3GSculr/72z4fBKb
         iAqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZuxvZEMI9UZvAkfhciiNlpcRsFpNQRFBbAPRZ3tHnPA=;
        b=IuirdSRvuD7+kztSYWzxUjXB9/yH0fnZh1e/cUHzcWcymoFwhva9QujPQqv4OrfhkP
         2CvX89WCQQ2EiDW6IYU2LWdybMYxfjNVTDpaJZcrflp0PV7KT3d9DfzeT8uENLN30TrX
         x5X3AR0+pzj3ySD/ETsXg0uaA/TcJkNeOmWE4y3E2LnMuiVE6QjqY4ZKnQQ0JmcL9d+k
         GnAjtlJRfVG8Msg/Tejp1v/p2U9gT3TGP760n8Ir3bWpeMI5qqvna4LLM36xdgKjyUvj
         H+mF/UymZr/MyTyqs+Rv/9F0wKbG4XEW0qBrmuyR6AmOFiR1jVFA8dFRKTBIDkwxyDZd
         c7Ow==
X-Gm-Message-State: APjAAAVlSHnTcawjE4tfdGAdSBWeLI5UtrGvs3NHdy07plMAgJqgtZvn
        PTezGGObWMs8pEzuDVrc2rWanZ9fPcKRN/EBcN9QIO9XIck=
X-Google-Smtp-Source: APXvYqw+/kLZSbHMJrQ2yKEDvRQKPY0BFOkJnzCBPf2Io8sTdQz7MgxeGK3ry0tZaia7RY/+8WwSrwnszOZqOdza7TM=
X-Received: by 2002:ac8:368a:: with SMTP id a10mr105676032qtc.143.1564987975278;
 Sun, 04 Aug 2019 23:52:55 -0700 (PDT)
MIME-Version: 1.0
References: <20190801202605.18172-1-jlayton@kernel.org>
In-Reply-To: <20190801202605.18172-1-jlayton@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Mon, 5 Aug 2019 14:52:44 +0800
Message-ID: <CAAM7YA=2sdDvjxczGM3Qx=uQTyV3J4jR5ULFksTSE0qsM4Xe2A@mail.gmail.com>
Subject: Re: [PATCH 0/9] ceph: add asynchronous unlink support
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, Sage Weil <sage@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Aug 2, 2019 at 4:26 AM Jeff Layton <jlayton@kernel.org> wrote:
>
> I sent a preliminary patchset for this back in April, which relied
> on a totally hacked-up MDS patchset. Since then, Zheng has modified
> the approach somewhat to make the MDS grant the client explicit
> capabilities for asynchronous directory operations.
>
> This patchset is an updated version of the earlier set. With this,
> and the companion MDS set in play, removing a directory with a large
> number of files in it is roughly twice as fast as doing it
> synchronously.
>
> In addition this set includes some new tracepoints that allow the
> admin to better view what's happening with caps. They're mostly
> limited to unlink and cap handling here, but I expect we'll add
> more of those as time goes on.
>
> I don't think we'll want to merge this just yet, until the MDS
> support is merged. Once that goes in, and assuming we don't have
> any changes to the client/MDS interface, we should clear to do
> so.

MDS support for this is more complex  than I expected. I need more time for it.

Regards
Yan, Zheng

>
> Jeff Layton (7):
>   ceph: make several helper accessors take const pointers
>   ceph: hold extra reference to r_parent over life of request
>   ceph: register MDS request with dir inode from the get-go
>   ceph: add refcounting for Fx caps
>   ceph: wait for async dir ops to complete before doing synchronous dir
>     ops
>   ceph: new tracepoints when adding and removing caps
>   ceph: add tracepoints for async and sync unlink
>
> Yan, Zheng (2):
>   ceph: check inode type for CEPH_CAP_FILE_{CACHE,RD,REXTEND,LAZYIO}
>   ceph: perform asynchronous unlink if we have sufficient caps
>
>  fs/ceph/Makefile                |   3 +-
>  fs/ceph/caps.c                  |  88 +++++++++++++++++------
>  fs/ceph/dir.c                   | 121 ++++++++++++++++++++++++++++++--
>  fs/ceph/file.c                  |   4 ++
>  fs/ceph/inode.c                 |   9 ++-
>  fs/ceph/mds_client.c            |  27 +++----
>  fs/ceph/super.h                 |  28 ++++----
>  fs/ceph/trace.c                 |  76 ++++++++++++++++++++
>  fs/ceph/trace.h                 |  86 +++++++++++++++++++++++
>  include/linux/ceph/ceph_debug.h |   1 +
>  include/linux/ceph/ceph_fs.h    |   9 +++
>  11 files changed, 393 insertions(+), 59 deletions(-)
>  create mode 100644 fs/ceph/trace.c
>  create mode 100644 fs/ceph/trace.h
>
> --
> 2.21.0
>
