Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE9B3F446F
	for <lists+ceph-devel@lfdr.de>; Mon, 23 Aug 2021 06:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbhHWErN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 23 Aug 2021 00:47:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39107 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229462AbhHWErN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 23 Aug 2021 00:47:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629693990;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XZUfacO6snVN/JCz8AoFG030r9vcYrcs6mCyKkbZM5Y=;
        b=Rb36tRHPco6TPggBigD3w6nY0lvDa2SsLC67Wyt5OvetH5CH1U2GCNDGtvGKEUKwGt3Iz6
        O5hvun7VNogPN7Wgw1N6SWP4UCI3eZGSrwDoj2EXoQvxQFIUj8V8ppSahcZws0SuUnwqeo
        BgNUV+Htn6rgycvXrerHlWobS0uaCMY=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-583-EePH7zUlO3yb0E3CR_urgg-1; Mon, 23 Aug 2021 00:46:29 -0400
X-MC-Unique: EePH7zUlO3yb0E3CR_urgg-1
Received: by mail-ed1-f72.google.com with SMTP id g4-20020a056402180400b003c2e8da869bso408931edy.13
        for <ceph-devel@vger.kernel.org>; Sun, 22 Aug 2021 21:46:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XZUfacO6snVN/JCz8AoFG030r9vcYrcs6mCyKkbZM5Y=;
        b=YI/KNDs2csa9X8hHftaebb6bYZShTzJ6RcJ3eNxgq24D+FAipQl9ZOdi9ZbFcjWuON
         MZRiJfjJ4UYVF/phdHXFfFro3UFThWFOLah181kGHq8GqjBL94gujZtzDU5xuYQQrFtP
         WfhZ+gcWLESAPUiW0G4l6xSZL3IJLT3HSnsff/dCbtrzJMfWdc3EwJGKrg2slAa+JLY9
         EFwCdKBrXhINKD/3SNCSSsb1DCEcuiYnmWCIY/CRROrgkuTr3JidpJ4NXRt5SlEZhVqv
         ncJUEKuUD5i6PeuUiGJ2q6oRCMA2tUOu8IYPTlJk4qiEVS2kDvX2DS0flRSX0aVV+A2G
         powA==
X-Gm-Message-State: AOAM531dEzSZvnq5IZI0/peX+7XGxwC7Y3Fd/i95O64V2w8O40djZrO5
        qDJpB8sJPsWtHHpzL0hY9zKVZoe+wQV+J4R3jMCLC1nUgM4xPstMiKjvSXACoigjPC8caGJZNJE
        SKTnMyYlQk63uCZLPY8n6nElXeQjz0JskrVZLXA==
X-Received: by 2002:a05:6402:27d4:: with SMTP id c20mr8249072ede.332.1629693988145;
        Sun, 22 Aug 2021 21:46:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx2AERHR+uFEDx2GVu9mM4QOCmSZ5qrpBWGfpCFhwO7RmnZbI/tdq8pIHXoOMt/0+5E7qM0Jcy/9HsMIuyM9e8=
X-Received: by 2002:a05:6402:27d4:: with SMTP id c20mr8249063ede.332.1629693988048;
 Sun, 22 Aug 2021 21:46:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210818060134.208546-1-vshankar@redhat.com> <20210818060134.208546-3-vshankar@redhat.com>
 <CA+2bHPbs0EvoVjJazb1mLpZfX0euNratkhfzkWwP=_gHQAEvOQ@mail.gmail.com>
In-Reply-To: <CA+2bHPbs0EvoVjJazb1mLpZfX0euNratkhfzkWwP=_gHQAEvOQ@mail.gmail.com>
From:   Venky Shankar <vshankar@redhat.com>
Date:   Mon, 23 Aug 2021 10:15:51 +0530
Message-ID: <CACPzV1mPkwRmC-dA7oWNQ3=RsDPfw=tMJgw8sX_-CARy1UWH9w@mail.gmail.com>
Subject: Re: [RFC 2/2] ceph: add debugfs entries for v2 (new) mount syntax support
To:     Patrick Donnelly <pdonnell@redhat.com>
Cc:     Jeff Layton <jlayton@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sat, Aug 21, 2021 at 7:23 AM Patrick Donnelly <pdonnell@redhat.com> wrote:
>
> On Wed, Aug 18, 2021 at 2:01 AM Venky Shankar <vshankar@redhat.com> wrote:
> >
> > [...]
>
> Is "debugfs" the right place for this? I do wonder if that can be
> dropped/disabled via some obscure kernel config?

The primary use for this (v2 syntax entry) is for catching bugs in v2
mount syntax implementation which sounds more like a form of
"debugging". Sysfs represents the whole device model as seen from the
kernel.

And, sysfs is optional too (CONFIG_SYSFS).

>
> Also "debugX" doesn't sound like the proper place for a feature flag
> of the kernel. I just did a quick check on my system and I do see:
>
> $ ls /sys/fs/ext4/features
> batched_discard  casefold  encryption  fast_commit  lazy_itable_init
> meta_bg_resize  metadata_csum_seed  test_dummy_encryption_v2  verity
>
> Perhaps we need something similar for fs/ceph?
>
> --
> Patrick Donnelly, Ph.D.
> He / Him / His
> Principal Software Engineer
> Red Hat Sunnyvale, CA
> GPG: 19F28A586F808C2402351B93C3301A3E258DD79D
>


-- 
Cheers,
Venky

