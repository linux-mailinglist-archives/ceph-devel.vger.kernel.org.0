Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECF6426AEB8
	for <lists+ceph-devel@lfdr.de>; Tue, 15 Sep 2020 22:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbgIOUeN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Sep 2020 16:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbgIOUdd (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 15 Sep 2020 16:33:33 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E899FC06174A
        for <ceph-devel@vger.kernel.org>; Tue, 15 Sep 2020 13:33:32 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id l9so774290wme.3
        for <ceph-devel@vger.kernel.org>; Tue, 15 Sep 2020 13:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xSoZV2D0Od0c4AAf4y2a3kGtY0Sz7ktAkmMp4U6IdD0=;
        b=MWeELQfPA8utZ8cegGNmfuLl4P+gA+GBWn8pUXs2K7mpstceo/RHmDFihDahP1wP5W
         Z53XkBLX6DgRGmP9v4aKsp444YbexJzynE8A29kFDNMIHJ9YzRaOKaQnqmoIMBjH23gf
         cbFVe92WaOH36+k7kJOm8YmKqYm+3sf2xk8sddVSvtdzNK9NgWEwnmj6DhbxF5Nz3Bco
         vvlyySVhMzlfO29iHBJFl+ks9aphZOpfQxtp/UPSIzG4jLh321Tj4HZ/n8KtZ5mXucw4
         zU7gJM0bDN27lCT9bMQGKVr3COk7NKsz2YMvkyRAclkpHPFjIDtW6NFOqh4vVAi2hG87
         BYVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xSoZV2D0Od0c4AAf4y2a3kGtY0Sz7ktAkmMp4U6IdD0=;
        b=j+H+OKn+B/y3XWqbTmV0xwa0Fu+wUiUaTusnjLKxJWV4MsCFNVm2qfWgZC2nshSutj
         nv+ClfE7ohL8sbBUvLCI57avDGcosWXQn6Et9mX4dSMdCpFYJ4HrdmzKE50UQDEl1Zjp
         iZmkF+WigZy+tH280eQoxQfU/sE4ihcXEW3VLoot/o6Xz37O8BNqbeqra4BwJQoBSyft
         iRBBdYiteJ8BirxeYwrlW8jfkWR3/5v+G1yvPWQ93sB94uazxbU5dlxDxenCWAuPj/KD
         rSu8ErSMP6i8ATQYaNGTo4dqIPkKw11HIrdeZIcbtHSrDLBf+CBcCB9Ow0QXU05csBAo
         3VaA==
X-Gm-Message-State: AOAM533ZPje4VEhduRNyqtIfoaxc11QgMWAXQJSDHkH9NyT1/OKBPYKk
        eXiN3bD7ZvLUGTb8B0F9W8TM4uWevK1TsQ==
X-Google-Smtp-Source: ABdhPJxCK1XB1lLcWpF8X9KiTXO3tNO3HkfumFrdJ93ZbwiVaEB31PtTSLq3Wka5bJcaS+QWqfUbuQ==
X-Received: by 2002:a1c:81c9:: with SMTP id c192mr1069766wmd.2.1600202011288;
        Tue, 15 Sep 2020 13:33:31 -0700 (PDT)
Received: from kwango.redhat.com (ip-94-112-132-16.net.upcbroadband.cz. [94.112.132.16])
        by smtp.gmail.com with ESMTPSA id q12sm27487250wrs.48.2020.09.15.13.33.30
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 13:33:30 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH 0/3] libceph, rbd, ceph: "blacklist" -> "blocklist"
Date:   Tue, 15 Sep 2020 22:33:20 +0200
Message-Id: <20200915203323.4688-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hello,

This switches the kernel client to the conscious language.  Two
instances of "blacklist" remain because they are part of the on-wire
format: the "osd blacklist add" monitor command used as a fallback
and the session reject error string.  The latter is to be addressed
in the near future:

  https://tracker.ceph.com/issues/47450

Thanks,

                Ilya


Ilya Dryomov (3):
  libceph, rbd, ceph: "blacklist" -> "blocklist"
  libceph: switch to the new "osd blocklist add" command
  ceph: add a note explaining session reject error string

 Documentation/filesystems/ceph.rst |  6 +--
 drivers/block/rbd.c                |  8 ++--
 fs/ceph/addr.c                     | 24 +++++------
 fs/ceph/file.c                     |  4 +-
 fs/ceph/mds_client.c               | 20 +++++----
 fs/ceph/super.c                    |  4 +-
 fs/ceph/super.h                    |  4 +-
 include/linux/ceph/mon_client.h    |  2 +-
 include/linux/ceph/rados.h         |  2 +-
 net/ceph/mon_client.c              | 67 +++++++++++++++++++++++-------
 10 files changed, 90 insertions(+), 51 deletions(-)

-- 
2.19.2

