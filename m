Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB60F1DAC94
	for <lists+ceph-devel@lfdr.de>; Wed, 20 May 2020 09:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbgETHvB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 20 May 2020 03:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726403AbgETHvA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 20 May 2020 03:51:00 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87857C061A0E
        for <ceph-devel@vger.kernel.org>; Wed, 20 May 2020 00:51:00 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id 142so2663728qkl.6
        for <ceph-devel@vger.kernel.org>; Wed, 20 May 2020 00:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=leblancnet-us.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=R/whvifzYo3ArWPOes6uHQ0ypJoY1rfMlelEST+k+34=;
        b=ujECdzOm+t5jRYozjoz/9E2VlZ775ig9fvC3lWhaZzG4w4tc8hngoeWpvFmUYDkyks
         QNphUShqxt3PnEps4qBHeh+00JXIinFVHJL9OPYRr+3k+DW3f8xSpTAf43crR9oohHMd
         Sg/+GOxcMCtEZoTxeyeYfRAVIHfU2XTc6OvEAQ3kH+kIUGMOlU8pDdJnldyeXaWV0V6D
         wtuowWc6/mZ/GsDBavnDWSEmgSlpzE41vDS7NknB2oGCz7D8TnV6sZXOb3y1Z1LlELUf
         Y0s7pzDz0aH1OJY0xjTNmtnXp2i2KIT5cYG8zRDI6NhUpaWva59g2Azwlt+EnXfYFXms
         jorg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=R/whvifzYo3ArWPOes6uHQ0ypJoY1rfMlelEST+k+34=;
        b=cP0CgwgxdGE/YYeGIbYloh4wJ+vuF9ocn0lsmmfu8O/tVCjdCHfoTP3Giz8lGC5HaM
         EQqT890B5GV+anRBq0564TfeJq6HQLi1x/r4TTPQ831tenpA9vYtWHhorJov7+/uWxUQ
         XPLF6sdwLy1SN6Vs0+VCAFtNpiWpquET+ngxJYJLF0kxZP8bgf6yg7xwXCpXZXfmj3ol
         C/oHkIj3yUZwgmcbJXEhQHFWPeMbqr8cP22UJs/lRkTUp+gsoZxrJPuzt+Ufom0li/L1
         eVlRSXY+TKfN6M1jzTsmXUNM2FwIpAxZdIGALISy6XWZOFdQayCZklywcPpK7nC02UJM
         XfpA==
X-Gm-Message-State: AOAM5309mbUO0hVn7ICZe1U4eppRIZ6X6RPcE11+rVU0SZo3gYfzl0WD
        BKMBVHD+aBSyTiGfHiKXs0kVJNbq8rxIYj7VHqridDEt
X-Google-Smtp-Source: ABdhPJzM7D+1wN9ud5OFMvrstsidTV0H9n7xJocxO3TR0nne1mexlaeRcmmi5lvYHtW7qXNO0hhHDBxmSPgKnEzXd94=
X-Received: by 2002:a05:620a:146a:: with SMTP id j10mr3576107qkl.333.1589961059365;
 Wed, 20 May 2020 00:50:59 -0700 (PDT)
MIME-Version: 1.0
References: <CAANLjFqkgn86Oa=70jHqHB-4o0saL9Q+AGPuGyyj94x7EiSi2Q@mail.gmail.com>
In-Reply-To: <CAANLjFqkgn86Oa=70jHqHB-4o0saL9Q+AGPuGyyj94x7EiSi2Q@mail.gmail.com>
From:   Robert LeBlanc <robert@leblancnet.us>
Date:   Wed, 20 May 2020 00:50:48 -0700
Message-ID: <CAANLjFo5fc3NZwV1MzxwXg6myDJv5iWGwY1TKAjbNPLp_kxhPA@mail.gmail.com>
Subject: Fwd: Possible bug in op path?
To:     ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

De-HTMLified
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1


---------- Forwarded message ---------
From: Robert LeBlanc <robert@leblancnet.us>
Date: Wed, May 20, 2020 at 12:40 AM
Subject: Possible bug in op path?
To: ceph-users <ceph-users@ceph.io>, ceph-devel <ceph-devel@vger.kernel.org>


We upgraded our Jewel cluster to Nautilus a few months ago and I've
noticed that op behavior has changed. This is an HDD cluster (NVMe
journals and NVMe CephFS metadata pool) with about 800 OSDs. When on
Jewel and running WPQ with the high cut-off, it was rock solid. When
we had recoveries going on it barely dented the client ops and when
the client ops on the cluster went down the backfills would run as
fast as the cluster could go. I could have max_backfills set to 10 and
the cluster performed admirably.
After upgrading to Nautilus the cluster struggles with any kind of
recovery and if there is any significant client write load the cluster
can get into a death spiral. Even heavy client write bandwidth (3-4
GB/s) can cause the heartbeat checks to raise, blocked IO and even
OSDs becoming unresponsive.
As the person who wrote the WPQ code initially, I know that it was
fair and proportional to the op priority and in Jewel it worked. It's
not working in Nautilus. I've tweaked a lot of things trying to
troubleshoot the issue and setting the recovery priority to 1 or zero
barely makes any difference. My best estimation is that the op
priority is getting lost before reaching the WPQ scheduler and is thus
not prioritizing and dispatching ops correctly. It's almost as if all
ops are being treated the same and there is no priority at all.
Unfortunately, I do not have the time to set up the dev/testing
environment to track this down and we will be moving away from Ceph.
But I really like Ceph and want to see it succeed. I strongly suggest
that someone look into this because I think it will resolve a lot of
problems people have had on the mailing list. I'm not sure if a bug
was introduced with the other queues that touches more of the op path
or if something in the op path restructuring that changed how things
work (I know that was being discussed around the time that Jewel was
released). But my guess is that it is somewhere between the op being
created and being received into the queue.
I really hope that this helps in the search for this regression. I
spent a lot of time studying the issue to come up with WPQ and saw it
work great when I switched this cluster from PRIO to WPQ. I've also
spent countless hours studying how it's changed in Nautilus.

Thank you,
Robert LeBlanc
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
