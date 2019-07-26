Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE39760A6
	for <lists+ceph-devel@lfdr.de>; Fri, 26 Jul 2019 10:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbfGZI0D (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 26 Jul 2019 04:26:03 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:45521 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbfGZI0B (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 26 Jul 2019 04:26:01 -0400
Received: by mail-qt1-f195.google.com with SMTP id x22so46864972qtp.12
        for <ceph-devel@vger.kernel.org>; Fri, 26 Jul 2019 01:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k3qriwTFQyja3MChLrh6VlWxpuljvFjMZBEt0+5vTX8=;
        b=nlithE+I/gs0gnOWOIHYjfpWOcrsSEwAxuJGeDru4XWIOM4PzGDJ2z7fGwgn361f4Y
         sWGvjXKJLZwqHqEtKvl26JW7WAWdtUJbxkK7FXttNYJEIhDEb8zwzxnYcWJN2grN7dAe
         mNKFlkWTd3/7wktyDBP2EEBd1OcrSQ0rizZV5BVPoLE0HyD6/LaOOlgL/6cN0xXrSNp9
         CcJ/PsKy5UWmFkFMmp6Gul7gUxmDAVBIpD1BLjBOHqqKGhTbETBHDDWc56H/gzR0ew52
         fLtsp43dZkFwAf4tBGFXRChIoiPdvnCfJOLLaBvrM7VkXINmeSApy4Gopf16BCSCidDI
         D+qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k3qriwTFQyja3MChLrh6VlWxpuljvFjMZBEt0+5vTX8=;
        b=nXgcUaN5CLbg90Ne5Q6+3yICvYjcemH3l0dtCoAcrXsNI10AnoVeaQdIRKpH8JShrK
         OUC74GzHuIt5hn3FN4o1XG5AjiXK3eFYhkX317X1mnbJIXXjzgwYutb1a0SFZjJ/ddx+
         iqE4VkLOkiRi00Gss6jp5EM4IqHDHIRNcHi4W2cLzqef5pb2csm2RwhPPbw/cBAWc/Ep
         nTt9Pih9tLY9kWOD9KI3sJEpp91hFSE8Ml1Wuu40X8qaOBLsHblCt74NhLw5IvgYpnYX
         jfaPiNI6onssJRtMDlcwqNfz/I3eYzokCwUo+7qe+ja6Zf0MrZ1TvErk7aEKjY8Gpp5T
         v4KQ==
X-Gm-Message-State: APjAAAVw43FBYpYnSFi/UJtdCk1ckwMyGq+ldDSOEnAiVpP/JdsQh9fH
        0tgwanMgWFdgg6+u98rWsleXtjupH4F1fgYuZOnPmPbwAsc=
X-Google-Smtp-Source: APXvYqy4ORWSMZn0SPP03Vn793Yn7BZ1Ys1TU7FfwCXEgNZZr8OPivuNB4Kem7Lhyp93saQz421C5/aBNcYQPl9HU0U=
X-Received: by 2002:ac8:368a:: with SMTP id a10mr65562150qtc.143.1564129560643;
 Fri, 26 Jul 2019 01:26:00 -0700 (PDT)
MIME-Version: 1.0
References: <20190725111746.10393-1-jlayton@kernel.org>
In-Reply-To: <20190725111746.10393-1-jlayton@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Fri, 26 Jul 2019 16:25:49 +0800
Message-ID: <CAAM7YA=Fp5Np5e6YMgx-mPrmHZcgtMpiaXy_k51doZ4NGn_-Tg@mail.gmail.com>
Subject: Re: [PATCH 0/8] ceph: minor cleanup patches for v5.4
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Jul 26, 2019 at 12:54 AM Jeff Layton <jlayton@kernel.org> wrote:
>
> I've been trying to chip away at the coverage of the session->s_mutex,
> and in the process have been doing some minor cleanup of the code and
> comments, mostly around the cap handing.
>
> These shouldn't cause much in the way of behavioral changes.
>
> Jeff Layton (8):
>   ceph: remove ceph_get_cap_mds and __ceph_get_cap_mds
>   ceph: fetch cap_gen under spinlock in ceph_add_cap
>   ceph: eliminate session->s_trim_caps
>   ceph: fix comments over ceph_add_cap
>   ceph: have __mark_caps_flushing return flush_tid
>   ceph: remove unneeded test in try_flush_caps
>   ceph: remove CEPH_I_NOFLUSH
>   ceph: remove incorrect comment above __send_cap
>

reviewed-by

>  fs/ceph/caps.c       | 80 ++++++++++++--------------------------------
>  fs/ceph/mds_client.c | 17 +++++-----
>  fs/ceph/mds_client.h |  2 +-
>  fs/ceph/super.h      | 20 +++++------
>  4 files changed, 39 insertions(+), 80 deletions(-)
>
> --
> 2.21.0
>
