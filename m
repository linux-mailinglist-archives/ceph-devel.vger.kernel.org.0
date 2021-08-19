Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8E13F1F1D
	for <lists+ceph-devel@lfdr.de>; Thu, 19 Aug 2021 19:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232803AbhHSR3e (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 19 Aug 2021 13:29:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34916 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232558AbhHSR3e (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 19 Aug 2021 13:29:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629394137;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7x1TL+JbHM2CiMQtWF06FBb8TWTiiEku0dqPTMU41h8=;
        b=F6Ro9HyhXFs2Gw8duyHZlEycsMLjWGGTixJl0w2HCbE4M3s7lzIKatSFlQV1iZxvPCAxfN
        9uC6XTBF/UWa4a1tzfRLjCyAjPILUdft0837hWRyVt3QtDaM/DlNDRhqXaP+41X9iX4aPp
        F1OOYGZMZMa9Xg7uSxiMz0QoGpnn9z4=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-460-oSGtJQEJNF2iGq-odDMwug-1; Thu, 19 Aug 2021 13:28:56 -0400
X-MC-Unique: oSGtJQEJNF2iGq-odDMwug-1
Received: by mail-qk1-f198.google.com with SMTP id v21-20020a05620a0a9500b003d5c1e2f277so3763012qkg.13
        for <ceph-devel@vger.kernel.org>; Thu, 19 Aug 2021 10:28:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=7x1TL+JbHM2CiMQtWF06FBb8TWTiiEku0dqPTMU41h8=;
        b=VOTaG1Vn4UOw63j9to/JI0zErpDh0H1MOJ1u24ee/xPeMHYVpY09l4dsGp7FyPXMTV
         zsBVZQeImKfFrN+voTycsTTtnevI1OBgiImUO7/gc0qxSsZ0S93rzed5Y7XAG8/FgDNT
         Qv9u6wwwpNo8GdunBX8UQUzhZYUWS7A4LKn6cqdm9SrlfZmLqHLt6H3Qo6TItp4R76tN
         R5QAb2NXG1j1zOp74Cku5pCyb8XWNDKtujC7SGY6cl82FSDmzf/aIt7ph5Q64eCU0mQg
         Vo3zDWiyn60hAz9CvjFvHHr/yVl/4oKjHAjfAwVbx2nRWdkegMMDQDiXQqSaBsbt3dhl
         NCpQ==
X-Gm-Message-State: AOAM530a+RGgx/tJo0VA/9X9yHGfZF2r//TXMmHwdrJchcq5JeXHxNjy
        2o2913gUqHMnDRJfO7qkzfBTTl4D7NrM2Vqjbowt2a2x+fb4RW1GABe5jCKG8J0Rzb7rDmHH2op
        f6xKCAOC1rGXx519UfgRzRQ==
X-Received: by 2002:a37:8243:: with SMTP id e64mr4806519qkd.89.1629394135662;
        Thu, 19 Aug 2021 10:28:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyyc4cz+LgXCY/BjkFxI8ClVc58cGylLLbg6tGMjMyXklwLXI+lN4UJ05Wmp2QAbVOAg16iug==
X-Received: by 2002:a37:8243:: with SMTP id e64mr4806502qkd.89.1629394135511;
        Thu, 19 Aug 2021 10:28:55 -0700 (PDT)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id u7sm443688qtc.75.2021.08.19.10.28.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 10:28:55 -0700 (PDT)
Message-ID: <754ccb93528a7d19b5e943641d7e73aa3fe48fc1.camel@redhat.com>
Subject: Re: [PATCH 0/2] ceph: add debugfs entries signifying new mount
 syntax support
From:   Jeff Layton <jlayton@redhat.com>
To:     Venky Shankar <vshankar@redhat.com>, pdonnell@redhat.com
Cc:     ceph-devel@vger.kernel.org
Date:   Thu, 19 Aug 2021 13:28:54 -0400
In-Reply-To: <20210819060701.25486-1-vshankar@redhat.com>
References: <20210819060701.25486-1-vshankar@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.3 (3.40.3-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2021-08-19 at 11:36 +0530, Venky Shankar wrote:
> [This is based on top of new mount syntax series]
> 
> Patrick proposed the idea of having debugfs entries to signify if
> kernel supports the new (v2) mount syntax. The primary use of this
> information is to catch any bugs in the new syntax implementation.
> 
> This would be done as follows::
> 
> The userspace mount helper tries to mount using the new mount syntax
> and fallsback to using old syntax if the mount using new syntax fails.
> However, a bug in the new mount syntax implementation can silently
> result in the mount helper switching to old syntax.
> 
> So, the debugfs entries can be relied upon by the mount helper to
> check if the kernel supports the new mount syntax. Cases when the
> mount using the new syntax fails, but the kernel does support the
> new mount syntax, the mount helper could probably log before switching
> to the old syntax (or fail the mount altogether when run in test mode).
> 
> Debugfs entries are as follows::
> 
>     /sys/kernel/debug/ceph/
>     ....
>     ....
>     /sys/kernel/debug/ceph/dev_support
>     /sys/kernel/debug/ceph/dev_support/v2
>     ....
>     ....
> 

Hmm I'm not sure I like the idea of adding a directory _just_ to
indicate whether v2-style mounts are supported. I think we might want to
add something more generic here to indicate what sort of client-side
features the kernel supports.

That's useful for teuthology, and also potentially for support in
general. How about we rename this dir as:

    /sys/kernel/debug/ceph/client_features

...and then we can have a file in there for "v2_mount_device" or
something.

> Note that there is no entry signifying v1 mount syntax. That's because
> the kernel still supports mounting with old syntax and older kernels do
> not have debug entries for the same.
> 

I think we probably _should_ add a v1_mount_device file too. Eventually
we may want to drop support for v1 style mounts, once older releases
roll off the support matrix. If we drop the file at that time, then that
could be a handy way to indicate that the kernel no longer supports
them.

> Venky Shankar (2):
>   ceph: add helpers to create/cleanup debugfs sub-directories under
>     "ceph" directory
>   ceph: add debugfs entries for v2 (new) mount syntax support
> 
>  fs/ceph/debugfs.c            | 28 ++++++++++++++++++++++++++++
>  fs/ceph/super.c              |  3 +++
>  fs/ceph/super.h              |  2 ++
>  include/linux/ceph/debugfs.h |  3 +++
>  net/ceph/debugfs.c           | 27 +++++++++++++++++++++++++--
>  5 files changed, 61 insertions(+), 2 deletions(-)
> 

-- 
Jeff Layton <jlayton@redhat.com>

