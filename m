Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCACC359364
	for <lists+ceph-devel@lfdr.de>; Fri,  9 Apr 2021 05:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233196AbhDIDtO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 8 Apr 2021 23:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232662AbhDIDtO (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 8 Apr 2021 23:49:14 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F377C061760
        for <ceph-devel@vger.kernel.org>; Thu,  8 Apr 2021 20:49:01 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id f12so4227794wro.0
        for <ceph-devel@vger.kernel.org>; Thu, 08 Apr 2021 20:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=leblancnet-us.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iGyVxLqCM9a3q9O6Jc5gjj+UiLgoYz6kG6Wa/1FaIxo=;
        b=V20YpIyGHqWlpMW9ilnLixj//XFO8+UjPYJTNOhOSZBcUs9c0TdEpXfN6fk0dBpv9q
         J6tmCrgd+HOb6sD8OqC3UsJMABSCEjQWZYygf/ptZqSSs6KZnEHslxQk2CMQsQwCt2mC
         UMmwgv6r8/7X4+kU9vwAMfUwNixLM5zD/OxYRQ+JRvjqm+Be1ikAmcmgeItQFLhOe8FT
         teFr0j2V/ypcd5SpOATVEkEbKW75JZkB1sPmRZ+vl6PZkIlCV41HRyLFQrf2i1B+CGaw
         tX9GU+2BpqeZSjNq1BL7gHRNCW8nlxKybVgxYVceUYNLOk9uyDv0NLNkKMlYLKXMAswL
         6V+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iGyVxLqCM9a3q9O6Jc5gjj+UiLgoYz6kG6Wa/1FaIxo=;
        b=ce1jF5tyr8VVYDZbbhaNscf4v/rrqBzIU8IDfKkJUM9gthIObMwRCps0Kp8sADniTK
         /7siuIn37XxiIHpl2AFWJb6QmffVdz2UwtdtldV8ZY1hyKos3u2TcwA6rtKZDLeFMwSs
         CE4/J3pJ70JCQ6dOHL1MumLf5CF5a6Y3mkXqNXjI7wpaSIVRCTpeigrOevqhVref9DBA
         RAA/S/CDJEw2Sttkt0B3bSLEVmNHytyp8+o3MFoeFWnjgPpKR95sDRCISCUCLUBqiWAk
         cE6C9RlwBld8v/bGxODAW5Rke6NZJr6AsqvDTjqDYRSvuBTiBKRY3MzrcMn2sBdc3lNO
         rD5Q==
X-Gm-Message-State: AOAM531MSJ9suR59YtzhCKoLPfrZbnxHyRJEa953OY8Spu5xn3pz5PvO
        30TSE+RODgTubKukM9gcsdhDQxExyHNNs9DPIL7Bug==
X-Google-Smtp-Source: ABdhPJyjsv24qtJ6iZylqDqK72L7qxfT+/nWH+mXANffdoNGZSUjhNUzrfDWDL9DXpM2xIy3mJloWPSB+ECceo0yJfQ=
X-Received: by 2002:adf:eb0a:: with SMTP id s10mr15542513wrn.6.1617940140076;
 Thu, 08 Apr 2021 20:49:00 -0700 (PDT)
MIME-Version: 1.0
References: <CAANLjFpjRLtV+GR4WV15iXXCvkig6tJAr_G=_bZpZ=jKnYfvTQ@mail.gmail.com>
 <68fa3e03-55bd-c9aa-b19a-7cbe44af704e@bit.nl> <CAANLjFos0mFHhKULDD2SjEMN+JAra2x+tdw9gi5M27G_BumXVA@mail.gmail.com>
 <CAKTRiELqxD+0LtRXan9gMzot3y4A4M4x=km-MB2aET6wP_5mQg@mail.gmail.com>
In-Reply-To: <CAKTRiELqxD+0LtRXan9gMzot3y4A4M4x=km-MB2aET6wP_5mQg@mail.gmail.com>
From:   Robert LeBlanc <robert@leblancnet.us>
Date:   Thu, 8 Apr 2021 21:48:48 -0600
Message-ID: <CAANLjFrhHbuM-jW5HuuyBMFVu3GWnG23Ama8_vKs55GpOCTA-w@mail.gmail.com>
Subject: Re: [ceph-users] Nautilus 14.2.19 mon 100% CPU
To:     Zizon Qiu <zzdtsv@gmail.com>
Cc:     Stefan Kooman <stefan@bit.nl>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        ceph-users <ceph-users@ceph.io>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Good thought. The storage for the monitor data is a RAID-0 over three
NVMe devices. Watching iostat, they are completely idle, maybe 0.8% to
1.4% for a second every minute or so.
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1

On Thu, Apr 8, 2021 at 7:48 PM Zizon Qiu <zzdtsv@gmail.com> wrote:
>
> Will it be related to some kind of disk issue of that mon located in,which may casually
> slow down IO and further the rocksdb?
>
>
> On Fri, Apr 9, 2021 at 4:29 AM Robert LeBlanc <robert@leblancnet.us> wrote:
>>
>> I found this thread that matches a lot of what I'm seeing. I see the
>> ms_dispatch thread going to 100%, but I'm at a single MON, the
>> recovery is done and the rocksdb MON database is ~300MB. I've tried
>> all the settings mentioned in that thread with no noticeable
>> improvement. I was hoping that once the recovery was done (backfills
>> to reformatted OSDs) that it would clear up, but not yet. So any other
>> ideas would be really helpful. Our MDS is functioning, but stalls a
>> lot because the mons miss heartbeats.
>>
>> mon_compact_on_start = true
>> rocksdb_cache_size = 1342177280
>> mon_lease = 30
>> mon_osd_cache_size = 200000
>> mon_sync_max_payload_size = 4096
>>
>> ----------------
>> Robert LeBlanc
>> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
>>
>> On Thu, Apr 8, 2021 at 1:11 PM Stefan Kooman <stefan@bit.nl> wrote:
>> >
>> > On 4/8/21 6:22 PM, Robert LeBlanc wrote:
>> > > I upgraded our Luminous cluster to Nautilus a couple of weeks ago and
>> > > converted the last batch of FileStore OSDs to BlueStore about 36 hours
>> > > ago. Yesterday our monitor cluster went nuts and started constantly
>> > > calling elections because monitor nodes were at 100% and wouldn't
>> > > respond to heartbeats. I reduced the monitor cluster to one to prevent
>> > > the constant elections and that let the system limp along until the
>> > > backfills finished. There are large amounts of time where ceph commands
>> > > hang with the CPU is at 100%, when the CPU drops I see a lot of work
>> > > getting done in the monitor logs which stops as soon as the CPU is at
>> > > 100% again.
>> >
>> >
>> > Try reducing mon_sync_max_payload_size=4096. I have seen Frank Schilder
>> > advise this several times because of monitor issues. Also recently for a
>> > cluster that got upgraded from Luminous -> Mimic -> Nautilus.
>> >
>> > Worth a shot.
>> >
>> > Otherwise I'll try to look in depth and see if I can come up with
>> > something smart (for now I need to go catch some sleep).
>> >
>> > Gr. Stefan
