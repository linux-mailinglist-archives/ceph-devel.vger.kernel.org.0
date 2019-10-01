Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A98DBC384B
	for <lists+ceph-devel@lfdr.de>; Tue,  1 Oct 2019 16:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389554AbfJAO5Y (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 1 Oct 2019 10:57:24 -0400
Received: from mail-qk1-f171.google.com ([209.85.222.171]:41233 "EHLO
        mail-qk1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389329AbfJAO5Y (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 1 Oct 2019 10:57:24 -0400
Received: by mail-qk1-f171.google.com with SMTP id p10so11496255qkg.8
        for <ceph-devel@vger.kernel.org>; Tue, 01 Oct 2019 07:57:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=leblancnet-us.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xWOX6sg4LjNVtSX2xK0jjfbLYHEqIfR+P9pwnRxHwME=;
        b=nchxTJ9Rq/R7h4e/5wlm45kM40pP3InDmTYin3Zn63H4IOEg26i+A6I3GuigM7LSX+
         /VRS3BVL8I0F/Tmzt5o9a3Am2u2yyhK0ivrKBtvqqAuOHrvml6NQFc6J9tmqm7abMkY2
         n/LJFJaP1q0qgiEh4EA5RVWRQmjBqGgfZbN3CeApexxE69ycFaxQBLg5R9blHdylBFme
         B9YrnaIia9bCVfZRU1iL5prxRv1n9+8jXF0tlFEnw3+7CatkxTiDXREtBCyHDoZzYbvo
         T1Q96IRHx7yZPED//A7h5EIlpSl6BgJtYw08HGpxLHWQ77VlFZ05mkrLJwB8PJgV0JeK
         k5RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xWOX6sg4LjNVtSX2xK0jjfbLYHEqIfR+P9pwnRxHwME=;
        b=OsH7yCUbafP4PAn0Uzj+yeEE+/dasqbH2yaTEKe+vV7vF3a9xAL+z7HHBrKJSHeC9x
         3J8j43eK4tUkI2wJzOs6Ukt8qE3PgEVL462wfYrxR+33J64kPCBsOBBcL28EbAleR3MW
         koOU29P6t/bUV739koGyKRE9/Nals4sIF+rO8AYw3gKLF0pXQt5fWuWEgxZsbqLcF0i4
         UbSm04bbBQiydRm4aFlMwv5vHxZFz1Qzo7z6AlytptfVfsEEkNiygEU0NQb+kjWpSFws
         KewhZvOJZOK+en8Ex73FrS6hbGr9c5nFULZEYlLZP8HDTTrcEJFDQv+lhZjp1O4u8cdh
         vNjA==
X-Gm-Message-State: APjAAAW432X5EOW7pYIg2HcbRXa0B3BlgrFanS7ARbn1WORHzoYnxjI8
        A8pAcLnY/va0zRD22gs8sT6D71+Dm76VEInPvQTfIdU+gCh88w==
X-Google-Smtp-Source: APXvYqxXSd22Bn3tOCDrXvxWU+kYwfaiM+Ne0vuip/9k3LL4b28F74eas+mGcUcAVR2gxhMT8fKTQTgQUPidP0OZ2SY=
X-Received: by 2002:ae9:eb03:: with SMTP id b3mr6519031qkg.207.1569941843257;
 Tue, 01 Oct 2019 07:57:23 -0700 (PDT)
MIME-Version: 1.0
References: <qmq36f$5pap$1@blaine.gmane.org> <H000007100150ea4.1569860022.sx.f1-outsourcing.eu*@MHS>
 <CALi_L4-fNi=gP9sOCWPNcok9tVG=K-rtER68n1s9bkZzwuGhEw@mail.gmail.com>
 <CAD9yTbEzPJwAqVgn2fWtjZCG8zFnAgjvtMOnO-+FJd4XQx364Q@mail.gmail.com>
 <CALi_L4_dzsu3r4FGpc6K6Ce3iz6JAZmKaVTB8LXrLqVNOH1ong@mail.gmail.com> <CAANLjFqW6WE_vfYd=39GVV8DgGJge+qBr52tHj+t0P3Aap4rBw@mail.gmail.com>
In-Reply-To: <CAANLjFqW6WE_vfYd=39GVV8DgGJge+qBr52tHj+t0P3Aap4rBw@mail.gmail.com>
From:   Robert LeBlanc <robert@leblancnet.us>
Date:   Tue, 1 Oct 2019 07:57:12 -0700
Message-ID: <CAANLjFq0epgd-EPNG2Bb6WSr7XRRwMR7K205g52h=L_jJJEVdA@mail.gmail.com>
Subject: Re: [ceph-users] Commit and Apply latency on nautilus
To:     Sasha Litvak <alexander.v.litvak@gmail.com>
Cc:     Paul Emmerich <paul.emmerich@croit.io>,
        ceph-users <ceph-users@lists.ceph.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Oct 1, 2019 at 7:54 AM Robert LeBlanc <robert@leblancnet.us> wrote:
>
> On Mon, Sep 30, 2019 at 5:12 PM Sasha Litvak
> <alexander.v.litvak@gmail.com> wrote:
> >
> > At this point, I ran out of ideas.  I changed nr_requests and readahead parameters to 128->1024 and 128->4096, tuned nodes to performance-throughput.  However, I still get high latency during benchmark testing.  I attempted to disable cache on ssd
> >
> > for i in {a..f}; do hdparm -W 0 -A 0 /dev/sd$i; done
> >
> > and I think it make things not better at all.  I have H740 and H730 controllers with drives in HBA mode.
> >
> > Other them converting them one by one to RAID0 I am not sure what else I can try.
> >
> > Any suggestions?
>
> If you haven't already tried this, add this to your ceph.conf and
> restart your OSDs, this should help bring down the variance in latency
> (It will be the default in Octopus):
>
> osd op queue = wpq
> osd op queue cut off = high

I should clarify. This will reduce the variance in latency for client
OPs. If this counter is also including recovery/backfill/deep_scrub
OP-, then the latency can still be high as these settings make
recovery/backfill/deep_scrub less impactful to client I/O at the cost
of them possibly being delayed a bit.
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
