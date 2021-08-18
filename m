Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3FF93F0454
	for <lists+ceph-devel@lfdr.de>; Wed, 18 Aug 2021 15:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236629AbhHRNKT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 18 Aug 2021 09:10:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38533 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236614AbhHRNKL (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 18 Aug 2021 09:10:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629292176;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=klqHUUl+OL+P7P0q7J/3G4bLd72IElRJV1ftVfq2YrQ=;
        b=Mu8MJLIna3BlUKRYfIh1/BQFmFWkjL5PhRyn2V7hiSltSon3S2B3sRv29ALCzlwCmqfH5A
        VHe3Nl3qLvJ7xYjllSO+fze9+8L4fZWm0wH066iFWZkEDc+4/KKrI3U6u+z7ZV+YLiHegn
        1WD93MniHzDy7Z6Bu/jtzrCNrEGhV2M=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-590-NM3MJfFKPyqI04iY-PnKCA-1; Wed, 18 Aug 2021 09:09:35 -0400
X-MC-Unique: NM3MJfFKPyqI04iY-PnKCA-1
Received: by mail-qv1-f69.google.com with SMTP id t3-20020a0cf9830000b0290359840930bdso2147555qvn.2
        for <ceph-devel@vger.kernel.org>; Wed, 18 Aug 2021 06:09:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=klqHUUl+OL+P7P0q7J/3G4bLd72IElRJV1ftVfq2YrQ=;
        b=firbyQa6QiwE/vMJIuIVlOmka6VwKD/ZbW+vs+dyCG0ak6JATyEckW6m56Jo2bfAv4
         hxv1lB+KxR3fP/YHGSXgmiwqiX8f0niAASQXIEeFCIWkt/XKR3lPJEdsQJOC+P/32/g6
         5wcp01UJaFeaKYLpuUEZVeEBVyNGbe6jFq90wk+R+L/wjXEUmFuolDAX9nXf7Rh7T03N
         2noOi2n4/UV6LaY1l18AMyUAxSV2J0J743SVa0Q2IQLMn7VEtSKBKwnMxVlZefiUEmuv
         3jOpCnmUCtYQbkV280YjK0yq5MDfZlUJ78MNkTa6O9p/057kc3oZS5Egy93iBrIKAyhG
         SdEA==
X-Gm-Message-State: AOAM532Mt6Avqa753jrUYr2DeGU4g/aXmDDRJMv8gdoeoSoypns9Jcjo
        AmbKm0hyIhT/UO/O9XAAHsKLPBATGXusbgfCej5hn2gYD2l2HOFpBt8cSDVr1cAxMnuTlXdmuSG
        hGogYyKF2Eg1ee9mnqffQIg==
X-Received: by 2002:a05:620a:17a4:: with SMTP id ay36mr9812440qkb.361.1629292174545;
        Wed, 18 Aug 2021 06:09:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxjX+VGgYlrb1KJDWkdDWzE4/ODKT+/X3PNquc5f1QJELzgxVc9I3+zAAFHF32ajhoFI9J5lg==
X-Received: by 2002:a05:620a:17a4:: with SMTP id ay36mr9812419qkb.361.1629292174302;
        Wed, 18 Aug 2021 06:09:34 -0700 (PDT)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id h20sm2193680qtr.81.2021.08.18.06.09.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 06:09:33 -0700 (PDT)
Message-ID: <68e7fb33b9ed652847a95af49f38654780fdbe20.camel@redhat.com>
Subject: Re: [RFC 0/2] ceph: add debugfs entries signifying new mount syntax
 support
From:   Jeff Layton <jlayton@redhat.com>
To:     Venky Shankar <vshankar@redhat.com>, pdonnell@redhat.com
Cc:     ceph-devel@vger.kernel.org
Date:   Wed, 18 Aug 2021 09:09:32 -0400
In-Reply-To: <20210818060134.208546-1-vshankar@redhat.com>
References: <20210818060134.208546-1-vshankar@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.3 (3.40.3-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2021-08-18 at 11:31 +0530, Venky Shankar wrote:
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

Is this a known bug you're talking about or are you just speculating
about the potential for bugs there?

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
> Note that there is no entry signifying v1 mount syntax. That's because
> the kernel still supports mounting with old syntax and older kernels do
> not have debug entries for the same.
> 
> Venky Shankar (2):
>   ceph: add helpers to create/cleanup debugfs sub-directories under
>     "ceph" directory
>   ceph: add debugfs entries for v2 (new) mount syntax support
> 
>  fs/ceph/debugfs.c            | 28 ++++++++++++++++++++++++++++
>  fs/ceph/super.c              |  3 +++
>  fs/ceph/super.h              |  2 ++
>  include/linux/ceph/debugfs.h |  3 +++
>  net/ceph/debugfs.c           | 26 ++++++++++++++++++++++++--
>  5 files changed, 60 insertions(+), 2 deletions(-)
> 

I'm not a huge fan of this approach overall as it requires that you have
access to debugfs, and that's not guaranteed to be available everywhere.
If you want to add this for debugging purposes, that's fine, but I don't
think you want the mount helper to rely on this infrastructure.

-- 
Jeff Layton <jlayton@redhat.com>

