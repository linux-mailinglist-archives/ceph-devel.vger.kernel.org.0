Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54ACD76103
	for <lists+ceph-devel@lfdr.de>; Fri, 26 Jul 2019 10:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725953AbfGZIkQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 26 Jul 2019 04:40:16 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]:33852 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbfGZIkQ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 26 Jul 2019 04:40:16 -0400
Received: by mail-wr1-f44.google.com with SMTP id 31so53563593wrm.1
        for <ceph-devel@vger.kernel.org>; Fri, 26 Jul 2019 01:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sza4Njfs9Q1len1RyNznfxVY7je8XlhXZD5qRHZNwYc=;
        b=Hk+gfyyCX8T85cDzssWoo8QbksNHXx/l21OWMHjgiWqdGIHze5C/JmKiSSLorDvokD
         NVmPuPaBGVcxu8AsNDXx44ajaYwmHlZIibenvg0hraazAuCvduPG3HRnI2B2cZfGpom2
         0FFQdZMejaBrhs+2HIBwYHABb1Oa/YV0aU+3jCh/1UK1Y0uLQEkAWWAGeHZiHl4f033m
         5B5fHHyiuoSa+N9MahkfxhDo3uEvx//Y7Uh4I6A4YUvwCL+MwvguuhPd7D6PpYmaIYW/
         O5jPsT9oQdBbpgvy5NYBN6OblS8ZEVk7i9Qa9ZT7/tD2xFKn4FLRzn3gCDFOg9IFUnh4
         fETA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sza4Njfs9Q1len1RyNznfxVY7je8XlhXZD5qRHZNwYc=;
        b=OtA8WzPML5CUko6q8dPcp/Jf9TvvlKNA2ug6e6m1/gY6/3fknN2oZ22NjeaHYh8mXo
         1zlcXHpRINhYKpvnZmw25cCWfAIHDzrjxqkNGqwsQZTy0IDFckmETomHFsW9vtp5DOJm
         IJ+AvrNNKtuslF+ixPn5rGPnnPfRFRJUReEF83RfxOcXpb4ipI2xAGat54bAXCSXGGTT
         SsD0JBuXC2/EG7RyXDCeASqlkULJOFrwPFDRcHUYVuHRVO65ak7i3RE0iw39ErqKRb0x
         iNzAyWPnWwCq7Xjvy55PJWsGy+I3uQSRtVmzSc1Gnrc8T0XlU82Eb8o7TgtsvzZ1Fher
         L8Kg==
X-Gm-Message-State: APjAAAXHaWQZ0IZTdcdMk3NwpPwq9lOPRqNwf+MzAHS7efFZOU1pFADc
        pjz/R47tKFhK8x0YsAGj1IRNHe31dqRAmmpJmWtVr7x66fWU7w==
X-Google-Smtp-Source: APXvYqyaWmJy+mBVUcTqOcUPIVsElbFwlWuu/gDEMY+QBjaK1Xy5DerCxRDd0t7JAhML2VY38X2po1wgD+yteDVaXb4=
X-Received: by 2002:adf:ed41:: with SMTP id u1mr95335543wro.162.1564130414355;
 Fri, 26 Jul 2019 01:40:14 -0700 (PDT)
MIME-Version: 1.0
References: <CAHRQ3VVjW31oiGnoiZfLhpQUGpN6AHrsENTeNUPWpPXs5bAbxw@mail.gmail.com>
 <CAJ4mKGYHOj+vi6JEOeCz91dkMEG5FqdSrP0L_QRjc10fHD9M0A@mail.gmail.com>
In-Reply-To: <CAJ4mKGYHOj+vi6JEOeCz91dkMEG5FqdSrP0L_QRjc10fHD9M0A@mail.gmail.com>
From:   Songbo Wang <hack.coo@gmail.com>
Date:   Fri, 26 Jul 2019 16:40:02 +0800
Message-ID: <CAG=-QKposGfEzPvyXbjd-mSxDCb+pNhi45RctQ+fUWWuZ-mb8Q@mail.gmail.com>
Subject: Re: Implement QoS for CephFS
To:     Gregory Farnum <gfarnum@redhat.com>
Cc:     Songbo Wang <songbo1227@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Gregory,

Appreciated for your reply. And comments inline.

Gregory Farnum <gfarnum@redhat.com> =E4=BA=8E2019=E5=B9=B47=E6=9C=8826=E6=
=97=A5=E5=91=A8=E4=BA=94 =E4=B8=8A=E5=8D=883:01=E5=86=99=E9=81=93=EF=BC=9A
>
> On Wed, Jul 24, 2019 at 8:29 PM Songbo Wang <songbo1227@gmail.com> wrote:
> >
> > Hi guys,
> >
> > As a distributed filesystem, all clients of CephFS share the whole
> > cluster's resources, for example, IOPS, throughput. In some cases,
> > resources will be occupied by some clients. So QoS for CephFS is
> > needed in most cases.
> >
> > Based on the token bucket algorithm, I implement QoS for CephFS.
> >
> > The basic idea is as follows:
> >
> >   1. Set QoS info as one of the dir's xattrs;
> >   2. All clients can access the same dirs with the same QoS setting.
> >   3. Similar to the Quota's config flow. when the MDS receives the QoS
> > setting, it'll also broadcast the message to all clients.
> >   4. We can change the limit online.
> >
> >
> > And we will config QoS as follows, it supports
> > {limit/burst}{iops/bps/read_iops/read_bps/write_iops/write_bps}
> > configure setting, some examples:
> >
> >       setfattr -n ceph.qos.limit.iops           -v 200 /mnt/cephfs/test=
dirs/
> >       setfattr -n ceph.qos.burst.read_bps -v 200 /mnt/cephfs/testdirs/
> >       getfattr -n ceph.qos.limit.iops                      /mnt/cephfs/=
testdirs/
> >       getfattr -n ceph.qos
> > /mnt/cephfs/testdirs/
> >
> >
> > But, there is also a big problem. For the bps{bps/write_bps/read_bps}
> > setting, if the bps is lower than the request's block size, the client
> > will be blocked until it gets enough token.
> >
> > Any suggestion will be appreciated, thanks!
> >
> > PR: https://github.com/ceph/ceph/pull/29266
>
> I briefly skimmed this and if I understand correctly, this lets you
> specify a per-client limit on hierarchies. But it doesn't try and
> limit total IO across a hierarchy, and it doesn't let you specify
> total per-client limits if they have multiple mount points.
>
> Given this, what's the point of maintaining the QoS data in the
> filesystem instead of just as information that's passed when the
> client mounts?

Sorry for my little description of my design in my previous email.
I have made two kinds of design, as follows:
1. all clients use the same QoS setting, just as the implementation in this=
 PR.
Maybe there are multiple mount points, if we limit the total IO, the
number of total
mount points is also limited. So in my implementation, the total IO &
BPS is not limited.

2. all clients share a specific QoS setting. I think there are two
kinds of use cases in detail.
2.1 setting a total limit, all clients limited by the average:
total_limit/clients_num.
2.2 setting a total limit, the mds decide the client's limitation by
their historical IO&BPS.

I think both of these design all have their usage scenario.
So I need more suggestions about this feature.

> How hard is this scheme likely to be to implement in the kernel?

It's not difficult to implement this in the kernel. I think most of
the work is to translate the TokenBucketThrottle into the kernel.
I have started this work and will push the code when I finish.

Thanks.
