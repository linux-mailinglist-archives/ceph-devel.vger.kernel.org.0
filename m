Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43B4335A013
	for <lists+ceph-devel@lfdr.de>; Fri,  9 Apr 2021 15:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233661AbhDINky (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 9 Apr 2021 09:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233440AbhDINkv (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 9 Apr 2021 09:40:51 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8E41C061764
        for <ceph-devel@vger.kernel.org>; Fri,  9 Apr 2021 06:40:37 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id q26so5677567wrz.9
        for <ceph-devel@vger.kernel.org>; Fri, 09 Apr 2021 06:40:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=leblancnet-us.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=RbELviTNHtfCLXB4U2xwH1TA6vfNjox4OrIIy93uFfE=;
        b=gZCfEvnKJTWhD2WTNdKyvDM1L/ryDPI/zWv7diHybgV7jULT4Q+nXD4WNlUA2YK0o1
         vgK9jiB1nV2bXmE/ZoYsWzKQfplYgYYBkONPeSPMlY5z30xLYyY+XwzcmtWNHB09yCGg
         rjisiqYwf8UJP1N3DFU+cQGzH1wl0Ieji8VhttYDNbQ250Biv5Mexgd2NNJUJMvkI4SN
         B1J1XXO2kCqgJ2ZqGcRtsx8mo3Th5C5jXY1Hs9WPYGR40ibwJIyh9wP1Og1iKIKliLsV
         oNXodJfRzEOwSZVcje7O3tUlBsBvzO5asFx6A8I8RY5Jwfyw/wGYZY7yFOSCel5iuF+X
         ecPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=RbELviTNHtfCLXB4U2xwH1TA6vfNjox4OrIIy93uFfE=;
        b=aona96W2cfRfJzsjKMAxsvPFkUBMd2BiL2Bqq6dKV4+6pSsy7RIwIQqOyDp2DLVHpD
         qET8I7TfmePsSaccC9iPneiPuG9XakVVLRnkq+CBsdOhEGoGemcDLL0QM9/eoT2Jwr07
         VcLX27+Ve2m69h86EZVLioH6s4mzLOCncMyAxqzdc2qf/NUi2bwSJtRqsmfsI4wvRKcV
         tXTbJhHnTLuqMzw0P768DDy1yo9qemZvpI4bF7IQ20nl8GdHKX/bzF98MdUUkjf6oSLG
         wY5GYbvxiWXGS2Pl09PNtZUtc1Y/pRTdPNbBS7UP3KBZolZGkPIptK9IWjI0FRLZaib7
         4SRg==
X-Gm-Message-State: AOAM531qm4kJ23/58KrhRuBxfrsuy9VfWNdEZqTNEv/BswRSdrsEqMBK
        jaRhlA/hBm0IGXVCBiuv/vBYaPdmgbUVz2xYkJl+xN+y7M8=
X-Google-Smtp-Source: ABdhPJzeg4MsED7b4o/W8d7hQDwH/NbXe+2rDUtQrgDs3ZOky4oIfyg1rfsgNs+N0/2A8ly/dELogojmSPCNjLAiH0E=
X-Received: by 2002:adf:e38d:: with SMTP id e13mr17525740wrm.328.1617975636231;
 Fri, 09 Apr 2021 06:40:36 -0700 (PDT)
MIME-Version: 1.0
References: <CAANLjFpjRLtV+GR4WV15iXXCvkig6tJAr_G=_bZpZ=jKnYfvTQ@mail.gmail.com>
 <68fa3e03-55bd-c9aa-b19a-7cbe44af704e@bit.nl> <CAANLjFos0mFHhKULDD2SjEMN+JAra2x+tdw9gi5M27G_BumXVA@mail.gmail.com>
 <CAKTRiELqxD+0LtRXan9gMzot3y4A4M4x=km-MB2aET6wP_5mQg@mail.gmail.com> <CAANLjFrhHbuM-jW5HuuyBMFVu3GWnG23Ama8_vKs55GpOCTA-w@mail.gmail.com>
In-Reply-To: <CAANLjFrhHbuM-jW5HuuyBMFVu3GWnG23Ama8_vKs55GpOCTA-w@mail.gmail.com>
From:   Robert LeBlanc <robert@leblancnet.us>
Date:   Fri, 9 Apr 2021 07:40:25 -0600
Message-ID: <CAANLjFqttbppgtW=n2V04SyD-Lg2NbsNLvfE83Z5OsS=ZirjmQ@mail.gmail.com>
Subject: Re: [ceph-users] Nautilus 14.2.19 mon 100% CPU
To:     ceph-devel <ceph-devel@vger.kernel.org>,
        ceph-users <ceph-users@ceph.io>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

I'm attempting to deep scrub all the PGs to see if that helps clear up
some accounting issues, but that's going to take a really long time on
2PB of data.
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1

On Thu, Apr 8, 2021 at 9:48 PM Robert LeBlanc <robert@leblancnet.us> wrote:
>
> Good thought. The storage for the monitor data is a RAID-0 over three
> NVMe devices. Watching iostat, they are completely idle, maybe 0.8% to
> 1.4% for a second every minute or so.
> ----------------
> Robert LeBlanc
> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
>
> On Thu, Apr 8, 2021 at 7:48 PM Zizon Qiu <zzdtsv@gmail.com> wrote:
> >
> > Will it be related to some kind of disk issue of that mon located in,which may casually
> > slow down IO and further the rocksdb?
> >
> >
> > On Fri, Apr 9, 2021 at 4:29 AM Robert LeBlanc <robert@leblancnet.us> wrote:
> >>
> >> I found this thread that matches a lot of what I'm seeing. I see the
> >> ms_dispatch thread going to 100%, but I'm at a single MON, the
> >> recovery is done and the rocksdb MON database is ~300MB. I've tried
> >> all the settings mentioned in that thread with no noticeable
> >> improvement. I was hoping that once the recovery was done (backfills
> >> to reformatted OSDs) that it would clear up, but not yet. So any other
> >> ideas would be really helpful. Our MDS is functioning, but stalls a
> >> lot because the mons miss heartbeats.
> >>
> >> mon_compact_on_start = true
> >> rocksdb_cache_size = 1342177280
> >> mon_lease = 30
> >> mon_osd_cache_size = 200000
> >> mon_sync_max_payload_size = 4096
> >>
> >> ----------------
> >> Robert LeBlanc
> >> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
> >>
> >> On Thu, Apr 8, 2021 at 1:11 PM Stefan Kooman <stefan@bit.nl> wrote:
> >> >
> >> > On 4/8/21 6:22 PM, Robert LeBlanc wrote:
> >> > > I upgraded our Luminous cluster to Nautilus a couple of weeks ago and
> >> > > converted the last batch of FileStore OSDs to BlueStore about 36 hours
> >> > > ago. Yesterday our monitor cluster went nuts and started constantly
> >> > > calling elections because monitor nodes were at 100% and wouldn't
> >> > > respond to heartbeats. I reduced the monitor cluster to one to prevent
> >> > > the constant elections and that let the system limp along until the
> >> > > backfills finished. There are large amounts of time where ceph commands
> >> > > hang with the CPU is at 100%, when the CPU drops I see a lot of work
> >> > > getting done in the monitor logs which stops as soon as the CPU is at
> >> > > 100% again.
> >> >
> >> >
> >> > Try reducing mon_sync_max_payload_size=4096. I have seen Frank Schilder
> >> > advise this several times because of monitor issues. Also recently for a
> >> > cluster that got upgraded from Luminous -> Mimic -> Nautilus.
> >> >
> >> > Worth a shot.
> >> >
> >> > Otherwise I'll try to look in depth and see if I can come up with
> >> > something smart (for now I need to go catch some sleep).
> >> >
> >> > Gr. Stefan
