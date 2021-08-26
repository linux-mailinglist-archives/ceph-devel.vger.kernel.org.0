Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD75D3F88A1
	for <lists+ceph-devel@lfdr.de>; Thu, 26 Aug 2021 15:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbhHZNTV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 26 Aug 2021 09:19:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24081 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232909AbhHZNTL (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 26 Aug 2021 09:19:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629983903;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=y0mGOq7UUJH69rcbuoEbcj1O/gAvjxf2/OfFz7IuKBo=;
        b=fzntmacY9Fa9RS5RHzjLUXzqf/h15+A3Dhn/CtSJeQZA5nYvhZzjo8h/YLDcmGrWUJUH25
        CB217UkM9ULAQKXedEZGmKB0/4HEgEZNJOO4DmC1lWzAust65VgQyoVUk7Z5uLPfi0+OLq
        h8/7S/BPEMwQtKUGvaKpx1xW1C+sktE=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-535-atWhRhg1M1ehJeOlx0FWgg-1; Thu, 26 Aug 2021 09:18:22 -0400
X-MC-Unique: atWhRhg1M1ehJeOlx0FWgg-1
Received: by mail-ed1-f70.google.com with SMTP id b6-20020aa7c6c6000000b003c2b5b2ddf8so1536579eds.0
        for <ceph-devel@vger.kernel.org>; Thu, 26 Aug 2021 06:18:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y0mGOq7UUJH69rcbuoEbcj1O/gAvjxf2/OfFz7IuKBo=;
        b=i1uNS9gcTJ3ZYetI+rrOI16xQG7oN96JnrnbC3sB2OQIuYjIigLiIFtylh2FQjJnxD
         i5fcjf58yzMHBEnDFTAWG4YfoXImvaoafr9DQRPCqVv9ekEKz6qPripvYQoW8lHSvE90
         dXK3wGI2JcGPNGBFYGst5p9z99fSAQp62esGPyrRCCgMcL5i39/DHfNARnYMjuXgx/pt
         +t7yfLEU78BmZUnrRxsfQbbNtD4UPXoNZaswL3yW/BDZPOIWwuehMIOLoLAjO/ZlYlLc
         PPl0mCQ6LT7XG+PlNw3/YOnzS3qKDyJIa/LDQKr9fEIwB7NarwdzSOd2YHrSKODhRSnQ
         K4DA==
X-Gm-Message-State: AOAM530vjF3TW/FsFR79hySmX1CT4AcYoyEsCdvDnMrFJISmg8dtDKfp
        4VOaAYvuApwmXxXqm9gz1hAYD8VvBIRVO27e1lJObrdHrotlLp0Kv7FN6cxxu3jAnE1nRnoQc/Q
        jk9WwTAijo33rCwNLS27oaGI38XK1E2MEv7GvSw==
X-Received: by 2002:a17:906:3a98:: with SMTP id y24mr4201839ejd.198.1629983901199;
        Thu, 26 Aug 2021 06:18:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxaO3gxVrpzUzLlV1LINx4yIpWCzxpzVajNgctT9wrwaFmAw/vTm1VO8daL19oVidGUI9fv1bIa4uCMYFtCHTU=
X-Received: by 2002:a17:906:3a98:: with SMTP id y24mr4201810ejd.198.1629983900942;
 Thu, 26 Aug 2021 06:18:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210825055035.306043-1-vshankar@redhat.com> <7081867582ee2fbda9da80fa1611f890f0e61372.camel@redhat.com>
In-Reply-To: <7081867582ee2fbda9da80fa1611f890f0e61372.camel@redhat.com>
From:   Venky Shankar <vshankar@redhat.com>
Date:   Thu, 26 Aug 2021 18:47:44 +0530
Message-ID: <CACPzV1nNes8KxA6fVXMbZqOGaQG2qUSB0ARRfucgNRrRKtsdYw@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] ceph: add debugfs entries signifying new mount
 syntax support
To:     Jeff Layton <jlayton@redhat.com>
Cc:     Patrick Donnelly <pdonnell@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Aug 25, 2021 at 10:57 PM Jeff Layton <jlayton@redhat.com> wrote:
>
> On Wed, 2021-08-25 at 11:20 +0530, Venky Shankar wrote:
> > v2:
> >  - export ceph_debugfs_dir
> >  - include v1 mount support debugfs entry
> >  - create debugfs entries under /<>/ceph/client_features dir
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
> >     /sys/kernel/debug/ceph/client_features
> >     /sys/kernel/debug/ceph/client_features/v2_mount_syntax
> >     /sys/kernel/debug/ceph/client_features/v1_mount_syntax
> >     ....
> >     ....
> >
>
> There are at least some scripts in teuthology that iterate over all of
> the directories under /sys/kernel/debug/ceph/. Once you add this, some
> of them may become confused.
>
> I think we might want a more generic top-level directory for this sort
> of thing, so that we only need to deal with the fallout once if we want
> to put other generic info in there.

Hmm, makes sense.

>
> Maybe something like this?
>
>     /sys/kernel/debug/ceph/meta/
>     /sys/kernel/debug/ceph/meta/client_features
>
> I'd be open to different names for "meta" too.

meta, misc, info, ...

I do not have a strong opinion on the naming.

>
> Also, do we really want to present this info via directories? I would
> have thought something more like a "meta/mount_syntax" file there that
> just prints "v1 v2" when read.
>
> What's easier for scripting?

One reason I kept these as files was to not do parsing stuff and just
rely on stat().

>
> > Venky Shankar (2):
> >   libceph: export ceph_debugfs_dir for use in ceph.ko
> >   ceph: add debugfs entries for mount syntax support
> >
> >  fs/ceph/debugfs.c            | 36 ++++++++++++++++++++++++++++++++++++
> >  fs/ceph/super.c              |  3 +++
> >  fs/ceph/super.h              |  2 ++
> >  include/linux/ceph/debugfs.h |  2 ++
> >  net/ceph/debugfs.c           |  3 ++-
> >  5 files changed, 45 insertions(+), 1 deletion(-)
> >
>
> --
> Jeff Layton <jlayton@redhat.com>
>


-- 
Cheers,
Venky

