Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 621533F48B2
	for <lists+ceph-devel@lfdr.de>; Mon, 23 Aug 2021 12:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234188AbhHWKdT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 23 Aug 2021 06:33:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51065 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233118AbhHWKdS (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 23 Aug 2021 06:33:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629714756;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UFJxRqkvl4sOwwD9aSBiqWrtAt/8FlGk/IpSe9/TKw4=;
        b=PQoZ0WZ7aMhCnR064Agrg2S0FdVJHdjFuI/j23eyuLZPLIKQje52VqRKvIt0vvMoJoqapI
        5xUvdWA8n9Ml3UkvKVcFN+o0wupV/mK08ClNy6SbttRc4MLQt64CPZvqqtX+QHRe9nha/p
        a+hGFXiivC2elg5j49wjExcRYOx9S+s=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-454-qgkcfHweMLOu1TrX-ouIUA-1; Mon, 23 Aug 2021 06:32:35 -0400
X-MC-Unique: qgkcfHweMLOu1TrX-ouIUA-1
Received: by mail-qk1-f197.google.com with SMTP id h135-20020a379e8d000000b003f64b0f4865so5965345qke.12
        for <ceph-devel@vger.kernel.org>; Mon, 23 Aug 2021 03:32:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=UFJxRqkvl4sOwwD9aSBiqWrtAt/8FlGk/IpSe9/TKw4=;
        b=ZDc0UdrslwKZGEv88iTwPNb3EWJ18rwz9Ojek547lZqERThzF7GRDNttj8PLznSN9T
         6QFK20KvT89n9xY47O2nxyCdxsG5vmQPYuzh1sZaEp6k7omN67Fo0NBi/jKmiProf74c
         yA/IOT+i/TEIHbg5UZQVguQ62VzJi5Zw+IFK37rGaT2bnUZ1g9W9y6Ep3wY7NWCi6QcU
         qInnkUj2UcTvk3hReh57PJMI6kimhXYd5BMtgTkhb+U/kQFS+cgmtytlufuAi5Pi/YLd
         oM/m5HebF/sPgrhWxRmIjY2K3FfBAPsFpGW11Sa5D4TfWVJxCEUwhhy0VQThQabzfm+d
         0PBg==
X-Gm-Message-State: AOAM531XYsFM5o7cN4LprNFKmeULUidrIjl0hvTAkqerXkXHDCKrQL2y
        5IpRyWowKbRGBBLDS3XRF53TtZIyUJVA9trsSgPOQ6ulIbrfweBPnBpZtsldHqIEovcxOrsM32u
        jhSoSRVobWvbO5Pi2T8WJew==
X-Received: by 2002:ac8:4b43:: with SMTP id e3mr29007894qts.312.1629714754643;
        Mon, 23 Aug 2021 03:32:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxxsjhTWW1T9MReVJXwbdo8ShdZhAJcRPq46PfdzMHwqS45Wnfxd0VWTpFUaU7lEed0t+dXhg==
X-Received: by 2002:ac8:4b43:: with SMTP id e3mr29007884qts.312.1629714754494;
        Mon, 23 Aug 2021 03:32:34 -0700 (PDT)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id l11sm6271878qtv.88.2021.08.23.03.32.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 03:32:34 -0700 (PDT)
Message-ID: <6deefa227ca4f58719d574f213464dd2d510dd35.camel@redhat.com>
Subject: Re: [RFC 2/2] ceph: add debugfs entries for v2 (new) mount syntax
 support
From:   Jeff Layton <jlayton@redhat.com>
To:     Venky Shankar <vshankar@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Date:   Mon, 23 Aug 2021 06:32:33 -0400
In-Reply-To: <CACPzV1nJQzqmLxMEfaGobVCT9u61kqyQ7yCG++dzUK4eLmM1AA@mail.gmail.com>
References: <20210818060134.208546-1-vshankar@redhat.com>
         <20210818060134.208546-3-vshankar@redhat.com>
         <CA+2bHPbs0EvoVjJazb1mLpZfX0euNratkhfzkWwP=_gHQAEvOQ@mail.gmail.com>
         <CACPzV1mPkwRmC-dA7oWNQ3=RsDPfw=tMJgw8sX_-CARy1UWH9w@mail.gmail.com>
         <CACPzV1nJQzqmLxMEfaGobVCT9u61kqyQ7yCG++dzUK4eLmM1AA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2021-08-23 at 11:01 +0530, Venky Shankar wrote:
> On Mon, Aug 23, 2021 at 10:15 AM Venky Shankar <vshankar@redhat.com> wrote:
> > 
> > On Sat, Aug 21, 2021 at 7:23 AM Patrick Donnelly <pdonnell@redhat.com> wrote:
> > > 
> > > On Wed, Aug 18, 2021 at 2:01 AM Venky Shankar <vshankar@redhat.com> wrote:
> > > > 
> > > > [...]
> > > 
> > > Is "debugfs" the right place for this? I do wonder if that can be
> > > dropped/disabled via some obscure kernel config?
> > 
> > The primary use for this (v2 syntax entry) is for catching bugs in v2
> > mount syntax implementation which sounds more like a form of
> > "debugging". Sysfs represents the whole device model as seen from the
> > kernel.
> 
> So, Jeff in another thread suggested that we make these debugfs
> entries generic (client_features). In that case, I'm ok with having
> these in sysfs.
> 

I think debugfs is fine for this. This is mainly for teuthology, and in
that case we'll have debugfs available.

One of the reasons to use debugfs here is that stuff in there is
specifically _not_ considered part of the kernel's ABI, so we can more
easily make changes to it in the future w/o worrying as much about
backward compatibility.

> > 
> > And, sysfs is optional too (CONFIG_SYSFS).
> > 
> > > 
> > > Also "debugX" doesn't sound like the proper place for a feature flag
> > > of the kernel. I just did a quick check on my system and I do see:
> > > 
> > > $ ls /sys/fs/ext4/features
> > > batched_discard  casefold  encryption  fast_commit  lazy_itable_init
> > > meta_bg_resize  metadata_csum_seed  test_dummy_encryption_v2  verity
> > > 
> > > Perhaps we need something similar for fs/ceph?
> > > 
> > > --
> > > Patrick Donnelly, Ph.D.
> > > He / Him / His
> > > Principal Software Engineer
> > > Red Hat Sunnyvale, CA
> > > GPG: 19F28A586F808C2402351B93C3301A3E258DD79D
> > > 
> > 
> > 
> > --
> > Cheers,
> > Venky
> 
> 
> 

-- 
Jeff Layton <jlayton@redhat.com>

