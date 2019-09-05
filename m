Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9BDFAA211
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Sep 2019 13:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387612AbfIEL4f convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Thu, 5 Sep 2019 07:56:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33822 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725921AbfIEL4f (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 5 Sep 2019 07:56:35 -0400
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A8FAA90B0A
        for <ceph-devel@vger.kernel.org>; Thu,  5 Sep 2019 11:56:34 +0000 (UTC)
Received: by mail-qt1-f200.google.com with SMTP id i19so2156992qtq.17
        for <ceph-devel@vger.kernel.org>; Thu, 05 Sep 2019 04:56:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FKwYhaiBHo7B4SN6mZ6fcEfWCtr1gokBhQPNst6mfWY=;
        b=ooPsO7qv+VQqvvBZ7TOqCG0qB3XWKTeczh5sUtj+5BCaREcSFciry5roPbo8KnWhHd
         T5mrND6nFZ/EKHY4h85dC9rElYkAzjdpRfvVgdAggUDEkl0MD/cbqRMse8q3LAUJZV0W
         0TB3I7OVg5zbQC6zrNfYHBMVqTq0D+GLGgtYlBwTEjb5ojsvzKiaQuwqFF3bDCgr94ZV
         1Ez+qFfwi080uwlNqUVroc3Ralt1fkJT/kkbZZH8ZfUdmZmtSumzhigGZ6Krbm3QFF+N
         TcbjE/4ALBar5oSsJ64qRvORbqaMPKHy9GvpmVOw1itlyAk+pCIftMrBel0mQOYi6AWE
         WREQ==
X-Gm-Message-State: APjAAAXiNhQrjDnh6qvI47WCLjNjQfyJ9vH0seDrPFshJZMyLOB5beBm
        85BiBsnHxQm9ouvshpxYK3TKNdaQw6UjaDjGbwglerpzVH1KgmUefYxwnJrU3WHgtaR3otrVZZ5
        gBQ7HhPRpaQ+GuJPd10f3jYrzZndb2m01QFieog==
X-Received: by 2002:ac8:4548:: with SMTP id z8mr2718650qtn.258.1567684593733;
        Thu, 05 Sep 2019 04:56:33 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwXb9hqc0QX4Q3B/rGq+Yt4kVcnhj/S+jyqoPUUtwJ7LOCJzjs87ef5utIuNpfGqR/tn87G3tmxdaK40V7DGPA=
X-Received: by 2002:ac8:4548:: with SMTP id z8mr2718635qtn.258.1567684593524;
 Thu, 05 Sep 2019 04:56:33 -0700 (PDT)
MIME-Version: 1.0
References: <CAD9yTbH74a+i5viVjV6Qj4yB9dguxO946YkUDf6ODQb-wvJM=Q@mail.gmail.com>
 <CAC-Np1xhZoKqVVjMhCPnBoJ5Z0aPj6iL4UYJfgp7M+VXCs9vkA@mail.gmail.com>
 <CALi_L4-rkKonTLAcBK==qs4Cr190j00cbRCDOGWsBWy61RdwMQ@mail.gmail.com> <CAC-Np1zv8oHtGj_0L4gWa23KTf3tOnAs_JtTqhZYDvKzNinUpQ@mail.gmail.com>
In-Reply-To: <CAC-Np1zv8oHtGj_0L4gWa23KTf3tOnAs_JtTqhZYDvKzNinUpQ@mail.gmail.com>
From:   Alfredo Deza <adeza@redhat.com>
Date:   Thu, 5 Sep 2019 07:56:22 -0400
Message-ID: <CAC-Np1w45EGTW07ovfrK_sWNg5JNuMkwbs7kxcfBxr=98n6xsQ@mail.gmail.com>
Subject: Re: ceph-volume lvm activate --all broken in 14.2.3
To:     Sasha Litvak <alexander.v.litvak@gmail.com>
Cc:     Paul Emmerich <paul.emmerich@croit.io>,
        ceph-devel <ceph-devel@vger.kernel.org>, dev@ceph.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

While we try to fix this, in the meantime the only workaround is not
to redirect stderr. This is far from ideal if you require redirection,
but so far is the only workaround to avoid this problem.


On Wed, Sep 4, 2019 at 7:54 PM Alfredo Deza <adeza@redhat.com> wrote:
>
> On Wed, Sep 4, 2019 at 6:35 PM Sasha Litvak
> <alexander.v.litvak@gmail.com> wrote:
> >
> > How do you fix it?  Or you wait till 14.2.4?
>
> This is a high priority for me, I will provide a fix as soon as
> possible and hopefully a workaround.
>
> >
> > On Wed, Sep 4, 2019, 3:38 PM Alfredo Deza <adeza@redhat.com> wrote:
> >>
> >> On Wed, Sep 4, 2019 at 4:01 PM Paul Emmerich <paul.emmerich@croit.io> wrote:
> >> >
> >> > Hi,
> >> >
> >> > see https://tracker.ceph.com/issues/41660
> >> >
> >> > ceph-volume lvm activate --all fails on the second OSD when stderr is
> >> > not a terminal.
> >> > Reproducible on different servers, so there's nothing weird about a
> >> > particular disk.
> >> >
> >> > Any idea where/how this is happening?
> >>
> >> That looks very odd, haven't seen it other than a unit test we have
> >> that fails in some machines. I was just investigating that today.
> >>
> >> Is it possible that the locale is set to something that is not
> >> en_US.UTF-8 ? I was able to replicate some failures with LC_ALL=C
> >>
> >> Another thing I would try is to enable debug (or show/paste the
> >> traceback) so that tracebacks are immediately available in the output:
> >>
> >> CEPH_VOLUME_DEBUG=1 ceph-volume lvm activate --all
> >>
> >> I'll follow up in the tracker ticket
> >> >
> >> > This makes 14.2.3 unusable for us as we need to re-activate all OSDs
> >> > after reboots because we don't have a persistent system disk.
> >> >
> >> >
> >> > Paul
> >> >
> >> > --
> >> > Paul Emmerich
> >> >
> >> > Looking for help with your Ceph cluster? Contact us at https://croit.io
> >> >
> >> > croit GmbH
> >> > Freseniusstr. 31h
> >> > 81247 München
> >> > www.croit.io
> >> > Tel: +49 89 1896585 90
> >> _______________________________________________
> >> Dev mailing list -- dev@ceph.io
> >> To unsubscribe send an email to dev-leave@ceph.io
