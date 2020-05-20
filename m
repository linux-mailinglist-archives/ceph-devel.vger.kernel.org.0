Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8481DBA61
	for <lists+ceph-devel@lfdr.de>; Wed, 20 May 2020 18:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbgETQ5D (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 20 May 2020 12:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726890AbgETQ5D (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 20 May 2020 12:57:03 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B2C2C061A0E
        for <ceph-devel@vger.kernel.org>; Wed, 20 May 2020 09:57:03 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id p12so3065938qtn.13
        for <ceph-devel@vger.kernel.org>; Wed, 20 May 2020 09:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=leblancnet-us.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VDBiDd1hrLX7cLKTNCCCT75Ye6NMS7cRz8/9qHQE8RA=;
        b=P0/rRqPYQGjjfz0lrxzk91xjlorsvjwolvN3GEDzimImL/Tl5ct3MztZLjumwukuFa
         Qj7HOyrEskThwMCESswMx3m8bJZT/9Xrpc7tY8CfKrahe4pE6BsKkNeRZ/4/1xJrC4cZ
         WXpzhQsD7ODJUsUFdrPfK7xekfHYIUYxn7V0R98SjOdq+G/b/G5zD1M3YDbynxehRjML
         iR4uBPAR6vOWauQnpbLgcLMswp6LMrChHkdbqDRYJOyF7bNIln6+mi+VEWUmbfAykonA
         /7YdVFB4VG3hyjahIsN7Bz/0g1M1pL/29p+qDz/10rY+jPbo7wzTCAShwuQ7P0OlZAjk
         KOjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VDBiDd1hrLX7cLKTNCCCT75Ye6NMS7cRz8/9qHQE8RA=;
        b=fugu0xVwmtiq6eHqopb9upXTOOmAMjIO4hFZlE89UlafRlGJ7/iptpdRIUqybrankn
         R+M3seE6d2/8a7IcUhD5afomED7Sl4Nuy0iJq58FfjVhxawmbo4IxfRfnuEhl2Lvti02
         JOxf8FR42E0rsXcUoF+7ZcSmC2gUHYwXvG0qDZYN2+6RuxYz24Izol5/FQ7SVh2dn+hP
         T8yp7d3DCt4qOnf9yQbI1b5qCZ02qD9i1J3nOrChrte8k8axBGfakZt26VFGHatOzzs8
         zKDnoNDcBDr+ksCknifOmJ7zpOReeypF62NP77jH5xWJEP+1syHO/bgOVEINiwjcuSwv
         LVWw==
X-Gm-Message-State: AOAM5334GryvT3LcQItYkMLjyjoMF3xhG9OE3KGRzawfGctP4szP25fu
        4jchS1tZ6mpJIX7hYSJKcV1z7XDnYPY4gFrp+4G09t62
X-Google-Smtp-Source: ABdhPJyHg6oDkVIyUbf5AO9AhSTgR6xQReq0XahR4mDSD4DJUWO9JnMZhvzPqVia20PYflkwW0TJJtwbRYHpAbZ+3aY=
X-Received: by 2002:aed:2565:: with SMTP id w34mr6358239qtc.54.1589993822103;
 Wed, 20 May 2020 09:57:02 -0700 (PDT)
MIME-Version: 1.0
References: <CAANLjFqkgn86Oa=70jHqHB-4o0saL9Q+AGPuGyyj94x7EiSi2Q@mail.gmail.com>
 <CABZ+qqn7DwiDO1Ecynx8zY_JuEP81AKemoesSE4F8dkhLtAmLg@mail.gmail.com>
In-Reply-To: <CABZ+qqn7DwiDO1Ecynx8zY_JuEP81AKemoesSE4F8dkhLtAmLg@mail.gmail.com>
From:   Robert LeBlanc <robert@leblancnet.us>
Date:   Wed, 20 May 2020 09:56:51 -0700
Message-ID: <CAANLjFq+EerkocoYN0MW4VaGRHOWdNPs2HLsROLtcu374B6sMg@mail.gmail.com>
Subject: Re: [ceph-users] Possible bug in op path?
To:     Dan van der Ster <dan@vanderster.com>
Cc:     ceph-users <ceph-users@ceph.io>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

We are using high and the people on the list that have also changed
have not seen the improvements that I would expect.
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1

On Wed, May 20, 2020 at 1:38 AM Dan van der Ster <dan@vanderster.com> wrote:
>
> Hi Robert,
>
> Since you didn't mention -- are you using osd_op_queue_cut_off low or
> high? I know you are usually advocating high, but the default is still
> low and most users don't change this setting.
>
> Cheers, Dan
>
>
> On Wed, May 20, 2020 at 9:41 AM Robert LeBlanc <robert@leblancnet.us> wrote:
> >
> > We upgraded our Jewel cluster to Nautilus a few months ago and I've noticed
> > that op behavior has changed. This is an HDD cluster (NVMe journals and
> > NVMe CephFS metadata pool) with about 800 OSDs. When on Jewel and running
> > WPQ with the high cut-off, it was rock solid. When we had recoveries going
> > on it barely dented the client ops and when the client ops on the cluster
> > went down the backfills would run as fast as the cluster could go. I could
> > have max_backfills set to 10 and the cluster performed admirably.
> > After upgrading to Nautilus the cluster struggles with any kind of recovery
> > and if there is any significant client write load the cluster can get into
> > a death spiral. Even heavy client write bandwidth (3-4 GB/s) can cause the
> > heartbeat checks to raise, blocked IO and even OSDs becoming unresponsive.
> > As the person who wrote the WPQ code initially, I know that it was fair and
> > proportional to the op priority and in Jewel it worked. It's not working in
> > Nautilus. I've tweaked a lot of things trying to troubleshoot the issue and
> > setting the recovery priority to 1 or zero barely makes any difference. My
> > best estimation is that the op priority is getting lost before reaching the
> > WPQ scheduler and is thus not prioritizing and dispatching ops correctly.
> > It's almost as if all ops are being treated the same and there is no
> > priority at all.
> > Unfortunately, I do not have the time to set up the dev/testing environment
> > to track this down and we will be moving away from Ceph. But I really like
> > Ceph and want to see it succeed. I strongly suggest that someone look into
> > this because I think it will resolve a lot of problems people have had on
> > the mailing list. I'm not sure if a bug was introduced with the other
> > queues that touches more of the op path or if something in the op path
> > restructuring that changed how things work (I know that was being discussed
> > around the time that Jewel was released). But my guess is that it is
> > somewhere between the op being created and being received into the queue.
> > I really hope that this helps in the search for this regression. I spent a
> > lot of time studying the issue to come up with WPQ and saw it work great
> > when I switched this cluster from PRIO to WPQ. I've also spent countless
> > hours studying how it's changed in Nautilus.
> >
> > Thank you,
> > Robert LeBlanc
> > ----------------
> > Robert LeBlanc
> > PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
> > _______________________________________________
> > ceph-users mailing list -- ceph-users@ceph.io
> > To unsubscribe send an email to ceph-users-leave@ceph.io
