Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7569E35A44A
	for <lists+ceph-devel@lfdr.de>; Fri,  9 Apr 2021 19:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234049AbhDIRCP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 9 Apr 2021 13:02:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233332AbhDIRCO (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 9 Apr 2021 13:02:14 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F53CC061760
        for <ceph-devel@vger.kernel.org>; Fri,  9 Apr 2021 10:02:01 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id w4so2565710wrt.5
        for <ceph-devel@vger.kernel.org>; Fri, 09 Apr 2021 10:02:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=leblancnet-us.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1o7A9R9nUOiY0oJrVrVq+PlpjLvzioq+/lQ6TS7MOE4=;
        b=LT8GPfaoy397DfL9rGlXLhG4G+XCyI78tScAfambSmBuvLOyxmrGT8ltRHMLAWjMtG
         tnNapMkp/rCkw6JiWJ93viVQxBf6KxwDLiHxzCz3LxQcuxRcBiqJizqn2YQpNFV+iQ+g
         j/+/nw1SknWRWCRnFmKFOHS/w51tCDj9yzFsBxEMLjxKpid2CChEFDWa+rQCIQbsszT3
         /64ltQBwLQLpNgi2QSVXWXc0MgjgjWyzylkvCpzhryHw6dHRx8FBAKWDc1JKFK9Ub//x
         MyB3wFeq8OhR1+YLBHUGTkWuFn5JyOHjxj3Y0ZMydWJJQLi2V+9pug1mazDDO7g7nAMq
         gBmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1o7A9R9nUOiY0oJrVrVq+PlpjLvzioq+/lQ6TS7MOE4=;
        b=hMNnxvdmvUO/Hf2SeXl7ZZ0X8dP/t2mQl4bnrc6aXAIfUwFjU0rolIldoYnfn6yXA5
         NgJrZRcoA4meFsDLYVmNuV4PUA6vqXLrxPF3suVIHQO8/8YBWXS0yxBlz7pGy2TgkkjC
         jRChFi0kUgXWhjlm9bqLs7r0NISg9Sh+dn3gjkUVTk0NB2qpCmQbxruLqFITs16urxks
         9adPyHKQVBBg3vrSFJQfk7mBjnOaHKty8Ot7R/sWu/boxvPBIz8gjW8+6vCQSSRcciLC
         rDT2CJeDgjEOoX5v5bqfTsWrq+YzVTmwcfA3uKMxMWA6d0gJbllZR2l4V41md81xkA3m
         sN3Q==
X-Gm-Message-State: AOAM532BI5JLd3xssZEZCmWLsYg3rl8TANAQb94RFxgQE8mIG3TNMM6t
        y6i1Af4ZWXee35Qlo+PvroC0hR9l/TxQ3jmPAkhC+ibJ8yA=
X-Google-Smtp-Source: ABdhPJxfuYNGB2vPxqlYbIaOLFvnxB3SF6Nm5zS5pB2H1ieNAqMwreXCTt/UYU4PdqZyz8U0dcmMm/uK1P4gR9xVzGs=
X-Received: by 2002:adf:d219:: with SMTP id j25mr4428180wrh.187.1617987720137;
 Fri, 09 Apr 2021 10:02:00 -0700 (PDT)
MIME-Version: 1.0
References: <CAANLjFpjRLtV+GR4WV15iXXCvkig6tJAr_G=_bZpZ=jKnYfvTQ@mail.gmail.com>
 <68fa3e03-55bd-c9aa-b19a-7cbe44af704e@bit.nl> <CAANLjFos0mFHhKULDD2SjEMN+JAra2x+tdw9gi5M27G_BumXVA@mail.gmail.com>
 <CAKTRiELqxD+0LtRXan9gMzot3y4A4M4x=km-MB2aET6wP_5mQg@mail.gmail.com>
 <CAANLjFrhHbuM-jW5HuuyBMFVu3GWnG23Ama8_vKs55GpOCTA-w@mail.gmail.com>
 <CAANLjFqttbppgtW=n2V04SyD-Lg2NbsNLvfE83Z5OsS=ZirjmQ@mail.gmail.com>
 <8933c3a0-64f7-aaab-6ab7-30e39b76a387@bit.nl> <CAANLjFpKGaKRM+2j6+YfLsufdgQi3jz_Nm5RNsSpbVGmSsFj5g@mail.gmail.com>
In-Reply-To: <CAANLjFpKGaKRM+2j6+YfLsufdgQi3jz_Nm5RNsSpbVGmSsFj5g@mail.gmail.com>
From:   Robert LeBlanc <robert@leblancnet.us>
Date:   Fri, 9 Apr 2021 11:01:48 -0600
Message-ID: <CAANLjFqpNEQ2f16FONCURtMGwzQ1=fsePkaxpZ+oVWQfDMgnUg@mail.gmail.com>
Subject: Re: [ceph-users] Re: Nautilus 14.2.19 mon 100% CPU
To:     Stefan Kooman <stefan@bit.nl>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        ceph-users <ceph-users@ceph.io>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The only step not yet taken was to move to straw2. That was the last
step we were going to do next.
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1

On Fri, Apr 9, 2021 at 10:41 AM Robert LeBlanc <robert@leblancnet.us> wrote:
>
> On Fri, Apr 9, 2021 at 9:25 AM Stefan Kooman <stefan@bit.nl> wrote:
> > Are you running with 1 mon now? Have you tried adding mons from scratch?
> > So with a fresh database? And then maybe after they have joined, kill
> > the donor mon and start from scratch.
> >
> > You have for sure not missed a step during the upgrade (just checking
> > mode), i.e. ceph osd require-osd-release nautilus.
>
> I have tried adding one of the other monitors by removing the data
> directory and starting from scratch, but it would go back to the
> monitor elections and I didn't feel comfortable that it's up to sync
> to fail over to it so I took it back out. I have run `ceph
> osd-require-osd-release nautilus` after the upgrade of all the OSDs.
> I'll go back and double check all the steps, but I think I got them
> all.
>
> Thank you,
> Robert LeBlanc
