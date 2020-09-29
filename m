Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3CB27C01D
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Sep 2020 10:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727824AbgI2IzI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Sep 2020 04:55:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727767AbgI2IzH (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 29 Sep 2020 04:55:07 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22858C061755
        for <ceph-devel@vger.kernel.org>; Tue, 29 Sep 2020 01:55:06 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id m17so4011360ioo.1
        for <ceph-devel@vger.kernel.org>; Tue, 29 Sep 2020 01:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bSJqmsSZBnYwnV8I9M8PhG2ZMSW8s5Ehuo6WR2P2pMU=;
        b=oJfM8js8ADJSg+73jhDs3qMxUqhbUrAQ1EMYvm7oc12v9zbM1IfjzWCLTUY1MH/Ux+
         A1P9SKG2h2hLqUq8LFiyrdCeJ2YmLYoHnXqIu3nsMQTmHppj8tCz/asb/AFhmyl+G0dz
         3sc0e3fGHk8zwCbrQyD2Gfr50fuCiu5qxB3YuAI1SYWfv26pzUAW8qemgyH+73Ba6/A+
         scncfOaUVqLtySukVlMSRSo8Ahb1YDvfolm2E/JSTmX/MM7yoF/hsTELLC5UIBUY+T5b
         3NwA2EPnoXF8ZNLCZM+sbLfieNtHjpbCu6lPNXSsYifTsONx4e7DFt6CVla7EEugQ7ZT
         lGSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bSJqmsSZBnYwnV8I9M8PhG2ZMSW8s5Ehuo6WR2P2pMU=;
        b=l3Uognch4YpdIt+hrXDu04cgOGL9WDewzdVL6Dwkmc9E0g0Ehi0nzIWkJObid/WdsQ
         8GCrxA0E6AVp+/slV3LISezybfJSwwfulDRuynpUx7OY+p1ECpZlIzU5m0rQ7Y8Tj7kK
         7jxZmqZ7d4zqv3w9dvibbME+2J7BqTYjCQUedSP0IUzZGVCCa9iBfmApCvVEEjphRzgt
         UxtYXumpjvAaL1UaTRI1oMEIEKGgD8/sZNZvpR64Zx74eG6sqWqXSbk7HAL0dlkLAx06
         Hyx/UX37MK5A4CAeEArieD6BGeSyauhEco/sAzxE4bxwu1TJUHzTV6Ne20cLLcjZ3WYd
         WpPw==
X-Gm-Message-State: AOAM530sC3oG2n/xnCWpyzz1KJsfgFit1ZwOvwDQ+fivpo7s7FS2BDO2
        aCaZJODr+9OcjWaQ3n1y9Et7H11TuI67u5HVExg=
X-Google-Smtp-Source: ABdhPJxL/xyneV/EUxPKIHyxkSdkAZ47frCU78BjuK+CAeSq5szwYxqZuLrlFXN01U5R2C1dRq3dheB4QKSKX9nuBX0=
X-Received: by 2002:a05:6638:13cc:: with SMTP id i12mr484816jaj.69.1601369705429;
 Tue, 29 Sep 2020 01:55:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200925140851.320673-1-jlayton@kernel.org> <CAAM7YAmJfNCbt4ON5c44FFVYOUhXu0ipK858aLJK22ZX2E-FdA@mail.gmail.com>
In-Reply-To: <CAAM7YAmJfNCbt4ON5c44FFVYOUhXu0ipK858aLJK22ZX2E-FdA@mail.gmail.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 29 Sep 2020 10:54:53 +0200
Message-ID: <CAOi1vP9Nz2Art=rq06qBuU3DvKzZs+RR7pf+qsGxYZkrbSB-1Q@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] ceph: fix spurious recover_session=clean errors
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Sep 29, 2020 at 10:28 AM Yan, Zheng <ukernel@gmail.com> wrote:
>
> On Fri, Sep 25, 2020 at 10:08 PM Jeff Layton <jlayton@kernel.org> wrote:
> >
> > Ilya noticed that he would get spurious EACCES errors on calls done just
> > after blocklisting the client on mounts with recover_session=clean. The
> > session would get marked as REJECTED and that caused in-flight calls to
> > die with EACCES. This patchset seems to smooth over the problem, but I'm
> > not fully convinced it's the right approach.
> >
>
> the root is cause is that client does not recover session instantly
> after getting rejected by mds. Before session gets recovered, client
> continues to return error.

Hi Zheng,

I don't think it's about whether that happens instantly or not.
In the example from [1], the first "ls" would fail even if issued
minutes after the session reject message and the reconnect.  From
the user's POV it is well after the automatic recovery promised by
recover_session=clean.

[1] https://tracker.ceph.com/issues/47385

Thanks,

                Ilya

>
>
> > The potential issue I see is that the client could take cap references to
> > do a call on a session that has been blocklisted. We then queue the
> > message and reestablish the session, but we may not have been granted
> > the same caps by the MDS at that point.
> >
> > If this is a problem, then we probably need to rework it so that we
> > return a distinct error code in this situation and have the upper layers
> > issue a completely new mds request (with new cap refs, etc.)
> >
> > Obviously, that's a much more invasive approach though, so it would be
> > nice to avoid that if this would suffice.
> >
> > Jeff Layton (4):
> >   ceph: don't WARN when removing caps due to blocklisting
> >   ceph: don't mark mount as SHUTDOWN when recovering session
> >   ceph: remove timeout on allowing reconnect after blocklisting
> >   ceph: queue request when CLEANRECOVER is set
> >
> >  fs/ceph/caps.c       |  2 +-
> >  fs/ceph/mds_client.c | 10 ++++------
> >  fs/ceph/super.c      | 13 +++++++++----
> >  fs/ceph/super.h      |  1 -
> >  4 files changed, 14 insertions(+), 12 deletions(-)
> >
> > --
> > 2.26.2
> >
