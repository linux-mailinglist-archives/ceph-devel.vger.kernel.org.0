Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC1FA497ADF
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Jan 2022 10:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242559AbiAXJAv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 24 Jan 2022 04:00:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242563AbiAXJAr (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 24 Jan 2022 04:00:47 -0500
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13389C061744
        for <ceph-devel@vger.kernel.org>; Mon, 24 Jan 2022 01:00:47 -0800 (PST)
Received: by mail-qt1-x831.google.com with SMTP id w6so18832098qtk.4
        for <ceph-devel@vger.kernel.org>; Mon, 24 Jan 2022 01:00:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3oCgt8t6AqdT1t91XIpWZvI+R0X7Aa4qGVAyOiAmySo=;
        b=l1nUEFR4DFpAk8YKwHdma8lHJCE/boo7S0CYf9YtdSmVG7NvOYyoZvs1BuNVoq3mHk
         Rn/YyJN6+IXoFxrkBOCzOv/XwAgIm+PeQM9eFBj8uR08wXlOedGjJ0dSR9e7D2U8DK3G
         81ahyvd9Q6yt20KkWP6c35HlUf0pdYL7OeHn2COTR290JX6spzk0aMxHU+S95cFgv+VV
         vwgapdH1NlKt+1UlGN1VdR7hGiOVceokOjPjYpPyZ5k+62S7IczmeeANsjcUqyis0/kp
         L7Ugz7dddNyx9j01ZwxZF4WakGIm6M2VcJdlvlCaXJ0Mml2EmJ2Ayt601FYDH7AufJHK
         I3Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3oCgt8t6AqdT1t91XIpWZvI+R0X7Aa4qGVAyOiAmySo=;
        b=iQHOUYoSkWZ8bjbRfn640eNZWsIBLa5Ylfx1neNc9AbM0Ubh6+Q9WH9nfRGTIVvpBb
         fcL9jvgilVOyBwmo4pNVWndxTJkaV7fPIIe5AkTOcFCkUWrKPwGH/qiCurQB4mhAMMel
         I6aiOAH4GMlDh9T46jHZeOgtxTAcfFzsw4wAai+B4euZxxdHwShd/TMIyURGtMt70KRX
         t7MpAhVJddZaCcfSEPQwXV6V2VKVBs0LlZECD1/+HFKY/XCOWHZfkukJmqRuRkwPxhGk
         A5B/l7RfLnHeBPwUnxhb63f1F/HRzCLZXAlYEKNSXKDL3BBcicff2Rp4B58u5ZPS4OWt
         rVlw==
X-Gm-Message-State: AOAM533ixRWZKLyqOpOU1OENlvg3EoZQ+BfrqzN8c22S2uddguqZuf0s
        +XtTbK3SantpqD1sKoswEMQtoOhxopIMjA==
X-Google-Smtp-Source: ABdhPJypwLNwASOFm0YwAnnF88/2ff1awjP2M17DhdD63PP0F/4PktlTYhW0IGoYTGYvxjA0GE9W5A==
X-Received: by 2002:a05:622a:152:: with SMTP id v18mr11624925qtw.610.1643014846175;
        Mon, 24 Jan 2022 01:00:46 -0800 (PST)
Received: from vossi01.front.sepia.ceph.com ([8.43.84.3])
        by smtp.gmail.com with ESMTPSA id a9sm7124653qtb.50.2022.01.24.01.00.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 01:00:45 -0800 (PST)
From:   Milind Changire <milindchangire@gmail.com>
X-Google-Original-From: Milind Changire <mchangir@redhat.com>
To:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Cc:     Milind Changire <mchangir@redhat.com>
Subject: [PATCH v5 0/1] add getvxattr op
Date:   Mon, 24 Jan 2022 09:00:24 +0000
Message-Id: <20220124090025.70417-1-mchangir@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

changes in v5:
* ceph.(dir|file).layout.(json|pool_name|pool_id)
are new xattrs added to the list.
These xattrs are now fetched from the MDS.

pool_name and pool_id are added as separate xattrs to disambiguate
the situation where a digit sequence is used by users to name a pool.

Milind Changire (1):
  ceph: add getvxattr op

 fs/ceph/inode.c              | 51 ++++++++++++++++++++++++++++++++++++
 fs/ceph/mds_client.c         | 27 ++++++++++++++++++-
 fs/ceph/mds_client.h         | 12 ++++++++-
 fs/ceph/strings.c            |  1 +
 fs/ceph/super.h              |  1 +
 fs/ceph/xattr.c              | 41 ++++++++++++++++++++++++++++-
 include/linux/ceph/ceph_fs.h |  1 +
 7 files changed, 131 insertions(+), 3 deletions(-)

-- 
2.31.1

