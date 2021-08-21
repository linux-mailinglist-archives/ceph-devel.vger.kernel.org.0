Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECE93F37F6
	for <lists+ceph-devel@lfdr.de>; Sat, 21 Aug 2021 03:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232458AbhHUByB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 20 Aug 2021 21:54:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38033 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230172AbhHUByA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 20 Aug 2021 21:54:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629510801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jExsKTkbgZ9THe3gvXb04/xzUylKYW//0jOKCF2Ka0w=;
        b=G0vT0arAHzMe7hO5BLmE9SkTIovLh9N0j0bM3PPA4IzW/D+7EraCyj7lBCQ0f8guoL8XyX
        RTyAcrQYpGz6/8Mpc1ohkQE/fq3tJKxd35Y0W2nGNGQJ3aCoTTcVW4Qycma9HF3lwbDbIv
        j8WIujSEIw681GH59y2SHxKDhTqLWv8=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-38-OxQAi_lUNG2OT0tcGhS_uw-1; Fri, 20 Aug 2021 21:53:19 -0400
X-MC-Unique: OxQAi_lUNG2OT0tcGhS_uw-1
Received: by mail-io1-f71.google.com with SMTP id f10-20020a6b620a0000b02904e5ab8bdc6cso6491068iog.22
        for <ceph-devel@vger.kernel.org>; Fri, 20 Aug 2021 18:53:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jExsKTkbgZ9THe3gvXb04/xzUylKYW//0jOKCF2Ka0w=;
        b=IzzTaX0FYCr/HNSRug/w1O0xlAgmJ4c7IwtHHDycFGQQPNoSOtkcRaZmPPjs4K8uT2
         6fx8XxEZLsNf9j0Q+h1MNgyw8V9pbRJTsoENDpIgM2Hb5u6+qWmcQmByi67cIL+PDEI+
         il+zrvAuw7p80BM3tIVlx3IYHlh/tFyNhIE66IlX8Vnpa5Krq7XADJPqkN7Tzhlt85sT
         cBJ8ukt+8wAciGwH6Bys8X+oUwEH7vaE9+sruYxN6/Jb4efLAAZtsho6pIHsSxlHLMVw
         jmyYTYkFhFdekp6I4dZ2clqzzyQo7YQOaLmiMGC3Om/70owlYdcEGo5Lo1wFwGG9LKxg
         6GmQ==
X-Gm-Message-State: AOAM530ZV4796WpHIqUvp2i2Bd5vbSAXH+zGgGzm2k8lFwmUfPgf19j6
        jlOvkRoqnyEZiQ9x8cvB7AoSYLlbp6IVHzxC0QY3MyClRY0fseS5nmmnHKw9w2LS0TJdKHyGuXA
        n+yoOzC6ySADPrYCPeAYEaYUK9J2e/+1SLMI+Ow==
X-Received: by 2002:a5e:d80e:: with SMTP id l14mr18465276iok.79.1629510799162;
        Fri, 20 Aug 2021 18:53:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxuTPUuCMRo/Cac6U+GHzTG88mk6T/61oPkHlK87mThixxfx6MXSdCRzgrygXpKn4Yey0p65P+UxnsAf42QK2c=
X-Received: by 2002:a5e:d80e:: with SMTP id l14mr18465265iok.79.1629510799009;
 Fri, 20 Aug 2021 18:53:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210818060134.208546-1-vshankar@redhat.com> <20210818060134.208546-3-vshankar@redhat.com>
In-Reply-To: <20210818060134.208546-3-vshankar@redhat.com>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Fri, 20 Aug 2021 21:52:53 -0400
Message-ID: <CA+2bHPbs0EvoVjJazb1mLpZfX0euNratkhfzkWwP=_gHQAEvOQ@mail.gmail.com>
Subject: Re: [RFC 2/2] ceph: add debugfs entries for v2 (new) mount syntax support
To:     Venky Shankar <vshankar@redhat.com>
Cc:     Jeff Layton <jlayton@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Aug 18, 2021 at 2:01 AM Venky Shankar <vshankar@redhat.com> wrote:
>
> [...]

Is "debugfs" the right place for this? I do wonder if that can be
dropped/disabled via some obscure kernel config?

Also "debugX" doesn't sound like the proper place for a feature flag
of the kernel. I just did a quick check on my system and I do see:

$ ls /sys/fs/ext4/features
batched_discard  casefold  encryption  fast_commit  lazy_itable_init
meta_bg_resize  metadata_csum_seed  test_dummy_encryption_v2  verity

Perhaps we need something similar for fs/ceph?

-- 
Patrick Donnelly, Ph.D.
He / Him / His
Principal Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D

