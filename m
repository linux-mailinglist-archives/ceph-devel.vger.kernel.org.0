Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 368C041F215
	for <lists+ceph-devel@lfdr.de>; Fri,  1 Oct 2021 18:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231966AbhJAQZ5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 1 Oct 2021 12:25:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:36437 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231572AbhJAQZ5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 1 Oct 2021 12:25:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633105452;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H8DOh+gPnWAezUs/IaKvkUFvQZALfqbxoAsg/2Zva7k=;
        b=SXBOwn9dXIug1INWcdEjBwF0u3TvJXlpn8og1AVNeFMdxLYdwlJ8BISDczyeG2caBXdvg6
        QHzZoTGm64DGp2UfDS57WRLIFraUHUMSctO1RiNApD53LPfNKlTx3cDuCqHDqk7puLYBu6
        ChOqqimXW/tL4th90NF6QFVCPUS793I=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-21-d8VzvkROOwu-xQ17NfsGDw-1; Fri, 01 Oct 2021 12:24:11 -0400
X-MC-Unique: d8VzvkROOwu-xQ17NfsGDw-1
Received: by mail-qv1-f72.google.com with SMTP id p75-20020a0c90d1000000b0037efc8547d4so13596975qvp.16
        for <ceph-devel@vger.kernel.org>; Fri, 01 Oct 2021 09:24:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=H8DOh+gPnWAezUs/IaKvkUFvQZALfqbxoAsg/2Zva7k=;
        b=kcZ0tZiIqcEUGaJ6tQt6JJxGsNZWTyBk9R43U/8kWIc/QBnm8CUZRt8XdM3wIxiRzz
         GrOrjfBE3d5t85GmDov8DtReIpi31M/T+AZEcL8BRPznH02NVxwpJn0NBWmNyACgc/Yk
         /qs2SuvCwXldd9Xtts6t/yqotqVsAGOeOu6Az5Qfimd8jtlD3NDjzA3UHcwn59E4+9iF
         wo47fD9dvmfc14fV9CPP9k+BXcIkoDQ0x+DyKy3Z/rQ9R2FUNU0ZUXDJS8/o65DjzTWr
         h7hHDrDlavzs9YTznnK1CHNYIitvhuO/UyOrD55tx7CRTESjGQ5mp6kCrVkZl1q6j0Xm
         /ROQ==
X-Gm-Message-State: AOAM533LICKiaRp0Z6zlK+6bYlKBA1Wv4ZgvoR5jpHmbXav5RljIkdsO
        2eKO+Q+FaKGWM93v0JirUTrWe2jRMM4Mqh5A4hAnJGuCSm5kz1KMRvlAJsy6LvacLeFDlFD7EYV
        TITKCzgCJc32yEDEsdl85jQ==
X-Received: by 2002:ac8:5bcf:: with SMTP id b15mr14297573qtb.178.1633105450776;
        Fri, 01 Oct 2021 09:24:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz6Tgl+vRR+/wuaR2Vg5Y6FsQRxDH+d6KOA1v4oEA5Kps3WgRWosVFZU3TuPxyVNFiYJshA+Q==
X-Received: by 2002:ac8:5bcf:: with SMTP id b15mr14297544qtb.178.1633105450543;
        Fri, 01 Oct 2021 09:24:10 -0700 (PDT)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id b14sm3354359qkl.81.2021.10.01.09.24.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 09:24:10 -0700 (PDT)
Message-ID: <e0f529e2e17cb886bd6a906541fb978be45e0e4e.camel@redhat.com>
Subject: Re: [PATCH v4 0/2] ceph: add debugfs entries signifying new mount
 syntax support
From:   Jeff Layton <jlayton@redhat.com>
To:     Venky Shankar <vshankar@redhat.com>, pdonnell@redhat.com
Cc:     ceph-devel@vger.kernel.org
Date:   Fri, 01 Oct 2021 12:24:09 -0400
In-Reply-To: <20211001050037.497199-1-vshankar@redhat.com>
References: <20211001050037.497199-1-vshankar@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2021-10-01 at 10:30 +0530, Venky Shankar wrote:
> v4:
>   - use mount_syntax_v1,.. as file names
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
>     /sys/kernel/debug/ceph/meta/client_features/mount_syntax_v2
>     /sys/kernel/debug/ceph/meta/client_features/mount_syntax_v1
>     ....
>     ....
> 
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

This looks good to me. Merged into testing branch.

Note that there is a non-zero chance that this will break teuthology in
some wa. In particular, looking at qa/tasks/cephfs/kernel_mount.py, it
does this in _get_global_id:

            pyscript = dedent("""
                import glob
                import os
                import json

                def get_id_to_dir():
                    result = {}
                    for dir in glob.glob("/sys/kernel/debug/ceph/*"):
                        mds_sessions_lines = open(os.path.join(dir, "mds_sessions")).readlines()
                        global_id = mds_sessions_lines[0].split()[1].strip('"')
                        client_id = mds_sessions_lines[1].split()[1].strip('"')
                        result[client_id] = global_id
                    return result
                print(json.dumps(get_id_to_dir()))
            """)


What happens when this hits the "meta" directory? Is that a problem?

We may need to fix up some places like this. Maybe the open there needs
some error handling? Or we could just skip directories called "meta".
-- 
Jeff Layton <jlayton@redhat.com>

