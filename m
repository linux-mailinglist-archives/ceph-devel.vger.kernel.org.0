Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82F8E3F7B8C
	for <lists+ceph-devel@lfdr.de>; Wed, 25 Aug 2021 19:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242340AbhHYR2f (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 25 Aug 2021 13:28:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54800 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242339AbhHYR2d (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 25 Aug 2021 13:28:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629912467;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HktB3ftGpgWLPMAz9JlP0NZyAymPXwA5tAcYK/Bjojw=;
        b=YqrkFNhw649lCfxfjxgPhtBtUukE0QROc7nRJCmaVwisRpaCK21Wwsn8/g5BUzy+UlG0oe
        ODxhBC3cdZplUBcOCN9GXBI6Adwg14tUGxqsUsSs5E0bFVTxNPmMmJ1gTUobl3FC6CgStV
        J59cAmQfbxab0S6p1E+DAkq64PAEt0Y=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-378-yQNlT1bWMIiZXuaNdnKinQ-1; Wed, 25 Aug 2021 13:27:46 -0400
X-MC-Unique: yQNlT1bWMIiZXuaNdnKinQ-1
Received: by mail-qv1-f71.google.com with SMTP id n14-20020a0c9d4e0000b0290354a5f8c800so314065qvf.17
        for <ceph-devel@vger.kernel.org>; Wed, 25 Aug 2021 10:27:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=HktB3ftGpgWLPMAz9JlP0NZyAymPXwA5tAcYK/Bjojw=;
        b=fSzVXcXEjf3Rn1n5VvMuY2mQFbXAQfie0GPZHjkFmNT8U2BiRUtikjVBEg7jeJBtK/
         hQ0qrwZmvkBaWNhIRMQXYPkXoX3Txasum0Of1kcUvRkSJfDJsJr9rgwOkBp1jekCp/GO
         jbmBe7JdsN8UT0BCXPo1+ReAVC+nMkx3L3etpBI4vzxzvwuINU5QPoYAwXCY7KpXwgtx
         qJXPQDzSDSg9wYR503agCs2wxB/8DKUa3KO0vWqROk0VHbJ95DWOBE1szISIX6EX0agg
         TTWaHImrwKnk62btLPAsKTRBZim74QbrE0c7zcgyoai51HEPp0GDIszY8YNMmn3tVEzG
         bPVw==
X-Gm-Message-State: AOAM532YaJHDaQ1302cDknjNPo3I46UZ8GY7fnoxD4IdAWd8aj8FG/KF
        nIXqZfi11pP8NhnKE0x9R39JubotjC9eC4zaDKazcAh2W9EYV0VWZBFCFoaEam250tjAHoB/V8g
        n6ZsxxXIFpK3F1xmMQ4DDwQ==
X-Received: by 2002:ac8:5a86:: with SMTP id c6mr15475021qtc.171.1629912465632;
        Wed, 25 Aug 2021 10:27:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyxYAGXerGLtiEvgqtZ2Yn038yGMLbXEqh25RdZmemNqERvt8WSnqPJSV6kH5XAuvwcNVn03w==
X-Received: by 2002:ac8:5a86:: with SMTP id c6mr15475009qtc.171.1629912465422;
        Wed, 25 Aug 2021 10:27:45 -0700 (PDT)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id g8sm436205qkm.25.2021.08.25.10.27.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 10:27:45 -0700 (PDT)
Message-ID: <7081867582ee2fbda9da80fa1611f890f0e61372.camel@redhat.com>
Subject: Re: [PATCH v2 0/2] ceph: add debugfs entries signifying new mount
 syntax support
From:   Jeff Layton <jlayton@redhat.com>
To:     Venky Shankar <vshankar@redhat.com>, pdonnell@redhat.com
Cc:     ceph-devel@vger.kernel.org
Date:   Wed, 25 Aug 2021 13:27:44 -0400
In-Reply-To: <20210825055035.306043-1-vshankar@redhat.com>
References: <20210825055035.306043-1-vshankar@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2021-08-25 at 11:20 +0530, Venky Shankar wrote:
> v2:
>  - export ceph_debugfs_dir
>  - include v1 mount support debugfs entry
>  - create debugfs entries under /<>/ceph/client_features dir
> 
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
>     /sys/kernel/debug/ceph/client_features
>     /sys/kernel/debug/ceph/client_features/v2_mount_syntax
>     /sys/kernel/debug/ceph/client_features/v1_mount_syntax
>     ....
>     ....
> 

There are at least some scripts in teuthology that iterate over all of
the directories under /sys/kernel/debug/ceph/. Once you add this, some
of them may become confused.

I think we might want a more generic top-level directory for this sort
of thing, so that we only need to deal with the fallout once if we want
to put other generic info in there.

Maybe something like this?

    /sys/kernel/debug/ceph/meta/
    /sys/kernel/debug/ceph/meta/client_features

I'd be open to different names for "meta" too.

Also, do we really want to present this info via directories? I would
have thought something more like a "meta/mount_syntax" file there that
just prints "v1 v2" when read.

What's easier for scripting?

> Venky Shankar (2):
>   libceph: export ceph_debugfs_dir for use in ceph.ko
>   ceph: add debugfs entries for mount syntax support
> 
>  fs/ceph/debugfs.c            | 36 ++++++++++++++++++++++++++++++++++++
>  fs/ceph/super.c              |  3 +++
>  fs/ceph/super.h              |  2 ++
>  include/linux/ceph/debugfs.h |  2 ++
>  net/ceph/debugfs.c           |  3 ++-
>  5 files changed, 45 insertions(+), 1 deletion(-)
> 

-- 
Jeff Layton <jlayton@redhat.com>

