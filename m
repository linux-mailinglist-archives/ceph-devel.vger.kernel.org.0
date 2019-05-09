Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC0031841D
	for <lists+ceph-devel@lfdr.de>; Thu,  9 May 2019 05:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbfEIDVt (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 May 2019 23:21:49 -0400
Received: from mail-wm1-f45.google.com ([209.85.128.45]:37973 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbfEIDVs (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 8 May 2019 23:21:48 -0400
Received: by mail-wm1-f45.google.com with SMTP id f2so1114169wmj.3
        for <ceph-devel@vger.kernel.org>; Wed, 08 May 2019 20:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7mgZgpR7CkGGl9q/lycxfr8rTF+OLHCvyHTg+PJWU3k=;
        b=aFKIw5oHVSelwH4lcKxa6bUe0iTmQ6/VJZbrogcOiAzlzHMcNotJkYWMFE8XCnl2Wp
         PRFobxVIQwqSetsIkwzzhlDNW4DuUh91Dl6ZNiTGG46n0YZYmV9mtOFmkQg7G8RjLi1t
         ++KnKtssAQA7cEcFNw6NTpAebjM7osug3iruYej01OoBiT2hqe6jXFnZCP5VkkYXUVZh
         Vlewj9pPe5X5QZYPkBbs79R9SM5Mpxt5vhz6P/355av31TtV3Dpk3SRXrBbKKh6Jv4Nj
         du8wSJCFwxrwFr58ntxcFkGyMLO6w/7c8GM+eJLlNMMZdES5teMgbYkFfzXxFyM5mwBo
         tXMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7mgZgpR7CkGGl9q/lycxfr8rTF+OLHCvyHTg+PJWU3k=;
        b=e11wXTtLxyEaCqURKx4S0uxXi+MDIN3Tkv0QCuRthWTqkQFSCmfB/HSbtMuELEMFbf
         x87VetVMawSkehXBdn3ynuDN5kv6K9JHwIPvlN5N8GvpxbscTvA0lIW4oO6PHay1pCvP
         FuUDfHMnZ0bhsFVz2Z3ITn685jdiyMhHlVPWrOC8VLgIjb+FTZ1jeHHySx9jJlwkoQpA
         xhwJK6Jm2/kGYOIKQHKlnBkYosd2touGrzsi4K8X4HtTp5Io+JjfTA5XcqIfVFwj6lav
         6ovciVHOK2xd3ckQ9De5d/VvqLbbYAcxJUmhOOg74bcyXsIOh+o20XGbVB5wKrN35ADp
         V8Yg==
X-Gm-Message-State: APjAAAX3pX8C3WioNaDD38sJndRO2/K5uF2AKxugTO83pd4zFU3poJ7Y
        RgadAnofuTca735KzjPjOqp+QyEfGe2xxiu8sxA=
X-Google-Smtp-Source: APXvYqzLAfZjIISh4ceR0s1R//c5cluLeY+HhJwod9siKsovVrzBcLHvUDHulei+3/Fby3XgcrcYMlz0k2YgA2X3Oio=
X-Received: by 2002:a1c:1903:: with SMTP id 3mr923305wmz.103.1557372106150;
 Wed, 08 May 2019 20:21:46 -0700 (PDT)
MIME-Version: 1.0
References: <CALi+v1_fTKgpKtMTBDw3ioy4SqtsvP3xkjXLyLX5Gb=_7yoaNg@mail.gmail.com>
 <CAJ4mKGaRZrA9P6=hZ+CZ7oca5_b9uGXZAV5gNu2YiNajy1q8Qw@mail.gmail.com>
In-Reply-To: <CAJ4mKGaRZrA9P6=hZ+CZ7oca5_b9uGXZAV5gNu2YiNajy1q8Qw@mail.gmail.com>
From:   zengran zhang <z13121369189@gmail.com>
Date:   Thu, 9 May 2019 19:21:16 +0800
Message-ID: <CALi+v1-qsyB8S8sxPoQe+hpC8C_tz+d7Fz3cmeMoh5sWNQZ8Bg@mail.gmail.com>
Subject: Re: some questions about fast dispatch peering events
To:     Gregory Farnum <gfarnum@redhat.com>
Cc:     Sage Weil <sweil@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Gregory Farnum <gfarnum@redhat.com> =E4=BA=8E2019=E5=B9=B45=E6=9C=889=E6=97=
=A5=E5=91=A8=E5=9B=9B =E4=B8=8A=E5=8D=885:00=E5=86=99=E9=81=93=EF=BC=9A
>
> On Wed, May 8, 2019 at 6:12 AM zengran zhang <z13121369189@gmail.com> wro=
te:
> >
> > Hi Sage:
> >
> >   I see there are two difference between luminous and upstream after
> > the patch of *fast dispatch peering events*
> >
> > 1. When handle pg query w/o pg, luminous will preject history since
> > the epoch_send in query and create pg if within the same interval.
> >     but upstream now will reply empty info or log directly w/o create t=
he pg.
> >     My question is : can we do this on luminous?
>
> I think you mean "project history" here?

Sorry, I mean could we reply empty info or log directly in luminous
cluster w/o create the pg?

>
> In any case, lots of things around PG creation happened since
> Luminous, as part of the fast dispatch and enabling PG merge. That
> included changes to the monitor<->OSD interactions that are difficult
> to do within a release stream since they change the protocol. We
> typically handle those protocol changes by flagging them on the
> "min_osd_release" option. We probably can't backport this behavior
> given that.
>
> >
> > 2. When handle pg notify w/o pg, luminous will preject history since
> > the epoch_send of notify and give up next creating if not within the
> > same interval.
> >     but upstream now will create the pg unconditionally, If it was
> > stray, auth primary will purge it later.
> >     Here my question is: is the behavior of upstream a specially
> > designed improvement?
>
> My recollection is that this was just for expediency within the fast
> dispatch pipeline rather than something we thought made life within
> the cluster better, but I don't remember with any certainty. It might
> also have improved resiliency of PG create messages from the monitors
> since the OSD has the PG and will send notifies to subsequent primary
> targets?
> -Greg

Got it, Thank you for the clarification.

Now our luminous cluster, we found that the stale notify/query with
too old epoch
will cause the dispatch queue under high pressure dur to project history..
then I see the upstream remove the project history, so I'm curious
about the same
circumstance on upstream..
