Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C41DA443C4A
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Nov 2021 06:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbhKCFDZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 3 Nov 2021 01:03:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24979 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229650AbhKCFDY (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 3 Nov 2021 01:03:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635915648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=2MpeJ1k4uMGheSmYLGEXMQuo14p8TpUevnqWhZgURN4=;
        b=hZb6sc09ppgqj0SnFZ0rnA4CtKALh0cI1FbNlRK02+5ejiFkBIsEtJ7I/lXZMuTrZ+LDqy
        KIkPjEl4TWb3wO4fbuxEVfKwR5xfvNZ78JlymVGB1eHjK4Tvo0PIP3FKPw1PAP4LBJxCZi
        mMPzc/Dc1iWrXjW3yuGic5SzSq33b+o=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-mEUMT2IzNSOFdB-mDotUBw-1; Wed, 03 Nov 2021 01:00:46 -0400
X-MC-Unique: mEUMT2IzNSOFdB-mDotUBw-1
Received: by mail-pg1-f197.google.com with SMTP id x14-20020a63cc0e000000b002a5bc462947so892789pgf.20
        for <ceph-devel@vger.kernel.org>; Tue, 02 Nov 2021 22:00:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2MpeJ1k4uMGheSmYLGEXMQuo14p8TpUevnqWhZgURN4=;
        b=CLwdYzWSWycns5/oTUMNg/GzlB22Zli2Tw5TdM0M1gtIwLbqU4VCPV5AM1Z2K0FgN3
         KUg05YfRDtR2DBfJTPw79Z9btkC8ZtbQOLktpmcSbwuPItTY4CuL0IopFYgkVSZA4ZCG
         079mwwbcKqb5kotU390tO9PQhsZLrWEwCX214PYF9gfOXojNNSincZ52RwT1sZuYFG/i
         hPujRUcRthA9bJMy/dn71vUnJPdz/cvafamsJP24PJm8SbwEK9iNtzqBk4J6A7MZRBt5
         EJS5o6lAj/lzjHgWN9ZLn+3vKjB+7Bw7iG78wYevmC6aLLSMuAgZjz1eLLIGQfo10IEt
         MXpg==
X-Gm-Message-State: AOAM530bqROOyUJRvDjsyirst+Y1PkSNBM70vdpPunsWUFe+ikPREfT7
        NJGlxHGYokl9qTX+WCV/iEIz3Ec083WHfMG5HM6r2+KqrednCBMAZg8uMmCiGYLUjQFN/uQbJ1f
        PWH7Md1jCaHSj2g+5vs96pA==
X-Received: by 2002:a17:90b:3509:: with SMTP id ls9mr12125741pjb.99.1635915645825;
        Tue, 02 Nov 2021 22:00:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwF5pMFExDxRdxDmE8TDzhArwZXx+Yt/1tpcz6rwpD2o/hHW7pWRakuIFuLL5Y1mk4PoG8WCQ==
X-Received: by 2002:a17:90b:3509:: with SMTP id ls9mr12125713pjb.99.1635915645570;
        Tue, 02 Nov 2021 22:00:45 -0700 (PDT)
Received: from h3ckers-pride.redhat.com ([49.207.207.105])
        by smtp.gmail.com with ESMTPSA id h6sm780636pfi.174.2021.11.02.22.00.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 22:00:44 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, pdonnell@redhat.com, idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org, Venky Shankar <vshankar@redhat.com>
Subject: [PATCH v5 0/1] ceph: add sysfs entries signifying new mount syntax support
Date:   Wed,  3 Nov 2021 10:30:38 +0530
Message-Id: <20211103050039.371277-1-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

v5:
  - switch to sysfs instead of debugfs

[This is based on top of new mount syntax series]

Patrick/Ilya proposed the idea of having sysfs entries to signify if
kernel supports the new (v2) mount syntax. The primary use of this
information is to catch any bugs in the new syntax implementation.

This would be done as follows::

The userspace mount helper tries to mount using the new mount syntax
and fallsback to using old syntax if the mount using new syntax fails.
However, a bug in the new mount syntax implementation can silently
result in the mount helper switching to old syntax.

So, the sysfs entries can be relied upon by the mount helper to
check if the kernel supports the new mount syntax. Cases when the
mount using the new syntax fails, but the kernel does support the
new mount syntax, the mount helper could probably log before switching
to the old syntax (or fail the mount altogether when run in test mode).

sysfs entries are as follows::

    /sys/module/ceph/parameters/
    ....
    ....
    /sys/module/ceph/parameters/mount_syntax_v2
    /sys/module/ceph/parameters/mount_syntax_v1
    ....
    ....

Venky Shankar (1):
  ceph: mount syntax module parameter

 fs/ceph/super.c | 8 ++++++++
 1 file changed, 8 insertions(+)

-- 
2.27.0

