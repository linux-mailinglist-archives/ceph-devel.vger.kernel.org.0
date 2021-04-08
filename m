Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82AC5358E53
	for <lists+ceph-devel@lfdr.de>; Thu,  8 Apr 2021 22:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231897AbhDHU0z (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 8 Apr 2021 16:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231451AbhDHU0y (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 8 Apr 2021 16:26:54 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D17BC061760
        for <ceph-devel@vger.kernel.org>; Thu,  8 Apr 2021 13:26:41 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id 5-20020a05600c0245b029011a8273f85eso1867902wmj.1
        for <ceph-devel@vger.kernel.org>; Thu, 08 Apr 2021 13:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=leblancnet-us.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gAI4PpbmZ78TtgNtCOmqZAiC3U9VrLe03ulzGvmjC0E=;
        b=PKz8kuzormiQipznE9FOwXvbqRVkPWZobGkuQG9CstiQhAEY6euF3bNn+oLFgabFxW
         QqwC9hitcxOKt7AUNVc/NlKF4SFdMFs9iUc20uVb78a9XR6fGOoPt/KldQ0lf4dXTDYf
         rMXanMKeaVr5YP3j2WWFSTIWvwXlJt3cFl9ksc/fpE8jUJlR/WxS4yMckleTathHMhQ2
         pPXkNFcpaRUIbQMzZFLKbUstZzHZ7XYoszCg2KuUlnn2GAmDl2/fOpIZvpoXYzuLdwSk
         bxUrJuKpLSYdJsglt/2M5eWee7YkYWv4WcC0NLQO+Wdz4rFrEzSaKGn32uJicVHSJ3VZ
         5/QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gAI4PpbmZ78TtgNtCOmqZAiC3U9VrLe03ulzGvmjC0E=;
        b=JNhkyaAaaC8HM07xVet+61JBi5wdZ0u312b7OBIeI91wVSP8/OplWsWt3VkXoywX7/
         PPcBHleYP7UTdN1/nVXSw0EcOpyvPQq0XcRDWZQqoxLw8RlzbycMnXaSdPlQtwGBtTov
         5eGsdNdSQplGYjKK++dpVsFR6MkfjQ+hNgZGW1pgkSYx9w95hTR7lIB1iBsy5O+yA5aF
         aAGmZUTAiw4nZVtXdo+fty88tpn7iLsdJwhllMnNzFtPT5Dwq7O19nO+57FKqslulpAz
         xp5tLouj3DFa6QgPRq93OMsx4rhsrnnntlHKrGhwMp4xKGYTibubl/lQKJv0o0DNyiXX
         Vceg==
X-Gm-Message-State: AOAM531IjfrGDz9rPiGC1mL8w0K8vWkj9IOQ3pq3mHYwjNlh6W5nd2+3
        XyMoKcpSwVN9K4bLPfP/vt/I2P48r8Iq1AoOMW41FzzjfdWr6Q==
X-Google-Smtp-Source: ABdhPJx4Mx2lEeJ3r4onMjej8q1bjCFKSwQVhUefKpnk9j8jlebtIvcmBPZ7BKIK4I5N2vS2sbX0qPOKzDrCO3fFid0=
X-Received: by 2002:a1c:3984:: with SMTP id g126mr3135432wma.65.1617913599792;
 Thu, 08 Apr 2021 13:26:39 -0700 (PDT)
MIME-Version: 1.0
References: <CAANLjFpjRLtV+GR4WV15iXXCvkig6tJAr_G=_bZpZ=jKnYfvTQ@mail.gmail.com>
 <68fa3e03-55bd-c9aa-b19a-7cbe44af704e@bit.nl>
In-Reply-To: <68fa3e03-55bd-c9aa-b19a-7cbe44af704e@bit.nl>
From:   Robert LeBlanc <robert@leblancnet.us>
Date:   Thu, 8 Apr 2021 14:26:28 -0600
Message-ID: <CAANLjFos0mFHhKULDD2SjEMN+JAra2x+tdw9gi5M27G_BumXVA@mail.gmail.com>
Subject: Re: [ceph-users] Nautilus 14.2.19 mon 100% CPU
To:     Stefan Kooman <stefan@bit.nl>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        ceph-users <ceph-users@ceph.io>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

I found this thread that matches a lot of what I'm seeing. I see the
ms_dispatch thread going to 100%, but I'm at a single MON, the
recovery is done and the rocksdb MON database is ~300MB. I've tried
all the settings mentioned in that thread with no noticeable
improvement. I was hoping that once the recovery was done (backfills
to reformatted OSDs) that it would clear up, but not yet. So any other
ideas would be really helpful. Our MDS is functioning, but stalls a
lot because the mons miss heartbeats.

mon_compact_on_start = true
rocksdb_cache_size = 1342177280
mon_lease = 30
mon_osd_cache_size = 200000
mon_sync_max_payload_size = 4096

----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1

On Thu, Apr 8, 2021 at 1:11 PM Stefan Kooman <stefan@bit.nl> wrote:
>
> On 4/8/21 6:22 PM, Robert LeBlanc wrote:
> > I upgraded our Luminous cluster to Nautilus a couple of weeks ago and
> > converted the last batch of FileStore OSDs to BlueStore about 36 hours
> > ago. Yesterday our monitor cluster went nuts and started constantly
> > calling elections because monitor nodes were at 100% and wouldn't
> > respond to heartbeats. I reduced the monitor cluster to one to prevent
> > the constant elections and that let the system limp along until the
> > backfills finished. There are large amounts of time where ceph commands
> > hang with the CPU is at 100%, when the CPU drops I see a lot of work
> > getting done in the monitor logs which stops as soon as the CPU is at
> > 100% again.
>
>
> Try reducing mon_sync_max_payload_size=4096. I have seen Frank Schilder
> advise this several times because of monitor issues. Also recently for a
> cluster that got upgraded from Luminous -> Mimic -> Nautilus.
>
> Worth a shot.
>
> Otherwise I'll try to look in depth and see if I can come up with
> something smart (for now I need to go catch some sleep).
>
> Gr. Stefan
