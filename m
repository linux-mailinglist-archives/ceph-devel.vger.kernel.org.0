Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 612FC41D8C9
	for <lists+ceph-devel@lfdr.de>; Thu, 30 Sep 2021 13:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350453AbhI3L3t (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 30 Sep 2021 07:29:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23029 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1350416AbhI3L3s (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 30 Sep 2021 07:29:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633001286;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tfjvvSUhggKL/+tEwJr+PV+kV1DNiiMuPrYLulpiYhM=;
        b=DSzoOaEamI0XulBq4lTxnTi+7Brc7EfKx7VQ+qjpW5PVMzw/Dnsm9djZlauBULApgIGV36
        PMS2Raetrq5DJY8VDZF8hHlgffLAsIE+M7dobDRHagiqjKesjJT38I7ewq1kIq6BSeSVJd
        lvITM4+QF0Lxx2f97tEZpt55sabdpeE=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-509-4iyexlNLP66BpMTh4mN4zw-1; Thu, 30 Sep 2021 07:28:04 -0400
X-MC-Unique: 4iyexlNLP66BpMTh4mN4zw-1
Received: by mail-qt1-f198.google.com with SMTP id a18-20020aed2792000000b002a6d480aa95so11572256qtd.14
        for <ceph-devel@vger.kernel.org>; Thu, 30 Sep 2021 04:28:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=tfjvvSUhggKL/+tEwJr+PV+kV1DNiiMuPrYLulpiYhM=;
        b=4VrTXvr36Tm2Nnqemmn/P205YghjkvqnAxWAkOCJJNolF57jgKpFxczM+XFPn3WB5m
         pb+iVmDGhQk3sn8iro7ePfJL/JHSpAhLDd1WofJCPh1aF9E4FwrHw03N47pIQqnO+UIP
         7OzDFonCl4UgdmuIHpTe4oUK0E+4YiH5kxwlDFlUtkRuWJYWNLBGFrveOvAe+DBWINvc
         ngduVoAHDtnItMpNvHvJcYLp/Va8hHZaxGzdRdfpuQgHDgSV+LwkLVs18b6PbHReqeKg
         u3wWlCX3vJC2EFNkPsMvSYPUy0GN8MD5YoH3Dl6BnZ9/4n3hsIQUH5tz1AYQass8gzFk
         3Acw==
X-Gm-Message-State: AOAM533xWFrH3i4ZUVW3VYiBBpOE5QEqeG5yAYdSfTly4QGFsQon64Mk
        54LTsyRznR/TJ0X5dpHh6j/GW3xMF8eixGrdgty/Gu4Koz6KNhSeqXUZmrwCheOM/Etem//tZOT
        7CPxOhrdW1hnFjccBuBwDJw==
X-Received: by 2002:a05:622a:4d4:: with SMTP id q20mr5900947qtx.57.1633001284345;
        Thu, 30 Sep 2021 04:28:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyraMft4tOpX+tQ9P5EphiN99L1zLqWnHav+N0+sG54f+vPoKbrFFyaXBCYbDh+MSRN8OT3Ug==
X-Received: by 2002:a05:622a:4d4:: with SMTP id q20mr5900920qtx.57.1633001284100;
        Thu, 30 Sep 2021 04:28:04 -0700 (PDT)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id o15sm1265451qkk.129.2021.09.30.04.28.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 04:28:03 -0700 (PDT)
Message-ID: <54238e8d192057c5ea9dc393d9974d7bdf09bf40.camel@redhat.com>
Subject: Re: [PATCH v3 0/2] ceph: add debugfs entries signifying new mount
 syntax support
From:   Jeff Layton <jlayton@redhat.com>
To:     Venky Shankar <vshankar@redhat.com>, pdonnell@redhat.com
Cc:     ceph-devel@vger.kernel.org
Date:   Thu, 30 Sep 2021 07:28:02 -0400
In-Reply-To: <20210928060633.349231-1-vshankar@redhat.com>
References: <20210928060633.349231-1-vshankar@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2021-09-28 at 11:36 +0530, Venky Shankar wrote:
> v3:
>  - create mount syntax debugfs entries under /<>/ceph/meta/client_features directory
>  - mount syntax debugfs file names are v1, v2,... (were v1_mount_sytnax,... earlier)
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
>     /sys/kernel/debug/ceph/meta
>     /sys/kernel/debug/ceph/meta/client_features
>     /sys/kernel/debug/ceph/meta/client_features/v2
>     /sys/kernel/debug/ceph/meta/client_features/v1
>     ....
>     ....
> 

The patches look fine, technically, so I think we're down to the
bikeshedding here.

My minor gripe is that "v1" and "v2" are not really client features.
Perhaps we should call these "mount_format_v1" or maybe
"mount_syntax_v1" ? I could forsee is advertising other features in this
dir in the future, and at that point "v1" and "v2" are somewhat
ambiguous for names.

Make sense?


> Venky Shankar (2):
>   libceph: export ceph_debugfs_dir for use in ceph.ko
>   ceph: add debugfs entries for mount syntax support
> 
>  fs/ceph/debugfs.c            | 41 ++++++++++++++++++++++++++++++++++++
>  fs/ceph/super.c              |  3 +++
>  fs/ceph/super.h              |  2 ++
>  include/linux/ceph/debugfs.h |  2 ++
>  net/ceph/debugfs.c           |  3 ++-
>  5 files changed, 50 insertions(+), 1 deletion(-)
> 

-- 
Jeff Layton <jlayton@redhat.com>

