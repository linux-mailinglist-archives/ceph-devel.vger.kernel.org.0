Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7B03F44A5
	for <lists+ceph-devel@lfdr.de>; Mon, 23 Aug 2021 07:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232724AbhHWFcb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 23 Aug 2021 01:32:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27302 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231267AbhHWFc3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 23 Aug 2021 01:32:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629696705;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fNuBjnpNR2okihNpqlqbanyKJiWTqjAI+XtuKGsodQM=;
        b=HSGerfBv1T0CBM1BHUXsypmzlKUCKbqjmsyqRbMNAS4O290Iya67vUVNgI0LBtA4j/xeAF
        gHpT+EEy9cvePllvEzwDieheFoetIdsYjSTREcjcSMPNtsvs8QTGK9Sad53X+X1ZbmZwsD
        T0ykx8KSYLs2MZUlle5+GxUOaTU3AWk=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-434-QLLeIyvKODyv39SdSxzNYw-1; Mon, 23 Aug 2021 01:31:41 -0400
X-MC-Unique: QLLeIyvKODyv39SdSxzNYw-1
Received: by mail-ej1-f69.google.com with SMTP id v19-20020a170906b013b02905b2f1bbf8f3so5173893ejy.6
        for <ceph-devel@vger.kernel.org>; Sun, 22 Aug 2021 22:31:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fNuBjnpNR2okihNpqlqbanyKJiWTqjAI+XtuKGsodQM=;
        b=H2HXPOC7A/kaLaLRz3eDd3VM27JBBT6ibKTgRwdmptydV5wfOe6nSg4jrE1n4tq+mE
         URoZ7SU1vS4jb8j54eMugTPnSi3IybrMjZg66OmRV5Zo90kxsyNhPZY/UrwRxmOploPg
         TfABjocWDPw1NBJXmxJ2RFJXOqKNLigAoaaNmkuQsnJq8BC5TPZhF9fHBsytB1RWqCdp
         g64h7FUikwXvO8ij2ZKsT++B/CyO4hvEe6LJuwnvR8X4Mf12sWhXJCARuUqTvQ+xbr1Y
         g1g1hQcMxSDRw+WzI5O0v0Ye4RL9cWSYwNEmo4SMDR7aUThD2J3jHXPV3zAdhWYMsPWY
         4DIw==
X-Gm-Message-State: AOAM5337iLZm11pB6N29w00iNZn9pK61rjJrtOAcszRcfED+SPFJD5o9
        fOC9EIFqFCfjPUAFyli8LcsKIkPe23V7/cxfTOFDIfbeZQbQF4TlJ0CWYiDT1RygI/hK0EUEt25
        Qa/0frL+Nf8gGFmSksl44AvDYRgOvT3pYOvxrOQ==
X-Received: by 2002:a17:906:8da:: with SMTP id o26mr4810935eje.424.1629696700544;
        Sun, 22 Aug 2021 22:31:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxm95T0x8f7jSJzDAqYPQ+76dzsTmfT55Z3qNZPDyFvNmhcSlrmzgfolw/nl0Z5S0XNGBYN7KI3o0fYCSjZ3d0=
X-Received: by 2002:a17:906:8da:: with SMTP id o26mr4810925eje.424.1629696700408;
 Sun, 22 Aug 2021 22:31:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210818060134.208546-1-vshankar@redhat.com> <20210818060134.208546-3-vshankar@redhat.com>
 <CA+2bHPbs0EvoVjJazb1mLpZfX0euNratkhfzkWwP=_gHQAEvOQ@mail.gmail.com> <CACPzV1mPkwRmC-dA7oWNQ3=RsDPfw=tMJgw8sX_-CARy1UWH9w@mail.gmail.com>
In-Reply-To: <CACPzV1mPkwRmC-dA7oWNQ3=RsDPfw=tMJgw8sX_-CARy1UWH9w@mail.gmail.com>
From:   Venky Shankar <vshankar@redhat.com>
Date:   Mon, 23 Aug 2021 11:01:04 +0530
Message-ID: <CACPzV1nJQzqmLxMEfaGobVCT9u61kqyQ7yCG++dzUK4eLmM1AA@mail.gmail.com>
Subject: Re: [RFC 2/2] ceph: add debugfs entries for v2 (new) mount syntax support
To:     Patrick Donnelly <pdonnell@redhat.com>
Cc:     Jeff Layton <jlayton@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Aug 23, 2021 at 10:15 AM Venky Shankar <vshankar@redhat.com> wrote:
>
> On Sat, Aug 21, 2021 at 7:23 AM Patrick Donnelly <pdonnell@redhat.com> wrote:
> >
> > On Wed, Aug 18, 2021 at 2:01 AM Venky Shankar <vshankar@redhat.com> wrote:
> > >
> > > [...]
> >
> > Is "debugfs" the right place for this? I do wonder if that can be
> > dropped/disabled via some obscure kernel config?
>
> The primary use for this (v2 syntax entry) is for catching bugs in v2
> mount syntax implementation which sounds more like a form of
> "debugging". Sysfs represents the whole device model as seen from the
> kernel.

So, Jeff in another thread suggested that we make these debugfs
entries generic (client_features). In that case, I'm ok with having
these in sysfs.

>
> And, sysfs is optional too (CONFIG_SYSFS).
>
> >
> > Also "debugX" doesn't sound like the proper place for a feature flag
> > of the kernel. I just did a quick check on my system and I do see:
> >
> > $ ls /sys/fs/ext4/features
> > batched_discard  casefold  encryption  fast_commit  lazy_itable_init
> > meta_bg_resize  metadata_csum_seed  test_dummy_encryption_v2  verity
> >
> > Perhaps we need something similar for fs/ceph?
> >
> > --
> > Patrick Donnelly, Ph.D.
> > He / Him / His
> > Principal Software Engineer
> > Red Hat Sunnyvale, CA
> > GPG: 19F28A586F808C2402351B93C3301A3E258DD79D
> >
>
>
> --
> Cheers,
> Venky



-- 
Cheers,
Venky

