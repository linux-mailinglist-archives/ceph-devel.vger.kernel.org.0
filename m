Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE49D35A398
	for <lists+ceph-devel@lfdr.de>; Fri,  9 Apr 2021 18:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234059AbhDIQlg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 9 Apr 2021 12:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbhDIQlf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 9 Apr 2021 12:41:35 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51ABEC061760
        for <ceph-devel@vger.kernel.org>; Fri,  9 Apr 2021 09:41:22 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id y20-20020a1c4b140000b029011f294095d3so5076369wma.3
        for <ceph-devel@vger.kernel.org>; Fri, 09 Apr 2021 09:41:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=leblancnet-us.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UQSeNBoGfP4rYkb6z90VtPIX742BEzuoeezocNHgNVY=;
        b=xQg8NOsKaQen1nGZsuXvtNl/LkyfFhmKDXBi8P+THs/fy4VxBT17rJMTB8gIKbDnRi
         Qqg0UwvN+jPYt9honWoqN7M4qWNcu9TmkFPPaZoEZgZsHC9ai4yi4Zyu+XReoADtYBwB
         +8WihrYmZpNAw4k9k6FxtKnCyTBoHgl7Ofx6Uc1c2MeYFu4RvhxgISQC+AZWbKX5BvEP
         cdpcFaTHk6QXBNUbYhrWwlMB+Gh488PCDcjPh9sVVvPaTCi6x3A2+yaVKQQ9w0CvF7AT
         yRAUCBVacrCSbEALjyghbIe9MToCrGlnYhGg5odeCP1RM2YPExQlqoOndO9VbveKx/36
         yCtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UQSeNBoGfP4rYkb6z90VtPIX742BEzuoeezocNHgNVY=;
        b=cYxItYm6uSH+mTAui2O4/0BrVth6NXmnU6VDj9PnqBDNt6Iafk/7PpTCdWKsieVFQw
         Eqf1qpU3V9OnAHTrEptbyf1Bn8VIusmr/BXleyKvYOybPKZn98KeDJDZaeEK47KfrNRR
         ksZvAboSD79QpiUGolHE5HtmRI7w3ZVyj8pgL/S/5pQ/RNhuGdYWwfhGZZvx+Kp+VY6o
         LJEo0rebV+XBOsRX2w+7DWDoIFzrVHrtx+KXG/e4x/+coU8rYJ2KWzgfCMZm0ME6OAum
         Xhb9Dk4Bx1H/1ts86b27Lxg0BE3in2HOfK6qGOhlNVzPlQzdQQ1XMWR7q1aEauJ8mF5H
         6KKQ==
X-Gm-Message-State: AOAM5315ED9ORpeHqrEeEZHFTLhZ+NXlUukGGkSc/rhb+RG4wLzlfDwN
        hRKYdY0xbFtSMKYhiEIZvp0gYQiKI+m8tK+Zqk0syeFfroY=
X-Google-Smtp-Source: ABdhPJyL/p9fnXGesPBXmU5+mE1f1buK7y/0/9Q/hDH1g+QVYyo7JbObR+aGy33EIsmQFKzDjKjJmXC3kpRJoVzBcO0=
X-Received: by 2002:a05:600c:289:: with SMTP id 9mr14815554wmk.135.1617986481016;
 Fri, 09 Apr 2021 09:41:21 -0700 (PDT)
MIME-Version: 1.0
References: <CAANLjFpjRLtV+GR4WV15iXXCvkig6tJAr_G=_bZpZ=jKnYfvTQ@mail.gmail.com>
 <68fa3e03-55bd-c9aa-b19a-7cbe44af704e@bit.nl> <CAANLjFos0mFHhKULDD2SjEMN+JAra2x+tdw9gi5M27G_BumXVA@mail.gmail.com>
 <CAKTRiELqxD+0LtRXan9gMzot3y4A4M4x=km-MB2aET6wP_5mQg@mail.gmail.com>
 <CAANLjFrhHbuM-jW5HuuyBMFVu3GWnG23Ama8_vKs55GpOCTA-w@mail.gmail.com>
 <CAANLjFqttbppgtW=n2V04SyD-Lg2NbsNLvfE83Z5OsS=ZirjmQ@mail.gmail.com> <8933c3a0-64f7-aaab-6ab7-30e39b76a387@bit.nl>
In-Reply-To: <8933c3a0-64f7-aaab-6ab7-30e39b76a387@bit.nl>
From:   Robert LeBlanc <robert@leblancnet.us>
Date:   Fri, 9 Apr 2021 10:41:09 -0600
Message-ID: <CAANLjFpKGaKRM+2j6+YfLsufdgQi3jz_Nm5RNsSpbVGmSsFj5g@mail.gmail.com>
Subject: Re: [ceph-users] Re: Nautilus 14.2.19 mon 100% CPU
To:     Stefan Kooman <stefan@bit.nl>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        ceph-users <ceph-users@ceph.io>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Apr 9, 2021 at 9:25 AM Stefan Kooman <stefan@bit.nl> wrote:
> Are you running with 1 mon now? Have you tried adding mons from scratch?
> So with a fresh database? And then maybe after they have joined, kill
> the donor mon and start from scratch.
>
> You have for sure not missed a step during the upgrade (just checking
> mode), i.e. ceph osd require-osd-release nautilus.

I have tried adding one of the other monitors by removing the data
directory and starting from scratch, but it would go back to the
monitor elections and I didn't feel comfortable that it's up to sync
to fail over to it so I took it back out. I have run `ceph
osd-require-osd-release nautilus` after the upgrade of all the OSDs.
I'll go back and double check all the steps, but I think I got them
all.

Thank you,
Robert LeBlanc
