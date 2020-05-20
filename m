Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80D761DADAE
	for <lists+ceph-devel@lfdr.de>; Wed, 20 May 2020 10:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbgETIi2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 20 May 2020 04:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgETIi2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 20 May 2020 04:38:28 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17127C061A0E
        for <ceph-devel@vger.kernel.org>; Wed, 20 May 2020 01:38:28 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id s3so2579033eji.6
        for <ceph-devel@vger.kernel.org>; Wed, 20 May 2020 01:38:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vanderster.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GHcua224BUZ+YrEjYca1YTt4PbLXR7o65UI1AVBV6TQ=;
        b=Hos5oSsIP363TEX+PSnLpZ2xxKQ3CHeN/HrMoUKC1EOY8Hf6zL11HR+ZMjsiMTGtzK
         jjgsXVTT4wf/almKt/+0tjwM0wNcqJeF5fiUo2c2Z7SpDeWD6FdLIG3dGq/paQz1eqX5
         +ZaLyuqmmlxF0H97zU9DpqS9t0S8eZjpkyPq4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GHcua224BUZ+YrEjYca1YTt4PbLXR7o65UI1AVBV6TQ=;
        b=ouvsWtRG4XNRFGayS3NX8Z0ASXphqzSq491x7HQ+M3V3OHNjY8iczX2d0UKvjs52XW
         RtrlIuRvQEu8ATyeL5sOGFi7X8O2cdQgssBSWptJ7vNSOwy42nvZbQilwRHZ4W5q3Ler
         cBNKD9ZL50IHSMbzOZi7pZr43O6mztNVebV/s4JVuY8QnSl6GLXYrhDxZv73WsVdJ79s
         9cwCh7uGaJwQ+JNgscwbraeyjJ82yWdmjtetgCHoKTKfKOjU8QbK2xtGqfCiVITLuTyt
         hGC9acOPP5YW0KDVqZXOCruQJ2Rze0w0Wn2wVQ6Dn9TJkzCkjhL/KNX1/HcaoiCA48pa
         ly5Q==
X-Gm-Message-State: AOAM531uV8hWQBFzvzsD52vBcZItI3V6z7I30nvKesKy9+bY0nrHs/7+
        +fAE3uYVtLfpUCjuLXGTpiAvPegnYRw=
X-Google-Smtp-Source: ABdhPJzImrJhWUIe3lN65klC1/q34o01TWKb9mOS70Az+TIpNGB1kYUeRuOVgygfzxJ+ziGBwM0rtw==
X-Received: by 2002:a17:907:39b:: with SMTP id ss27mr2687951ejb.209.1589963905888;
        Wed, 20 May 2020 01:38:25 -0700 (PDT)
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com. [209.85.128.41])
        by smtp.gmail.com with ESMTPSA id 25sm1328206ejy.32.2020.05.20.01.38.24
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2020 01:38:25 -0700 (PDT)
Received: by mail-wm1-f41.google.com with SMTP id m12so1759009wmc.0
        for <ceph-devel@vger.kernel.org>; Wed, 20 May 2020 01:38:24 -0700 (PDT)
X-Received: by 2002:a1c:de05:: with SMTP id v5mr3463878wmg.1.1589963904467;
 Wed, 20 May 2020 01:38:24 -0700 (PDT)
MIME-Version: 1.0
References: <CAANLjFqkgn86Oa=70jHqHB-4o0saL9Q+AGPuGyyj94x7EiSi2Q@mail.gmail.com>
In-Reply-To: <CAANLjFqkgn86Oa=70jHqHB-4o0saL9Q+AGPuGyyj94x7EiSi2Q@mail.gmail.com>
From:   Dan van der Ster <dan@vanderster.com>
Date:   Wed, 20 May 2020 10:37:48 +0200
X-Gmail-Original-Message-ID: <CABZ+qqn7DwiDO1Ecynx8zY_JuEP81AKemoesSE4F8dkhLtAmLg@mail.gmail.com>
Message-ID: <CABZ+qqn7DwiDO1Ecynx8zY_JuEP81AKemoesSE4F8dkhLtAmLg@mail.gmail.com>
Subject: Re: [ceph-users] Possible bug in op path?
To:     Robert LeBlanc <robert@leblancnet.us>
Cc:     ceph-users <ceph-users@ceph.io>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Robert,

Since you didn't mention -- are you using osd_op_queue_cut_off low or
high? I know you are usually advocating high, but the default is still
low and most users don't change this setting.

Cheers, Dan


On Wed, May 20, 2020 at 9:41 AM Robert LeBlanc <robert@leblancnet.us> wrote:
>
> We upgraded our Jewel cluster to Nautilus a few months ago and I've noticed
> that op behavior has changed. This is an HDD cluster (NVMe journals and
> NVMe CephFS metadata pool) with about 800 OSDs. When on Jewel and running
> WPQ with the high cut-off, it was rock solid. When we had recoveries going
> on it barely dented the client ops and when the client ops on the cluster
> went down the backfills would run as fast as the cluster could go. I could
> have max_backfills set to 10 and the cluster performed admirably.
> After upgrading to Nautilus the cluster struggles with any kind of recovery
> and if there is any significant client write load the cluster can get into
> a death spiral. Even heavy client write bandwidth (3-4 GB/s) can cause the
> heartbeat checks to raise, blocked IO and even OSDs becoming unresponsive.
> As the person who wrote the WPQ code initially, I know that it was fair and
> proportional to the op priority and in Jewel it worked. It's not working in
> Nautilus. I've tweaked a lot of things trying to troubleshoot the issue and
> setting the recovery priority to 1 or zero barely makes any difference. My
> best estimation is that the op priority is getting lost before reaching the
> WPQ scheduler and is thus not prioritizing and dispatching ops correctly.
> It's almost as if all ops are being treated the same and there is no
> priority at all.
> Unfortunately, I do not have the time to set up the dev/testing environment
> to track this down and we will be moving away from Ceph. But I really like
> Ceph and want to see it succeed. I strongly suggest that someone look into
> this because I think it will resolve a lot of problems people have had on
> the mailing list. I'm not sure if a bug was introduced with the other
> queues that touches more of the op path or if something in the op path
> restructuring that changed how things work (I know that was being discussed
> around the time that Jewel was released). But my guess is that it is
> somewhere between the op being created and being received into the queue.
> I really hope that this helps in the search for this regression. I spent a
> lot of time studying the issue to come up with WPQ and saw it work great
> when I switched this cluster from PRIO to WPQ. I've also spent countless
> hours studying how it's changed in Nautilus.
>
> Thank you,
> Robert LeBlanc
> ----------------
> Robert LeBlanc
> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
> _______________________________________________
> ceph-users mailing list -- ceph-users@ceph.io
> To unsubscribe send an email to ceph-users-leave@ceph.io
