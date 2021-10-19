Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81DDF43336A
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Oct 2021 12:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234914AbhJSKYS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 19 Oct 2021 06:24:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:35344 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230042AbhJSKYR (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 19 Oct 2021 06:24:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634638924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZbXPRFaSxEizeGWjvqwzCb2xhh+f6OVUvBw3jJOsSis=;
        b=AQVWelAMEqS6OlwL4aWnd1/E4pjMCnKbXVQNcNXaYUIoHzI4NBR0D9NgP5VZ0Ej8wz68Nb
        y78RYmkO4o7FHrD4mj/6P6mSUfYcTUA3OS2d7urEh3USTlq9EycTgJRg3RxUINdmlJK48j
        F3h9U5BVdN14GiyzJfLl3ChjEHZJDoc=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-113-XHguBReaPiOTjP2DKoqOeA-1; Tue, 19 Oct 2021 06:22:03 -0400
X-MC-Unique: XHguBReaPiOTjP2DKoqOeA-1
Received: by mail-qv1-f72.google.com with SMTP id x16-20020a0cfe10000000b003834102a98cso17123488qvr.9
        for <ceph-devel@vger.kernel.org>; Tue, 19 Oct 2021 03:22:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=ZbXPRFaSxEizeGWjvqwzCb2xhh+f6OVUvBw3jJOsSis=;
        b=XHIwWlKs9zxrUp61olNUbBN9gB8cSjKR5eMk9xj0ANJP+ulieoegxloOib5M9oNqHl
         yKdVQa0Fib8Dl+nwdrEf9DaVv0bYi3LJ570D199Wcj0ZP8eWFml7avKrltBGn3seAK5j
         8qWFhpt+3gkonlsuwasztNnGp/ckYzC2psu/AdYMAVE9vxS7I798kJM0nbyEs66bPYUk
         8L1zQZ4F2Rtk/Xe0NgW5CPkUoGw+FZ8z7PQAt+j+iGHYtu62E3wiE++yJR9nZuT0EMIC
         z2PhVqDCp2pcsc7J4xAicxPBI6Up8q4RRgwsuedviDCjWGyAgGrAv7iLvbNA3OXoZOsD
         VDKA==
X-Gm-Message-State: AOAM533R3nEOjElA5z5rvzq2QWAAjQyvIhIwzzzz/Yz3TSBazYr8xwv0
        EO3LE6JQk0L1qJr71yBQPePDjHR5UdTUBaAPoOli5wy0AdVkZ/SjmGWCqRGPAmwwWSvxK10/8A8
        icNAzd/eoxaTLPzAiMbkvuQ==
X-Received: by 2002:a37:b742:: with SMTP id h63mr26905087qkf.204.1634638922770;
        Tue, 19 Oct 2021 03:22:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzZTlcHLI0/PJeu+NVA/wQaYRAVngQqqieLQa7J6ull+x2VAnXJ/HRQjiP/3BPtVP7IRDpgOA==
X-Received: by 2002:a37:b742:: with SMTP id h63mr26905074qkf.204.1634638922576;
        Tue, 19 Oct 2021 03:22:02 -0700 (PDT)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id 74sm7697930qke.109.2021.10.19.03.22.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 03:22:02 -0700 (PDT)
Message-ID: <47197b0b8ce67404c8b6caaca0a2614ee829d3bf.camel@redhat.com>
Subject: Re: [PATCH v4 0/2] ceph: add debugfs entries signifying new mount
 syntax support
From:   Jeff Layton <jlayton@redhat.com>
To:     Ilya Dryomov <idryomov@gmail.com>,
        Venky Shankar <vshankar@redhat.com>
Cc:     Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Date:   Tue, 19 Oct 2021 06:22:01 -0400
In-Reply-To: <CAOi1vP_ePRvs4fPRxXq2onbcxvCarXvE6O6vzc3de2W2=jV57Q@mail.gmail.com>
References: <20211001050037.497199-1-vshankar@redhat.com>
         <CAOi1vP_ePRvs4fPRxXq2onbcxvCarXvE6O6vzc3de2W2=jV57Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-2.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2021-10-19 at 10:31 +0200, Ilya Dryomov wrote:
> On Fri, Oct 1, 2021 at 7:05 AM Venky Shankar <vshankar@redhat.com> wrote:
> > 
> > v4:
> >   - use mount_syntax_v1,.. as file names
> > 
> > [This is based on top of new mount syntax series]
> > 
> > Patrick proposed the idea of having debugfs entries to signify if
> > kernel supports the new (v2) mount syntax. The primary use of this
> > information is to catch any bugs in the new syntax implementation.
> > 
> > This would be done as follows::
> > 
> > The userspace mount helper tries to mount using the new mount syntax
> > and fallsback to using old syntax if the mount using new syntax fails.
> > However, a bug in the new mount syntax implementation can silently
> > result in the mount helper switching to old syntax.
> > 
> > So, the debugfs entries can be relied upon by the mount helper to
> > check if the kernel supports the new mount syntax. Cases when the
> > mount using the new syntax fails, but the kernel does support the
> > new mount syntax, the mount helper could probably log before switching
> > to the old syntax (or fail the mount altogether when run in test mode).
> > 
> > Debugfs entries are as follows::
> > 
> >     /sys/kernel/debug/ceph/
> >     ....
> >     ....
> >     /sys/kernel/debug/ceph/meta
> >     /sys/kernel/debug/ceph/meta/client_features
> >     /sys/kernel/debug/ceph/meta/client_features/mount_syntax_v2
> >     /sys/kernel/debug/ceph/meta/client_features/mount_syntax_v1
> >     ....
> >     ....
> 
> Hi Venky, Jeff,
> 
> If this is supposed to be used in the wild and not just in teuthology,
> I would be wary of going with debugfs.  debugfs isn't always available
> (it is actually compiled out in some configurations, it may or may not
> be mounted, etc).  With the new mount syntax feature it is not a big
> deal because the mount helper should do just fine without it but with
> other features we may find ourselves in a situation where the mount
> helper (or something else) just *has* to know whether the feature is
> supported or not and falling back to "no" if debugfs is not available
> is undesirable or too much work.
> 

I made this same point earlier, and the response was that this was
basically specifically for certain teuthology tests (mostly for testing
different mount syntax handling), and so debugfs should be available for
those.

> I don't have a great suggestion though.  When I needed to do this in
> the past for RADOS feature bits, I went with a read-only kernel module
> parameter [1].  They are exported via sysfs which is guaranteed to be
> available.  Perhaps we should do the same for mount_syntax -- have it
> be either 1 or 2, allowing it to be revved in the future?
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d6a3408a77807037872892c2a2034180fcc08d12
> 


That's not a bad idea either, and this info _is_ read-only. I don't have
a particular preference, but this approach would be fine with me as
well, and there is already some precedent for it.
-- 
Jeff Layton <jlayton@redhat.com>

