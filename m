Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4C1188A9F
	for <lists+ceph-devel@lfdr.de>; Tue, 17 Mar 2020 17:41:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbgCQQlc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 17 Mar 2020 12:41:32 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:21833 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726130AbgCQQlc (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 17 Mar 2020 12:41:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584463291;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=I+w/pr0CSUCGponnUaoqxRHGah6gl8/RUIJ3Z3TgH20=;
        b=Zf3x1qMm2btn2zgV2SZ+uzCUedJS7nIg0sMuviYH94OjNaIYFCAcMpMKprTyHkxaEQAfRp
        Z7uqL7bJn/+eo98bFmOC7RGCqbUStJR0tfa4IYJnJr6fa7X4m5XX5YE8CUKmzjX0oOVZ3u
        L71vGu8TtFaDZUPbk0ne0r2u7D+EgS8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-77--HxtUp0KPKWyH5bzWcP9Tg-1; Tue, 17 Mar 2020 12:41:29 -0400
X-MC-Unique: -HxtUp0KPKWyH5bzWcP9Tg-1
Received: by mail-wm1-f72.google.com with SMTP id z16so2056512wmi.2
        for <ceph-devel@vger.kernel.org>; Tue, 17 Mar 2020 09:41:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=I+w/pr0CSUCGponnUaoqxRHGah6gl8/RUIJ3Z3TgH20=;
        b=UpyBs08w48KKOtNEiPC5AjRR8yJ8VTMX6SRPdJwqkODS1Hd9g8yT4HMjtaPn6NO6cX
         q1DYUQTMjhxLRXtEO4+s6qXCwSW8ldggdxL3jrQ1+d10IuygMHPFyb3Y329LpCKuJT68
         /NFP0/cYGNBs49QIqRpRstEZPW+1umOXHDroUw3hu8HqJwgZIkCLabMiF2R9OOaGUgeo
         3OcvhrQdx31Z6lhBl8mvts7/QGFOOt+nytBrCQHqvQ9t+3/ScuBcyUk6dhYWYbtTHqFi
         C6zCdveA+Ze7hf5yUb07DMcjnOaztnlcIsuH9pznfdLkgOK6FvDT/XE4SPmOwNPOZWrq
         Xmhw==
X-Gm-Message-State: ANhLgQ16JIe09GLGZYKIzMBLpNIh5Pn1Q6AYAK4deiilxJiS/xMTvzeh
        31DUqZiB/WVw4JBkQwMg7GZkK8QohfQpLXcS2KtJUHrJcd04jCdwjlD/2AwgiZMGyuNwfTrIUcv
        IVu3HDuilzbhNDTxPHNszaX0xF2clsAIo3k6xJw==
X-Received: by 2002:adf:fd87:: with SMTP id d7mr3570109wrr.393.1584463288891;
        Tue, 17 Mar 2020 09:41:28 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtWu6qPrYl51997AWIIn2ltG/lBKXX3VdkYu/EZIdRDO9nBSr+o+YbWH3wU2ACJs9mgFgEcqqw6Kkcx0IR1488=
X-Received: by 2002:adf:fd87:: with SMTP id d7mr3570099wrr.393.1584463288679;
 Tue, 17 Mar 2020 09:41:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200317120422.3406-1-idryomov@gmail.com>
In-Reply-To: <20200317120422.3406-1-idryomov@gmail.com>
Reply-To: dillaman@redhat.com
From:   Jason Dillaman <jdillama@redhat.com>
Date:   Tue, 17 Mar 2020 12:41:16 -0400
Message-ID: <CA+aFP1DkGftqkWF6_g6Op0prYBXgv50ynfsG=yyCinLDm++uRg@mail.gmail.com>
Subject: Re: [PATCH 0/3] rbd: fix some issues around flushing notifies
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Mar 17, 2020 at 8:06 AM Ilya Dryomov <idryomov@gmail.com> wrote:
>
> Hello,
>
> A recent snapshot-based mirroring experiment exposed a deadlock on
> header_rwsem in the error path of rbd_dev_image_probe() (i.e. "rbd
> map").
>
> Thanks,
>
>                 Ilya
>
>
> Ilya Dryomov (3):
>   rbd: avoid a deadlock on header_rwsem when flushing notifies
>   rbd: call rbd_dev_unprobe() after unwatching and flushing notifies
>   rbd: don't test rbd_dev->opts in rbd_dev_image_release()
>
>  drivers/block/rbd.c | 23 ++++++++++++++---------
>  1 file changed, 14 insertions(+), 9 deletions(-)
>
> --
> 2.19.2
>

The "get_snapcontext" call still going to hang (albeit in an
interruptible state) if the image has > 510 snapshots, correct?

Reviewed-by: Jason Dillaman <dillaman@redhat.com>

-- 
Jason

